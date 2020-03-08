module Audit
  class TeamCollections < TeamBnet
    FIELDS = [

    ]

    def characters
      @characters ||= super(CharacterCollections.where(:team_id => id).to_a)
    end
  end
end
