module Audit
  class TeamEssentials < TeamBnet
    FIELDS = [
      :equipment
    ]

    def characters
      @characters ||= super(CharacterEssentials.where(:team_id => id).to_a)
    end

    def character_query(character)
      {
        name: character.name.downcase,
        realm: character.realm_slug,
        season: CURRENT_KEYSTONE_SEASON,
        source: character
      }
    end
  end
end
