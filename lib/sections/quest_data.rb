module Audit
  class QuestData < Data
    def add
      if @achievements
        @character.data['quests_done_total'] = @achievements[508]['criteria']['child_criteria'].first['amount'] rescue 0
        @character.data['wqs_done_total'] = @achievements[11132]['criteria']['child_criteria'].first['amount'] rescue 0
        @character.data['dailies_done_total'] = @achievements[977]['criteria']['child_criteria'].first['amount'] rescue 0
      end

      unless @data[:completed_quests].class == RBattlenet::EmptyHashResult
        @character.data['weekly_event_completed'] = @data.dig(:completed_quests, 'quests')&.any? { |quest| WEEKLY_EVENT_QUESTS.include? quest['id'] }
      end
    end
  end
end
