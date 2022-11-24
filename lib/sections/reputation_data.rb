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

      @character.data["total_renown_score"] = rand(0..100)

      @character.data["dragonscale_expedition_renown"] = rand(0..25)
      @character.data["maruuk_centaur_renown"] = rand(0..20)
      @character.data["iskaara_tuskarr_renown"] = rand(0..30)
      @character.data["valdrakken_accord_renown"] = rand(0..30)

      if @achievements
        @character.data['exalted_amount'] = @achievements[12866]['criteria']['amount'] rescue 0
      end
    end
  end
end
