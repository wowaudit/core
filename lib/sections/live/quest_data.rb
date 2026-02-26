module Audit
  module Live
    class QuestData < Data
      def add
        if @achievements
          @character.data['quests_done_total'] = @achievements[508][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['wqs_done_total'] = @achievements[11132][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['dailies_done_total'] = @achievements[977][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['worldsoul_memories'] = @achievements[40251][:criteria][:amount] rescue 0
        end

        @character.data['legends_of_the_haranir_weekly'] = 'no'
        @character.data['weekly_abundance'] = 'no'
        @character.data['saltherils_soiree'] = 'no'

        raid_buff_amount = 0
        @data.dig(:completed_quests, :quests)&.lazy&.each do |quest|
          @character.data['unity_against_the_void_weekly'] = 'yes' if UNITY_WEEKLY_QUESTS.include? quest[:id]
          @character.data['legends_of_the_haranir_weekly'] = 'yes' if HARANIR_WEEKLY_QUESTS.include? quest[:id]
          @character.data['weekly_abundance'] = 'yes' if quest[:id] == 89507
          @character.data['stormarion_assault'] = 'yes' if quest[:id] == 94581
          @character.data['saltherils_soiree'] = 'yes' if SALTHERIL_WEEKLY_QUESTS.include? quest[:id]
          raid_buff_amount += 1 if RAID_BUFF_IDS.include? quest[:id]
        end

        @character.data['raid_buff_percentage'] = " #{raid_buff_amount * 3} %"

        unless !@data[:completed_quests]
          @character.data['weekly_event_completed'] = @data.dig(:completed_quests, :quests)&.lazy&.any? { |quest| WEEKLY_EVENT_QUESTS.include? quest[:id] } ? 'yes' : 'no'
        end
      end
    end
  end
end
