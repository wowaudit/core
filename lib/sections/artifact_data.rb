module Audit
  class ArtifactData

    def self.add(character, data)
      # TODO: Add data source once it's available
      character.data['artifact_level'] = 0
      character.data['ap_obtained_total'] = 0
      character.data['ap_this_week'] = 0
    end
  end
end
