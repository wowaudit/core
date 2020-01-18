module Audit
  class CollectionData < Data
    def add
      @character.data['achievement_points'] =
        @data['achievementPoints']

      @character.data['mounts'] =
        @data['statistics']['subCategories'][0]['subCategories'][2]['statistics'][7]['quantity']

      # not working at the moment
      @character.data['titles'] = 0

      pets_owned = []
      level_25_pets = 0

      @data['pets']['collected'].each do |pet|
        unless pets_owned.include?(pet['creatureId'])
          pets_owned << pet['creatureId']
          level_25_pets += pet['stats']['level'] == 25 ? 1 : 0
        end
      end

      @character.data['unique_pets'] =
        @data['achievements']['criteriaQuantity'][@data['achievements']['criteria'].index(19598)] rescue pets_owned.size
      @character.data['lvl_25_pets'] = level_25_pets

      mounts = @data["mounts"]["collected"].map{ |m| m["itemId"] }
      # The API sometimes incorrectly returns an empty set for mount IDs
      # When this happens, use historical data instead.
      if mounts.any?
        @character.data['jaina_mount'] = (mounts.include? 166705) ? "yes" : "no"
        @character.data['nzoth_mount'] = (mounts.include? 174872) ? "yes" : "no"
      else
        @character.data['jaina_mount'] = (character.last_refresh['jaina_mount'] || "no")
        @character.data['nzoth_mount'] = (character.last_refresh['nzoth_mount'] || "no")
      end
    end
  end
end
