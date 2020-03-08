module Audit
  class WorldQuestData < Data
    def add
      # Await Blizzard to allow tracking WQs completed again
      @character.data['wqs_done_total'] = @character.historical_snapshots.last["wqs"] rescue 0
      @character.data['wqs_this_week'] = 0

      @character.data['island_expedition_weekly'] = @data.completed_quests.quests.any? { |quest| [53435, 53436].include? quest.id }
      @character.data['island_expedition_total'] =
        (@achievements[12596].criteria.child_criteria.first.amount rescue 0) + # PvE
        (@achievements[13121].criteria.child_criteria.first.amount rescue 0)   # PvP

      @character.data['weekly_event_completed'] = @data.completed_quests.quests.any? { |quest| WEEKLY_EVENT_QUESTS.include? quest.id }
    end
  end
end
