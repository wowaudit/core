module Audit
  module ClassicProgression
    class CollectionData < Data
      def add
        @character.data['achievement_points'] = @data[:achievement_points]
        @character.data['exalted_amount'] = @achievements[522][:criteria][:child_criteria].first[:amount] rescue 0
      end
    end
  end
end
