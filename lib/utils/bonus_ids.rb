# TODO: share with other apps instead of duplicating
module Audit
  class BonusIds
    BONUS_IDS_BY_SEASON = {
      11 => { mythic: 9573..9576, heroic: [9658, 9569, 9570, 9571, 9572, 9581], normal: 9560..9567, raid_finder: 9552..9559, world_advanced: 9544..9551, world_basic: 9536..9543 },
      12 => { mythic: 10335..10338, heroic: 10329..10334, normal: 10313..10320, raid_finder: 10341..10348, world_advanced: 10321..10328, world_basic: 10305..10312 },
      13 => { mythic: [10260, 10259, 10258, 10257, 10298, 10299], heroic: [10265, 10264, 10263, 10262, 10261, 10256], normal: [10273, 10272, 10271, 10270, 10269, 10268, 10267, 10266], raid_finder: [10281, 10280, 10279, 10278, 10277, 10276, 10275, 10274], world_advanced: [10297, 10296, 10295, 10294, 10293, 10292, 10291, 10290], world_basic: [10289, 10288, 10287, 10286, 10285, 10284, 10283, 10282] },
      14 => { mythic: [11991, 11992, 11993, 11994, 11995, 11996, 12375, 12376], heroic: [11985, 11986, 11987, 11988, 11989, 11990, 12371, 12372], normal: 11977..11984, raid_finder: 11969..11976 },
      15 => { mythic: [12356, 12357, 12358, 12359, 12360, 12361, 13445, 13446], heroic: [12350, 12351, 12352, 12353, 12354, 12355, 13443, 13444], normal: 12290..12297, raid_finder: 12282..12289 }
    }

    DIFFICULTY_LABELS = {
      mythic: "Myth",
      heroic: "Hero",
      normal: "Champion",
      raid_finder: "Veteran",
      world_advanced: "Adventurer",
      world_basic: "Explorer",
    }

    class << self
      def current
        for_season(Season.current)
      end

      def for_season(season)
        if season
          BONUS_IDS_BY_SEASON[season.id]
        else
          @all_seasons ||= BONUS_IDS_BY_SEASON.reduce({}) do |memo, (season, ids_by_difficulty)|
            ids_by_difficulty.each do |difficulty, ids|
              memo[difficulty] ||= Set.new
              memo[difficulty].merge(ids.to_a)
            end

            memo
          end
        end
      end

      def label_for_id(id, season = Season.current)
        for_season(season).each do |difficulty, ids|
          if index = ids.to_a.index(id)
            return "Base level" if index.zero?
            return "#{DIFFICULTY_LABELS[difficulty]} #{index + 1}/#{ids.size}"
          end
        end

        nil
      end

      def difficulty_for_id(id, season = Season.current)
        for_season(season).each do |difficulty, ids|
          return difficulty if ids.include?(id)
        end

        nil
      end

      def id_for_index(index, difficulty, season = Season.current)
        for_season(season)[difficulty.to_sym].to_a[index]
      end

      def label_for_index(index, difficulty, season = Season.current)
        label_for_id(id_for_index(index, difficulty, season), season)
      end

      def all_ids
        @all_ids ||= BONUS_IDS_BY_SEASON.values.flat_map(&:values).flat_map(&:to_a)
      end

      def difficulty_by_id(season = Season.current)
        for_season(season).values.map.with_index { |ids, difficulty| ids.map { |id| [id, difficulty] } }.flatten(1).to_h
      end
    end
  end
end
