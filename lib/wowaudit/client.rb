module Wowaudit
  class Client
    RETRIEVERS = {
      blizzard: Wowaudit::Retrievers::Blizzard,
      keystones: Wowaudit::Retrievers::Keystones,
      historical_keystones: Wowaudit::Retrievers::HistoricalKeystones,
      wcl: Wowaudit::Retrievers::Wcl,
      raiderio: Wowaudit::Retrievers::Raiderio,
    }

    def initialize(client_id, client_secret)
      authenticate(client_id, client_secret)
      RBattlenet.set_options(concurrency: 10, timeout: 5, retries: 5, response_type: :hash)
    end

    def authenticate(client_id, client_secret)
      attempts = 0
      begin
        RBattlenet.authenticate(client_id: client_id, client_secret: client_secret)
      rescue
        attempts += 1
        if attempts < 5
          retry
        else
          raise
        end
      end

      @authenticated_at = DateTime.now
    end

    def retrieve(characters, type = :blizzard)
      RETRIEVERS[type].retrieve(characters)
    end

    def retrieve_group(team, type = :blizzard)
      RETRIEVERS[type].retrieve_group(team)
    end
  end
end
