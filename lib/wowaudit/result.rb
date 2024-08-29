module Wowaudit
  class Result
    attr_accessor :output, :data, :gems, :ilvl, :character, :changed, :details

    def initialize(character, response)
      Audit.verify_details(character, character.details, character.realm)

      @output = []
      @character = character
      @details = character.details
      @response = response
      @data = {}
      @gems = []
      @ilvl = 0.0

      # Populate identifying data regardless of response
      @data['realm_slug'] = character.realm.slug

      raise Wowaudit::Exception::ApiLimitReached if check_api_limit_reached
      if check_character_api_status && !@character.marked_for_deletion_at && check_data_completeness
        Wowaudit.update_field(@character, :status, 'tracking')
        Wowaudit.update_field(@character, :refreshed_at, DateTime.now)
        Audit::Data.process(self, @response, false, @character.realm, @character)
        store_metadata

        # Ensure that the two different database records play well with each other for now...
        @character.role = @character.role.downcase
      else
        # TODO: Set status in database? What do we want to do with tiemouts?
        timeouts = @response[:status_codes].values.select { |status| status[:timeout] }.size
        code = @response[:status_codes].values.map { |status| status[:code] }.max
        raise Wowaudit::Exception::CharacterUnavailable.new(code)
      end
    end

    private

    def check_character_api_status
      if gdpr_deletion? && !@character.marked_for_deletion_at
        Wowaudit.update_field(@character, :marked_for_deletion_at, DateTime.now)
        return false
      elsif !gdpr_deletion? && @character.marked_for_deletion_at
        Wowaudit.update_field(@character, :marked_for_deletion_at, nil)
        return true
      end

      @response[:status_codes][:itself][:code] == 200 && @response.class == RBattlenet::HashResult
    end

    def gdpr_deletion?
      return false if !@response[:status]
      return true if @response[:status_codes][:status][:code] == 404
      return true unless @response[:status][:is_valid]

      if @character.uid.to_s != @response[:status][:id].to_s
        Wowaudit.update_field(@character, :uid, @response[:status][:id].to_i)
      end

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
      Wowaudit.update_field(@character, :guild_uid, @response.dig(:guild, :id))
      Wowaudit.update_field(@character, :race_id, @response.dig(:race, :id))

      Wowaudit.update_field(@character, :level, @response[:level])
      if (media_zone = (@response[:media] && @response[:media][:assets].first[:value].split('/')[-2] rescue nil))
        Wowaudit.update_field(@character, :media_zone, media_zone)
      end

      @achievements = @response[:achievements].group_by{ |ach| ach[:id] }.transform_values(&:first)
      transfer_id = CHARACTER_IDENTIFICATION_IDS.sum do |achievement_id|
        @achievements[achievement_id]&.dig(:completed_timestamp) || 0
      end + @response.dig(:character_class, :id)
      Wowaudit.update_field(@character, :transfer_id, transfer_id)
    end
  end
end
