module Audit
  module ClassicEra
    class PvPData < Data
      def add
        if @data[:pvp_summary]
          @character.data['honor_level'] = [@data[:pvp_summary][:pvp_rank], 14].min
          @character.data['honor_title'] = CLASSIC_ERA_HONOR_TITLES.dig(@data.dig(:faction, :name).downcase.to_sym, @character.data['honor_level'].to_i) || ""
          @character.data['honorable_kills'] = @data[:pvp_summary][:honorable_kills]
          @character.data['makgora_duels_won'] =  @data[:pvp_summary][:pvpFeatureData]&.find { |feature| feature[:key] == "makgora_kills" }&.dig(:intValue) || 0
        end
      end
    end
  end
end
