module Audit
  module ClassicProgression
    class ExternalData < Data
      SKIPPABLE = false

      def add
        Audit::Live::ExternalData.new(@character, @data, @skipped, @realm, @temp_character).add(:classic_progression)
      end
    end
  end
end
