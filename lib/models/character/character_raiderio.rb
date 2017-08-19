module Audit
  class CharacterRaiderio < Character

    def process_result(response)
      if response.code == 200
        data = JSON.parse response.body
        self.raiderio = {
          :score => (data['mythic_plus_scores']['all'] rescue 0),
          :season_highest => (data['mythic_plus_highest_level_runs'][0]['mythic_level'] rescue 0)
        }
        self.raiderio_weekly = data['mythic_plus_weekly_highest_level_runs'][0]['mythic_level'].to_i rescue 0
        self.changed = true
      elsif response.code == 403
        raise ApiLimitReachedException
      else
        Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", id)
        self.changed = false
      end
    end
  end
end
