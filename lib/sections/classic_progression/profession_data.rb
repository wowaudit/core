module Audit
  module ClassicProgression
    class ProfessionData < Data
      ENCHANTMENTS_BY_PROFESSION = {
        jewelcrafting: [83151, 83150, 83142, 83141, 83143, 93409, 83146, 83149, 83152, 83147, 93404, 93406, 83145, 83148, 93408, 93410, 93405, 83144],
        enchanting: [4360, 4359, 4807, 4361],
        engineering: [4698, 4898, 4697, 4223],
        inscription: [4912, 4913, 4914, 4915, 4916],
        leatherworking: [4873, 4875, 4190, 4874, 4191, 4879, 3758, 4192, 4877, 3757, 4189, 4878],
        tailoring: [3730, 4118, 4894, 3722, 4115, 4892, 3728, 4116, 4893],
      }

      ITEMS_BY_PROFESSION = {
        engineering: [77539, 77533, 77534, 77536, 77535, 77537, 77538],
        alchemy: [75274],
      }

      def add
        # Wipe data...
        @character.data["profession_1"] = "?"
        @character.data["profession_1_benefits"] = ""
        @character.data["profession_2"] = "?"
        @character.data["profession_2_benefits"] = ""

        professions_found = 0
        profession_data = {
          jewelcrafting: { found: 0, wanted: 2 },
          enchanting: { found: 0, wanted: 2 },
          engineering: { found: 0, wanted: 2, identified: false },
          inscription: { found: 0, wanted: 1 },
          leatherworking: { found: 0, wanted: 1 },
          tailoring: { found: 0, wanted: 1 },
          blacksmithing: { found: 0, wanted: 2 },
          alchemy: { found: 0, wanted: 0, identified: false },
        }

        ITEMS[:classic_progression].each do |item|
          equipped_item = @data[:equipment][:equipped_items].lazy.select{ |eq_item| eq_item[:slot][:type] == item.upcase }.first
          next unless equipped_item

          (equipped_item[:enchantments] || []).each do |enchantment|
            profession_data[:jewelcrafting][:found] += 1 if ENCHANTMENTS_BY_PROFESSION[:jewelcrafting].include?(enchantment.dig(:source_item, :id))

            [:enchanting, :inscription, :leatherworking, :tailoring].each do |profession|
              profession_data[profession][:found] += 1 if ENCHANTMENTS_BY_PROFESSION[profession].include?(enchantment[:enchantment_id])
            end

            ITEMS_BY_PROFESSION.keys.each do |profession|
              profession_data[profession][:identified] = true if ITEMS_BY_PROFESSION[profession].include?(equipped_item[:item][:id])
            end

            # Only require Nitro Boosts and gloves enchants for Engineering
            if ENCHANTMENTS_BY_PROFESSION[:engineering].include?(enchantment[:enchantment_id])
              profession_data[:engineering][:found] += 1 if ['hands', 'waist'].include?(item)
            end
          end

          if ['wrist', 'hands'].include?(item)
            gems_found = [2, 3, 4].count { |enchantment_slot| equipped_item[:enchantments]&.find { |e| e.dig(:enchantment_slot, :id) == enchantment_slot } }
            base_sockets = MOP_SOCKETS_BY_ITEM[equipped_item[:item][:id]] || 0
            profession_data[:blacksmithing][:found] += 1 if gems_found > base_sockets
          end
        end

        profession_data.each do |profession, result|
          if result[:found] > 0 || result[:identified]
            professions_found += 1
            @character.data["profession_#{professions_found}"] = profession.capitalize
            @character.data["profession_#{professions_found}_benefits"] = result[:found] == result[:wanted] ? 'yes' : 'no'
          end
        end
      end
    end
  end
end
