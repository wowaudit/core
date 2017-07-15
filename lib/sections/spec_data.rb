module Audit
  class SpecData

    def self.add(character, data)
      spec_output = []
      max_spec = [0,0]

      (1..4).to_a.each do |spec|
        if spec == character.spec_id
          spec_output << "#{character.data['equipped_traits']}_#{character.data['ilvl']}"
          character.data["spec#{spec}_traits"] = character.data['equipped_traits']
          character.data["spec#{spec}_ilvl"] = character.data['ilvl']
          character.specs[spec] = [character.data['equipped_traits'], character.data['ilvl']]
        else
          spec_output << "#{character.specs[spec][0]}_#{character.specs[spec][1]}"
          character.data["spec#{spec}_traits"] = character.specs[spec][0]
          character.data["spec#{spec}_ilvl"] = character.specs[spec][1]
        end

        #Find main spec
        if ROLES[character.data['role']][CLASSES[data['class']]].include?(spec)
          if character.specs[spec][0].to_i >= max_spec[1]
            max_spec = [spec, character.specs[spec][0].to_i]
          end
        end
      end

      spec_output << character.max_ilvl.to_s
      character.data['highest_ilvl_ever_equipped'] = character.max_ilvl
      character.data['main_spec'] = max_spec[0]
      character.per_spec = spec_output.join('|')
    end
  end
end



