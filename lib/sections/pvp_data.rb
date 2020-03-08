module Audit
  class PvPData < Data
    def add
      @character.data['honor_level'] = @data.pvp_summary.honor_level
      @character.data['honorable_kills'] = @data.pvp_summary.honorable_kills

      if @data.pvp_bracket_2v2.class == RBattlenet::EmptyResult
        @character.data["2v2_rating"] = 0
        @character.data["2v2_season_played"] = 0
        @character.data["2v2_week_played"] = 0
        @character.data['max_2v2_rating'] = 0
      else
        @character.data["2v2_rating"] = @data.pvp_bracket_2v2.rating
        @character.data["2v2_season_played"] = @data.pvp_bracket_2v2.season_match_statistics.played
        @character.data["2v2_week_played"] = @data.pvp_bracket_2v2.weekly_match_statistics.played
        @character.data['max_2v2_rating'] = @data.achievement_statistics.statistics[9].sub_categories[0].statistics.select do |stat|
          stat.name == "Highest 2 man personal rating"
        end.first&.quantity&.to_i
      end

      if @data.pvp_bracket_3v3.class == RBattlenet::EmptyResult
        @character.data["3v3_rating"] = 0
        @character.data["3v3_season_played"] = 0
        @character.data["3v3_week_played"] = 0
        @character.data['max_3v3_rating'] = 0
      else
        @character.data["3v3_rating"] = @data.pvp_bracket_3v3.rating
        @character.data["3v3_season_played"] = @data.pvp_bracket_3v3.season_match_statistics.played
        @character.data["3v3_week_played"] = @data.pvp_bracket_3v3.weekly_match_statistics.played
        @character.data['max_3v3_rating'] = @data.achievement_statistics.statistics[9].sub_categories[0].statistics.select do |stat|
          stat.name == "Highest 3 man personal rating"
        end.first&.quantity&.to_i
      end
    end
  end
end
