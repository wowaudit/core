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
      raid_output = {'raids_raid_finder' => [], 'raids_raid_finder_weekly' => [],
                     'raids_normal' => [],      'raids_normal_weekly' => [],
                     'raids_heroic' => [],      'raids_heroic_weekly' => [],
                     'raids_mythic' => [],      'raids_mythic_weekly' => []}
      dungeon_list = {}
      total_dungeons = 0

      @data.achievement_statistics.categories[5].sub_categories.map(&:statistics).flatten.each do |instance|
        if MYTHIC_DUNGEONS.include?(instance.id)
          @character.data[MYTHIC_DUNGEONS[instance.id]] = instance.quantity.to_i
          total_dungeons += instance.quantity.to_i
        end

        # Track weekly Raid kills through the statistics
        if boss_ids.include?(instance.id)
          raid_list[instance.id] = [
            instance.quantity.to_i,
            (instance.last_updated_timestamp / 1000) > Audit.timestamp ? 1 : 0
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
        end
      end

      raid_output.each do |metric, data|
        @character.data[metric] = data.join('|')
      end

      if @achievements
        @character.data['cutting_edge'] =
          CUTTING_EDGE_ACHIEVEMENTS.count{ |raid| @achievements[raid] }
        @character.data['ahead_of_the_curve'] =
          AHEAD_OF_THE_CURVE_ACHIEVEMENTS.count{ |raid| @achievements[raid] }

        @character.data['memento_amount'] = @achievements[14173].criteria.child_criteria.first.amount rescue 0
      end
    end
  end
end
