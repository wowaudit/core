module Wowaudit
  class DataProcessor::Basic < DataProcessor::Base
    ESSENTIAL = true

    def add
      @result.data['name'] = @character.name
      @result.data['realm'] = @character.realm.name
      @result.data['realm_slug'] = @character.realm.slug
      @result.data['rank'] = "" # TODO: Do something with this
      @result.data['note'] = @character.note || ""
      @result.data['character_id'] = @character.id
      @result.data['join_date'] = @character.created_at
      @result.data['class'] = CLASSES[@character.class_id || @data.dig('character_class', 'id')]
      @result.data['faction'] = @data['faction']['name']
      @result.data['blizzard_last_modified'] = @data['last_login_timestamp']
      @result.data['gender'] = @data['gender']['name']
      @result.data['race'] = @data['race']['name']

      # Parse the role if it's valid, otherwise set the default role
      begin
        if ROLES[@character.role][CLASSES[@character.class_id || @data.dig('character_class', 'id')]]
          @result.data['role'] = @character.role
        else
          raise RoleError
        end
      rescue
        @character.role = DEFAULT_ROLES[CLASSES[@character.class_id || @data.dig('character_class', 'id')]]
        @result.data['role'] = @character.role
        @character.changed = true
      end

      if covenant = @data['covenant_progress']
        @result.data['current_covenant'] = covenant.dig('chosen_covenant', 'name')
        @result.data['renown_level'] = covenant['renown_level']
      end
    end
  end
end
