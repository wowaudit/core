module Audit
  module Live
    class CollectionData < Data
      def add
        @character.data['achievement_points'] = @data[:achievement_points]

        begin
          crest_stats = @data[:achievement_statistics][:categories].find do |category|
            category[:name] == "Character"
          end[:statistics]

          @character.data['adventurer_crests'] = crest_stats.find { |stat| stat[:id] == 62292 }[:quantity] rescue 0
          @character.data['veteran_crests'] = crest_stats.find { |stat| stat[:id] == 62293 }[:quantity] rescue 0
          @character.data['champion_crests'] = crest_stats.find { |stat| stat[:id] == 62294 }[:quantity] rescue 0
          @character.data['hero_crests'] = crest_stats.find { |stat| stat[:id] == 62295 }[:quantity] rescue 0
          @character.data['myth_crests'] = crest_stats.find { |stat| stat[:id] == 62296 }[:quantity] rescue 0
        rescue
          nil
        end

        if @achievements
          @character.data['mounts'] = @achievements[2143][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['toys_owned'] = @achievements[9670][:criteria][:child_criteria].first[:amount] rescue 0
        end

        if @data[:titles]
          @character.data['titles'] = @data[:titles].size
        end

        if @data[:mounts]
          @character.data['midnight_falls_mount'] = 'no'

          @data[:mounts].lazy.each do |entry|
            next unless entry.is_a? Hash

            @character.data['midnight_falls_mount'] = 'yes' if entry.dig(:mount, :id) == 2607
          end
        end

        if @data[:pets]
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
