module Audit
  class WorldQuestData

    def self.add(character, data)
      wq_data = data['achievements']['criteria'].index(33094)
      character.data['wqs_done_total'] =
        data['achievements']['criteriaQuantity'][wq_data] rescue 0

      character.data['wqs_this_week'] =
        character.wq_snapshot ? character.data['wqs_done_total'] - character.wq_snapshot : 0

      paragon_amount = 0
      (36330..36336).to_a.each do |chest|
        criteria = data['achievements']['criteria'].index(chest)
        paragon_amount += data['achievements']['criteriaQuantity'][criteria] rescue 0

      # For some reason the first 10 completions are removed
      # from the criterias when the achievement is completed
      paragon_amount += 10 if data['achievements']['achievementsCompleted'].include?(11653)

      character.data['paragon_amount'] = paragon_amount
    end
  end
end





