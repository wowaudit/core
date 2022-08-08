module Audit
  class InstanceData < Data
    def add
      encounters_by_raid = VALID_RAIDS.map{ |raid|
        raid['encounters'].map{ |boss|
          boss['raid_ids']
        }
      }
      boss_ids = encounters_by_raid.flatten.map{ |encounter| encounter.values }.flatten
      raid_list = {}
      great_vault_list = {}
      raid_output = {'raids_raid_finder' => [], 'raids_raid_finder_weekly' => [],
                     'raids_normal' => [],      'raids_normal_weekly' => [],
                     'raids_heroic' => [],      'raids_heroic_weekly' => [],
                     'raids_mythic' => [],      'raids_mythic_weekly' => []}
      dungeon_list = {}

      begin
        dungeons_and_raids =  @data[:achievement_statistics]['categories'].find do |category|
          category['name'] == "Dungeons & Raids"
        end

        dungeons_and_raids['sub_categories'].map{ |cat| cat['statistics'] }.flatten.each do |instance|
          # Track weekly Raid kills through the statistics
          if boss_ids.include?(instance['id'])
            raid = VALID_RAIDS.find { |raid| instance['name'].include? raid['name'] }
            last_fated_period = raid[:fated_periods].reject { |period| period > Audit.period }.max
            killed_this_rotation = (instance['last_updated_timestamp'] / 1000) > Audit.timestamp - (604799 * (Audit.period - last_fated_period))

            if killed_this_rotation
              (@character.details['raid_kills'][last_fated_period] ||= {})[instance['id']] = instance['last_updated_timestamp'] / 1000
            end

            raid_list[instance['id']] = [
              instance['quantity'].to_i,
              killed_this_rotation ? 1 : 0
            ]
          end
        end
      rescue
        nil
      end

      kills_by_difficulty = { 'heroic' => 0, 'mythic' => 0 }
      total_fated_kills = encounters_by_raid.sum do |encounters|
        @character.details['raid_kills'].keys.sum do |period|
          encounters.select do |encounter_ids|
            kills = (@character.details['raid_kills'][period].keys & encounter_ids.values.flatten)
            kills_by_difficulty.keys.each do |difficulty|
              if (kills & encounter_ids[difficulty]).any?
                kills_by_difficulty[difficulty] += 1
              end
            end

            kills.any?
          end.size
        end
      end

      @character.data['dinar_earned'] = [30, 50, 60].select { |q| total_fated_kills >= q }.size
      @character.data['dinar_progress'] = if @character.data['dinar_earned'] == 3
        "-"
      elsif @character.data['dinar_earned'].zero?
        "#{total_fated_kills} / 30"
      else
        "#{total_fated_kills - [30, 50, 60][@character.data['dinar_earned'] - 1]} / #{[30, 20, 10][@character.data['dinar_earned']]}"
      end

      @character.data["heroic_upgrade_tokens"] = kills_by_difficulty["heroic"]
      @character.data["mythic_upgrade_tokens"] = kills_by_difficulty["mythic"]

      @data[:season_keystones]['best_runs'].each do |run|
        run_id = run['completed_timestamp'] / 1000
        run_period = Audit.period_from_timestamp(run_id).to_s
        unless @character.details['keystones'][run_period]&.include?(run_id.to_s)
          (@character.details['keystones'][run_period] ||= {})[run_id.to_s] = {
            "level" => run['keystone_level'],
            "dungeon" => run.dig('dungeon', 'id'),
          }
        end
      end

      best_runs = @data[:season_keystones]['best_runs']
                    &.group_by { |run| run.dig('dungeon', 'id') }
                    &.transform_values { |runs| runs.map { |run| run.dig('mythic_rating', 'rating') }.max } || {}

      SLUGIFIED_DUNGEON_NAMES.each do |dungeon_id, dungeon_name|
        @character.data["#{dungeon_name}_score"] = best_runs[dungeon_id.to_i].to_i
        @character.data[dungeon_name] = (@character.details['keystones'].values[0] || {}).sum do |run_id, run|
          run['dungeon'].to_i == dungeon_id.to_i ? 1 : 0
        end
      end

      @character.data['dungeons_this_week'] = @character.details['keystones'][Audit.period.to_s]&.size || 0
      dungeons_per_week_in_season = @character.details['keystones'].map do |period, runs|
        if period.to_i < FIRST_PERIOD_OF_SEASON
          0
        else
          runs.size
        end
      end
      @character.data['dungeons_done_total'] = dungeons_per_week_in_season.sum
      @character.data['historical_dungeons_done'] = dungeons_per_week_in_season.join('|')

      @character.data['m+_score'] = (@data[:season_keystones].dig('mythic_rating', 'rating') || 0).to_i

      vault_index = -1
      encounters_by_raid.flatten.each_with_index do |encounter, index|
        if (boss_ids & encounter['normal']).any?
          vault_index += 1
          great_vault_list[vault_index] = {}
        end

        encounter.each do |difficulty, ids|
          raid_output["raids_#{difficulty}"] << ids.map{ |id| raid_list[id] && raid_list[id][0] || 0 }.max
          raid_output["raids_#{difficulty}_weekly"] << ids.map{ |id| raid_list[id] && raid_list[id][1] || 0 }.max

          if (boss_ids & ids).any?
            great_vault_list[vault_index][difficulty] = ids.map{ |id| raid_list[id] && raid_list[id][1] || 0 }.max
          end
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

        total_layers = 0
        @achievements[14810]['criteria']['child_criteria'].each do |wing|
          @character.data["torghast_layers_#{TORGHAST_WINGS[wing['id']]}"] = TORGHAST_LAYER_CRITERIA.count { |layer| layer <= (wing['amount'] || 0) }
          total_layers += @character.data["torghast_layers_#{TORGHAST_WINGS[wing['id']]}"]
        end rescue nil

        @character.data['torghast_layers_twisting_corridors'] =
          TORGHAST_TWISTING_CORRIDORS_IDS.count{ |layer| @achievements[layer] }

        @character.data['torghast_layers_jailers_gauntlet'] =
          TORGHAST_JAILERS_GAUNTLET_IDS.count{ |layer| @achievements[layer] }

        @character.data['torghast_floors'] = total_layers + @character.data['torghast_layers_twisting_corridors'] + @character.data['torghast_layers_jailers_gauntlet']
      end
    end

    def add_great_vault_data(raid_completions)
      raid_bosses_killed = raid_completions.count { |boss, difficulties| difficulties.any? { |diff, killed| killed > 0 } }
      completions_per_difficulty = {
        'mythic' => [],
        'heroic' => [],
        'normal' => [],
        'raid_finder' => [],
      }

      raid_completions.values.each do |boss|
        boss.keys.each do |difficulty|
          completions_per_difficulty[difficulty] << (boss[difficulty] > 0 ? difficulty : nil)
        end
      end

      slot_info = raid_completions.keys.map do |boss|
        completions_per_difficulty['mythic'][boss] ||
        completions_per_difficulty['heroic'][boss] ||
        completions_per_difficulty['normal'][boss] ||
        completions_per_difficulty['raid_finder'][boss]
      end.compact.sort_by do |kill|
        completions_per_difficulty.keys.index(kill)
      end

      GREAT_VAULT_RAID_KILLS_NEEDED.each do |slot, kills_needed|
        @character.data["great_vault_slot_#{slot}"] = if raid_bosses_killed >= kills_needed
          GREAT_VAULT_TO_ILVL['raid'][slot_info[kills_needed - 1]]
        end || ''
      end

      # Use either Raider.io data or leaderboard data, whichever is more complete at the moment
      dungeon_data = if @character.details['raiderio']['top_ten_highest'].sum > @character.details['raiderio']['leaderboard_runs'].sum
        @character.details['raiderio']['top_ten_highest']
      else
        (@character.details['raiderio']['leaderboard_runs'] || []).sort_by { |h| h * -1 }
      end

      @character.data['great_vault_slot_4'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[0] || 0, 15].min]
      @character.data['great_vault_slot_5'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[3] || 0, 15].min]
      @character.data['great_vault_slot_6'] = GREAT_VAULT_TO_ILVL['dungeon'][[dungeon_data[7] || 0, 15].min]

      honor_earned = 0
      highest_rating = 0

      BRACKETS.each do |bracket, endpoint|
        if @data[endpoint.to_sym].class == RBattlenet::HashResult && @data[endpoint.to_sym]['season']['id'] == CURRENT_PVP_SEASON
          # Assume that players haven't played more than 3 different days.. Hacky for now
          honor_earned += [@data[endpoint.to_sym]['weekly_match_statistics']['won'], 3].min * HONOR_PER_WIN[bracket][:daily]
          honor_earned += [@data[endpoint.to_sym]['weekly_match_statistics']['won'] - 3, 0].max * HONOR_PER_WIN[bracket][:win]
          honor_earned += @data[endpoint.to_sym]['weekly_match_statistics']['lost'] * HONOR_PER_WIN[bracket][:loss]

          if @data[endpoint.to_sym]['season']['id'] == CURRENT_PVP_SEASON && @data[endpoint.to_sym]['weekly_match_statistics']['won'] > 0
            highest_rating = [highest_rating, @data[endpoint.to_sym]['rating']].max
          end
        end
      end

      item_level = GREAT_VAULT_TO_ILVL['pvp'][GREAT_VAULT_TO_ILVL['pvp'].keys.find { |rating| highest_rating >= rating }]

      @character.data['great_vault_slot_7'] = honor_earned >= 1250 ? item_level : ''
      @character.data['great_vault_slot_8'] = honor_earned >= 2500 ? item_level : ''
      @character.data['great_vault_slot_9'] = honor_earned >= 5500 ? item_level : ''
    end
  end
end
