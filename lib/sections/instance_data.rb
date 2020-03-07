module Audit
  class InstanceData < Data
    def add
      add_attunement_data

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
      instance_data = @data.legacy['statistics']['subCategories'][5]['subCategories'][7]['statistics']

      MYTHIC_DUNGEONS_CRITERIA.keys.each do |i|
        amount = @data.legacy['achievements']['criteriaQuantity'][@data.legacy['achievements']['criteria'].index(i)] rescue 0
        dungeon_count += amount
        @character.data[MYTHIC_DUNGEONS_CRITERIA[i]] = amount
      end

      instance_data.each do |instance|
        # For some reason not all normal Mythic kills are being tracked with the criteria
        # for some characters. If the criteria is lower than the statistics then use the
        # statistics instead, as a workaround.
        if MYTHIC_DUNGEONS.include?(instance['id'])
          if @character.data[MYTHIC_DUNGEONS[instance['id']]].to_i < instance['quantity']
            dungeon_count -= @character.data[MYTHIC_DUNGEONS[instance['id']]].to_i
            @character.data[MYTHIC_DUNGEONS[instance['id']]] = instance['quantity']
            dungeon_count += instance['quantity']
          end
        end

        # Track weekly Raid kills through the statistics
        if boss_ids.include?(instance['id'])
          raid_list[instance['id']] = [
            instance['quantity'],
            (instance['lastUpdated'] / 1000) > Audit.timestamp ? 1 : 0
          ]
        end
      end

      @character.data['dungeons_done_total'] = dungeon_count
      @character.data['dungeons_this_week'] =
        dungeon_count - @character.details['snapshots'][Audit.year][Audit.week]['dungeons'] rescue 0

      encounters.each do |encounter|
        encounter.each do |difficulty, ids|
          raid_output["raids_#{difficulty}"] << ids.map{ |id| raid_list[id][0] }.max
          raid_output["raids_#{difficulty}_weekly"] << ids.map{ |id| raid_list[id][1] }.max
        end
      end

      raid_output.each do |metric, data|
        @character.data[metric] = data.join('|')
      end

      @character.data['cutting_edge'] =
        CUTTING_EDGE_ACHIEVEMENTS.count{ |raid| @data.achievements.achievementsCompleted.include? raid }
      @character.data['ahead_of_the_curve'] =
        AHEAD_OF_THE_CURVE_ACHIEVEMENTS.count{ |raid| @data.achievements.achievementsCompleted.include? raid }

      add_warcraftlogs_data
      add_raiderio_data
    end

    def add_warcraftlogs_data
      RAID_DIFFICULTIES.each_key do |diff|
        output = []
        WCL_IDS.each do |boss|
          output << (@character.details['warcraftlogs'][diff.to_s][boss] || '-')
        end
        @character.data["WCL_#{RAID_DIFFICULTIES[diff]}"] = output.join('|')
      end
    end

    def add_raiderio_data
      @character.data['m+_score'] =
        (@character.details['raiderio']['score'] rescue '')

      @character.data['season_highest_m+'] =
        (@character.details['raiderio']['season_highest'] rescue '-')

      @character.data['weekly_highest_m+'] =
        (@character.details['raiderio']['weekly_highest'] rescue 0)
    end

    def add_attunement_data
      if @character.data['faction'] == 'Alliance'
        @character.data['siege_of_boralus_attuned'] = @data.legacy['quests'].include?(51445)
        @character.data['kings_rest_attuned'] = @data.legacy['quests'].include?(53131)
      elsif @character.data['faction'] == 'Horde'
        @character.data['siege_of_boralus_attuned'] = @data.legacy['quests'].include?(53121)
        @character.data['kings_rest_attuned'] = @data.legacy['quests'].include?(50954)
      end
    end
  end
end
