module Audit
  class HistoricalData

    def self.add(character, data)
      wqs = []
      dungeons = []

      character.historical_snapshots.drop(1).each_with_index do |week, index|
        wqs.insert(0, week['wqs'] - character.historical_snapshots[index]['wqs'])
        dungeons.insert(0, week['dungeons'] - character.historical_snapshots[index]['dungeons'])
      end

      character.data['historical_wqs_done'] = wqs.join('|')
      character.data['historical_dungeons_done'] = dungeons.join('|')
    end
  end
end
