module Audit
  class CharacterHonor < Character

    def process_result(response)
      if response.code == 200
        # Hacky solution to find the actual honor level, hopefully it's temporary
        # until Blizzard decides to expose the data in the official API
        details["honor_level"] =
          response.body.split('text-upper">Level ')[1].split('</div>')[0] rescue honor_level
      else
        Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", id)
      end
    end

    def update
      {
        _key: id.to_s,
        honor_level: details["honor_level"].to_i
      }
    end

    def honor_level
      details["honor_level"] || 0
    end
  end
end
