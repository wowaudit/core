module Audit
  module ClassicAnniversary
    class PvPData < Data
      def add
        if @data[:pvp_summary]
          @character.data['honorable_kills'] = @data[:pvp_summary][:honorable_kills]

          BRACKETS[:classic_anniversary].each do |bracket, endpoint|
            if @data[endpoint.to_sym] && !@data[endpoint.to_sym][:empty]
              if @data[endpoint.to_sym][:season][:id] == CURRENT_PVP_SEASON[:classic_anniversary]
                @character.data["#{bracket}_rating"] = @data[endpoint.to_sym][:rating]
                @character.data["#{bracket}_season_played"] = @data[endpoint.to_sym][:season_match_statistics][:played]
                @character.data["#{bracket}_week_played"] = @data[endpoint.to_sym][:weekly_match_statistics][:played]
              else
                @character.data["#{bracket}_rating"] = 0
                @character.data["#{bracket}_season_played"] = 0
                @character.data["#{bracket}_week_played"] = 0
              end
            end
          end
        end
      end
    end
  end
end
