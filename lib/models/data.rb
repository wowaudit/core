module Audit
  class Data
    SKIPPABLE = true

    class << self
      def process(character, data, skipped, realm)
        {
          live: [
            Audit::Live::BasicData, Audit::Live::CollectionData, Audit::Live::ExternalData, Audit::Live::GearData, Audit::Live::HistoricalData,
            Audit::Live::InstanceData, Audit::Live::ProfessionData, Audit::Live::PvPData, Audit::Live::QuestData, Audit::Live::ReputationData
          ],
          classic_era: [
            Audit::ClassicEra::BasicData,
            Audit::ClassicEra::GearData,
            Audit::ClassicEra::PvPData,
          ],
          classic_progression: [
            Audit::ClassicProgression::BasicData,
          ]
        }[realm.kind.to_sym].each do |type|
          next if skipped && type::SKIPPABLE

          type.new(character, data, skipped, realm).add
        end
      end
    end

    def initialize(character, data, skipped, realm)
      @character = character
      @data = data
      @skipped = skipped
      @realm = realm

      if !@skipped && @realm.kind == 'live'
        @achievements = @data[:achievements]
                          .group_by{ |ach| ach[:id] }
                          .transform_values(&:first)
      end
    end
  end
end
