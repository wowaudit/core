module Wowaudit
  module Results
    class Keystones
      def process_leaderboard_result(runs, current_week)
        updated = false

        if current_week
          levels = runs.map { |run| run[:keystone_level] }.sort_by { |h| h * -1 }
          if details['raiderio']['period'] != Audit.period || details['raiderio']['leaderboard_runs'] != levels
            details['raiderio']['weekly_highest'] = levels.max
            details['raiderio']['leaderboard_runs'] = levels
            details['raiderio']['period'] = Audit.period
            updated = true
          end
        end

        runs.each do |run|
          run_id = run[:completed_timestamp] / 1000
          run_period = Audit.period_from_timestamp(run_id).to_s
          unless details['keystones'][run_period]&.include?(run_id.to_s)
            updated = true
            (details['keystones'][run_period] ||= {})[run_id.to_s] = {
              "level" => run[:keystone_level],
              "dungeon" => run[:dungeon_id],
            }
          end
        end

        updated
      end
    end
  end
end
