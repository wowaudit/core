module Audit
  class BasicData < Data
    ESSENTIAL = true

    def add
      @character.data['name'] = @character.name
      @character.data['realm'] = REALMS[@character.realm_id]&.name
      @character.data['realm_slug'] = @character.realm_slug
      @character.data['rank'] = @character.rank.capitalize
      @character.data['note'] = @character.note || ""
      @character.data['character_id'] = @character.id
      @character.data['join_date'] = @character.created_at
      @character.data['class'] = CLASSES[@character.class_id || @data.dig(:character_class, :id)]
      @character.data['faction'] = @data.dig(:faction, :name)
      @character.data['blizzard_last_modified'] = @data[:last_login_timestamp]
      @character.data['gender'] = @data[:gender][:name]
      @character.data['race'] = @data[:race][:name]

      # Parse the role if it's valid, otherwise set the default role
      begin
        if ROLES[@character.role][CLASSES[@character.class_id || @data.dig(:character_class, :id)]]
          @character.data['role'] = @character.role
        else
          raise RoleError
        end
      rescue
        @character.role = DEFAULT_ROLES[CLASSES[@character.class_id || @data.dig(:character_class, :id)]]
        @character.data['role'] = @character.role
        @character.changed = true
      end
    end
  end
end
