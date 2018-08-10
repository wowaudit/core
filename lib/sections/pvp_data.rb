module Audit
  class PvPData

    def self.add(character, data)
      character.data['honor_level'] = character.details["honor_level"] || "-"
      character.data['honorable_kills'] = data['totalHonorableKills']

      ['2v2','3v3','RBG'].each do |bracket|
        character.data["#{bracket}_rating"] = data['pvp']['brackets']["ARENA_BRACKET_#{bracket}"]['rating']
        character.data["#{bracket}_season_played"] = data['pvp']['brackets']["ARENA_BRACKET_#{bracket}"]['seasonPlayed']
        character.data["#{bracket}_week_played"] = data['pvp']['brackets']["ARENA_BRACKET_#{bracket}"]['weeklyPlayed']
      end

      character.data['max_2v2_rating'] =
        data['statistics']['subCategories'][9]['subCategories'][0]['statistics'][24]['quantity']

      character.data['max_3v3_rating'] =
        data['statistics']['subCategories'][9]['subCategories'][0]['statistics'][23]['quantity']
    end
  end
end
