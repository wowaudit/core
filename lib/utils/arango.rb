module Audit
  module Arango

    def self.get_characters(team_id)
      ArangoServer.async = false
      ADB.documentsMatch(match: { team_id: team_id }).map do |character|
        [character.body["character_id"], character.body.to_h]
      end.to_h
    end

    def self.update(documents)
      ArangoServer.async = true
      ADB.importJSON body: documents, onDuplicate: 'update'
    end
  end
end
