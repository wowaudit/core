module Audit
  module Writer
    MAX_PENDING_WRITES = 100

    class << self
      def write(team, result, header)
        json = ([header] + result.map(&:output).compact.reject(&:empty?)).to_json
        file = STORAGE[team.guild.realm.game_version.to_sym].bucket(BUCKET).object("acc-#{team.readonly_key}.json")
        file.put(body: json)

        Logger.t(INFO_TEAM_WRITTEN, team.id)
      end

      def update_db(results)
        ensure_writer_thread
        queue << results
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
            loop { flush(queue.pop) }
          end
        end
      end

      def flush(results)
        results.select(&:changed).each do |result|
          begin
            result.character.save_changes
          rescue Sequel::DatabaseError => e
            Sentry.capture_exception(e, extra: { character_id: result.character.id })
          end
        end

        tracking_ids = results.select { |r| r.character.status == 'tracking' }.map { |r| r.character.id }
        if tracking_ids.any?
          DB.run("UPDATE characters SET refreshed_at = NOW() WHERE id IN (#{tracking_ids.join(',')})")
        end
      rescue StandardError => e
        Sentry.capture_exception(e)
      end
    end
  end
end
