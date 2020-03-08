module Audit
  class WorldQuestData < Data
    def add
      wq_data = @data.legacy.achievements.criteria.index(33094)
      wqs = @data.legacy.achievements.criteriaQuantity[wq_data] rescue 0
      @character.data['wqs_done_total'] = wqs
      @character.data['wqs_this_week'] =
        wqs - @character.details['snapshots'][Audit.year][Audit.week]['wqs'] rescue 0

      # Workaround for bug when WQ total returns an incorrect high amount
      if @character.data['wqs_this_week'] < 0
        @character.details['snapshots'][Audit.year][Audit.week]['wqs'] = wqs
        @character.data['wqs_this_week'] = 0
      end

      @character.data['island_expedition_weekly'] = @data.legacy['quests'].include?(53435) || @data.legacy['quests'].include?(53436)
      @character.data['island_expedition_total'] =
        (@data.legacy['achievements']['criteriaQuantity'][@data.legacy['achievements']['criteria'].index(40564)] rescue 0) + # PvE
        (@data.legacy['achievements']['criteriaQuantity'][@data.legacy['achievements']['criteria'].index(40565)] rescue 0)   # PvP

      @character.data['weekly_event_completed'] = WEEKLY_EVENT_QUESTS.select{ |e| @data.legacy['quests'].include?(e) }.any?
    end
  end
end
