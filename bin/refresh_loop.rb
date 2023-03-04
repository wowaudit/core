REGISTER = true
TYPE = ARGV[0] || "blizzard"
require_relative('../lib/core')
Audit.refresh_from_schedule(TYPE)
