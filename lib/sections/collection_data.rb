module Audit
  class CollectionData < Data
    def add
      @character.data['achievement_points'] = @data[:achievement_points]

      if @achievements
        @character.data['mounts'] = @achievements[2143][:criteria][:child_criteria].first[:amount] rescue 0
      end

      unless !@data[:titles][:titles] || @data[:titles].class == RBattlenet::EmptyHashResult
        @character.data[:titles] = @data[:titles][:titles].size
      end

      unless @data[:pets].class == RBattlenet::EmptyHashResult || !@data[:pets][:pets]
        pets_owned = []
        level_25_pets = 0

        @data[:pets][:pets].lazy.each do |pet|
          unless pets_owned.lazy.include?(pet[:species][:id])
            pets_owned << pet[:species][:id]
            level_25_pets += pet[:level] == 25 ? 1 : 0
          end
        end

        @character.data['unique_pets'] = pets_owned.size # Await Blizzard to add account wide collection achievement again
        @character.data['lvl_25_pets'] = level_25_pets
      end
    end
  end
end
