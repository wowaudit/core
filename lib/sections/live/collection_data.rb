module Audit
  module Live
    class CollectionData < Data
      def add
        @character.data['achievement_points'] = @data[:achievement_points]

        if @achievements
          @character.data['mounts'] = @achievements[2143][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['toys_owned'] = @achievements[9670][:criteria][:child_criteria].first[:amount] rescue 0
        end

        unless !@data[:titles]
          @character.data[:titles] = @data[:titles].size
        end

        unless !@data[:mounts]
          @character.data['fyrakk_mount'] = @data[:mounts].lazy.find { |entry| entry.dig(:mount, :id) == 1818 } ? 'yes' : 'no'
        end

        unless !@data[:pets]
          pets_owned = []
          level_25_pets = 0

          @data[:pets].lazy.each do |pet|
            next unless pet.is_a? Hash

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
end
