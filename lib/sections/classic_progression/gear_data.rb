module Audit
  module ClassicProgression
    class GearData < Data
      def add
        # Check equipped gear
        items_equipped = 0
        @character.data['empty_sockets'] = 0
        @character.data['meta_gem_quality'] = 0

        # Wipe current gear (it will be repopulated)
        @character.details['current_gear'] = {}

        # Quickfix to not have a 0 returned, which messes up the spreadsheet
        @character.data["off_hand_enchant_quality"] = ''
        @character.data["off_hand_enchant_name"] = ''
        tier_statuses = {
          '14' => 0,
          '15' => 0,
          '16' => 0,
        }

        ITEMS[:classic_progression].each do |item|
          begin
            equipped_item = @data[:equipment][:equipped_items].lazy.select{ |eq_item| eq_item[:slot][:type] == item.upcase }.first
            items_equipped += 1 if equipped_item

            @character.details['current_gear'][item] = {
              'ilvl' => MOP_ITEM_LEVELS[equipped_item[:item][:id]] || 0,
              'id' => equipped_item[:item][:id],
              'name' => equipped_item[:name],
              'bonus_ids' => [],
              'quality' => QUALITIES[equipped_item[:quality][:type].to_sym],
              'enchant' => check_enchant(item, equipped_item),
              'sockets' => check_sockets(item, equipped_item),
            }

            if equipped_item[:quality][:type].to_sym == :HEIRLOOM
              @character.details['current_gear'][item]['ilvl'] = 187
              @character.ilvl += 187
            else
              @character.ilvl += MOP_ITEM_LEVELS[equipped_item[:item][:id]] || 0
            end


            MOP_TIER_ITEMS_BY_SLOT.each do |tier, slots|
              if slots.keys.include? item
                if MOP_TIER_ITEMS[tier].include?(equipped_item[:item][:id].to_i)
                  @character.details["tier_#{tier}_#{item}"] = @character.details['current_gear'][item]['ilvl']
                end

                tier_statuses[tier] += @character.details["tier_#{tier}_#{item}"] ? 1 : 0
                @character.data["tier_#{tier}_#{item}"] = @character.details["tier_#{tier}_#{item}"] ? 'yes' : 'no'
              end
            end

            @character.data[item + '_id'] = equipped_item[:item][:id]
            @character.data[item + '_ilvl'] = @character.details['current_gear'][item]['ilvl']
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
          @character.ilvl += (@character.details.dig('current_gear', 'main_hand', 'ilvl') || 0)
        end

        tier_statuses.each do |tier, amount|
          @character.data["tier_#{tier}_status"] = amount
        end

        @character.data['ilvl'] = (@character.ilvl / ([items_equipped, 1].max)).round(2) rescue 0

        @character.details['max_ilvl'] = [@character.data['ilvl'], @character.details['max_ilvl'].to_f].max
        @character.data['highest_ilvl_ever_equipped'] = @character.details['max_ilvl']
        @character.data['gem_list'] = @character.gems.join('|')
        @character.data['meta_gem'] = @character.data['meta_gem_quality'] == 3 ? 'yes' : 'no'
      end

      def check_sockets(item, equipped_item)
        return unless equipped_item

        socket_info = []

        sockets_expected = (item == 'waist' ? 1 : 0) + (MOP_SOCKETS_BY_ITEM[equipped_item[:item][:id]] || 0)
        if sockets_expected > 0
          [2, 3, 4].first(sockets_expected).each do |enchantment_slot|
            if enchantment = equipped_item[:enchantments]&.find { |e| e.dig(:enchantment_slot, :id) == enchantment_slot }
              if meta_gem_type = MOP_META_GEMS.find { |category, ids| ids.include?(enchantment[:source_item][:id]) }&.first
                @character.data['meta_gem_quality'] = GEM_QUALITY_MAPPING[meta_gem_type]
              elsif gem_type = MOP_GEMS.find { |category, ids| ids.include?(enchantment[:source_item][:id]) }&.first
                @character.gems << GEM_QUALITY_MAPPING[gem_type]
              else
                @character.gems << 1 # unknown?
              end

              socket_info << { type: meta_gem_type ? 'meta' : 'socket', gem: enchantment[:source_item][:id] }
            else
              @character.data['empty_sockets'] += 1
              socket_info << { type: nil, gem: nil }
            end
          end
        end

        socket_info
      end

      def check_enchant(item, equipped_item)
        if MOP_ENCHANT_SLOTS.include? item
          begin
            enchantment = equipped_item[:enchantments].find { |e| e.dig(:enchantment_slot, :id) == 0 }
            name = enchantment[:display_string].split('Enchanted: ').reject(&:empty?).first.split(' |').first
            source = enchantment.dig(:source_item, :name)&.gsub("QA", "")

            display_name = if !source || name.split(" ").all? { |word| source.include? word }
              name
            else
              "#{source} (#{name})"
            end.gsub("+", "")

            @character.data["#{item}_enchant_name"] = display_name
            @character.data["#{item}_enchant_quality"] = 3
          rescue => err
            @character.data["#{item}_enchant_quality"] = 0
            @character.data["#{item}_enchant_name"] = ''
          end

          { name: @character.data["#{item}_enchant_name"], quality: @character.data["#{item}_enchant_quality"] }
        end
      end
    end
  end
end
