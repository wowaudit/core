module Audit
  class Data
    ESSENTIAL = false

    class << self
      def process(character, data)
        [
          Audit::BasicData, Audit::CollectionData, Audit::ExternalData, Audit::GearData, Audit::HistoricalData,
          Audit::InstanceData, Audit::ProfessionData, Audit::PvPData, Audit::QuestData, Audit::ReputationData
        ].each do |type|
          next if character.essentials_only? && !type::ESSENTIAL
          type.new(character, data).add
        end
      end
    end

    def initialize(character, data)
      @character = character
      @data = data

      unless character.essentials_only?
        @achievements = @data[:achievements][:achievements]
                          .group_by{ |ach| ach[:id] }
                          .transform_values(&:first)
      end
    end
  end
end
