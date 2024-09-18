module Audit
  module Live
    class HistoricalData < Data
      SKIPPABLE = false

      def add
        wqs = []
        mplus = []
        vault = { 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [], 8 => [], 9 => [] }

        (FIRST_PERIOD_OF_EXPANSION..(Audit.period)).each_with_index do |period, index|
          week = @character.details['snapshots'][period] || {}


          wqs.insert(0, [(week['wqs'] || 0) - (@character.details['snapshots'][period - 1]&.dig('wqs') || 0), 0].max) if index > 0

          vault.keys.each do |slot|
            # Experiment with constructing historical vaults from stored keystones instead of using a one-time snapshot
            if [4, 5, 6].include?(slot)
              nil
            else
              value = week.dig('vault', slot.to_s) || "-"
              vault[slot].insert(0, value.to_s.empty? ? "-" : value)
            end
          end

          # Experiment with constructing historical vaults from stored keystones instead of using a one-time snapshot
          # TODO: this doesn't work when looking back at previous seasons, it will now always return the item level of the current season.
          dungeon_data = (@character.details['keystones'][period.to_s]&.values || []).map { |run| run['level'] }.sort.reverse
          vault[4].insert(0, Season.current.data[:vault_ilvl][:dungeon][[dungeon_data[0] || 0, 10].min] || "-")
          vault[5].insert(0, Season.current.data[:vault_ilvl][:dungeon][[dungeon_data[3] || 0, 10].min] || "-")
          vault[6].insert(0, Season.current.data[:vault_ilvl][:dungeon][[dungeon_data[7] || 0, 10].min] || "-")

          mplus << dungeon_data.join(',')
        end

        # Current week's highest M+ completion and vault data are not stored as a snapshot
        vault.values.each { |slot| slot.shift(1) }
        mplus.shift(1)

        @character.data['historical_wqs_done'] = wqs.join('|')
        @character.data['historical_mplus_done'] = mplus.join('|')

        vault.each do |slot, data|
          @character.data["historical_great_vault_slot_#{slot}"] = data.join('|')
        end

        @character.data['wqs_this_week'] =
          [@character.data['wqs_done_total'] - @character.details['snapshots'][Audit.period.to_s]['wqs'], 0].max rescue 0

        @character.data['week_heroic_dungeons'] =
          [@character.data['season_heroic_dungeons'] - @character.details['snapshots'][Audit.period.to_s]['heroic_dungeons'], 0].max rescue 0

        # @character.data['week_mythic_dungeons'] =
        #   [@character.data['season_mythic_dungeons'] - @character.details['snapshots'][Audit.period.to_s]['mythic_dungeons'], 0].max rescue 0


        # Reset WQ data to 0 when a character changes their account wide sharing setting
        if @character.data['wqs_this_week'] < 0 || @character.data['wqs_this_week'] > 1000
          @character.details['snapshots'][Audit.period.to_s]['wqs'] = @character.data['wqs_done_total']
          @character.data['wqs_this_week'] = 0
        end
      end
    end
  end
end
