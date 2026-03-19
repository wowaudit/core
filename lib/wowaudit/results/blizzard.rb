module Wowaudit
  module Results
    class Blizzard < Base
      attr_accessor :data, :gems, :ilvl, :changed, :stat_info, :delve_info

      def initialize(character, response, commit_changes = true)
        super(character, response, commit_changes)

        @data = {}
        @gems = []
        @ilvl = 0.0
        @stat_info = TRACKED_STATS.values.map { |stat| [stat, { gear: 0, enchantments: 0 }] }.to_h
        @delve_info = { total: 0, tier_1: 0, tier_2: 0, tier_3: 0, tier_4: 0, tier_5: 0, tier_6: 0, tier_7: 0, tier_8: 0, tier_9: 0, tier_10: 0, tier_11: 0 }

        # Populate identifying data regardless of response
        @data['realm_slug'] = character.realm.slug

        raise Wowaudit::Exception::ApiLimitReached if check_api_limit_reached
        if check_character_api_status && !@character.marked_for_deletion_at && check_data_completeness
          update_field(@character, :status, 'tracking')
          update_field(@character, :last_status_code, 200)

          if @commit_changes
            update_field(@character, :refreshed_at, DateTime.now)
          end

          Audit::Data.process(self, @response, false, @character.realm, @character)
          HEADER[@character.realm.game_version.to_sym].each { |value| @output << (@data[value] || 0) }
          store_metadata
        else
          timeouts = @response[:status_codes].values.select { |status| status[:timeout] }.size
          http_code = @response[:status_codes].values.map { |status| status[:code] }.max

          code = http_code >= 400 ? http_code : timeouts.zero? ? 0 : 408
          update_field(@character, :status, code >= 500 ? 'temporarily_unavailable' : 'unavailable')
          update_field(@character, :last_status_code, code)
          update_field(@character, :refresh_failed_at, DateTime.now)
          raise Wowaudit::Exception::CharacterUnavailable.new(code)
        end
      end

      # Tab visibility should be handled at a later moment, when generating the JSON.
      # Since we now refresh from the character's perspective, not the team membership.
      def team_rank
        nil
      end

      def last_refresh_data
        [HEADER[@character.realm.game_version.to_sym], @output].transpose.to_h
      end

      def update_snapshots
        if @character.realm.game_version == 'live'
          current_week = @character.details['snapshots'][Audit.period.to_s] || {}

          @character.details['snapshots'][Audit.period.to_s] = current_week.merge({ 'vault' => 9.times.map do |i|
            [(i + 1).to_s, last_refresh_data["great_vault_slot_#{i + 1}"] || @data["great_vault_slot_#{i + 1}"]]
          end.to_h })

          @character.details['snapshots'][Audit.period.to_s]['wqs'] ||= @data['wqs_done_total']
          @character.details['snapshots'][Audit.period.to_s]['heroic_dungeons'] ||= @data['season_heroic_dungeons']
          @character.details['snapshots'][Audit.period.to_s]['regular_mythic_dungeons'] = [@character.details['snapshots'][Audit.period.to_s]['regular_mythic_dungeons'], @data['week_regular_mythic_dungeons']].compact.max
          @character.details['snapshots'][Audit.period.to_s]['delve_info'] ||= @delve_info
        end

        @character.details['current_version'] = CURRENT_VERSION[@character.realm.game_version.to_sym]
        @character.details['current_period'] = Audit.period
      end

      private

      def check_character_api_status
        if gdpr_deletion? && @character.gdpr_status == 'exists'
          update_field(@character, :gdpr_status, Wowaudit.failure_status)
          update_field(@character, :marked_for_deletion_at, DateTime.now)
          return false
        elsif !gdpr_deletion? && @character.gdpr_status != 'exists'
          update_field(@character, :gdpr_status, 'exists')
          update_field(@character, :marked_for_deletion_at, nil)
          return true
        end

        initial_request = @response[:status_codes][:itself] || @response[:status_codes][:status]
        initial_request[:code] == 200 && @response.class == RBattlenet::HashResult
      end

      def gdpr_deletion?
        return false if !@response[:status]
        return true if @response[:status_codes][:status][:code] == 404
        return true if @response[:status][:is_valid] == false

        profile_id = "#{@response.dig(:realm, :id)}-#{@response.dig(:status, :id)}"
        if @character.profile_id != profile_id
          if @character.realm.game_version == 'classic_era' || @character.realm.game_version == 'classic_anniversary' || @character.achievement_uid != new_achievement_uid
            create_newly_found_character(profile_id)
            return true
          else
            # In practice this only happens when a character performs a faction change. The profile ID also
            # changes with a realm transfer, but in that case the API will not return the new character
            # (since it's on a different realm).
            update_field(@character, :profile_id, profile_id)
          end
        end

        false
      end

      def create_newly_found_character(profile_id)
        (Audit::Character.first(profile_id: profile_id) || Audit::Character.new(profile_id: profile_id)).tap do |new_character|
          new_character.game_version = @character.realm.game_version
          store_metadata(new_character)
          new_character.save
        end
      end

      def check_data_completeness
        return false unless @response[:equipment] && @response[:equipment][:equipped_items]

        if @character.realm.game_version != 'classic_era' && @character.realm.game_version != 'classic_anniversary'
          return false unless @response[:achievements]&.is_a? Array
        end

        true
      end

      def new_achievement_uid
        return unless @response[:achievements]&.is_a? Array

        @achievements = @response[:achievements].group_by{ |ach| ach[:id] }.transform_values(&:first)
        uid = CHARACTER_IDENTIFICATION_IDS.sum do |achievement_id|
          @achievements[achievement_id]&.dig(:completed_timestamp) || 0
        end + @response.dig(:character_class, :id)

        uid.to_s
      end

      def check_api_limit_reached
        @response[:status_codes].values.any? { |status| status[:code] == 429 }
      end

      def store_metadata(target = @character)
        update_field(target, :guild_profile_id, ("#{@response.dig(:guild, :realm, :id)}-#{@response.dig(:guild, :id)}" if @response.dig(:guild)))
        update_field(target, :realm_id, @response.dig(:realm, :id))
        update_field(target, :race_id, @response.dig(:race, :id))
        update_field(target, :faction_id, FACTIONS.invert[@response.dig(:faction, :name)])
        update_field(target, :name, @response.dig(:name))
        update_field(target, :current_spec_id, @response.dig(:active_spec, :id))

        update_field(target, :level, @response[:level])
        if (media_zone = (@response[:media] && @response[:media][:assets].first[:value].split('/')[-2] rescue nil))
          update_field(target, :media_zone, media_zone)
        end

        update_field(target, :achievement_uid, new_achievement_uid) if new_achievement_uid

        update_snapshots

        if @commit_changes
          Wowaudit::Metadata.store(self)
        end
      end

      def update_field(entity, field, value)
        if Wowaudit.can_update_field?(entity, field) && entity.send(field) != value
          entity.send("#{field}=", value)
          @changed = true
        end
      end
    end
  end
end
