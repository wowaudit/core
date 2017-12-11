module Audit
  class CharacterWcl < Character

    def process_result(response)
      if response.code == 200
        data = JSON.parse response.body
        parse_result(data) unless data.empty? or (data["hidden"] rescue false)
      elsif response.code == 403 or response.code == 429
        raise ApiLimitReachedException
      else
        Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", id)
        self.changed = false
      end
    end

    def parse_result(data)
      details['warcraftlogs_id'] = data[0]['specs'][0]['data'][0]['character_id']
      data.reject{ |encounter| encounter['difficulty'] < 3 }.each do |encounter|
        encounter['specs'].each do |spec|
          if spec['spec'][0..3] == self.role[0..3] || ROLES_TO_SPEC[self.role].include?(spec['spec'])
            details['warcraftlogs'][encounter['difficulty'].to_s][WCL_MAP[encounter['name']]] = {
              best: spec['best_historical_percent'].round,
              median: spec['historical_median'].round,
              average: spec['historical_avg'].round
            }
            break
          end rescue nil
        end
      end
    end

    def wcl_role
      role == "Heal" ? "hps" : "dps"
    end
  end
end

