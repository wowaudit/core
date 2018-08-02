module Audit
  class ArtifactData

    def self.add(character, data)
      character.data['artifact_level'] = 0 #TODO: Add data source

      ap_data = data['achievements']['criteria'].index(30103)
      ap = data['achievements']['criteriaQuantity'][ap_data] rescue 0
      character.data['ap_obtained_total'] = ap
      character.data['ap_this_week'] =
        ap - character.details['snapshots'][Audit.year][Audit.week]['ap'] rescue 0
    end
  end
end
