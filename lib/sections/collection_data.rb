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

      mounts = data["mounts"]["collected"].map{ |m| m["itemId"] }
      # The API sometimes incorrectly returns an empty set for mount IDs
      # When this happens, use historical data instead.
      if mounts.any?
        character.data['guldan_mount'] = (mounts.include? 137575) ? "yes" : "no"
        character.data['argus_mount'] = (mounts.include? 152789) ? "yes" : "no"
      else
        character.data['guldan_mount'] = (character.last_refresh['guldan_mount'] || "no")
        character.data['argus_mount'] = (character.last_refresh['argus_mount'] || "no")
      end
    end
  end
end
