module Audit
  class LegendaryData

    def self.add(character, data)
      character.legendaries_equipped.uniq.each do |legendary|
        if !character.owned_legendaries.include? legendary
          character.details['legendaries'] << {
            'id' => legendary,
            'name' => LEGENDARIES[legendary]
          }
        end
      end

      character.data['legendary_amount'] = character.details['legendaries'].size
      character.data['legendary_list'] =
        character.details['legendaries'].map{ |l| "#{l['id']}_#{l['name']}"}.join('|')
    end
  end
end
