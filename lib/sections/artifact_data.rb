module Audit
  class ArtifactData

    def self.add(character, data)
      begin
        character.data['artifact_ilvl'] = data['items']['mainHand']['itemLevel']

        total_traits = 0

        # Find if the character has an Artifact weapon equipped
        # And whether it is a main-hand or off-hand Artifact
        if data['items']['mainHand']['artifactTraits'].any?
          weapon = 'mainHand'
        else
          weapon = data['items']['offHand']['artifactTraits'] ? 'offHand' : false rescue false
        end

        if weapon
          character.data['current_spec_name'] = ARTIFACTS[data['items'][weapon]['name']][0]
          character.spec_id = ARTIFACTS[data['items'][weapon]['name']][1]

          data['items'][weapon]['artifactTraits'].each do |trait|
            total_traits += trait['rank'].to_i
          end

          total_traits -= data['items'][weapon]['relics'].length
          character.data['equipped_traits'] = total_traits

          (1..3).to_a.each do |relic|
            character.data["relic#{relic}_ilvl"] =
              RELIC_ILVL[data['items'][weapon]['bonusLists'][relic]-1472] rescue ''
            character.data["relic#{relic}_id"] =
              data['items'][weapon]['relics'][relic - 1]['itemId'] rescue ''

            character.data["relic#{relic}_name"] = '' #Not used yet
            character.data["relic#{relic}_quality"] = '' #Not used yet
          end
        else
          raise StandardError
        end
      rescue
        # Fallback values when the character has no Artifact equipped
        character.data['current_spec_name'] = 'Unknown'
        character.data['equipped_traits'] = 0
        character.data['artifact_ilvl'] = 0

        (1..3).to_a.each do |relic|
          character.data["relic#{relic}_ilvl"] = ''
          character.data["relic#{relic}_id"] = ''
          character.data["relic#{relic}_name"] = ''
          character.data["relic#{relic}_quality"] = ''
        end
      end

      ap_data = data['achievements']['criteria'].index(30103)
      character.data['ap_obtained_total'] =
        data['achievements']['criteriaQuantity'][ap_data] rescue 0

      character.data['ap_this_week'] =
        character.ap_snapshot ? character.data['ap_obtained_total'] - character.ap_snapshot : 0
    end
  end
end
