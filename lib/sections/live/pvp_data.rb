module Audit
  module Live
    class PvPData < Data
      def add
        if @data[:pvp_summary]
          @character.data['honor_level'] = @data[:pvp_summary][:honor_level]
          @character.data['honorable_kills'] = @data[:pvp_summary][:honorable_kills]

          BRACKETS[:live].each do |bracket, endpoint|
            if !@data[endpoint.to_sym][:empty]
              if @data[endpoint.to_sym][:season][:id] == Season.current.data[:pvp_season]
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

          # TODO: Refactor and DRY x2
          @character.data["shuffle_rating"] = 0
          @character.data["shuffle_season_played"] = 0
          @character.data["shuffle_week_played"] = 0
          @data.keys.select { |key| key.to_s.include? 'shuffle' }.each do |key|
            next unless bracket = @data[key]

            if bracket.dig(:season, :id) == Season.current.data[:pvp_season]
              @character.data["shuffle_rating"] = [@character.data["shuffle_rating"], bracket[:rating]].max
              @character.data["shuffle_season_played"] += bracket[:season_match_statistics][:played]
              @character.data["shuffle_week_played"] += bracket[:weekly_match_statistics][:played]
            end
          end

          begin
            pvp_category = @data[:achievement_statistics][:categories].find do |category|
              category[:name] == "Player vs. Player"
            end

            arena_category = pvp_category[:sub_categories].find do |sub_category|
              sub_category[:name] == "Rated Arenas"
            end[:statistics]

            @character.data['max_2v2_rating'] = arena_category.select do |stat|
              stat[:name] == "Highest 2v2 personal rating"
            end.first&.dig(:quantity)&.to_i rescue 0

            @character.data['max_3v3_rating'] = arena_category.select do |stat|
              stat[:name] == "Highest 3v3 personal rating"
            end.first&.dig(:quantity)&.to_i rescue 0
          rescue
            nil
          end
        end
      end
    end
  end
end
