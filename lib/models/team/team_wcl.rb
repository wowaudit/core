module Audit
  class TeamWcl < Team

    def refresh
    end

    def characters
      @characters ||= super(CharacterWcl.where(:team_id => id).to_a)
    end
  end
end
