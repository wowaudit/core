module Wowaudit
  class DataProcessor::Collections < DataProcessor::Base
    def add
      @result.data['achievement_points'] = @data['achievement_points']

      if @achievements
        @result.data['mounts'] = @achievements[2143]['criteria']['child_criteria'].first['amount'] rescue 0
      end

      unless !@data[:titles]['titles'] || @data[:titles].class == RBattlenet::EmptyHashResult
        @result.data['titles'] = @data[:titles]['titles'].size
      end

      unless @data[:pets].class == RBattlenet::EmptyHashResult || !@data[:pets]['pets']
        pets_owned = []
        level_25_pets = 0

        @data[:pets]['pets'].each do |pet|
          unless pets_owned.include?(pet['species']['id'])
            pets_owned << pet['species']['id']
            level_25_pets += pet['level'] == 25 ? 1 : 0
          end
        end

        @result.data['unique_pets'] = pets_owned.size # Await Blizzard to add account wide collection achievement again
        @result.data['lvl_25_pets'] = level_25_pets
      end

      # unless @data[:mounts].class == RBattlenet::EmptyHashResult
        # @result.data['jaina_mount'] = @data[:mounts]['mounts'].any? { |owned| owned['mount']['id'] == 1219 } ? "yes" : "no"
        # @result.data['nzoth_mount'] = @data[:mounts]['mounts'].any? { |owned| owned['mount']['id'] == 1293 } ? "yes" : "no"
      # end
    end
  end
end
