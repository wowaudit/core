module Wowaudit
  module DataProcessor
    class Base
      ESSENTIAL = false
      PROCESSORS = [
        "Wowaudit::DataProcessor::Basic",
        "Wowaudit::DataProcessor::Collections",
        "Wowaudit::DataProcessor::Gear",
        "Wowaudit::DataProcessor::Instances",
        "Wowaudit::DataProcessor::Professions",
        "Wowaudit::DataProcessor::PvP",
        "Wowaudit::DataProcessor::Quests",
        "Wowaudit::DataProcessor::Reputation",
        "Wowaudit::DataProcessor::Soulbinds",
      ]

      class << self
        def process(result, data)
          PROCESSORS.map(&:constantize).each do |type|
            next if !Wowaudit.extended && !type::ESSENTIAL
            type.new(result, data).add
          end

          result
        end
      end

      def initialize(result, data)
        @result = result
        @character = @result.character
        @data = data

        if Wowaudit.extended
          @achievements = @data[:achievements]['achievements']
                            .group_by{ |ach| ach['id'] }
                            .transform_values(&:first)
        end
      end
    end
  end
end
