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

        @character.data['theater_troupe'] = @data.dig(:completed_quests, :quests)&.lazy&.any? { |quest| quest[:id] == 83240 } ? 'yes' : 'no'
        @character.data['spreading_the_light'] = @data.dig(:completed_quests, :quests)&.lazy&.any? { |quest| quest[:id] == 76586 } ? 'yes' : 'no'
        @character.data['awakening_the_machine'] = @data.dig(:completed_quests, :quests)&.lazy&.any? { |quest| quest[:id] == 83333 } ? 'yes' : 'no'

        unless !@data[:completed_quests]
          @character.data['weekly_event_completed'] = @data.dig(:completed_quests, :quests)&.lazy&.any? { |quest| WEEKLY_EVENT_QUESTS.include? quest[:id] } ? 'yes' : 'no'
        end
      end
    end
  end
end
