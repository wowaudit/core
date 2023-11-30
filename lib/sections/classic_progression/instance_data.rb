module Audit
  module ClassicProgression
    class InstanceData < Data
      def add
        encounters_by_raid = VALID_RAIDS[:classic_progression].map{ |raid|
          raid['encounters'].map{ |boss|
            boss['raid_ids']
          }
        }
        boss_ids = encounters_by_raid.flatten.map{ |encounter| encounter.values }.flatten
        raid_list = {}
        great_vault_list = {}
        raid_output = {'raids_normal' => [],      'raids_normal_weekly' => [],
                       'raids_heroic' => [],      'raids_heroic_weekly' => []}

        begin
          dungeons_and_raids =  @data[:achievement_statistics][:categories].find do |category|
            category[:name] == "Dungeons & Raids"
          end

          dungeons_and_raids[:sub_categories].map{ |cat| cat[:statistics] }.flatten.lazy.each do |instance|
            # Track weekly Raid kills through the statistics
            if boss_ids.include?(instance[:id])
              raid_list[instance[:id]] = [
                instance[:quantity].to_i,
                (instance[:last_updated_timestamp] / 1000) > Audit.timestamp ? 1 : 0,
              ]
            end
          end
        rescue
          nil
        end

        encounters_by_raid.each_with_index do |raid_encounters, raid_index|
          raid_encounters.each_with_index do |encounter, index|
            encounter.each do |difficulty, ids|
              raid_output["raids_#{difficulty}"] << (ids.map{ |id| raid_list[id] && raid_list[id][0] || 0 }.max || 0)
              raid_output["raids_#{difficulty}_weekly"] << (ids.map{ |id| raid_list[id] && raid_list[id][1] || 0 }.max || 0)
            end
          end
        end

        raid_output.lazy.each do |metric, data|
          @character.data[metric] = data.join('|')
        end
      end
    end
  end
end
