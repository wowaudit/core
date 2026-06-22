REGISTER = true
TYPE = ARGV[0] || "blizzard"
require_relative('../lib/core')
require_relative('../lib/wowaudit/metrics')
Wowaudit::Metrics.install! if TYPE == "blizzard"
Audit.refresh_from_schedule(TYPE)
