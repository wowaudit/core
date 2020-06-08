module Audit
  class GearData < Data
    ESSENTIAL = true

    def add
      # Check equipped gear
      items_equipped = 0
      @character.data['corruption_amount'] = 0
      @character.data['empty_sockets'] = 0

      # Quickfix to not have a 0 returned, which messes up the spreadsheet
      @character.data["enchant_quality_off_hand"] = ''
      @character.data["off_hand_enchant"] = ''

      ITEMS.each do |item|
        begin
          equipped_item = @data[:equipment]['equipped_items'].select{ |eq_item| eq_item['slot']['type'] == item.upcase }.first
          check_enchant(item, equipped_item)

          @character.ilvl += equipped_item['level']['value']

          @character.data[item + '_ilvl'] = equipped_item['level']['value']
          @character.data[item + '_id'] = equipped_item['item']['id']
          @character.data[item + '_name'] = equipped_item['name']
          @character.data[item + '_quality'] = QUALITIES[equipped_item['quality']['type'].to_sym]
          items_equipped += 1

          if item == "back"
            @character.data['corruption_amount'] -=
              equipped_item['stats'].select{ |stat| stat['type']['name'] == "Corruption Resistance" }.first&.dig('value') || 0
          end

          (item == "neck" && equipped_item['azerite_details']['selected_essences'].any? do |essence|
            essence['passive_spell_tooltip']['description'].include? "Corruption Resistance"
          end ? (@character.data['corruption_amount'] -= 10) : nil) rescue nil

          if corruption = equipped_item['stats'].select{ |stat| stat['type']['name'] == "Corruption" }.first
            @character.data['corruption_amount'] += corruption['value']
          end
        rescue
          @character.data[item + '_ilvl'] = ''
          @character.data[item + '_id'] = ''
          @character.data[item + '_name'] = ''
          @character.data[item + '_quality'] = ''
        end
      end

      # For 2H weapons the item level is counted twice to normalise between weapon types
      if @data[:equipment]['equipped_items'] && !@data[:equipment]['equipped_items'].any?{ |eq_item| eq_item['slot']['type'] == "OFF_HAND" }
        items_equipped += 1
        @character.ilvl += @data[:equipment]['equipped_items'].select{ |eq_item| eq_item['slot']['type'] == "MAIN_HAND" }.first['level']['value'] rescue 0
      end

      @character.data['ilvl'] = (@character.ilvl / ([items_equipped, 1].max)).round(2) rescue 0

      # Set item level to 0 if it's above 600, so inactive Legion characters aren't being shown as top
      @character.data['ilvl'] = 0 if @character.data['ilvl'] > 600

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
        begin
          # Off-hand items that are not weapons can't be enchanted
          return if !equipped_item['weapon'] && item == "off_hand"

          @character.data["enchant_quality_#{item}"] =
            ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']][0]

          @character.data["#{item}_enchant"] =
            ENCHANTS[item][equipped_item['enchantments'].first['enchantment_id']][1]
        rescue
          @character.data["enchant_quality_#{item}"] = 0
          @character.data["#{item}_enchant"] = ''
        end
      end
    end
  end
end
