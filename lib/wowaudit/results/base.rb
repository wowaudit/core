module Wowaudit
  module Results
    class Base
      attr_accessor :output, :character, :details, :response

      def initialize(character, response, commit_changes = true)
        Audit.verify_details(character, character.details, character.realm)

        @output = []
        @commit_changes = commit_changes
        @character = character
        @details = character.details
        @response = response
      end

      def metadata
        {
          _key: @character.id.to_s,
          character_id: @character.id,
          timestamp: (last_refresh_data || {})['blizzard_last_modified'],
          max_ilvl: @details['max_ilvl'],
          current_period: @details['current_period'],
          current_version: @details['current_version'],
          last_refresh: last_refresh_data,
          current_gear: @details['current_gear'],
        }.merge(@character.realm.game_version == 'live' ? {
          best_gear: @details['best_gear'],
          spark_gear_s1: @details['spark_gear_s1'],
          keystones: @details['keystones'],
          snapshots: @details["snapshots"],
          warcraftlogs: @details["warcraftlogs"],
          recent_reports: @details["recent_reports"],
          raiderio: @details["raiderio"],
          tier_items_s1: @details["tier_items_s1"],
          timeline: @details["timeline"],
        } : {})
      end
    end
  end
end
