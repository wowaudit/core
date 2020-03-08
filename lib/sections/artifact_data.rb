module Audit
  class ArtifactData < Data
    ESSENTIAL = true

    def add
      neck = @data.equipment.equipped_items&.select{ |item| item.slot.name == "Neck" }&.first
      cloak = @data.equipment.equipped_items&.select{ |item| item.slot.name == "Back" }&.first

      if neck
        @character.data['artifact_level'] = neck.azerite_details.level.value rescue 0
        @character.data['artifact_progress'] = (neck.azerite_details.percentage_to_next_level * 100).round(2) rescue 0.0
      end

      @character.data['cloak_level'] = begin
        if cloak&.item&.id == 169223
          ((cloak.level.value - 470) + 2) / 2
        end
      end

      # For old spreadsheet versions
      @character.data['ap_this_week'] = 0
      @character.data['ap_obtained_total'] = 0
    end
  end
end
