module Audit
  class HistoricalData

    def self.add(character, data)
      wqs = []
      ap = []
      dungeons = []

      character.old_snapshots.drop(1).each_with_index do |week, index|
        wqs.insert(0, week['wqs'] - character.old_snapshots[index]['wqs'])
        ap.insert(0, week['ap'] - character.old_snapshots[index]['ap'])
        dungeons.insert(0, week['dungeons'] - character.old_snapshots[index]['dungeons'])
      end

      character.data['historical_wqs_done'] = wqs.join('|')
      character.data['historical_ap_gained'] = ap.join('|')
      character.data['historical_dungeons_done'] = dungeons.join('|')
    end
  end
end
