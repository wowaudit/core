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
          PROCESSORS.constantize.each do |type|
            next if character.essentials_only? && !type::ESSENTIAL
            type.new(character, data).add
          end

          result
        end
      end

      def initialize(result, data)
        @result = result
        @character = @result.character
        @data = data

        unless @character.essentials_only?
          @achievements = @data[:achievements]['achievements']
                            .group_by{ |ach| ach['id'] }
                            .transform_values(&:first)
        end
      end
    end
  end
end
