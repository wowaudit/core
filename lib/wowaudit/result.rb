module Wowaudit
  class Result
    attr_accessor :output, :data, :gems, :ilvl, :character

    def initialize(character, response)
      @output = []
      @character = character
      @response = response
      @data = {}

      # Populate identifying data regardless of response
      @data['name'] = character.name
      @data['realm'] = character.realm.name
      @data['realm_slug'] = character.realm.slug

      # Variables for gear data
      @gems = []
      @ilvl = 0.0

      raise Wowaudit::Exception::ApiLimitReached if check_api_limit_reached
      if character_available? && check_data_completeness
        Wowaudit.update_field(@character, :status, 'tracking')
        Wowaudit.update_field(@character, :refreshed_at, DateTime.now)
        DataProcessor::Base.process(self, @response)
      else
        # TODO: Set status in database? What do we want to do with tiemouts?
        timeouts = @response.values.map { | v| v.dig(:timeout) if v.is_a? Hash }.compact.count(&:itself)
        raise Wowaudit::Exception::CharacterUnavailable.new(@response[:status_code])
      end
    end

    private

    def character_available?
      if Wowaudit.extended
        if gdpr_deletion? && !character.marked_for_deletion_at
          Wowaudit.update_field(@character, :marked_for_deletion_at, DateTime.now)
          return false
        elsif !gdpr_deletion? && character.marked_for_deletion_at
          Wowaudit.update_field(@character, :marked_for_deletion_at, nil)
          return true
        end
      end

      @response[:status_code] == 200 && @response.class == RBattlenet::HashResult
    end

    def gdpr_deletion?
      return false if !@response[:status]
      raise Wowaudit::Exception::ApiLimitReached if @response[:status][:status_code] == 429
      return true if @response[:status][:status_code] == 404
      return true unless @response[:status]['is_valid']
      false
    end

    def check_data_completeness
      if Wowaudit.extended
        [:achievements, :pets, :mounts, :reputations, :equipment].each do |type|
          raise Wowaudit::Exception::ApiLimitReached if @response.dig(type, :status_code) == 429
          return false unless @response[type] && @response[type][type == :equipment ? 'equipped_items' : type.to_s]
        end

        true
      else
        raise Wowaudit::Exception::ApiLimitReached if @response.dig(:equipment, :status_code) == 429
        @response[:equipment] && @response[:equipment]['equipped_items']
      end
    end

    def check_api_limit_reached
      @response[:status_code] == 429 || @response.values.any? { |v| v.respond_to?(:dig) && v[:status_code] == 429 }
    end
  end
end
