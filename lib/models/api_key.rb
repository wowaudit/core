module Audit
  class ApiKey < Sequel::Model
    many_to_one :guild

    def expired?
      # Count as expired if the token expires within 30 minutes
      token.to_s.length.zero? || !token_expires_at || token_expires_at + 1800 < Time.now
    end
  end
end
