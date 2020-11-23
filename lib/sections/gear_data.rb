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
        begin
          equipped_item = @data[:equipment]['equipped_items'].select{ |eq_item| eq_item['slot']['type'] == item.upcase }.first
          check_enchant(item, equipped_item)

          @character.ilvl += equipped_item['level']['value']

          if equipped_item['level']['value'] >= @character.details['best_gear'][item]['ilvl']
            @character.details['best_gear'][item] = {
              'ilvl' => equipped_item['level']['value'],
              'id' => equipped_item['item']['id'],
              'name' => equipped_item['name'],
              'quality' => QUALITIES[equipped_item['quality']['type'].to_sym]
            }
          end

          # Don't trigger the Legendary cloak from BfA or other legacy legendaries here (so check item level)
          if equipped_item['quality']['type'] == 'LEGENDARY' && equipped_item['level']['value'].to_i > 170
            @character.data['current_legendary_ilvl'] = equipped_item['level']['value']
            @character.data['current_legendary_id'] = equipped_item['item']['id']
            @character.data['current_legendary_name'] = equipped_item['name']
          end

          @character.data[item + '_ilvl'] = equipped_item['level']['value']
          @character.data[item + '_id'] = equipped_item['item']['id']
          @character.data[item + '_name'] = equipped_item['name']
          @character.data[item + '_quality'] = QUALITIES[equipped_item['quality']['type'].to_sym]
          items_equipped += 1
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
      (equipped_item['sockets'] || []).each do |socket|
        if has_gem = GEMS[socket.dig('item', 'id')]
          @character.gems << has_gem
        elsif !socket.dig('item', 'id')
          @character.data['empty_sockets'] += 1
        end
      end

      if ENCHANTS.include? item
        column = ['wrists', 'hands', 'feet'].include?(item) ? 'primary' : item

        begin
          # Off-hand items that are not weapons can't be enchanted
          return if !equipped_item['weapon'] && item == "off_hand"

          @character.data["enchant_quality_#{column}"] =
            ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']][0]

          @character.data["#{column}_enchant"] =
            ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']][1]
        rescue
          @character.data["enchant_quality_#{column}"] = 0
          @character.data["#{column}_enchant"] = ''
        end
      end
    end
  end
end
