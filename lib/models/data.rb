module Audit
  class Data
    SKIPPABLE = true

    class << self
      def process(character, data, skipped)
        [
          Audit::BasicData, Audit::CollectionData, Audit::ExternalData, Audit::GearData, Audit::HistoricalData,
          Audit::InstanceData, Audit::ProfessionData, Audit::PvPData, Audit::QuestData, Audit::ReputationData
        ].each do |type|
          next if skipped && type::SKIPPABLE

          type.new(character, data, skipped).add
        end
      end
    end

    def initialize(character, data, skipped)
      @character = character
      @data = data

      unless skipped
        @achievements = @data[:achievements]
                          .group_by{ |ach| ach[:id] }
                          .transform_values(&:first)
      end
    end
  end
end
