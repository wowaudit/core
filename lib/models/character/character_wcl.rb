module Audit
  class CharacterWcl < Character

    def process_result(response)
      if response.code == 200
        data = JSON.parse response.body
        store_result(data) unless (data["hidden"] rescue false)
      elsif response.code == 403 or response.code == 429
        raise ApiLimitReachedException
      else
        Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", id)
        self.changed = false
      end
    end

    def store_result(data)
      percentiles = { 3 => {}, 4 => {}, 5 => {} }
      data.reject{ |parse| parse['difficulty'] < 3 }.each do |parse|
        next unless ROLES_TO_SPEC[self.role].include?(parse['spec'])
        (percentiles[parse['difficulty']][parse['encounterID'].to_s] ||= []) << parse['percentile']
      end

      percentiles.each do |difficulty, encounters|
        WCL_IDS.each do |encounter_id|
          details['warcraftlogs'][difficulty.to_s][encounter_id] = calculated_percentiles(encounters[encounter_id])
        end
      end
    end

    def calculated_percentiles(percentiles)
      if percentiles
        {
          'best' => percentiles.max,
          'median' => percentiles.median,
          'average' => percentiles.mean
        }
      else
        {
          'best' => '-',
          'median' => '-',
          'average' => '-'
        }
      end
    end

    def wcl_role
      role == "Heal" ? "hps" : "dps"
    end

    def update
      {
        _key: id.to_s,
        warcraftlogs: details["warcraftlogs"]
      }
    end
  end
end
