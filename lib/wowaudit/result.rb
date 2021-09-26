module Wowaudit
  class Result
    attr_accessor :output, :data, :gems, :ilvl, :character

    def initialize(character, response)
      @output = []
      @character = character
      @response = response
      @data = character.details&.dig('last_refresh') || {}

      # Populate identifying data regardless of response
      @data['name'] = character.name
      @data['realm'] = character.realm.name
      @data['realm_slug'] = character.realm.slug

      # Variables for gear data
      @gems = []
      @ilvl = 0.0

      raise ApiLimitReachedException if [429, { status_code: 429 }].include?(@response[:status_code])
      if character_available? && check_data_completeness
        Wowaudit.update_field(@character, :tracking, true)
        DataProcessor.process(self, @response)
      else
        # TODO: Set status in database?
        raise CharacterUnavailableException.new(@response[:status_code])
      end
    end

    private

    def character_available?
      if Wowaudit.extended
        if gdpr_deletion?(@response) && !character.marked_for_deletion_at
          Wowaudit.update_field(@character, :marked_for_deletion_at, DateTime.now)
          return false
        elsif !gdpr_deletion?(@response) && character.marked_for_deletion_at
          Wowaudit.update_field(@character, :marked_for_deletion_at, nil)
          return true
        end
      end

      @response[:status_code] == 200 && @response.class == RBattlenet::HashResult
    end

    def gdpr_deletion?
      return false if !@response[:status]
      raise ApiLimitReachedException if @response[:status][:status_code] == 429
      return true if @response[:status][:status_code] == 404
      return true unless @response[:status]['is_valid']
      false
    end

    def check_data_completeness
      if Wowaudit.extended
        [:achievements, :pets, :mounts, :reputations, :equipment].each do |type|
          raise ApiLimitReachedException if @response.dig(type, :status_code) == 429
          return false unless @response[type] && @response[type][type == :equipment ? 'equipped_items' : type.to_s]
        end

        true
      else
        raise ApiLimitReachedException if @response.dig(:equipment, :status_code) == 429
        @response[:equipment] && @response[:equipment]['equipped_items']
      end
    end
  end
end
