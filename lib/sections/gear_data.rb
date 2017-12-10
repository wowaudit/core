module Audit
  class GearData

    def self.add(character, data)
      # Check activity feed
      data['feed'].select{ |item| item["type"] == "LOOT" }.each do |item|
        self.check_tier_from_feed(item, data, character)
        self.check_legendary_from_feed(item, data, character)
        self.check_pantheon_from_feed(item, data, character)
      end

      # Check equipped gear
      ITEMS.each do |item|
        begin
          self.check_enchant(item, data, character)
          self.check_tier(item, data, character)
          self.check_legendary(item, data, character)
          self.check_pantheon(item, data, character) if (["trinket1", "trinket2"].include? item)
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

      # Weapon ilvl is counted twice to normalise between 1H and 2H specialisations
      character.ilvl += (data['items']['mainHand']['itemLevel']*2) rescue 0
      character.data['ilvl'] = (character.ilvl / (ITEMS.length + 2)).round(2)
      character.max_ilvl = [character.data['ilvl'], character.max_ilvl].max

      character.data['empty_sockets'] = data['audit']['emptySockets']
      character.data['gem_list'] = character.gems.join('|')
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
      if TIER_IDS_MAPPED.keys.include? data['items'][item]['id'].to_i
        if character.details['tier_data'][item] != data['items'][item]['itemLevel'].to_i
          character.details['tier_data'][item] = data['items'][item]['itemLevel'].to_i
        end
      end

      if character.details['tier_data'].include? item
        character.data["tier_#{item}"] = character.details['tier_data'][item]
      end
    end

    def self.check_tier_from_feed(item, data, character)
      if TIER_IDS_MAPPED.keys.include? item["itemId"].to_i
        if character.details['tier_data'][TIER_IDS_MAPPED[item["itemId"].to_i]] < (BASE_ILVL[item["context"]] || 915)
          character.details['tier_data'][TIER_IDS_MAPPED[item["itemId"].to_i]] = (BASE_ILVL[item["context"]] || 915)
        end
      end
    end

    def self.check_legendary(item, data, character)
      if data['items'][item]['itemLevel'] >= 800 && data['items'][item]['quality'] == 5
        character.legendaries_equipped << "#{data['items'][item]['id']}_#{data['items'][item]['name']}"
      end
    end

    def self.check_legendary_from_feed(item, data, character)
      if LEGENDARIES.keys.include? item["itemId"]
        character.legendaries_equipped << "#{item["itemId"]}_#{LEGENDARIES[item["itemId"]]}"
      end
    end

    def self.check_pantheon(item, data, character)
      if PANTHEON_TRINKETS.keys.include? data['items'][item]['id'].to_i
        if character.details['pantheon_trinket']['ilvl'].to_i < data['items'][item]['itemLevel'].to_i
          character.details['pantheon_trinket']['ilvl'] = data['items'][item]['itemLevel']
          character.details['pantheon_trinket']['type'] = PANTHEON_TRINKETS[data['items'][item]['id'].to_i]
        end
      end
      character.data["pantheon_trinket_ilvl"] = character.details['pantheon_trinket']['ilvl']
      character.data["pantheon_trinket_type"] = character.details['pantheon_trinket']['type']
    end

    def self.check_pantheon_from_feed(item, data, character)
      if PANTHEON_TRINKETS.keys.include? item["itemId"]
        if character.details['pantheon_trinket']['ilvl'].to_i < 940
          character.details['pantheon_trinket']['ilvl'] = 940
          character.details['pantheon_trinket']['type'] = PANTHEON_TRINKETS[item["itemId"].to_i]
        end
      end
    end
  end
end
