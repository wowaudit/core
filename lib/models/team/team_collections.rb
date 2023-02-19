module Audit
  class TeamCollections < TeamBnet
    FIELDS = [
      :achievements,
      :achievement_statistics,
      :completed_quests,
      :equipment,
      # :mounts, # Only needed to track Mythic raid mounts, when relevant
      :pets,
      :professions,
      :pvp_bracket_2v2,
      :pvp_bracket_3v3,
      :pvp_bracket_rbg,
      :pvp_summary,
      :season_keystones,
      :reputations,
      :status,
      :titles,
    ]

    def characters
      @characters ||= super(CharacterCollections.where(:team_id => id).to_a)
    end

    def character_query(character)
      {
        name: character.name.downcase,
        realm: character.realm_slug,
        season: CURRENT_KEYSTONE_SEASON,
        source: character,
        timestamp: character.last_modified
      }
    end
  end
end
