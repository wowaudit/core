module Audit
  module Live
    class ExternalData < Data
      SKIPPABLE = false

      def add
        add_warcraftlogs_data
        add_raiderio_data
        add_leaderboard_data
      end

      def add_warcraftlogs_data
        RAID_DIFFICULTIES.each_key do |diff|
          output = []
          WCL_IDS[:live].each do |boss|
            value = @character.details['warcraftlogs'][diff.to_s][boss]
            output << (value ? (value == '-' ? '-' : value&.to_f.to_i) : '-')
          end
          @character.data["WCL_#{RAID_DIFFICULTIES[diff]}"] = output.join('|')
        end
      end

      def add_raiderio_data
        @character.data['season_highest_m+'] =
          (@character.details['raiderio']['season_highest'] rescue '-')

        @character.data['weekly_highest_m+'] =
          [
            (@character.details['raiderio']['weekly_highest'] rescue 0) || 0,
            (@character.details['raiderio']['top_ten_highest'][0] rescue 0) || 0
          ].max
      end

      def add_leaderboard_data
        @character.data['dungeons_this_week'] = @character.details['keystones'][Audit.period.to_s]&.size || 0
        dungeons_per_week_in_season = (FIRST_PERIOD_OF_SEASON..(Audit.period - 1)).to_a.reverse.map do |period|
          @character.details['keystones'][period.to_s]&.size || 0
        end
        @character.data['dungeons_done_total'] = dungeons_per_week_in_season.sum + @character.data['dungeons_this_week']
        @character.data['historical_dungeons_done'] = dungeons_per_week_in_season.join('|')

        dungeon_data = (@character.details['keystones'][Audit.period.to_s]&.values&.map { |dungeon| dungeon['level'] } || []).sort.reverse

        if GREAT_VAULT_BLACKLISTED_PERIODS.include?(Audit.period)
          @character.data['great_vault_slot_4'] = ""
          @character.data['great_vault_slot_5'] = ""
          @character.data['great_vault_slot_6'] = ""
        else
          @character.data['great_vault_slot_4'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[0] || 0, 20].min] || ""
          @character.data['great_vault_slot_5'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[3] || 0, 20].min] || ""
          @character.data['great_vault_slot_6'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[7] || 0, 20].min] || ""
        end
      end
    end
  end
end
