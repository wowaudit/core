module Audit
  module ClassicProgression
    class GearData < Data
      def add
        # Check equipped gear
        items_equipped = 0

        # Quickfix to not have a 0 returned, which messes up the spreadsheet
        @character.data["off_hand_enchant_quality"] = ''
        @character.data["off_hand_enchant_name"] = ''
        tier_statuses = {
          '7' => 0,
          '8' => 0,
          '9' => 0,
          '10' => 0
        }

        ITEMS[:classic_progression].each do |item|
          begin
            equipped_item = @data[:equipment][:equipped_items].lazy.select{ |eq_item| eq_item[:slot][:type] == item.upcase }.first
            check_enchant(item, equipped_item)
            items_equipped += 1

            if WOTLK_LEGENDARIES.keys.include?(equipped_item[:item][:id].to_i)
              key = "legendary_#{WOTLK_LEGENDARIES[equipped_item[:item][:id].to_i]}"
              @character.details[key] = true
            end

            @character.details['current_gear'][item] = {
              'ilvl' => 0,
              'id' => equipped_item[:item][:id],
              'name' => equipped_item[:name],
              'quality' => QUALITIES[equipped_item[:quality][:type].to_sym],
            }

            @character.ilvl += WOTLK_TIER_ITEMS[equipped_item[:item][:id]] || 0

            WOTLK_TIER_ITEMS_BY_SLOT.each do |tier, slots|
              if slots.keys.include? item
                if WOTLK_TIER_ITEMS[tier].include?(equipped_item[:item][:id].to_i)
                  @character.details["tier_#{tier}_#{item}"] = true
                end

                tier_statuses[tier] += @character.details["tier_#{tier}_#{item}"] ? 1 : 0
                @character.data["tier_#{tier}_#{item}"] = @character.details["tier_#{tier}_#{item}"] ? 'yes' : 'no'
              end
            end

            @character.data[item + '_id'] = equipped_item[:item][:id]
            @character.data[item + '_ilvl'] = 0
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
          main_hand_ilvl = @data[:equipment][:equipped_items].select{ |eq_item| eq_item[:slot][:type] == "MAIN_HAND" }.first[:item][:ITEMLEVEL]
          @character.ilvl += main_hand_ilvl
        end

        WOTLK_LEGENDARIES.values.uniq.each do |legendary|
          meant_for_character = WOTLK_CLASSES_FOR_LEGENDARY[legendary].include?(@character.class_id || @data.dig(:character_class, :id))
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
        if WOTLK_ENCHANT_SLOTS.include? item
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
        end
      end
    end
  end
end
