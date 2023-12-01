module Audit
  module ClassicProgression
    class ProfessionData < Data
      ENCHANTMENTS_BY_PROFESSION = {
        jewelcrafting: [42153, 42142, 42144, 42143, 42158, 42156, 36767, 42148, 42150, 36766, 42154, 42149, 42157, 42155, 42146, 42152, 42145, 42151],
        enchanting: [3839, 3791, 3840],
        engineering: [3878, 3606, 3859, 3605, 3860, 3603, 3604, 3601, 3599],
        inscription: [3835, 3836, 3837, 3838],
        leatherworking: [3756, 3757, 3758, 3759, 3760, 3761, 3762, 3763],
        tailoring: [3728, 3722, 3730],
      }

      ITEMS_BY_PROFESSION = {
        engineering: [42549, 42552, 42551, 42555, 42550, 42554, 42553]
      }

      def add
        professions_found = 0
        profession_data = {
          jewelcrafting: { found: 0, wanted: 3 },
          enchanting: { found: 0, wanted: 2 },
          engineering: { found: 0, wanted: 2, identified: false },
          inscription: { found: 0, wanted: 1 },
          leatherworking: { found: 0, wanted: 1 },
          tailoring: { found: 0, wanted: 1 },
          blacksmithing: { found: 0, wanted: 2 },
        }

        ITEMS[:classic_progression].each do |item|
          equipped_item = @data[:equipment][:equipped_items].lazy.select{ |eq_item| eq_item[:slot][:type] == item.upcase }.first
          next unless equipped_item

          (equipped_item[:enchantments] || []).each do |enchantment|
            profession_data[:jewelcrafting][:found] += 1 if ENCHANTMENTS_BY_PROFESSION[:jewelcrafting].include?(enchantment.dig(:source_item, :id))

            [:enchanting, :inscription, :leatherworking, :tailoring].each do |profession|
              profession_data[profession][:found] += 1 if ENCHANTMENTS_BY_PROFESSION[profession].include?(enchantment[:enchantment_id])
            end

            # Only require Nitro Boosts and gloves enchants for Engineering
            profession_data[:engineering][:identified] = true if ITEMS_BY_PROFESSION.include?(equipped_item[:item][:id]) && item == 'head'
            if ENCHANTMENTS_BY_PROFESSION[:engineering].include?(enchantment[:enchantment_id])
              profession_data[:engineering][:found] += 1 if ['hands', 'feet'].include?(item)
            end
          end

          if ['wrist', 'hands'].include?(item)
            gems_found = [2, 3, 4].count { |enchantment_slot| equipped_item[:enchantments]&.find { |e| e.dig(:enchantment_slot, :id) == enchantment_slot } }
            base_sockets = WOTLK_SOCKETS_BY_ITEM[equipped_item[:item][:id]] || 0
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
