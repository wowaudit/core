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
          @character.data[key.to_s] = @achievements[id][:criteria][:child_criteria].first[:amount] rescue 0
        end

        @character.data['emblems_obtained'] = @achievements[4316][:criteria][:amount] rescue 0

        {
          undying: [2187],
          immortal: [2186],
          champion_of_ulduar: [2903],
          conqueror_of_ulduar: [2904],
          mimirons_head: [4626],
          tribute_to_immortality: [4079, 4156],
          invincible: [4625],
        }.each do |key, ids|
          @character.data["achievement_#{key}"] = ids.any? { |id| @achievements[id]&.dig(:criteria, :is_completed) } ? 'yes' : 'no'
        end
      end
    end
  end
end
