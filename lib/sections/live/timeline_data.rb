module Audit
  module Live
    class TimelineData < Data
      def add
        timeline = {}

        return unless @achievements

        TIMELINE_EVENTS.each do |event_id, event|
          event[:criteria].each_with_index do |criterion, index|
            achievement_id = criterion[:achievement_id]
            achievement = @achievements[achievement_id]

            next unless achievement

            completed_timestamp = achievement[:completed_timestamp]
            next unless completed_timestamp

            if criterion.key?(:time_sensitive)
              end_of_date = (criterion[:time_sensitive] + 1).to_time.to_i * 1000
              next unless completed_timestamp < end_of_date
            end

            timeline[event_id] = { index: index, ts: completed_timestamp }
            break
          end
        end

        @character.details['timeline'] = timeline
      end
    end
  end
end
