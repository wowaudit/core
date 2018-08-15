module Audit
  class ArtifactData

    def self.add(character, data)
      character.data['artifact_level'] = data['items']['neck']['azeriteItem']['azeriteLevel'] rescue 0
      character.data['artifact_experience'] = data['items']['neck']['azeriteItem']['azeriteExperience'] rescue 0
    end
  end
end
