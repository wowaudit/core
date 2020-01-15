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
    end
  end
end
