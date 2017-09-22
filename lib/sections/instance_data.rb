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

      # Track Dungeon count through the statistics
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

      # Patch dungeons haven't been added to statistics, but can be tracked using criterias
      DUNGEONS_BY_ACHIEVEMENT.each do |key, dungeon|
        criteria = data['achievements']['criteria'].index(key)
        completions = data['achievements']['criteriaQuantity'][criteria] rescue 0
        character.data[dungeon] = completions
        dungeon_count += completions
      end

      character.data['dungeons_done_total'] = dungeon_count
      character.data['dungeons_this_week'] =
        character.dungeon_snapshot ? dungeon_count - character.dungeon_snapshot : 0

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

        character.data['WCL_id'] = character.wcl_parsed['character_id']
        character.wcl_parsed.delete('character_id')

        character.wcl_parsed.delete('raider_io_score')
        character.wcl_parsed.delete('weekly_highest_m')
        character.wcl_parsed.delete('season_highest_m')

        character.wcl_parsed.each do |metric, values|
          difficulty = RAID_DIFFICULTIES[metric.split('_')[1].to_i]
          character.data["WCL_#{difficulty}_#{metric.split('_')[0]}"] = values.join('|')
        end
      else
        character.data['WCL_id'] = ''
        WCL_METRICS.each_key do |metric|
          difficulty = RAID_DIFFICULTIES[metric.split('_')[1].to_i]
          character.data["WCL_#{difficulty}_#{metric.split('_')[0]}"] = ''
        end
      end
    end

    def self.add_raiderio_data(character)
      if character.raiderio
        character.data['m+_score'] = character.raiderio_parsed['score']
        character.data['season_highest_m+'] = character.raiderio_parsed['season_highest']
      else
        character.data['m+_score'] = ''
        character.data['season_highest_m+'] = "-"
      end
      character.data['weekly_highest_m+'] = character.raiderio_weekly
    end
  end
end
