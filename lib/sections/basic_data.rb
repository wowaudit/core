module Audit
  class BasicData

    def self.add(character, data)
      character.data['name'] = data['name']
      character.data['class'] = CLASSES[data['class']]
      character.data['realm'] = character.realm
      character.data['faction'] = "" #TODO: Add data source
      character.data['realm_slug'] = character.realm_slug
      character.data['character_id'] = character.id
      character.data['honorable_kills'] = data['totalHonorableKills']
      character.data['join_date'] = character.created_at

      #Parse the role if it's valid, otherwise use the default role
      begin
        if ROLES[character.role][CLASSES[data['class']]]
          character.data['role'] = character.role
        else
          raise RoleError
        end
      rescue
        $errors[:role] += 1
        character.data['role'] = DEFAULT_ROLES[CLASSES[data['class']]]
      end
    end
  end
end
