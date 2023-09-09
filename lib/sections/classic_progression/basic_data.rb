module Audit
  module ClassicProgression
    class BasicData < Data
      SKIPPABLE = false

      def add
        Audit::Live::BasicData.new(@character, @data, @skipped, @realm).add
      end
    end
  end
end
