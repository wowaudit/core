module Audit
  # Compact encoding for sets of recipe ids. Ids are sorted and consecutive ids are collapsed into runs.
  # Each run is written as the base36 delta from the end of the previous run, followed by "-<base36 extra
  # length>" when the run contains more than one id. Runs are joined with ".". For example [3, 4, 5, 9]
  # becomes "3-2.4". The web frontend decodes this in TeamAudit/recipeIndex.ts.
  module RecipeIndex
    def self.encode(ids)
      previous = 0

      ids.uniq.sort.chunk_while { |a, b| b == a + 1 }.map do |run|
        token = (run.first - previous).to_s(36)
        token += "-#{(run.size - 1).to_s(36)}" if run.size > 1
        previous = run.last
        token
      end.join('.')
    end

    def self.decode(encoded)
      previous = 0

      encoded.to_s.split('.').flat_map do |token|
        delta, extra = token.split('-')
        first = previous + delta.to_i(36)
        previous = first + (extra || '0').to_i(36)
        (first..previous).to_a
      end
    end
  end
end
