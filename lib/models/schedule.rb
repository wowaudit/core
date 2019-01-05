module Audit
  class Schedule < Sequel::Model
    def restart
      Typhoeus.get(restart_url, userpwd: SERVER_AUTH)
      Logger.g(INFO_RESTARTED_WORKER + "Worker: #{name}")
    end
  end
end
