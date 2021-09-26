module Wowaudit
  class DataProcessor::Quests < DataProcessor::Base
    def add
      if @achievements
        @result.data['quests_done_total'] = @achievements[508]['criteria']['child_criteria'].first['amount'] rescue 0
        @result.data['wqs_done_total'] = @achievements[11132]['criteria']['child_criteria'].first['amount'] rescue 0
        @result.data['dailies_done_total'] = @achievements[977]['criteria']['child_criteria'].first['amount'] rescue 0
        @result.data['mission_table_completions'] = @achievements[14847]['criteria']['child_criteria'].first['amount'] rescue 0
      end

      unless @data[:completed_quests].class == RBattlenet::EmptyHashResult
        @result.data['weekly_event_completed'] = @data.dig(:completed_quests, 'quests')&.any? { |quest| WEEKLY_EVENT_QUESTS.include? quest['id'] }
      end
    end
  end
end
