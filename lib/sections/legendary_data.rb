module Audit
  class LegendaryData

    def self.add(character, data)
      all_legendaries = character.legendaries.split('|')
      character.legendaries_equipped.each do |legendary|
        if !all_legendaries.include?(legendary)
          all_legendaries << legendary
        end
      end

      character.data['legendary_amount'] = all_legendaries.length
      character.data['legendary_list'] = all_legendaries.join('|')
      character.legendaries = all_legendaries.join('|')
    end
  end
end
