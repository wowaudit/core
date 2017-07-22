module Audit
  class InstanceData

    def self.add(character, data)
      encounters = VALID_RAIDS.map{ |raid|
        raid['encounters'].map{ |boss|
          boss['raid_ids']
        }
      }.flatten
      boss_ids = encounters.map{ |encounter| encounter.values }.flatten
      raid_list = {}
      raid_output = {'raids_normal' => [],'raids_normal_weekly' => [],
                     'raids_heroic' => [],'raids_heroic_weekly' => [],
                     'raids_mythic' => [],'raids_mythic_weekly' => []}
      dungeon_list = {}
      dungeon_count = 0
      instance_data = data['statistics']['subCategories'][5]['subCategories'][6]['statistics']

      instance_data.each do |instance|
        if MYTHIC_DUNGEONS.include?(instance['id'])
          dungeon_count += instance['quantity']
          begin #For dungeons with multiple entries
            character.data[MYTHIC_DUNGEONS[instance['id']]] += instance['quantity']
          rescue
            character.data[MYTHIC_DUNGEONS[instance['id']]] = instance['quantity']
          end
        end
        if boss_ids.include?(instance['id'])
          raid_list[instance['id']] = [
            instance['quantity'],
            (instance['lastUpdated'] / 1000) > Audit.timestamp ? 1 : 0
          ]
        end
      end

      character.data['dungeons_done_total'] = dungeon_count
      character.data['dungeons_this_week'] =
        character.dungeon_snapshot ? dungeon_count - character.dungeon_snapshot : 0

      #Future dungeons with unknown ID that are already added in front-end
      character.data['Cathedral of Eternal Night'] = 0
      character.data['Seat of the Triumvirate'] = 0

      encounters.each do |encounter|
        encounter.each do |difficulty, id|
          raid_output["raids_#{difficulty}"] << raid_list[id][0]
          raid_output["raids_#{difficulty}_weekly"] << raid_list[id][1]
        end
      end

      raid_output.each do |metric, data|
        character.data[metric] = data.join('|')
      end

      self.add_warcraftlogs_data(character)
      self.add_raiderio_data(character)
    end

    def self.add_warcraftlogs_data(character)
      if character.warcraftlogs
        data = JSON.parse character.warcraftlogs
        character.data['WCL_id'] = data['character_id']
        data.delete('character_id')

        #Temporary
        data.delete('raider_io_score')
        data.delete('weekly_highest_m')
        data.delete('season_highest_m')

        data.each do |metric, values|
          difficulty = RAID_DIFFICULTIES[metric.split('_')[1].to_i]
          character.data["WCL_#{difficulty}_#{metric.split('_')[0]}"] = values.join('|')
        end
      else
        character.data['WCL_id'] = ''
        ['best_3','best_4','best_5',
         'median_3','median_4','median_5',
         'average_3','average_4','average_5'
        ].each do |metric|
          difficulty = RAID_DIFFICULTIES[metric.split('_')[1].to_i]
          character.data["WCL_#{difficulty}_#{metric.split('_')[0]}"] = ''
        end
      end
    end

    def self.add_raiderio_data(character)
      if character.raiderio
        data = JSON.parse character.raiderio

        character.data['m+_score'] = data['score']
        character.data['season_highest_m+'] = data['season_highest']
      else
        character.data['m+_score'] = ''
        character.data['season_highest_m+'] = "-"
      end
      character.data['weekly_highest_m+'] = character.raiderio_weekly
    end
  end
end
