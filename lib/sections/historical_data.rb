module Audit
  class HistoricalData < Data
    ESSENTIAL = true

    def add
      wqs = []
      dungeons = []
      mplus = []
      vault = { 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [], 8 => [], 9 => [] }

      @character.historical_snapshots.drop(1).each_with_index do |week, index|
        wqs.insert(0, [(week['wqs'] || 0) - (@character.historical_snapshots[index]['wqs'] || 0), 0].max)
        dungeons.insert(0, [(week['dungeons'] || 0) - (@character.historical_snapshots[index]['dungeons'] || 0), 0].max)
        mplus.insert(0, week['m+'] || '-')

        vault.keys.each do |slot|
          value = week.dig('vault', slot.to_s) || "-"
          vault[slot].insert(0, value.to_s.empty? ? "-" : value)
        end
      end

      # Current week's highest M+ completion and vault data are is not stored as a snapshot
      vault.values.each { |slot| slot.shift(1) }
      mplus.shift(1)

      @character.data['historical_wqs_done'] = wqs.join('|')
      @character.data['historical_dungeons_done'] = dungeons.join('|')
      @character.data['historical_mplus_done'] = mplus.join('|')

      vault.each do |slot, data|
        @character.data["historical_great_vault_slot_#{slot}"] = data.join('|')
      end

      weekly_dungeons_from_criteria = [@character.data['dungeons_done_total'] - @character.details['snapshots'][Audit.year][Audit.week]['dungeons'], 0].max rescue 0
      weekly_dungeons_from_raiderio = @character.details['raiderio']['top_ten_highest'].size
      @character.data['dungeons_this_week'] = [weekly_dungeons_from_criteria, weekly_dungeons_from_raiderio].max

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
