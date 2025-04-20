module Audit
  module Live
    class ReputationData < Data
      def add
        total_renown = 0

        unless !@data[:reputations]
          REPUTATIONS.each do |reputation, name|
            match = (@data[:reputations].lazy.select{ |r| r&.dig(:faction,:id) == reputation }.first rescue nil)

            if match
              total_renown += (match.dig(:standing, :raw) || 0)
              @character.data["#{name}_renown"] = match.dig(:standing, :renown_level)
            else
              @character.data["#{name}_renown"] = 0
            end
          end
        end

        @character.data['total_renown_score'] = total_renown

        if @achievements
          @character.data['exalted_amount'] = @achievements[12866][:criteria][:amount] rescue 0
        end
      end
    end
  end
end
