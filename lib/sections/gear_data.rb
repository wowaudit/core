module Audit
  class GearData < Data
    ESSENTIAL = true

    def add
      # Check equipped gear
      items_equipped = 0
      @character.data['empty_sockets'] = 0

      # Quickfix to not have a 0 returned, which messes up the spreadsheet
      @character.data["enchant_quality_off_hand"] = ''
      @character.data["off_hand_enchant"] = ''

      ITEMS.each do |item|
        @character.data["tier_#{item}_difficulty"] = ''

        begin
          equipped_item = @data[:equipment]['equipped_items'].select{ |eq_item| eq_item['slot']['type'] == item.upcase }.first
          check_enchant(item, equipped_item)
          check_sockets(item, equipped_item)

          items_equipped += 1
          @character.ilvl += equipped_item['level']['value']

          @character.details['current_gear'][item] = {
            'ilvl' => equipped_item['level']['value'],
            'id' => equipped_item['item']['id'],
            'bonus_ids' => equipped_item['bonus_list'],
          }

          if equipped_item['level']['value'] >= @character.details['best_gear'][item]['ilvl'].to_f
            @character.details['best_gear'][item] = {
              'ilvl' => equipped_item['level']['value'],
              'id' => equipped_item['item']['id'],
              'name' => equipped_item['name'],
              'quality' => QUALITIES[equipped_item['quality']['type'].to_sym]
            }
          end

          if TIER_ITEMS_BY_SLOT.keys.include? item
            if TIER_ITEMS.include?(equipped_item['item']['id'].to_i) && equipped_item['level']['value'] > @character.details['tier_items'][item]
              @character.details['tier_items'][item] = equipped_item['level']['value']
            end

            @character.data["tier_#{item}_ilvl"] = @character.details['tier_items'][item]
            @character.data["tier_#{item}_difficulty"] = TIER_CUTOFFS.map { |cutoff, string| string if cutoff <= @character.details['tier_items'][item] }.compact.last || ''
          end

          @character.data[item + '_ilvl'] = equipped_item['level']['value']
          @character.data[item + '_id'] = equipped_item['item']['id']
          @character.data[item + '_name'] = equipped_item['name']
          @character.data[item + '_quality'] = QUALITIES[equipped_item['quality']['type'].to_sym]
        rescue
          @character.data[item + '_ilvl'] = ''
          @character.data[item + '_id'] = ''
          @character.data[item + '_name'] = ''
          @character.data[item + '_quality'] = ''
        end

        @character.data["best_#{item}_ilvl"] = @character.details['best_gear'][item]['ilvl'] || ''
        @character.data["best_#{item}_id"] = @character.details['best_gear'][item]['id'] || ''
        @character.data["best_#{item}_name"] = @character.details['best_gear'][item]['name'] || ''
        @character.data["best_#{item}_quality"] = @character.details['best_gear'][item]['quality'] || ''
      end

      # For 2H weapons the item level is counted twice to normalise between weapon types
      if @data[:equipment]['equipped_items'] && !@data[:equipment]['equipped_items'].any?{ |eq_item| eq_item['slot']['type'] == "OFF_HAND" }
        items_equipped += 1
        @character.ilvl += @data[:equipment]['equipped_items'].select{ |eq_item| eq_item['slot']['type'] == "MAIN_HAND" }.first['level']['value'] rescue 0
      end

      @character.data['ilvl'] = (@character.ilvl / ([items_equipped, 1].max)).round(2) rescue 0

      @character.details['max_ilvl'] = [@character.data['ilvl'], @character.details['max_ilvl'].to_f].max
      @character.data['highest_ilvl_ever_equipped'] = @character.details['max_ilvl']
      @character.data['gem_list'] = @character.gems.join('|')
    end

    def check_enchant(item, equipped_item)
      if ENCHANTS.include? item
        begin
          # Off-hand items that are not weapons can't be enchanted
          return if !equipped_item&.dig('weapon') && item == "off_hand"


          if ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']]
            @character.data["enchant_quality_#{item}"] =
              ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']][0]

            @character.data["#{item}_enchant"] =
              ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']][1] || ''
          else
            name = equipped_item['enchantments'].first['display_string'].split('Enchanted: ').reject(&:empty?).first.split(' |').first
            quality = (equipped_item['enchantments'].first['display_string'].split('Tier')[1])

            @character.data["#{item}_enchant"] = name
            @character.data["enchant_quality_#{item}"] = quality
          end
        rescue
          @character.data["#{item}_enchant"] = ''
          @character.data["enchant_quality_#{item}"] = 0
        end
      elsif item == 'neck'
        @character.data["enchant_quality_#{item}"] = equipped_item&.dig('sockets')&.size || 0
      end
    end

    def check_sockets(item, equipped_item)
      (equipped_item['sockets'] || []).each do |socket|
        if has_gem = GEMS[socket.dig('item', 'id')]
          @character.gems << has_gem
        elsif !socket.dig('item', 'id') && socket.dig('socket_type', 'type') != "DOMINATION"
          @character.data['empty_sockets'] += 1
        end
      end
    end
  end
end
