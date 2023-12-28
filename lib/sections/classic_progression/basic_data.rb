module Audit
  module ClassicProgression
    class BasicData < Data
      SKIPPABLE = false

      def add
        Audit::Live::BasicData.new(@character, @data, @skipped, @realm, @temp_character).add(:classic_progression)
      end
    end
  end
end
