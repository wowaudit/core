module Audit
  class TeamMembership < Sequel::Model
    many_to_one :team
    many_to_one :character
    many_to_one :team_rank
  end
end
