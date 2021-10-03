module Wowaudit
  class DataProcessor::Basic < DataProcessor::Base
    ESSENTIAL = true

    def add
      @result.data['name'] = @character.name
      @result.data['realm'] = @character.realm.name
      @result.data['realm_slug'] = @character.realm.slug
      @result.data['rank'] = "" # TODO: Do something with this
      @result.data['note'] = "" # TODO: Do something with this
      @result.data['character_id'] = @character.id
      @result.data['join_date'] = @character.created_at
      @result.data['class'] = CLASSES[@character.class_id || @data.dig('character_class', 'id')]
      @result.data['faction'] = @data['faction']['name']
      @result.data['blizzard_last_modified'] = @data['last_login_timestamp']
      @result.data['gender'] = @data['gender']['name']
      @result.data['race'] = @data['race']['name']

      # Parse the role if it's valid, otherwise set the default role
      begin
        if ROLES[@character.role.downcase][CLASSES[@character.class_id || @data.dig('character_class', 'id')]]
          @result.data['role'] = @character.role.downcase
        else
          raise RoleError
        end
      rescue
        @character.role = DEFAULT_ROLES[CLASSES[@character.class_id || @data.dig('character_class', 'id')]]
        @result.data['role'] = @character.role.downcase
      end

      if covenant = @data['covenant_progress']
        @result.data['current_covenant'] = covenant.dig('chosen_covenant', 'name')
        @result.data['renown_level'] = covenant['renown_level']
      end

      Wowaudit.update_field(@character, :guild_uid, @data.dig('guild', 'id'))
      Wowaudit.update_field(@character, :race_id, @data.dig('race', 'id'))
      Wowaudit.update_field(@character, :faction_id, FACTIONS[@data.dig('faction', 'name')])

      Wowaudit.update_field(@character, :level, @data['level'])
      if (media_zone = (@data[:media] && @data[:media]['assets'].first['value'].split('/')[-2] rescue nil))
        Wowaudit.update_field(@character, :media_zone, media_zone)
      end

      transfer_id = CHARACTER_IDENTIFICATION_IDS.sum do |achievement_id|
        @achievements[achievement_id]&.dig('completed_timestamp') || 0
      end + @data.dig('character_class', 'id')
      Wowaudit.update_field(@character, :transfer_id, transfer_id)
    end
  end
end
