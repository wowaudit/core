module Audit
  class BasicData

    def self.add(character, data)
      character.processed_data['name'] = data['name']
      character.processed_data['class'] = CLASSES[data['class']]
      character.processed_data['realm'] = character.realm
      character.processed_data['realm_slug'] = character.realm_slug
      character.processed_data['character_id'] = character.id
      character.processed_data['honorable_kills'] = data['totalHonorableKills']

      #Parse the role if it's valid, otherwise use the default role
      begin
        ROLES[character.role][CLASSES[data['class']]]
        character.processed_data['role'] = character.role
      rescue
        character.processed_data['role'] = DEFAULT_ROLES[CLASSES[data['class']]]
      end
    end
  end
end
