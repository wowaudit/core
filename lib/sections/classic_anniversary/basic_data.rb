module Audit
  module ClassicAnniversary
    class BasicData < Data
      SKIPPABLE = false

      def add
        Audit::Live::BasicData.new(@character, @data, @skipped, @realm, @temp_character).add(:classic_anniversary)
      end
    end
  end
end
