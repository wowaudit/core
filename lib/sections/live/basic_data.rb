module Audit
  module Live
    class BasicData < Data
      SKIPPABLE = false

      def add(type = :live)
        @character.data['name'] = @temp_character.name
        @character.data['realm'] = (defined?(REALMS) ? REALMS : {})[@temp_character.realm_id]&.name
        @character.data['rank'] = (defined?(@temp_character.team_rank) ? @temp_character.team_rank&.name || "Unknown" : "Unknown")
        @character.data['note'] = (defined?(@temp_character.note) ? @temp_character.note : "") || ""
        @character.data['character_id'] = @temp_character.id
        @character.data['join_date'] = @temp_character.created_at
        @character.data['class'] = CLASSES[@temp_character.class_id || @data.dig(:character_class, :id)]
        @character.data['faction'] = @data.dig(:faction, :name)
        @character.data['blizzard_last_modified'] = @data[:last_login_timestamp]
        @character.data['gender'] = @data[:gender][:name]
        @character.data['race'] = @data[:race][:name]
        @character.data['level'] = @data[:level]
        @character.data['role'] = @temp_character.role || DEFAULT_ROLES[CLASSES[@temp_character.class_id || @data.dig(:character_class, :id)]]

        @character.data['summary_visible'] = @temp_character.team_rank&.spreadsheet_summary_visibility ? 'yes' : 'no'
        @character.data['roster_visible'] = @temp_character.team_rank&.spreadsheet_roster_visibility ? 'yes' : 'no'
        @character.data['overview_visible'] = @temp_character.team_rank&.spreadsheet_overview_visibility ? 'yes' : 'no'
        @character.data['vault_visible'] = @temp_character.team_rank&.spreadsheet_vault_visibility ? 'yes' : 'no'
        @character.data['raids_visible'] = @temp_character.team_rank&.spreadsheet_raids_visibility ? 'yes' : 'no'
        @character.data['professions_visible'] = @temp_character.team_rank&.spreadsheet_profession_visibility ? 'yes' : 'no'
      end
    end
  end
end
