module Audit
  class BasicData < Data
    def add
      @character.data['name'] = @data['name']
      @character.data['class'] = CLASSES[@data['class']]
      @character.data['realm'] = REALMS[@character.realm_id]&.name
      @character.data['faction'] = FACTIONS[@data['faction']]
      @character.data['realm_slug'] = @character.realm_slug
      @character.data['character_id'] = @character.id
      @character.data['join_date'] = @character.created_at
      @character.data['note'] = @character.note
      @character.data['rank'] = @character.rank
      @character.data['blizzard_last_modified'] = @data.legacy['lastModified']
      @character.data['gender'] = @data.legacy['gender'].zero? ? 'Male' : 'Female'
      @character.data['race'] = RACES[@data.legacy['race']]

      #Parse the role if it's valid, otherwise set the default role
      begin
        if ROLES[@character.role][CLASSES[@data.legacy['class']]]
          @character.data['role'] = @character.role
        else
          raise RoleError
        end
      rescue
        @character.role = DEFAULT_ROLES[CLASSES[@data.legacy['class']]]
        @character.data['role'] = @character.role
        @character.changed = true
      end
    end
  end
end
