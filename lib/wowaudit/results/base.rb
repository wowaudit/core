module Wowaudit
  module Results
    class Base
      attr_accessor :output, :character, :details, :response

      def initialize(character, response, commit_changes = true)
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
        } : {}).merge(tier_items_metadata)
      end

      def tier_items_metadata
        tiers_by_slot = case @character.realm.game_version
        when 'classic_era' then CLASSIC_ERA_TIER_ITEMS_BY_SLOT
        when 'classic_anniversary' then TBC_TIER_ITEMS_BY_SLOT
        when 'classic_progression' then MOP_TIER_ITEMS_BY_SLOT
        end

        return {} unless tiers_by_slot

        tiers_by_slot.keys.each_with_object({}) do |tier, result|
          key = "tier_items_t#{tier}"
          result[key.to_sym] = @details[key]
        end
      end
    end
  end
end
