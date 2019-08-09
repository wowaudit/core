module Audit
  class GearData

    def self.add(character, data)
      # Check equipped gear
      items_equipped = 0
      ITEMS.each do |item|
        begin
          self.check_enchant(item, data, character)
          character.ilvl += data['items'][item]['itemLevel']

          character.data[item + '_ilvl'] = data['items'][item]['itemLevel']
          character.data[item + '_id'] = data['items'][item]['id']
          character.data[item + '_name'] = data['items'][item]['name']
          character.data[item + '_quality'] = data['items'][item]['quality']
          items_equipped += 1

        rescue
          character.data[item + '_ilvl'] = ''
          character.data[item + '_id'] = ''
          character.data[item + '_name'] = ''
          character.data[item + '_quality'] = ''
        end
      end

      # For 2H weapons the item level is counted twice to normalise between weapon types
      if !data['items']['offHand']
        items_equipped += 1
        character.ilvl += data['items']['mainHand']['itemLevel'] rescue 0
      end

      character.data['active_loyal_traits'] = self.check_trait(303007, data, character)

      character.data['ilvl'] = (character.ilvl / (items_equipped)).round(2) rescue 0

      # Set item level to 0 if it's above 600, so inactive Legion characters aren't being shown as top
      character.data['ilvl'] = 0 if character.data['ilvl'] > 600

      character.details['max_ilvl'] = [character.data['ilvl'], character.details['max_ilvl'].to_f].max
      character.data['highest_ilvl_ever_equipped'] = character.details['max_ilvl']
      character.data['empty_sockets'] = data['audit']['emptySockets']
      character.data['gem_list'] = character.gems.join('|')
    end

    def self.check_enchant(item, data, character)
      has_gem = GEMS[data['items'][item]['tooltipParams']['gem0']]
      character.gems << has_gem if has_gem

      if ENCHANTS.include? item
        begin
          # Off-hand items that are not weapons can't be enchanted
          return if !data['items'][item]["weaponInfo"] && item == "offHand"

          character.data["enchant_quality_#{item}"] =
            ENCHANTS[item][data['items'][item]['tooltipParams']['enchant']][0]

          character.data["#{item}_enchant"] =
            ENCHANTS[item][data['items'][item]['tooltipParams']['enchant']][1]
        rescue
          character.data["enchant_quality_#{item}"] = 0
          character.data["#{item}_enchant"] = ''
        end
      end

      def self.check_trait(trait, data, character)
        ['head', 'shoulder', 'chest'].map do |item|
          data['items'][item]['azeriteEmpoweredItem']['azeritePowers'].map do |power|
            power['spellId'] == trait ? true : nil # Loyal to the End
          end rescue []
        end.flatten.compact.size
      end
    end
  end
end
