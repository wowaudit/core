module Audit
  module ClassicProgression
    class ProfessionData < Data
      ENCHANTMENTS_BY_PROFESSION = {
        jewelcrafting: [52265, 52263, 52262, 52261, 52266, 52264, 52268, 52260, 52267, 52269, 52259, 52258, 52257, 52255],
        enchanting: [4078, 4079, 4080, 4081],
        engineering: [4188, 4750, 4180, 4179, 4181, 4183, 4223],
        inscription: [4193, 4194, 4195, 4196],
        leatherworking: [4189, 4190, 4191, 4192],
        tailoring: [4115, 4116, 4118],
      }

      ITEMS_BY_PROFESSION = {
        engineering: [59359, 59449, 59455, 59456, 59453, 59458, 59448],
        alchemy: [68777, 58483, 68776, 68775],
      }

      def add
        # Wipe data...
        @character.data["profession_1"] = ""
        @character.data["profession_1_benefits"] = ""
        @character.data["profession_2"] = ""
        @character.data["profession_2_benefits"] = ""

        professions_found = 0
        profession_data = {
          jewelcrafting: { found: 0, wanted: 3 },
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
            base_sockets = CATA_SOCKETS_BY_ITEM[equipped_item[:item][:id]] || 0
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
