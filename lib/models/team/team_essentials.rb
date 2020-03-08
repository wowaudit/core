module Audit
  class TeamEssentials < TeamBnet
    FIELDS = [
      :equipment
    ]

    def characters
      @characters ||= super(CharacterEssentials.where(:team_id => id).to_a)
    end
  end
end
