module Audit
  class WorldQuestData

    def self.add(character, data)
      wq_data = data['achievements']['criteria'].index(33094)
      wqs = data['achievements']['criteriaQuantity'][wq_data] rescue 0
      character.data['wqs_done_total'] = wqs
      character.data['wqs_this_week'] =
        wqs - character.details['snapshots'][Audit.year][Audit.week]['wqs'] rescue 0

      paragon_amount = 0
      ((36330..36336).to_a + (37309..37315).to_a).each do |chest|
        criteria = data['achievements']['criteria'].index(chest)
        paragon_amount += data['achievements']['criteriaQuantity'][criteria] rescue 0
      end

      # For some reason the first 10 completions are removed
      # from the criterias when the achievement is completed
      paragon_amount += 10 if data['achievements']['achievementsCompleted'].include?(11653)

      character.data['paragon_amount'] = paragon_amount
    end
  end
end
