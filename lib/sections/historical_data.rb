module Audit
  class HistoricalData < Data
    ESSENTIAL = true

    def add
      wqs = []
      dungeons = []
      mplus = []

      @character.historical_snapshots.drop(1).each_with_index do |week, index|
        wqs.insert(0, [(week['wqs'] || 0) - @character.historical_snapshots[index]['wqs'], 0].max)
        dungeons.insert(0, [(week['dungeons'] || 0) - @character.historical_snapshots[index]['dungeons'], 0].max)
        mplus.insert(0, week['m+'] || '-')
      end

      # Current week's highest M+ completion is not stored as a snapshot
      mplus.shift(1)

      @character.data['historical_wqs_done'] = wqs.join('|')
      @character.data['historical_dungeons_done'] = dungeons.join('|')
      @character.data['historical_mplus_done'] = mplus.join('|')
    end
  end
end
