module Audit
  class InstanceData < Data
    def add
      encounters = VALID_RAIDS.map{ |raid|
        raid['encounters'].map{ |boss|
          boss['raid_ids']
        }
      }.flatten
      boss_ids = encounters.map{ |encounter| encounter.values }.flatten
      raid_list = {}
      great_vault_list = {
        'mythic' => 0,
        'heroic' => 0,
        'normal' => 0,
        'raid_finder' => 0,
      }
      raid_output = {'raids_raid_finder' => [], 'raids_raid_finder_weekly' => [],
                     'raids_normal' => [],      'raids_normal_weekly' => [],
                     'raids_heroic' => [],      'raids_heroic_weekly' => [],
                     'raids_mythic' => [],      'raids_mythic_weekly' => []}
      dungeon_list = {}
      total_dungeons = 0

      dungeons_and_raids =  @data[:achievement_statistics]['categories'].find do |category|
        category['name'] == "Dungeons & Raids"
      end

      dungeons_and_raids['sub_categories'].map{ |cat| cat['statistics'] }.flatten.each do |instance|
        if MYTHIC_DUNGEONS.include?(instance['id'])
          @character.data[MYTHIC_DUNGEONS[instance['id']]] = instance['quantity'].to_i
          total_dungeons += instance['quantity'].to_i
        end

        # Track weekly Raid kills through the statistics
        if boss_ids.include?(instance['id'])
          raid_list[instance['id']] = [
            instance['quantity'].to_i,
            (instance['last_updated_timestamp'] / 1000) > Audit.timestamp ? 1 : 0
          ]
        end
      end rescue nil

      unless total_dungeons.zero?
        @character.data['dungeons_done_total'] = total_dungeons
      end

      encounters.each do |encounter|
        encounter.each do |difficulty, ids|
          raid_output["raids_#{difficulty}"] << ids.map{ |id| raid_list[id] && raid_list[id][0] || 0 }.max
          raid_output["raids_#{difficulty}_weekly"] << ids.map{ |id| raid_list[id] && raid_list[id][1] || 0 }.max
          great_vault_list[difficulty] += ids.map{ |id| raid_list[id] && raid_list[id][1] || 0 }.max
        end
      end

      raid_output.each do |metric, data|
        @character.data[metric] = data.join('|')
      end

      add_great_vault_data(great_vault_list)

      if @achievements
        @character.data['cutting_edge'] =
          CUTTING_EDGE_ACHIEVEMENTS.count{ |raid| @achievements[raid] }
        @character.data['ahead_of_the_curve'] =
          AHEAD_OF_THE_CURVE_ACHIEVEMENTS.count{ |raid| @achievements[raid] }

        @character.data['torghast_floors'] = (@achievements[14810]['criteria']['child_criteria'].sum{ |cr| cr['amount'] } rescue 0)
      end
    end

    def add_great_vault_data(raid_completions)
      raid_bosses_killed = raid_completions.map { |diff, amount| [diff] * amount }.flatten

      @character.data['great_vault_slot_1'] = GREAT_VAULT_TO_ILVL['raid'][raid_bosses_killed[2]] || ''
      @character.data['great_vault_slot_2'] = GREAT_VAULT_TO_ILVL['raid'][raid_bosses_killed[6]] || ''
      @character.data['great_vault_slot_3'] = GREAT_VAULT_TO_ILVL['raid'][raid_bosses_killed[9]] || ''

      # Use either Raider.io data or leaderboard data, whichever is more complete at the moment
      dungeon_data = if @character.details['raiderio']['top_ten_highest'].sum > @character.details['raiderio']['leaderboard_runs'].sum
        @character.details['raiderio']['top_ten_highest']
      else
        @character.details['raiderio']['leaderboard_runs']
      end

      @character.data['great_vault_slot_4'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[0] || 0, 14].min]
      @character.data['great_vault_slot_5'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[3] || 0, 14].min]
      @character.data['great_vault_slot_6'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[9] || 0, 14].min]

      honor_earned = 0
      highest_rating = 0
      BRACKETS.each do |bracket, endpoint|
        if @data[endpoint.to_sym].class == RBattlenet::HashResult
          honor_earned += @data[endpoint.to_sym]['weekly_match_statistics']['won'] * HONOR_PER_WIN[bracket]
          highest_rating = [highest_rating, @data[endpoint.to_sym]['rating']].max
        end
      end

      item_level = GREAT_VAULT_TO_ILVL['pvp'][GREAT_VAULT_TO_ILVL['pvp'].keys.find { |rating| highest_rating >= rating }]

      @character.data['great_vault_slot_7'] = honor_earned >= 1250 ? item_level : ''
      @character.data['great_vault_slot_8'] = honor_earned >= 2500 ? item_level : ''
      @character.data['great_vault_slot_9'] = honor_earned >= 6250 ? item_level : ''
    end
  end
end
