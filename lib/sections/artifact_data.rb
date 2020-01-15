module Audit
  class ArtifactData < Data
    def add
      neck = @data.equipment.equipped_items.select{ |item| item.slot.name == "Neck" }.first

      if neck
        @character.data['artifact_level'] = neck.azerite_details.level.value rescue 0
        @character.data['artifact_progress'] = (neck.azerite_details.percentage_to_next_level * 100).round(2) rescue 0.0
      end

      # For old spreadsheet versions
      @character.data['ap_this_week'] = 0
      @character.data['ap_obtained_total'] = 0

      @character.data['island_expedition_weekly'] = @data.legacy['quests'].include?(53435) || @data.legacy['quests'].include?(53436)
      @character.data['island_expedition_total'] =
        (@data.legacy['achievements']['criteriaQuantity'][@data.legacy['achievements']['criteria'].index(40564)] rescue 0) + # PvE
        (@data.legacy['achievements']['criteriaQuantity'][@data.legacy['achievements']['criteria'].index(40565)] rescue 0)   # PvP

      @character.data['weekly_event_completed'] = WEEKLY_EVENT_QUESTS.select{ |e| @data.legacy['quests'].include?(e) }.any?
    end
  end
end
