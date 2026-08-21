module Audit
  module Live
    class CollectionData < Data
      def add
        @character.data['achievement_points'] = @data[:achievement_points]

        begin
          crest_stats = @data[:achievement_statistics][:categories].find do |category|
            category[:name] == "Character"
          end[:statistics]

          @character.data['adventurer_crests'] = crest_stats.find { |stat| stat[:id] == 62912 }[:quantity] rescue 0
          @character.data['veteran_crests'] = crest_stats.find { |stat| stat[:id] == 62913 }[:quantity] rescue 0
          @character.data['champion_crests'] = crest_stats.find { |stat| stat[:id] == 62914 }[:quantity] rescue 0
          @character.data['hero_crests'] = crest_stats.find { |stat| stat[:id] == 62915 }[:quantity] rescue 0
          @character.data['myth_crests'] = crest_stats.find { |stat| stat[:id] == 62916 }[:quantity] rescue 0
        rescue
          nil
        end

        add_uncapped_crests!

        if @achievements
          @character.data['mounts'] = @achievements[2143][:criteria][:child_criteria].first[:amount] rescue 0
          @character.data['toys_owned'] = @achievements[9670][:criteria][:child_criteria].first[:amount] rescue 0
          folio_achievement = @achievements.dig(63325, :criteria)
          @character.data['folio_amount'] = folio_achievement&.dig(:is_completed) ? "5 / 5" : "#{folio_achievement&.dig(:amount) || 0} / 5"
        end

        if @data[:titles]
          @character.data['titles'] = @data[:titles].size
        end

        if @data[:mounts]
          @character.data['midnight_falls_mount'] = 'no'
          @character.data['ulatek_mount'] = 'no'

          @data[:mounts].lazy.each do |entry|
            next unless entry.is_a? Hash

            @character.data['midnight_falls_mount'] = 'yes' if entry.dig(:mount, :id) == 2607
            @character.data['ulatek_mount'] = 'yes' if entry.dig(:mount, :id) == 3030
          end
        end

        if @data[:pets]
          pets_owned = []
          level_25_pets = 0

          @data[:pets].lazy.each do |pet|
            next unless pet.is_a? Hash

            unless pets_owned.lazy.include?(pet[:species][:id])
              pets_owned << pet[:species][:id]
              level_25_pets += pet[:level] == 25 ? 1 : 0
            end
          end

          @character.data['unique_pets'] = pets_owned.size # Await Blizzard to add account wide collection achievement again
          @character.data['lvl_25_pets'] = level_25_pets
        end
      end

      private

      def add_uncapped_crests!
        season = Season.current
        season_key = season.id.to_s
        earned_by_type = {}

        (season.data[:crests] || []).each do |crest|
          sources = crest[:uncapped_crests]
          next unless sources.is_a?(Hash) && sources.any?

          field = "uncapped_#{crest[:name].downcase}_crests"
          earned = {}

          sources.each do |source, amount|
            next unless uncapped_source_earned?(source.to_s)

            earned[source.to_s] = amount
          end

          @character.data[field] = earned.values.sum
          earned_by_type[crest[:name]] = earned if earned.any?
        end

        @character.details['uncapped_crests'][season_key] = earned_by_type
      end

      def uncapped_source_earned?(source)
        type, id = source.delete_prefix('/').split('=', 2)
        return false unless id

        case type
        when 'quest'
          @data.dig(:completed_quests, :quests)&.any? { |quest| quest[:id] == id.to_i }
        when 'achievement'
          @achievements&.dig(id.to_i, :criteria, :is_completed)
        else
          false
        end
      end
    end
  end
end
