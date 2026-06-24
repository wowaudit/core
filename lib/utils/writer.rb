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

      def update_db(results)
        changed = results.select(&:changed).map(&:character)
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
    end
  end
end
