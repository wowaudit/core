module Audit
  module Arango

    def self.get_characters(team_id)
      ArangoServer.async = false
      ADB.documentsMatch(match: { team_id: team_id }).map do |character|
        [character.body["character_id"], character.body]
      end.to_h
    end

    def self.update(documents)
      ArangoServer.async = true
      ADB.create_document document: documents
    end
  end
end
