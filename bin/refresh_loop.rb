REGISTER = true
TYPE = ARGV[0] || "blizzard"
require_relative('../lib/core')
Wowaudit::Metrics.install!(TYPE)
Audit.refresh_from_schedule(TYPE)
