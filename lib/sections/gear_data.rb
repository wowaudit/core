module Audit
  class GearData

    def self.add(character, data)
      ITEMS.each do |item|
        begin
          check_enchant(item, data, character)
          check_tier(item, data, character)
          check_legendary(item, data, character)
          character.ilvl += data['items'][item]['itemLevel']

          character.data[item + '_ilvl'] = data['items'][item]['itemLevel']
          character.data[item + '_id'] = data['items'][item]['id']
          character.data[item + '_name'] = data['items'][item]['name']
          character.data[item + '_quality'] = data['items'][item]['quality']

        rescue
          character.data[item + '_ilvl'] = ''
          character.data[item + '_id'] = ''
          character.data[item + '_name'] = ''
          character.data[item + '_quality'] = ''
        end
      end

      #Weapon ilvl is counted twice to normalise between 1H and 2H specialisations
      character.ilvl += (data['items']['mainHand']['itemLevel']*2) rescue nil

      if character.tier_data.include? item
        character.data["tier_#{item}"] = character.tier_data[item]
      end

      character.data['ilvl'] = (character.ilvl / ITEMS.length + 2).round(2)
      character.max_ilvl = [character.data['ilvl'], character.max_ilvl].max

      character.data['empty_sockets'] = data['audit']['emptySockets']
      character.data['gem_list'] = '|'.join(character.gems)
    end

    def check_enchant(item, data, character)
      character.gems << GEMS[data['items'][item]['tooltipParams']['gem0']] rescue nil

      if ENCHANTS.include? item
        begin
          character.data["enchant_quality_#{item}"] =
            ENCHANTS[item][data['items'][item]['tooltipParams']['enchant']][0]

          character.data["#{item}_enchant"] =
            ENCHANTS[item][data['items'][item]['tooltipParams']['enchant']][1]
        rescue
          character.data["enchant_quality_#{item}"] = 0
          character.data["#{item}_enchant"] = ''
        end
      end
    end

    def check_tier(item, data, character)
      if TIER_IDS.include? data['items'][item]['id'].to_i
        character.tier_data[item] = data['items'][item]['itemLevel'].to_i
      end
    end

    def check_legendary(item, data, character)
      if data['items'][item]['itemLevel'] >= 800 && data['items'][item]['quality'] == 5
        character.legendaries_equipped <<
          "#{data['items'][item]['id']}_#{data['items'][item]['name']}"
      end
    end
  end
end
