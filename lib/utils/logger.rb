module Audit
  module Logger

    def self.g(msg)
      # General log messages
      puts "[#{self.timestamp}] - #{msg}"
    end

    def self.t(msg, team_id)
      # Log messages related to a team
      puts "[#{self.timestamp}][Team ID: #{team_id}] - #{msg}"
    end

    def self.c(msg, character_id)
      # Log messages related to a character
      puts "[#{self.timestamp}][Character ID: #{character_id}] - #{msg}"
    end

    def self.timestamp
      Audit.now.strftime('%d-%m %H:%M:%S')
    end
  end
end
