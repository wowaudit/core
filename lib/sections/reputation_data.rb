module Audit
  class ReputationData < Data
    def add
      unless @data[:reputations].class == RBattlenet::EmptyHashResult
        REPUTATIONS[@data.dig('faction', 'name')].each do |reputation, name|
          match = @data[:reputations]['reputations'].select{ |r| r['faction']['id'] == reputation }.first
          if match
            @character.data["#{name}_standing"] = STANDINGS[match['standing']['tier']]
            @character.data["#{name}_value"] = match['standing']['value']
          else
            @character.data["#{name}_standing"] = 'Neutral'
            @character.data["#{name}_value"] = 0
          end
        end
      end

      if @achievements
        @character.data['exalted_amount'] = @achievements[12866]['criteria']['amount'] rescue 0
      end
    end
  end
end
