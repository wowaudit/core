module Audit
  class TeamRank < Sequel::Model
    many_to_one :team
    one_to_many :team_memberships
  end
end
