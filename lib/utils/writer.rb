module Audit
  module Writer
    MAX_PENDING_WRITES = 16

    class << self
      def write(team, result, header)
        json = ([header] + result.map(&:output).compact.reject(&:empty?)).to_json
        file = STORAGE[team.guild.realm.game_version.to_sym].bucket(BUCKET).object("#{team.readonly_key}.json")
        file.put(body: json)

        Logger.t(INFO_TEAM_WRITTEN, team.id)
      end

      def update_db(results, extra_changed = [])
        write_recipes(results)

        changed = results.select(&:changed).map(&:character) + extra_changed
        tracking_ids = results.select { |r| r.character.status == 'tracking' }.map { |r| r.character.id }
        return if changed.empty? && tracking_ids.empty?

        ensure_writer_thread
        queue << [changed, tracking_ids]
      end

      private

      def queue
        @queue ||= SizedQueue.new(MAX_PENDING_WRITES)
      end

      def ensure_writer_thread
        return if @writer_thread&.alive?

        (@writer_mutex ||= Mutex.new).synchronize do
          return if @writer_thread&.alive?

          @writer_thread = Thread.new do
            loop { flush(*queue.pop) }
          end
        end
      end

      def flush(changed, tracking_ids)
        changed.each do |character|
          begin
            character.save_changes
          rescue Sequel::DatabaseError => e
            Sentry.capture_exception(e, extra: { character_id: character.id })
          end
        end

        if tracking_ids.any?
          DB.run("UPDATE characters SET refreshed_at = NOW() WHERE id IN (#{tracking_ids.join(',')})")
        end
      rescue StandardError => e
        Sentry.capture_exception(e)
      end

      # Written before the metadata is stored rather than by the writer thread: when the write fails,
      # dropping the digest from the metadata makes the next refresh write the recipes again.
      def write_recipes(results)
        pending = results.select { |result| result.details['known_recipes'] }
        return if pending.empty?

        DB[:character_recipes]
          .insert_conflict(
            target: :character_id,
            update: { known_recipes: Sequel[:excluded][:known_recipes], updated_at: Sequel[:excluded][:updated_at] }
          )
          .multi_insert(pending.map do |result|
            {
              character_id: result.character.id,
              known_recipes: Sequel.cast(result.details['known_recipes'].to_json, :jsonb),
              updated_at: Sequel::CURRENT_TIMESTAMP,
            }
          end)
      rescue Sequel::DatabaseError => e
        pending.each { |result| result.details.delete('known_recipes_digest') }
        Sentry.capture_exception(e, extra: { character_ids: pending.map { |result| result.character.id } })
      end
    end
  end
end
