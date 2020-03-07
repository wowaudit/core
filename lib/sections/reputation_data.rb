module Audit
  class ReputationData < Data
    def add
      reps = {}

      REPUTATIONS[FACTIONS[@data.legacy.faction]].each do |reputation, name|
        match = @data.legacy.reputation.select{ |r| r.id == reputation }.first
        if match
          @character.data["#{name}_standing"] = STANDINGS[match.standing]
          @character.data["#{name}_value"] = match.value
        else
          @character.data["#{name}_standing"] = 'Neutral'
          @character.data["#{name}_value"] = 0
        end
      end

      @character.data['exalted_amount'] =
        @data.legacy.achievements.criteriaQuantity[@data.legacy.achievements.criteria.index(982)] rescue 0
    end
  end
end
