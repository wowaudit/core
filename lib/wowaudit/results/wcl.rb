module Wowaudit
  module Results
    class Wcl < Base
      def initialize(character, responses)
        super(character, responses)

        responses.each do |response|
          process_result(response[:response], response[:zone])
        end
      end

      def process_result(response, raid)
        if response.code == 200
          raise Wowaudit::Exception::ApiLimitReached if response.headers['content-type'].include?("text/html")
          data = Oj.load response.body
          store_result(data, raid) unless (data["hidden"] rescue false)
        elsif response.code == 403 or response.code == 429
          raise Wowaudit::Exception::ApiLimitReached
        else
          Audit::Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", @character.id)
        end
      end

      def store_result(data, raid)
        percentiles = { 1 => {}, 3 => {}, 4 => {}, 5 => {} }

        if data == []
          # If there are no parses, we want to wipe any parses from previous non-fated seasons
          percentiles.keys.each do |difficulty|
            raid['encounters'].map { |e| e[:id].to_s }.each do |encounter_id|
              @character.details['warcraftlogs'][difficulty.to_s][encounter_id] = '-'
            end
          end
        else
          # Don't use the Parses API for now, it is being rate limited too severely.
          data.each do |parse|
            next unless (ROLES_TO_SPEC['Melee'].include?(parse['spec'] || ROLES_TO_SPEC['Ranged'].include?(parse['spec'])) rescue false)
            percentiles[parse['difficulty']][parse['encounterID'].to_s] =
              [percentiles[parse['difficulty']][parse['encounterID'].to_s], parse['percentile'].to_f].compact.max
          end

          percentiles.each do |difficulty, encounters|
            WCL_IDS[:live].each do |encounter_id|
              @character.details['warcraftlogs'][difficulty.to_s][encounter_id] = encounters[encounter_id] ||
              @character.details['warcraftlogs'][difficulty.to_s][encounter_id] rescue '-'
            end
          end
        end
      end

      def last_refresh_data
        @character.details['last_refresh']
      end
    end
  end
end
