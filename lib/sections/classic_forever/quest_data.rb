module Audit
  module ClassicForever
    class QuestData < Data
      ATTUNEMENT_QUESTS = {
        'dalaran_sewers_attuned' => [92434, 92432],
        'onyxia_attuned' => [6502, 6602],
      }

      def add
        quests = @data.dig(:completed_quests, :quests)
        return unless quests

        completed = quests.map { |quest| quest[:id] }.to_set
        ATTUNEMENT_QUESTS.each do |field, quest_ids|
          @character.data[field] = quest_ids.any? { |id| completed.include?(id) } ? 'yes' : 'no'
        end
      end
    end
  end
end
