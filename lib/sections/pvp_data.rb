module Audit
  class PvPData < Data
    def add
      @character.data['honor_level'] = @data[:pvp_summary]['honor_level']
      @character.data['honorable_kills'] = @data[:pvp_summary]['honorable_kills']

      BRACKETS.each do |bracket, endpoint|
        if @data[endpoint.to_sym].class == RBattlenet::HashResult
          if @data[endpoint.to_sym]['season']['id'] == 30
            @character.data["#{bracket}_rating"] = @data[endpoint.to_sym]['rating']
            @character.data["#{bracket}_season_played"] = @data[endpoint.to_sym]['season_match_statistics']['played']
            @character.data["#{bracket}_week_played"] = @data[endpoint.to_sym]['weekly_match_statistics']['played']
          else
            @character.data["#{bracket}_rating"] = 0
            @character.data["#{bracket}_season_played"] = 0
            @character.data["#{bracket}_week_played"] = 0
          end
        end
      end

      @character.data['max_2v2_rating'] = @data[:achievement_statistics]['categories'][7]['sub_categories'][0]['statistics'].select do |stat|
        stat['name'] == "Highest 2v2 personal rating"
      end.first&.dig('quantity')&.to_i rescue 0

      @character.data['max_3v3_rating'] = @data[:achievement_statistics]['categories'][7]['sub_categories'][0]['statistics'].select do |stat|
        stat['name'] == "Highest 3v3 personal rating"
      end.first&.dig('quantity')&.to_i rescue 0
    end
  end
end
