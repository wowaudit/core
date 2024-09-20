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
        @character.data['week_mythic_dungeons'] = @character.details['keystones'][Audit.period.to_s]&.size || 0
        dungeons_per_week_in_season = (Season.current.data[:first_period]..(Audit.period - 1)).to_a.reverse.map do |period|
          # If for any reason there's a duplicate run stored with a slightly different timestamp, delete it.
          (@character.details['keystones'][period.to_s] || {}).keys.map(&:to_i).each do |timestamp|
            if @character.details['keystones'][period.to_s].keys.map(&:to_i).any? { |other| other != timestamp && other - 60 < timestamp && other + 60 > timestamp }
              @character.details['keystones'][period.to_s].delete(timestamp.to_s)
            end
          end

          (@character.details['keystones'][period.to_s]&.size || 0)
        end

        @character.data['season_mythic_dungeons'] = dungeons_per_week_in_season.sum
        @character.data['historical_dungeons_done'] = dungeons_per_week_in_season.join('|')

        dungeon_data = (@character.details['keystones'][Audit.period.to_s]&.values&.map { |dungeon| dungeon['level'] } || []).sort.reverse
        dungeon_data += (@character.data['week_heroic_dungeons'] || 0).times.map { 0 }

        if GREAT_VAULT_BLACKLISTED_PERIODS.include?(Audit.period)
          @character.data['great_vault_slot_4'] = ""
          @character.data['great_vault_slot_5'] = ""
          @character.data['great_vault_slot_6'] = ""
        else
          @character.data['great_vault_slot_4'] = Season.current.data[:vault_ilvl][:dungeon][[dungeon_data[0] || -1, 10].min] || ""
          @character.data['great_vault_slot_5'] = Season.current.data[:vault_ilvl][:dungeon][[dungeon_data[3] || -1, 10].min] || ""
          @character.data['great_vault_slot_6'] = Season.current.data[:vault_ilvl][:dungeon][[dungeon_data[7] || -1, 10].min] || ""
        end
      end
    end
  end
end
