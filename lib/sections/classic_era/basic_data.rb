module Audit
  module ClassicEra
    class BasicData < Data
      SKIPPABLE = false

      def add
        Audit::Live::BasicData.new(@character, @data, @skipped, @realm).add
      end
    end
  end
end
