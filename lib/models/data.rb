module Audit
  class Data
    ESSENTIAL = false

    class << self
      def process(character, data)
        ObjectSpace.each_object(Class).select { |klass| klass < self }.each do |type|
          next if character.essentials_only? && !type::ESSENTIAL
          type.new(character, data).add
        end
      end
    end

    def initialize(character, data)
      @character = character
      @data = data
    end
  end
end
