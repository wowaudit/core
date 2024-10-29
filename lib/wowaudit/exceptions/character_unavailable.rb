module Wowaudit
  module Exception
    class CharacterUnavailable < StandardError
      def initialize(code)
        @code = code
      end

      def message
        "Character data could not be updated (#{@code})."
      end
    end
  end
end
