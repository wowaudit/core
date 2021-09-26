module Wowaudit
  class DataProcessor
    ESSENTIAL = false
    PROCESSORS = [
      BasicDataProcessor,
      CollectionDataProcessor,
      GearDataProcessor,
      InstanceDataProcessor,
      ProfessionDataProcessor,
      PvPDataProcessor,
      QuestDataProcessor,
      ReputationDataProcessor,
      SoulbindDataProcessor,
    ]

    class << self
      def process(result, data)
        PROCESSORS.each do |type|
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
