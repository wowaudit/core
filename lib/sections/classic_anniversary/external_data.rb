module Audit
  module ClassicAnniversary
    class ExternalData < Data
      SKIPPABLE = false

      def add
        Audit::Live::ExternalData.new(@character, @data, @skipped, @realm, @temp_character).add(:classic_anniversary)
      end
    end
  end
end
