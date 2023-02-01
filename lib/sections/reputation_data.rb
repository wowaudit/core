module Audit
  class ReputationData < Data
    def add
      total_renown = 0

      unless @data[:reputations].class == RBattlenet::EmptyHashResult
        REPUTATIONS.each do |reputation, name|
          match = @data[:reputations]['reputations'].select{ |r| r[F_FACTION][F_ID] == reputation }.first

          if match
            total_renown += (match.dig('standing', 'raw') || 0)
            @character.data["#{name}_renown"] = match.dig('standing', 'renown_level')
          else
            @character.data["#{name}_renown"] = 0
          end
        end
      end

      @character.data['total_renown_score'] = total_renown

      if @achievements
        @character.data['exalted_amount'] = @achievements[12866]['criteria']['amount'] rescue 0
      end
    end
  end
end
