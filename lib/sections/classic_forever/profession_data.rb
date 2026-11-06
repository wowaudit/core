require_relative '../live/profession_data'

module Audit
  module ClassicForever
    class ProfessionData < Audit::Live::ProfessionData
      def add
        # Only set when the recipes changed, which signals that they need to be written to the database
        @character.details.delete('known_recipes')
        return if @data[:professions][:empty] || !@data[:professions][:primaries]

        known_recipes = {}

        # Each profession has a single tier, covering all of its skill levels
        @data[:professions][:primaries].each.with_index(1) do |profession, index|
          tier = (profession[:tiers] || []).first
          @character.data["profession_#{index}_name"] = profession[:profession][:name]
          @character.data["profession_#{index}_rank"] = tier ? tier[:skill_points] : 0
          @character.data["profession_#{index}_max_rank"] = tier ? tier[:max_skill_points] : 0

          known_recipes[profession[:profession][:id].to_s] = known_recipes_for(profession)
        end

        store_known_recipes(known_recipes)
      end
    end
  end
end
