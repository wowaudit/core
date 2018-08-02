module Audit
  class WorldQuestData

    def self.add(character, data)
      wq_data = data['achievements']['criteria'].index(33094)
      wqs = data['achievements']['criteriaQuantity'][wq_data] rescue 0
      character.data['wqs_done_total'] = wqs
      character.data['wqs_this_week'] =
        wqs - character.details['snapshots'][Audit.year][Audit.week]['wqs'] rescue 0
    end
  end
end
