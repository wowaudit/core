module Audit
  module ClassicProgression
    class CollectionData < Data
      def add
        @character.data['achievement_points'] = @data[:achievement_points]

        {
          exalted_amount: 523,
          mounts_obtained: 2141,
          unique_pets: 15,
          quests_done_total: 508,
          dailies_done_total: 977,
        }.each do |key, id|
          achievement = @achievements.dig(id, :criteria)
          @character.data[key.to_s] = achievement&.dig(:amount) || achievement[:child_criteria].first[:amount] rescue 0
        end

        chapters_completed = [
          7533,
          7534,
          8008,
          7535,
          7536,
          8325,
        ].count { |id| @achievements.dig(id, :criteria, :is_completed) }

        roman_numerals = {1 => 'I', 2 => 'II', 3 => 'III', 4 => 'IV', 5 => 'V'}
        @character.data['wrathion_questline'] = chapters_completed > 0 ? "Chapter #{roman_numerals[chapters_completed]}" : "-"
      end
    end
  end
end
