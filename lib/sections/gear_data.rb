module Audit
  class GearData < Data
    def add
      # Check equipped gear
      items_equipped = 0
      ITEMS.each do |item|
        begin
          equipped_item = @data.equipment.equipped_items.select{ |eq_item| eq_item.slot.type == item.upcase }.first
          check_enchant(item, equipped_item)

          @character.ilvl += equipped_item.level.value

          @character.data[item + '_ilvl'] = equipped_item.level.value
          @character.data[item + '_id'] = equipped_item.item.id
          @character.data[item + '_name'] = equipped_item.name
          @character.data[item + '_quality'] = QUALITIES[equipped_item.quality.type.to_sym]
          items_equipped += 1

        rescue
          @character.data[item + '_ilvl'] = ''
          @character.data[item + '_id'] = ''
          @character.data[item + '_name'] = ''
          @character.data[item + '_quality'] = ''
        end
      end

      # For 2H weapons the item level is counted twice to normalise between weapon types
      if !@data.equipment.equipped_items.any?{ |eq_item| eq_item.slot.type == "OFF_HAND" }
        items_equipped += 1
        @character.ilvl += @data.equipment.equipped_items.select{ |eq_item| eq_item.slot.type == "MAIN_HAND" }.first.level.value rescue 0
      end

      @character.data['active_loyal_traits'] = check_trait(303007)

      @character.data['ilvl'] = (@character.ilvl / (items_equipped)).round(2) rescue 0

      # Set item level to 0 if it's above 600, so inactive Legion characters aren't being shown as top
      @character.data['ilvl'] = 0 if @character.data['ilvl'] > 600

      @character.details['max_ilvl'] = [@character.data['ilvl'], @character.details['max_ilvl'].to_f].max
      @character.data['highest_ilvl_ever_equipped'] = @character.details['max_ilvl']
      @character.data['empty_sockets'] = @data.legacy['audit']['emptySockets']
      @character.data['gem_list'] = @character.gems.join('|')
    end

    def check_enchant(item, equipped_item)
      has_gem = GEMS[equipped_item.sockets&.first&.item&.id]
      @character.gems << has_gem if has_gem

      if ENCHANTS.include? item
        begin
          # Off-hand items that are not weapons can't be enchanted
          return if !equipped_item.weapon && item == "off_hand"

          @character.data["enchant_quality_#{item}"] =
            ENCHANTS[item][equipped_item.enchantments.first.enchantment_id][0]

          @character.data["#{item}_enchant"] =
            ENCHANTS[item][equipped_item.enchantments.first.enchantment_id][1]
        rescue
          @character.data["enchant_quality_#{item}"] = 0
          @character.data["#{item}_enchant"] = ''
        end
      end

      def check_trait(trait)
        ['head', 'shoulder', 'chest'].map do |item|
          @data.legacy['items'][item]['azeriteEmpoweredItem']['azeritePowers'].map do |power|
            power['spellId'] == trait ? true : nil # Loyal to the End
          end rescue []
        end.flatten.compact.size
      end
    end
  end
end
