module Audit
  class CharacterWcl < Character

    def process_result(response, raid)
      if response.code == 200
        raise ApiLimitReachedException if response.headers['content-type'].include?("text/html")
        data = Oj.load response.body
        store_result(data, raid) unless (data["hidden"] rescue false)
      elsif response.code == 403 or response.code == 429
        raise ApiLimitReachedException
      else
        Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", id)
        self.changed = false
      end
    end

    def store_result(data, raid)
      percentiles = { 1 => {}, 3 => {}, 4 => {}, 5 => {} }

      if data == []
        # If there are no parses, we want to wipe any parses from previous non-fated seasons
        percentiles.keys.each do |difficulty|
          raid['encounters'].map { |e| e[F_ID].to_s }.each do |encounter_id|
            details['warcraftlogs'][difficulty.to_s][encounter_id] = '-'
          end
        end
      else
        # Don't use the Parses API for now, it is being rate limited too severely.
        data.each do |parse|
          next unless (ROLES_TO_SPEC[self.role].include?(parse['spec']) rescue false)
          percentiles[parse['difficulty']][parse['encounterID'].to_s] =
            [percentiles[parse['difficulty']][parse['encounterID'].to_s], parse['percentile']].compact.max
        end

        percentiles.each do |difficulty, encounters|
          WCL_IDS.each do |encounter_id|
            details['warcraftlogs'][difficulty.to_s][encounter_id] = encounters[encounter_id] ||
              details['warcraftlogs'][difficulty.to_s][encounter_id] rescue '-'
          end
        end
      end
    end

    def wcl_role
      role == "Heal" ? "hps" : "dps"
    end

    def last_refresh_data
      details['last_refresh']
    end
  end
end
