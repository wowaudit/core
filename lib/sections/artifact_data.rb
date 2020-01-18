module Audit
  class ArtifactData < Data
    def add
      @character.data['artifact_level'] = @data['items']['neck']['azeriteItem']['azeriteLevel'] rescue 0
      @character.data['artifact_experience'] = @data['items']['neck']['azeriteItem']['azeriteExperience'] rescue 0
      @character.data['artifact_experience_total_for_level'] = @data['items']['neck']['azeriteItem']['azeriteExperienceRemaining'] rescue 0
      @character.data['artifact_progress'] =
        (@character.data['artifact_experience'].to_f / @character.data['artifact_experience_total_for_level'] * 100).round(2)
      @character.data['artifact_progress'] = 0 if @character.data['artifact_progress'].nan?

      @character.data['cloak_level'] = begin
        if @data.items.back&.id == 169223
          ((@data.items.back.itemLevel - 470) + 2) / 2
        end
      end

      # For old spreadsheet versions
      @character.data['ap_this_week'] = 0
      @character.data['ap_obtained_total'] = 0

      @character.data['island_expedition_weekly'] = @data['quests'].include?(53435) || @data['quests'].include?(53436)
      @character.data['island_expedition_total'] =
        (@data['achievements']['criteriaQuantity'][@data['achievements']['criteria'].index(40564)] rescue 0) + # PvE
        (@data['achievements']['criteriaQuantity'][@data['achievements']['criteria'].index(40565)] rescue 0)   # PvP

      @character.data['weekly_event_completed'] = WEEKLY_EVENT_QUESTS.select{ |e| @data['quests'].include?(e) }.any?
    end
  end
end
