module Audit
  class LegendaryData

    def self.add(character, data)
      character.legendaries_equipped.each do |legendary|
        if !character.all_legendaries.include?(legendary)
          character.all_legendaries << legendary
          character.changed = true
        end
      end

      character.data['legendary_amount'] = character.all_legendaries.length
      character.data['legendary_list'] = character.all_legendaries.join('|')
      character.legendaries = character.all_legendaries.join('|')
    end
  end
end
