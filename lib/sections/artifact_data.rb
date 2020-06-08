module Audit
  class ArtifactData < Data
    ESSENTIAL = true

    def add
      neck = @data[:equipment]['equipped_items']&.select{ |item| item['slot']['name'] == "Neck" }&.first
      cloak = @data[:equipment]['equipped_items']&.select{ |item| item['slot']['name'] == "Back" }&.first

      if neck
        @character.data['artifact_level'] = neck['azerite_details']['level']['value'] rescue 0
        @character.data['artifact_progress'] = (neck['azerite_details']['percentage_to_next_level'] * 100).round(2) rescue 0.0
      end

      @character.data['cloak_level'] = begin
        if cloak.dig('item', 'id') == 169223
          base_rank = [((cloak['level']['value'] - 470) + 2) / 2, 15].min
          cores = [((cloak['stats'].select{ |stat| stat['type']['name'] == "Corruption Resistance" }
            .first&.dig('value') || 0) - 50) / 3, 0].max
          base_rank + cores
        end
      end

      # For old spreadsheet versions
      @character.data['ap_this_week'] = 0
      @character.data['ap_obtained_total'] = 0
    end
  end
end
