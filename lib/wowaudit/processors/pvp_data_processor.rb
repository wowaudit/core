module Audit
  class PvPDataProcessor < DataProcessor
    def add
      @result.data['honor_level'] = @data[:pvp_summary]['honor_level']
      @result.data['honorable_kills'] = @data[:pvp_summary]['honorable_kills']

      BRACKETS.each do |bracket, endpoint|
        if @data[endpoint.to_sym].class == RBattlenet::HashResult
          if @data[endpoint.to_sym]['season']['id'] == CURRENT_PVP_SEASON
            @result.data["#{bracket}_rating"] = @data[endpoint.to_sym]['rating']
            @result.data["#{bracket}_season_played"] = @data[endpoint.to_sym]['season_match_statistics']['played']
            @result.data["#{bracket}_week_played"] = @data[endpoint.to_sym]['weekly_match_statistics']['played']
          else
            @result.data["#{bracket}_rating"] = 0
            @result.data["#{bracket}_season_played"] = 0
            @result.data["#{bracket}_week_played"] = 0
          end
        end
      end

      @result.data['max_2v2_rating'] = @data[:achievement_statistics]['categories'][7]['sub_categories'][0]['statistics'].select do |stat|
        stat['name'] == "Highest 2v2 personal rating"
      end.first&.dig('quantity')&.to_i rescue 0

      @result.data['max_3v3_rating'] = @data[:achievement_statistics]['categories'][7]['sub_categories'][0]['statistics'].select do |stat|
        stat['name'] == "Highest 3v3 personal rating"
      end.first&.dig('quantity')&.to_i rescue 0
    end
  end
end
