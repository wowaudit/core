module Audit
  module ClassicEra
    class GearData < Data
      def add
        # Check equipped gear
        items_equipped = 0

        # Wipe current gear (it will be repopulated)
        @character.details['current_gear'] = {}

        # Quickfix to not have a 0 returned, which messes up the spreadsheet
        @character.data["off_hand_enchant_quality"] = ''
        @character.data["off_hand_enchant_name"] = ''
        tier_statuses = {
          '1' => 0,
          '2' => 0,
          '2.5' => 0,
          '3' => 0
        }
        tier_finger_counted = false

        ITEMS[:classic_era].each do |item|
          begin
            equipped_item = @data[:equipment][:equipped_items].lazy.select{ |eq_item| eq_item[:slot][:type] == item.upcase }.first
            items_equipped += 1 if equipped_item

            if CLASSIC_ERA_LEGENDARIES.keys.include?(equipped_item[:item][:id].to_i)
              key = "legendary_#{CLASSIC_ERA_LEGENDARIES[equipped_item[:item][:id].to_i]}"
              @character.details[key] = true
            end

            @character.details['current_gear'][item] = {
              'ilvl' => CLASSIC_ERA_ITEM_LEVELS[equipped_item[:item][:id]] || 0,
              'id' => equipped_item[:item][:id],
              'bonus_ids' => [],
              'name' => equipped_item[:name],
              'enchant' => check_enchant(item, equipped_item),
              'sockets' => [],
              'quality' => QUALITIES[equipped_item[:quality][:type].to_sym],
            }

            @character.ilvl += CLASSIC_ERA_ITEM_LEVELS[equipped_item[:item][:id]] || 0

            CLASSIC_ERA_TIER_ITEMS_BY_SLOT.each do |tier, slots|
              generic_item = item.split('_').first
              if slots.keys.include? generic_item
                if CLASSIC_ERA_TIER_ITEMS[tier].include?(equipped_item[:item][:id].to_i)
                  @character.details["tier_#{tier}_#{generic_item}"] = true
                end

                # Only count the tier 3 ring for one of the finger slots at most
                tier_statuses[tier] += @character.details["tier_#{tier}_#{generic_item}"] && (!tier_finger_counted || generic_item != 'finger') ? 1 : 0
                tier_finger_counted = generic_item == 'finger' && @character.details["tier_#{tier}_#{generic_item}"]

                @character.data["tier_#{tier}_#{generic_item}"] = @character.details["tier_#{tier}_#{generic_item}"] ? 'yes' : 'no'
              end
            end

            @character.data[item + '_id'] = equipped_item[:item][:id]
            @character.data[item + '_ilvl'] = CLASSIC_ERA_ITEM_LEVELS[equipped_item[:item][:id]] || 0
            @character.data[item + '_name'] = equipped_item[:name]
            @character.data[item + '_quality'] = QUALITIES[equipped_item[:quality][:type].to_sym]
          rescue => err
            @character.data[item + '_ilvl'] = ''
            @character.data[item + '_id'] = ''
            @character.data[item + '_name'] = ''
            @character.data[item + '_quality'] = ''
          end
        end

        # For 2H weapons the item level is counted twice to normalise between weapon types
        if @data[:equipment][:equipped_items] && !@data[:equipment][:equipped_items].any?{ |eq_item| eq_item[:slot][:type] == "OFF_HAND" }
          items_equipped += 1
          main_hand_ilvl = (CLASSIC_ERA_ITEM_LEVELS[@data[:equipment][:equipped_items].select{ |eq_item| eq_item[:slot][:type] == "MAIN_HAND" }.first[:item][:id]] || 0) rescue 0
          @character.ilvl += main_hand_ilvl
        end

        CLASSIC_ERA_LEGENDARIES.values.uniq.each do |legendary|
          meant_for_character = CLASSIC_CLASSES_FOR_LEGENDARY[legendary].include?(@character.class_id || @data.dig(:character_class, :id))
          @character.data["legendary_#{legendary}"] = @character.details["legendary_#{legendary}"] ? 'yes' : meant_for_character ? 'no' : 'n/a'
        end

        tier_statuses.each do |tier, amount|
          @character.data["tier_#{tier}_status"] = amount
        end

        @character.data['ilvl'] = (@character.ilvl / ([items_equipped, 1].max)).round(2) rescue 0

        @character.details['max_ilvl'] = [@character.data['ilvl'], @character.details['max_ilvl'].to_f].max
        @character.data['highest_ilvl_ever_equipped'] = @character.details['max_ilvl']
      end

      def check_enchant(item, equipped_item)
        if CLASSIC_ERA_ENCHANT_SLOTS.include? item
          begin
            # Off-hand items that are not weapons or shields can't be enchanted
            return if !equipped_item&.dig(:weapon) && !equipped_item&.dig(:shield_block) && item == "off_hand"

            name = equipped_item[:enchantments].first[:display_string].split('Enchanted: ').reject(&:empty?).first.split(' |').first
            source = equipped_item[:enchantments].first.dig(:source_item, :name)&.gsub("QA", "")

            display_name = if !source || name.split(" ").all? { |word| source.include? word }
              name
            else
              "#{source} (#{name})"
            end

            @character.data["#{item}_enchant_name"] = display_name
            @character.data["#{item}_enchant_quality"] = 3 # TODO: How to identify what is BIS?
          rescue
            @character.data["#{item}_enchant_quality"] = 0
            @character.data["#{item}_enchant_name"] = ''
          end

          { name: @character.data["#{item}_enchant_name"], quality: @character.data["#{item}_enchant_quality"] }
        end
      end
    end
  end
end
