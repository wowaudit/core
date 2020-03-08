module Audit
  class CollectionData < Data
    def add
      @character.data['achievement_points'] = @data.achievement_points

      @character.data['mounts'] = @achievements[12933].criteria.child_criteria.first.amount

      @character.data['titles'] = @data.titles.size

      pets_owned = []
      level_25_pets = 0

      @data.pets.each do |pet|
        unless pets_owned.include?(pet.species.id)
          pets_owned << pet.species.id
          level_25_pets += pet.level == 25 ? 1 : 0
        end
      end

      @character.data['unique_pets'] = pets_owned.size # Await Blizzard to add account wide collection achievement again
      @character.data['lvl_25_pets'] = level_25_pets

      @character.data['jaina_mount'] = @data.mounts.any? { |owned| owned.mount.id == 1219 } ? "yes" : "no"
      @character.data['nzoth_mount'] = @data.mounts.any? { |owned| owned.mount.id == 1293 } ? "yes" : "no"
    end
  end
end
