module Audit
  module Live
    class QuestData < Data
      def add
        if @achievements
          @character.data['quests_done_total'] = @achievements[508][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['wqs_done_total'] = @achievements[11132][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['dailies_done_total'] = @achievements[977][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['worldsoul_memories'] = @achievements[40251][:criteria][:child_criteria].first[:amount] rescue 0
        end

        @character.data['worldsoul_weekly'] = 'no'
        @character.data['theater_troupe'] = 'no'
        @character.data['awakening_the_machine'] = 'no'

        @data.dig(:completed_quests, :quests)&.lazy&.each do |quest|
          @character.data['worldsoul_weekly'] = 'yes' if WORLDSOUL_WEEKLY_QUESTS.include? quest[:id]
          @character.data['theater_troupe'] = 'yes' if quest[:id] == 83240
          @character.data['awakening_the_machine'] = 'yes' if quest[:id] == 83333
        end

        unless !@data[:completed_quests]
          @character.data['weekly_event_completed'] = @data.dig(:completed_quests, :quests)&.lazy&.any? { |quest| WEEKLY_EVENT_QUESTS.include? quest[:id] } ? 'yes' : 'no'
        end
      end
    end
  end
end
