module Audit
  class ReputationData < Data
    def add
      total_renown = 0

      unless @data[:reputations].class == RBattlenet::EmptyHashResult
        REPUTATIONS.each do |reputation, name|
          match = @data[:reputations]['reputations'].select{ |r| r['faction']['id'] == reputation }.first

          if match
            total_renown += 0
            @character.data["#{name}_renown"] = 0 # TODO
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
