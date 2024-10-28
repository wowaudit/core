module Wowaudit
  class Result
    attr_accessor :output, :data, :gems, :ilvl, :character, :changed, :details, :stat_info, :delve_info

    def initialize(character, response)
      Audit.verify_details(character, character.details, character.realm)

      @output = []
      @character = character
      @details = character.details
      @response = response
      @data = {}
      @gems = []
      @ilvl = 0.0
      @stat_info = TRACKED_STATS.values.map { |stat| [stat, { gear: 0, enchantments: 0 }] }.to_h
      @delve_info = { total: 0, tier_1: 0, tier_2: 0, tier_3: 0, tier_4: 0, tier_5: 0, tier_6: 0, tier_7: 0, tier_8: 0, tier_9: 0, tier_10: 0, tier_11: 0 }

      # Populate identifying data regardless of response
      @data['realm_slug'] = character.realm.slug

      raise Wowaudit::Exception::ApiLimitReached if check_api_limit_reached
      if check_character_api_status && !@character.marked_for_deletion_at && check_data_completeness
        Wowaudit.update_field(@character, :status, 'tracking')
        Wowaudit.update_field(@character, :refreshed_at, DateTime.now)
        Audit::Data.process(self, @response, false, @character.realm, @character)
        HEADER[@character.realm.game_version.to_sym].each { |value| @output << (@data[value] || 0) }
        store_metadata

        # Ensure that the two different database records play well with each other for now...
        @character.role = @character.role.downcase
      else
        # TODO: Set status in database? What do we want to do with tiemouts?
        # timeouts = @response[:status_codes].values.select { |status| status[:timeout] }.size
        code = @response[:status_codes].values.map { |status| status[:code] }.max
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

    def metadata
      {
        _key: @character.id.to_s,
        character_id: @character.id,
        timestamp: (last_refresh_data || {})['blizzard_last_modified'],
        max_ilvl: @details['max_ilvl'],
        current_period: @details['current_period'],
        current_version: @details['current_version'],
        last_refresh: last_refresh_data,
        current_gear: @details['current_gear'],
      }.merge(@character.realm.game_version == 'live' ? {
        best_gear: @details['best_gear'],
        spark_gear_s1: @details['spark_gear_s1'],
        keystones: @details['keystones'],
        snapshots: @details["snapshots"],
        warcraftlogs: @details["warcraftlogs"],
        raiderio: @details["raiderio"],
        tier_items_s1: @details["tier_items_s1"],
      } : {})
    end

    def update_snapshots
      if @character.realm.game_version == 'live'
        current_week = @character.details['snapshots'][Audit.period.to_s] || {}

        @character.details['snapshots'][Audit.period.to_s] = current_week.merge({ 'vault' => 9.times.map do |i|
          [(i + 1).to_s, last_refresh_data["great_vault_slot_#{i + 1}"] || @data["great_vault_slot_#{i + 1}"]]
        end.to_h })

        @character.details['snapshots'][Audit.period.to_s]['wqs'] ||= @data['wqs_done_total']
        @character.details['snapshots'][Audit.period.to_s]['heroic_dungeons'] ||= @data['season_heroic_dungeons']
        @character.details['snapshots'][Audit.period.to_s]['delve_info'] ||= @delve_info
      end

      @character.details['current_version'] = CURRENT_VERSION[@character.realm.game_version.to_sym]
      @character.details['current_period'] = Audit.period
    end

    private

    def check_character_api_status
      if gdpr_deletion? && !@character.marked_for_deletion_at
        Wowaudit.update_field(@character, :exists, false)
        Wowaudit.update_field(@character, :marked_for_deletion_at, DateTime.now)
        return false
      elsif !gdpr_deletion? && @character.marked_for_deletion_at
        Wowaudit.update_field(@character, :exists, true)
        Wowaudit.update_field(@character, :marked_for_deletion_at, nil)
        return true
      end

      @response[:status_codes][:itself][:code] == 200 && @response.class == RBattlenet::HashResult
    end

    def gdpr_deletion?
      return false if !@response[:status]
      return true if @response[:status_codes][:status][:code] == 404
      return true unless @response[:status][:is_valid]

      # TODO: Allow this, but only after comparing the achievement_uid of the new data with the old
      # if @character.profile_id.to_s != @response[:status][:id].to_s
      #   Wowaudit.update_field(@character, :profile_id, @response[:status][:id].to_i)
      # end

      false
    end

    def check_data_completeness
      return false unless @response[:equipment] && @response[:equipment][:equipped_items]

      if @character.realm.kind != 'classic_era' && (Wowaudit.extended || Wowaudit.extra_fields.include?(:achievements))
        return false unless @response[:achievements]&.is_a? Array
      end

      true
    end

    def check_api_limit_reached
      @response[:status_codes].values.any? { |status| status[:code] == 429 }
    end

    def store_metadata
      Wowaudit.update_field(@character, :guild_profile_id, "#{@response.dig(:guild, :realm, :id)}-#{@response.dig(:guild, :id)}")
      Wowaudit.update_field(@character, :race_id, @response.dig(:race, :id))

      Wowaudit.update_field(@character, :level, @response[:level])
      if (media_zone = (@response[:media] && @response[:media][:assets].first[:value].split('/')[-2] rescue nil))
        Wowaudit.update_field(@character, :media_zone, media_zone)
      end

      @achievements = @response[:achievements].group_by{ |ach| ach[:id] }.transform_values(&:first)
      achievement_uid = CHARACTER_IDENTIFICATION_IDS.sum do |achievement_id|
        @achievements[achievement_id]&.dig(:completed_timestamp) || 0
      end + @response.dig(:character_class, :id)
      Wowaudit.update_field(@character, :achievement_uid, achievement_uid)

      update_snapshots
      Wowaudit::Metadata.store(self)
    end
  end
end
