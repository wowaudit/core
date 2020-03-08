module Audit
  class TeamCollections < TeamBnet
    FIELDS = [
      :achievements,
      :achievement_statistics,
      :completed_quests,
      :equipment,
      :mounts,
      :pets,
      # :professions,
      :pvp_bracket_2v2,
      :pvp_bracket_3v3,
      :pvp_summary,
      :reputations,
      :status,
      :titles
    ]

    def characters
      @characters ||= super(CharacterCollections.where(:team_id => id).to_a)
    end
  end
end
