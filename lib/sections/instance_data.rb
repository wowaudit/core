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
      raid_output = {'raids_raid_finder' => [], 'raids_raid_finder_weekly' => [],
                     'raids_normal' => [],      'raids_normal_weekly' => [],
                     'raids_heroic' => [],      'raids_heroic_weekly' => [],
                     'raids_mythic' => [],      'raids_mythic_weekly' => []}
      dungeon_list = {}
      dungeon_count = 0
      instance_data = data['statistics']['subCategories'][5]['subCategories'][7]['statistics']

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

      character.data['dungeons_done_total'] = dungeon_count
      character.data['dungeons_this_week'] =
        dungeon_count - character.details['snapshots'][Audit.year][Audit.week]['dungeons'] rescue 0

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
      RAID_DIFFICULTIES.each_key do |diff|
        output = []
        WCL_IDS.each do |boss|
          output << (character.details['warcraftlogs'][diff.to_s][boss] || '-')
        end
        character.data["WCL_#{RAID_DIFFICULTIES[diff]}"] = output.join('|')
      end
    end

    def self.add_raiderio_data(character)
      character.data['m+_score'] =
        (character.details['raiderio']['score'] rescue '')

      character.data['season_highest_m+'] =
        (character.details['raiderio']['season_highest'] rescue '-')

      character.data['weekly_highest_m+'] =
        (character.details['raiderio']['weekly_highest'] rescue 0)
    end
  end
end
