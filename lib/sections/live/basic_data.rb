module Audit
  module Live
    class BasicData < Data
      SKIPPABLE = false

      def add
        @character.data['name'] = @temp_character.name
        @character.data['realm'] = (defined?(REALMS) ? REALMS : {})[@temp_character.realm_id]&.name
        @character.data['realm_slug'] = (defined?(@temp_character.realm_slug) ? @temp_character.realm_slug : @data['realm_slug'])
        @character.data['rank'] = (defined?(@temp_character.rank) ? @temp_character.rank.capitalize : "")
        @character.data['note'] = (defined?(@temp_character.note) ? @temp_character.note : "") || ""
        @character.data['character_id'] = @temp_character.id
        @character.data['join_date'] = @temp_character.created_at
        @character.data['class'] = CLASSES[@temp_character.class_id || @data.dig(:character_class, :id)]
        @character.data['faction'] = @data.dig(:faction, :name)
        @character.data['blizzard_last_modified'] = @data[:last_login_timestamp]
        @character.data['gender'] = @data[:gender][:name]
        @character.data['race'] = @data[:race][:name]
        @character.data['level'] = @data[:level]

        # Parse the role if it's valid, otherwise set the default role
        begin
          if ROLES[@temp_character.role.capitalize][CLASSES[@temp_character.class_id || @data.dig(:character_class, :id)]]
            @character.data['role'] = @temp_character.role.capitalize
          else
            raise RoleError
          end
        rescue
          @temp_character.role = DEFAULT_ROLES[CLASSES[@temp_character.class_id || @data.dig(:character_class, :id)]]
          @character.data['role'] = @temp_character.role.capitalize
          @character.changed = true
        end
      end
    end
  end
end
