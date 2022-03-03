module Audit
  class CharacterRaiderio < Character

    def process_result(response)
      if response.code == 200
        data = JSON.parse response.body
        details['raiderio']['score'] =
          (data['mythic_plus_scores_by_season'][0]['scores']['all'] rescue 0)

        details['raiderio']['season_highest'] =
          (data['mythic_plus_highest_level_runs'][0]['mythic_level'] rescue 0)

        count = -1
        details['raiderio']['top_ten_highest'] = data['mythic_plus_weekly_highest_level_runs'].map do |run|
          # Exclude duplicate runs (Raider.io or Blizzard issue), check if completions are within 60 seconds of each other
          count += 1
          timestamp = Time.parse(run['completed_at']).to_i
          next if data['mythic_plus_weekly_highest_level_runs'].first(count).any? { |other_run|  (Time.parse(other_run['completed_at']).to_i - timestamp).abs < 60 }

          run.dig('mythic_level').to_i
        end.compact

      elsif response.code == 403 or response.code == 0 or response.code == 429
        # Treat response code of 0 as API Limit, to reduce
        # load on RaiderIO's API (it's a sign of too many requests)
        raise ApiLimitReachedException
      else
        Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", id)
      end
    end

    def process_leaderboard_result(levels)
      if details['raiderio']['period'] != Audit.period || details['raiderio']['leaderboard_runs'] != levels
        details['raiderio']['weekly_highest'] = levels.max
        details['raiderio']['leaderboard_runs'] = levels
        details['raiderio']['period'] = Audit.period
        true
      end
    end

    def last_refresh_data
      details['last_refresh']
    end
  end
end
