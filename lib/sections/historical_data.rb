module Audit
  class HistoricalData

    def self.add(character, data)
      wqs = []
      ap = []
      dungeons = []
      normal_daily_dungeons = []
      heroic_daily_dungeons = []

      character.historical_snapshots.drop(1).each_with_index do |week, index|
        wqs.insert(0, week['wqs'] - character.historical_snapshots[index]['wqs'])
        ap.insert(0, week['ap'] - character.historical_snapshots[index]['ap'])
        dungeons.insert(0, week['dungeons'] - character.historical_snapshots[index]['dungeons'])
        normal_daily_dungeons.insert(0, character.historical_snapshots[index]['dailies']['normal_dungeon'] || 0)
        heroic_daily_dungeons.insert(0, character.historical_snapshots[index]['dailies']['heroic_dungeon'] || 0)
      end

      character.data['historical_wqs_done'] = wqs.join('|')
      character.data['historical_ap_gained'] = ap.join('|')
      character.data['historical_dungeons_done'] = dungeons.join('|')
      character.data['historical_daily_normal_dungeons_done'] = normal_daily_dungeons.join('|')
      character.data['historical_daily_heroic_dungeons_done'] = heroic_daily_dungeons.join('|')
    end
  end
end
