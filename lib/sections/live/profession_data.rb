require 'zlib'

module Audit
  module Live
    class ProfessionData < Data
      def add
        # Only set when the recipes changed, which signals that they need to be written to the database
        @character.details.delete('known_recipes')

        if !@data[:professions][:empty] && @data[:professions][:primaries]
          spark_items = []
          known_recipes = {}
          professions = @data[:professions][:primaries].select{ |p| BASE_PROFESSIONS.keys.include?(p[:profession][:id]) }

          professions.each_with_index do |profession, index|
            tier = (profession[:tiers] || []).select{ |tier| EXPANSION_PROFESSIONS.keys.include?(tier[:tier][:id]) }.first
            @character.data["profession_#{index + 1}"] = "#{profession[:profession][:name]} (#{tier ? tier[:skill_points] : '0'})"

            if tier
              spark_items += (tier[:known_recipes] || []).map do |recipe|
                SPARK_RECIPE_NAME_TO_ITEM_ID[recipe[:name]][:id] if SPARK_RECIPE_NAME_TO_ITEM_ID.keys.include?(recipe[:name])
              end.compact
            end

            known_recipes[profession[:profession][:id].to_s] = known_recipes_for(profession)
          end

          @character.data['profession_recipes'] = "|#{spark_items.join('|')}|"

          digest = Zlib.crc32(known_recipes.to_json).to_s(36)
          if @character.details['known_recipes_digest'] != digest
            @character.details['known_recipes'] = known_recipes
            @character.details['known_recipes_digest'] = digest
          end
        end
      end

      private

      def known_recipes_for(profession)
        tiers = profession[:tiers] || []

        {
          's' => tiers.map { |tier| [tier[:tier][:id].to_s, [tier[:skill_points], tier[:max_skill_points]]] }.to_h,
          'r' => RecipeIndex.encode(tiers.flat_map { |tier| (tier[:known_recipes] || []).map { |recipe| recipe[:id] } }),
        }
      end
    end
  end
end
