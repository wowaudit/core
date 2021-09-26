module Wowaudit
  class DataProcessor::Gear < DataProcessor::Base
    ESSENTIAL = true

    def add
      # Check equipped gear
      items_equipped = 0
      bfa_level_detected = false
      @domination_sockets = { Blood: [], Frost: [], Unholy: [] }
      @result.data['empty_sockets'] = 0

      # Quickfix to not have a 0 returned, which messes up the spreadsheet
      @result.data["enchant_quality_off_hand"] = ''
      @result.data["off_hand_enchant"] = ''
      (1..5).to_a.each do |slot|
        @result.data["domination_socket_#{slot}_name"] = ""
        @result.data["domination_socket_#{slot}_rank"] = ""
        @result.data["domination_socket_#{slot}_id"] = ""
      end

      # Reset equipped legendary status, we don't want it to use last refresh data
      @result.data['current_legendary_ilvl'] = ''
      @result.data['current_legendary_id'] = ''
      @result.data['current_legendary_name'] = ''

      ITEMS.each do |item|
        begin
          equipped_item = @data[:equipment]['equipped_items'].select{ |eq_item| eq_item['slot']['type'] == item.upcase }.first
          check_enchant(item, equipped_item)
          check_sockets(item, equipped_item)

          items_equipped += 1
          @result.ilvl += equipped_item['level']['value']

          # if equipped_item['level']['value'] >= @character.details['best_gear'][item]['ilvl'].to_f
          #   @character.details['best_gear'][item] = {
          #     'ilvl' => equipped_item['level']['value'],
          #     'id' => equipped_item['item']['id'],
          #     'name' => equipped_item['name'],
          #     'quality' => QUALITIES[equipped_item['quality']['type'].to_sym]
          #   }
          # end

          # Don't trigger the Legendary cloak from BfA or other legacy legendaries here (so check item level)
          if equipped_item['quality']['type'] == 'LEGENDARY' && equipped_item['level']['value'].to_i > 170
            @result.data['current_legendary_ilvl'] = equipped_item['level']['value']
            @result.data['current_legendary_id'] = equipped_item['item']['id']
            @result.data['current_legendary_name'] = equipped_item['name']
          end

          @result.data[item + '_ilvl'] = equipped_item['level']['value']
          @result.data[item + '_id'] = equipped_item['item']['id']
          @result.data[item + '_name'] = equipped_item['name']
          @result.data[item + '_quality'] = QUALITIES[equipped_item['quality']['type'].to_sym]
        rescue
          @result.data[item + '_ilvl'] = ''
          @result.data[item + '_id'] = ''
          @result.data[item + '_name'] = ''
          @result.data[item + '_quality'] = ''
        end

        # if (@character.details['best_gear'][item]['ilvl'].to_f || 0) > 400
        #   bfa_level_detected = true
        # end

        # @result.data["best_#{item}_ilvl"] = @character.details['best_gear'][item]['ilvl'] || ''
        # @result.data["best_#{item}_id"] = @character.details['best_gear'][item]['id'] || ''
        # @result.data["best_#{item}_name"] = @character.details['best_gear'][item]['name'] || ''
        # @result.data["best_#{item}_quality"] = @character.details['best_gear'][item]['quality'] || ''
      end

      # For 2H weapons the item level is counted twice to normalise between weapon types
      if @data[:equipment]['equipped_items'] && !@data[:equipment]['equipped_items'].any?{ |eq_item| eq_item['slot']['type'] == "OFF_HAND" }
        items_equipped += 1
        @result.ilvl += @data[:equipment]['equipped_items'].select{ |eq_item| eq_item['slot']['type'] == "MAIN_HAND" }.first['level']['value'] rescue 0
      end

      # Correct broken average item levels
      # if @character.details['max_ilvl'].to_f > 400 || bfa_level_detected
      #   @character.details['max_ilvl'] = 0

      #   ITEMS.each do |item|
      #     @character.details['best_gear'][item] = { 'ilvl' => '', 'id' => '', 'name' => '', 'quality' => '' }
      #   end
      # end

      @result.data['ilvl'] = (@result.ilvl / ([items_equipped, 1].max)).round(2) rescue 0

      # Set item level to 0 if it's above 300, so inactive BfA characters aren't being shown as top
      @result.data['ilvl'] = 0 if @result.data['ilvl'] > 300

      # @character.details['max_ilvl'] = [@result.data['ilvl'], @character.details['max_ilvl'].to_f].max
      # @result.data['highest_ilvl_ever_equipped'] = @character.details['max_ilvl']
      @result.data['gem_list'] = @result.gems.join('|')

      type, sockets = @domination_sockets.find { |type, sockets| sockets.length >= 4 }
      @result.data["domination_socket_bonus_name"] = type || ""
      @result.data["domination_socket_bonus_rank"] = type ? sockets.min : ""
    end

    def check_enchant(item, equipped_item)
      if ENCHANTS.include? item
        column = ['wrist', 'hands', 'feet'].include?(item) ? 'primary' : item

        begin
          # Off-hand items that are not weapons can't be enchanted
          return if !equipped_item&.dig('weapon') && item == "off_hand"

          # Don't store enchant data for primary enchant when it's not there
          return if !ENCHANTS[item][equipped_item['enchantments']&.first&.dig('enchantment_id')] && column == 'primary'

          @result.data["enchant_quality_#{column}"] =
            ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']][0]

          @result.data["#{column}_enchant"] =
            ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']][1]
        rescue
          @result.data["enchant_quality_#{column}"] = 0
          @result.data["#{column}_enchant"] = ''
        end
      end
    end

    def check_sockets(item, equipped_item)
      (equipped_item['sockets'] || []).each do |socket|
        if has_gem = GEMS[socket.dig('item', 'id')]
          @result.gems << has_gem
        elsif !socket.dig('item', 'id') && socket.dig('socket_type', 'type') != "DOMINATION"
          @result.data['empty_sockets'] += 1
        end
      end

      (equipped_item["spells"] || []).each do |spell|
        if DOMINATION_SET_BONUSES.keys.include?(spell.dig('spell', 'name')) && !@domination_sockets[DOMINATION_SET_BONUSES[spell.dig('spell', 'name')]].include?(5)
          @domination_sockets[DOMINATION_SET_BONUSES[spell.dig('spell', 'name')]] << 5
        end
      end

      if slot = SHARD_OF_DOMINATION_SLOTS[@character.class_id || @data.dig('character_class', 'id')].index(item)
        (equipped_item['sockets'] || []).each do |socket|
          next unless socket.dig('socket_type', 'type') == "DOMINATION"

          if socket.dig('item', 'id')
            rank = SHARD_OF_DOMINATION_LEVELS[socket.dig('item', 'name').split(' ').first]
            @domination_sockets[SHARD_OF_DOMINATION_TYPES[socket.dig('item', 'name').split(' ').last]] << rank
            @result.data["domination_socket_#{slot + 1}_name"] = socket.dig('item', 'name').split(' ').last
            @result.data["domination_socket_#{slot + 1}_rank"] = rank
            @result.data["domination_socket_#{slot + 1}_id"] = socket.dig('item', 'id')
          end
        end
      end
    end
  end
end
