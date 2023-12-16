module Audit
  class Data
    SKIPPABLE = true

    class << self
      def process(character, data, skipped, realm, temp_character)
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
            Audit::ClassicProgression::CollectionData,
            Audit::ClassicProgression::GearData,
            Audit::ClassicProgression::InstanceData,
            Audit::ClassicProgression::ProfessionData,
            Audit::ClassicProgression::PvPData,
          ]
        }[realm.kind.to_sym].each do |type|
          next if skipped && type::SKIPPABLE

          type.new(character, data, skipped, realm, temp_character).add
        end
      end
    end

    def initialize(character, data, skipped, realm, temp_character)
      @character = character
      @temp_character = temp_character
      @data = data
      @skipped = skipped
      @realm = realm

      if !@skipped && @realm.kind != 'classic_era'
        @achievements = @data[:achievements]
                          .group_by{ |ach| ach[:id] }
                          .transform_values(&:first)
      end
    end
  end
end
