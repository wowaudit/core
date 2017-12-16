module Audit
  class SpecData

    def self.add(character, data)
      spec_output = []
      max_spec = [0,0]

      (1..4).to_a.each do |spec|
        if spec == character.spec_id
          character.data["spec#{spec}_traits"] = character.data['equipped_traits']
          character.data["spec#{spec}_ilvl"] = character.data['ilvl']
          character.details['spec_data'][spec.to_s] = {
            'traits' => character.data['equipped_traits'],
            'ilvl' => character.data['ilvl']
          }
        else
          character.data["spec#{spec}_traits"] = character.details['spec_data'][spec.to_s]['traits']
          character.data["spec#{spec}_ilvl"] = character.details['spec_data'][spec.to_s]['ilvl']
        end

        # Find main spec
        if ROLES[character.data['role']][CLASSES[data['class']]].include?(spec)
          if character.details['spec_data'][spec.to_s]['traits'].to_i >= max_spec[1]
            max_spec = [spec, character.details['spec_data'][spec.to_s]['traits'].to_i]
          end
        end
      end

      character.data['highest_ilvl_ever_equipped'] = character.details['max_ilvl']
      character.data['main_spec'] = max_spec[0]
    end
  end
end



