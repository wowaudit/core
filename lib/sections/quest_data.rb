module Audit
  class QuestData < Data
    def add
      @character.data['quests_done_total'] = @achievements[508].criteria.child_criteria.first.amount rescue 0
      @character.data['wqs_done_total'] = @achievements[11132].criteria.child_criteria.first.amount rescue 0
      @character.data['dailies_done_total'] = @achievements[977].criteria.child_criteria.first.amount rescue 0

      @character.data['wqs_this_week'] =
        @character.data['wqs_done_total'] - @character.details['snapshots'][Audit.year][Audit.week]['wqs'] rescue 0

      # Reset WQ data to 0 when a character changes their account wide sharing setting
      if @character.data['wqs_this_week'] < 0 || @character.data['wqs_this_week'] > 1000
        @character.details['snapshots'][Audit.year][Audit.week]['wqs'] = @character.data['wqs_done_total']
        @character.data['wqs_this_week'] = 0
      end

      @character.data['island_expedition_weekly'] = @data.completed_quests.quests.any? { |quest| [53435, 53436].include? quest.id }
      @character.data['island_expedition_total'] =
        (@achievements[12596].criteria.child_criteria.first.amount rescue 0) + # PvE
        (@achievements[13121].criteria.child_criteria.first.amount rescue 0)   # PvP

      @character.data['weekly_event_completed'] = @data.completed_quests.quests.any? { |quest| WEEKLY_EVENT_QUESTS.include? quest.id }
    end
  end
end
