module Audit
  class PvPData < Data
    def add
      @character.data['honor_level'] = @data.pvp_summary.honor_level
      @character.data['honorable_kills'] = @data.pvp_summary.honorable_kills

      BRACKETS.each do |bracket, endpoint|
        unless @data.send(endpoint).class == RBattlenet::EmptyResult
          @character.data["#{bracket}_rating"] = @data.send(endpoint).rating
          @character.data["#{bracket}_season_played"] = @data.send(endpoint).season_match_statistics.played
          @character.data["#{bracket}_week_played"] = @data.send(endpoint).weekly_match_statistics.played
        end
      end

      @character.data['max_2v2_rating'] = @data.achievement_statistics.categories[9].sub_categories[0].statistics.select do |stat|
        stat.name == "Highest 2 man personal rating"
      end.first&.quantity&.to_i rescue 0

      @character.data['max_3v3_rating'] = @data.achievement_statistics.categories[9].sub_categories[0].statistics.select do |stat|
        stat.name == "Highest 3 man personal rating"
      end.first&.quantity&.to_i rescue 0
    end
  end
end
