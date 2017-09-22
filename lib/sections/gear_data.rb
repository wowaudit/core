module Audit
  class GearData

    def self.add(character, data)
      ITEMS.each do |item|
        begin
          self.check_enchant(item, data, character)
          self.check_tier(item, data, character)
          self.check_legendary(item, data, character)
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
      character.ilvl += (data['items']['mainHand']['itemLevel']*2) rescue 0
      character.data['ilvl'] = (character.ilvl / (ITEMS.length + 2)).round(2)
      character.max_ilvl = [character.data['ilvl'], character.max_ilvl].max

      character.data['empty_sockets'] = data['audit']['emptySockets']
      character.data['gem_list'] = character.gems.join('|')
      character.tier_data = JSON.generate character.tier_pieces
    end

    def self.check_enchant(item, data, character)
      has_gem = GEMS[data['items'][item]['tooltipParams']['gem0']]
      character.gems << has_gem if has_gem

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

    def self.check_tier(item, data, character)
      if TIER_IDS.include? data['items'][item]['id'].to_i
        if character.tier_pieces[item] != data['items'][item]['itemLevel'].to_i
          character.changed = true
          character.tier_pieces[item] = data['items'][item]['itemLevel'].to_i
        end
      end

      if character.tier_pieces.include? item
        character.data["tier_#{item}"] = character.tier_pieces[item]
      end
    end

    def self.check_legendary(item, data, character)
      if data['items'][item]['itemLevel'] >= 800 && data['items'][item]['quality'] == 5
        character.legendaries_equipped <<
          "#{data['items'][item]['id']}_#{data['items'][item]['name']}"
      end
    end
  end
end
