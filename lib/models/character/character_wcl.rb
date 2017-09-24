module Audit
  class CharacterWcl < Character

    def process_result(response, output)
      if response.code == 200
        data = JSON.parse response.body
        if data.empty? or (data["hidden"] rescue false)
          self.changed = false
        else
          output = parse_result(data, output)
          self.changed = true
        end
      elsif response.code == 403 or response.code == 429
        raise ApiLimitReachedException
      else
        Logger.c(ERROR_CHARACTER + "Response code: #{response.code}", id)
        self.changed = false
      end
      output
    end

    def parse_result(data, output)
      output[:character_id] = data[0]['specs'][0]['data'][0]['character_id']

      data.reject{ |encounter| encounter['difficulty'] < 3 }.each do |encounter|
        encounter['specs'].each do |spec|
          if spec['spec'][0..3] == self.role[0..3] || ROLES_TO_SPEC[self.role].include?(spec['spec'])
            output[encounter['difficulty']][encounter['name']].merge!({
              'best' => spec['best_historical_percent'],
              'median' => spec['historical_median'],
              'average' => spec['historical_avg']
            })
            break
          end rescue nil
        end
      end
      transform(output)
    end

    def transform(output)
      transformed_output = Marshal.load(Marshal.dump(WCL_METRICS))
      transformed_output[:character_id] = output[:character_id]

      index = 0
      VALID_RAIDS.each do |raid|
        raid['encounters'].each do |encounter|
          WCL_METRICS.each_key do |metric|
            type, difficulty = metric.split("_")
            transformed_output[metric].push(
              verify(metric, index, output[difficulty.to_i][encounter['name']][type]))
          end
          index += 1
        end
      end
      transformed_output
    end

    def verify(metric, index, value)
      (value == "-" ? self.wcl_parsed[metric][index] : value.round) rescue value
    end

    def wcl_role
      role == "Heal" ? "hps" : "dps"
    end
  end
end

