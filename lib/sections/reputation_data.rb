module Audit
  class ReputationData

    def self.add(character, data)
      reps = {}
      rep_value = 0
      exalted_rep_amount = 0

      REPUTATIONS.each do |reputation, name|
        match = false

        data['reputation'].each do |rep_data|
          exalted_rep_amount += 1 if rep_data['standing'] == 7

          if rep_data['id'] == reputation
            # Exalted level value is always 0 since patch 7.2
            # Still passing 999 as the value because the spreadsheet
            # assumes it's the maximum for Exalted level reputations
            character.data["#{name}_standing"] =
              STANDINGS[rep_data['standing']]

            character.data["#{name}_value"] =
              rep_data['standing'] == 7 ? 999 : rep_data['value']

            rep_value += ( ( rep_data['standing'] - 2 ) +
                           ( rep_data['value'].to_f /
                            REP_AMOUNT[rep_data['standing']].to_f ) )
            match = true
          end
        end

        if not match
          character.data["#{name}_standing"] = 'Neutral'
          character.data["#{name}_value"] = 0
        end
      end

      character.data['reputation_ranking'] = rep_value #Deprecated
      character.data['exalted_amount'] = exalted_rep_amount / REPUTATIONS.length
    end
  end
end
