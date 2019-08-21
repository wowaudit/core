module Audit
  class Data
    class << self
      def process(character, data)
        ObjectSpace.each_object(Class).select { |klass| klass < self }.each do |type|
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
