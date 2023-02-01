module Audit
  class HistoricalData < Data
    ESSENTIAL = true

    def add
      wqs = []
      mplus = []
      vault = { 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [], 8 => [], 9 => [] }

      @character.historical_snapshots.drop(1).each_with_index do |week, index|
        wqs.insert(0, [(week['wqs'] || 0) - (@character.historical_snapshots[index]['wqs'] || 0), 0].max)
        mplus.insert(0, week['m+'] || '-')

        vault.keys.each do |slot|
          # Experiment with constructing historical vaults from stored keystones instead of using a one-time snapshot
          if [4, 5, 6].include?(slot)
            nil
          else
            value = week.dig('vault', slot.to_s) || "-"
            vault[slot].insert(0, value.to_s.empty? ? "-" : value)
          end
        end
      end


      # Experiment with constructing historical vaults from stored keystones instead of using a one-time snapshot
      (FIRST_PERIOD_OF_EXPANSION..(Audit.period)).each do |period|
        dungeon_data = (@character.details['keystones'][period.to_s]&.values || []).map { |run| run[F_LEVEL] }.sort.reverse
        vault[4].insert(0, GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[0] || 0, 20].min] || "-")
        vault[5].insert(0, GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[3] || 0, 20].min] || "-")
        vault[6].insert(0, GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[7] || 0, 20].min] || "-")
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
        [@character.data['wqs_done_total'] - @character.details['snapshots'][Audit.year][Audit.week]['wqs'], 0].max rescue 0

      # Reset WQ data to 0 when a character changes their account wide sharing setting
      if @character.data['wqs_this_week'] < 0 || @character.data['wqs_this_week'] > 1000
        @character.details['snapshots'][Audit.year][Audit.week]['wqs'] = @character.data['wqs_done_total']
        @character.data['wqs_this_week'] = 0
      end
    end
  end
end
