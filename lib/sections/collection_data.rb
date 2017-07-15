module Audit
  class CollectionData

    def self.add(character, data)
      character.data['achievement_points'] =
        data['achievementPoints']

      character.data['mounts'] =
        data['statistics']['subCategories'][0]['subCategories'][2]['statistics'][7]['quantity']

      pets_owned = []
      unique_pets = 0
      level_25_pets = 0

      data['pets']['collected'].each do |pet|
        unless pets_owned.include?(pet['stats']['speciesId'])
          unique_pets += 1
          pets_owned << pet['stats']['speciesId']
          level_25_pets += pet['stats']['level'] == 25 ? 1 : 0
        end
      end

      character.data['unique_pets'] = unique_pets
      character.data['lvl_25_pets'] = level_25_pets
    end
  end
end
