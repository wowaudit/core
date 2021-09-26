module Wowaudit
  class DataProcessor::Reputation < DataProcessor::Base
    def add
      unless @data[:reputations].class == RBattlenet::EmptyHashResult
        REPUTATIONS[@data.dig('faction', 'name')].each do |reputation, name|
          match = @data[:reputations]['reputations'].select{ |r| r['faction']['id'] == reputation }.first

          if match
            if name == 'venari'
              @result.data["#{name}_standing"] = MAW_STANDINGS[match['standing']['tier']]
            elsif name == 'archivists_codex'
              @result.data["#{name}_standing"] = CODEX_STANDINGS[match['standing']['tier']]
            else
              @result.data["#{name}_standing"] = STANDINGS[match['standing']['tier']]
            end

            @result.data["#{name}_value"] = match['standing']['value']
          else
            @result.data["#{name}_standing"] = DEFAULT_STANDING[name] || 'Neutral'
            @result.data["#{name}_value"] = 0
          end
        end
      end

      if @achievements
        @result.data['exalted_amount'] = @achievements[12866]['criteria']['amount'] rescue 0
      end
    end
  end
end
