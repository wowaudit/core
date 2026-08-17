module Audit
  module Live
    class ExternalData < Data
      SKIPPABLE = false

      def add(type = :live)
        add_warcraftlogs_data(type)

        # Raider.io and leaderboard (Mythic+) data only exist on the live game version.
        if type == :live
          add_raiderio_data
          add_leaderboard_data
          add_game_data
        end
      end

      def add_warcraftlogs_data(type = :live)
        RAID_DIFFICULTIES.each_key do |diff|
          output = []
          WCL_IDS[type].each do |boss|
            value = @character.details.dig('warcraftlogs', diff.to_s, boss)
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

      def add_game_data
        bonus_roll = bonus_roll_data
        expected = Season.current.data[:bonus_roll_currency_id]

        if bonus_roll.nil? || bonus_roll.empty? || (expected && bonus_roll['currency_id'] != expected)
          @character.data['bonus_rolls_left'] = "?"
          @character.data['bonus_rolls_earned'] = "?"
          @character.data['bonus_rolls_synced'] = "-"
          return
        end

        @character.data['bonus_rolls_left'] = bonus_roll['left']
        @character.data['bonus_rolls_earned'] = bonus_roll['earned']
        @character.data['bonus_rolls_synced'] = format_bonus_roll_age(bonus_roll['updated_at'])
      end

      def bonus_roll_data
        raw = @temp_character.respond_to?(:game_data) ? @temp_character.game_data : nil
        game_data = case raw
                    when String then (JSON.parse(raw) rescue {})
                    when Hash then raw
                    else {}
                    end
        game_data['bonus_roll']
      end

      def format_bonus_roll_age(updated_at)
        return "" if updated_at.nil? || updated_at == ""

        hours = (Time.now.to_i - updated_at.to_i) / 3600
        hours < 24 ? "#{hours}h ago" : "#{hours / 24}d ago"
      end

      def add_leaderboard_data
        first_period = Season.current.data[:first_period]
        preseason = first_period > Audit.period

        dungeons_per_week_in_season = (first_period..Audit.period).to_a.reverse.map do |period|
          # If for any reason there's a duplicate run stored with a slightly different timestamp, delete it.
          (@character.details['keystones'][period.to_s] || {}).keys.map(&:to_i).each do |timestamp|
            if @character.details['keystones'][period.to_s].keys.map(&:to_i).any? { |other| other != timestamp && other - 60 < timestamp && other + 60 > timestamp }
              @character.details['keystones'][period.to_s].delete(timestamp.to_s)
            end
          end

          if period == Audit.period
            @character.data['week_mythic_dungeons'] = (@character.details['keystones'][period.to_s]&.size || 0)
            nil
          else
            (@character.details['keystones'][period.to_s]&.size || 0)
          end
        end.compact

        regular_mythic_count = @character.data['week_regular_mythic_dungeons'] ||
          @character.details.dig('snapshots', Audit.period.to_s, 'regular_mythic_dungeons')

        # Before the season's first M+ period, regular mythics fill the dungeon vault (as +1).
        # After that they would double-count with keystone runs of the same dungeon.
        if preseason
          @character.data['week_mythic_dungeons'] = regular_mythic_count || @character.data['week_mythic_dungeons'] || 0
        end

        @character.data['season_mythic_dungeons'] = dungeons_per_week_in_season.sum + (@character.data['week_mythic_dungeons'] || 0)
        @character.data['historical_dungeons_done'] = dungeons_per_week_in_season.join('|')

        dungeon_data = if preseason
          (regular_mythic_count || @character.data['week_mythic_dungeons'] || 0).times.map { 1 }
        else
          (@character.details['keystones'][Audit.period.to_s]&.values&.map { |dungeon| dungeon['level'] } || []).sort.reverse
        end
        dungeon_data += (@character.data['week_heroic_dungeons'] || 0).times.map { 0 }

        if GREAT_VAULT_BLACKLISTED_PERIODS.include?(Audit.period)
          @character.data['great_vault_slot_4'] = ""
          @character.data['great_vault_slot_5'] = ""
          @character.data['great_vault_slot_6'] = ""
        else
          @character.data['great_vault_slot_4'] = Season.current.data[:great_vault][:dungeon][[dungeon_data[0] || -1, 10].min]&.dig(:ilvl) || ""
          @character.data['great_vault_slot_5'] = Season.current.data[:great_vault][:dungeon][[dungeon_data[3] || -1, 10].min]&.dig(:ilvl) || ""
          @character.data['great_vault_slot_6'] = Season.current.data[:great_vault][:dungeon][[dungeon_data[7] || -1, 10].min]&.dig(:ilvl) || ""
        end
      end
    end
  end
end
