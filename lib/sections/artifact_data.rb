module Audit
  class ArtifactData

    def self.add(character, data)
      character.data['artifact_level'] = data['items']['neck']['azeriteItem']['azeriteLevel'] rescue 0
      character.data['ap_obtained_total'] = 0
      character.data['ap_this_week'] =
        character.data['ap_obtained_total'] - character.details['snapshots'][Audit.year][Audit.week]['ap'] rescue 0
    end
  end
end
