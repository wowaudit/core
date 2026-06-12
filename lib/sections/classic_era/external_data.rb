module Audit
  module ClassicEra
    class ExternalData < Data
      SKIPPABLE = false

      def add
        Audit::Live::ExternalData.new(@character, @data, @skipped, @realm, @temp_character).add(:classic_era)
      end
    end
  end
end
