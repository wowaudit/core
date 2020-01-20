TYPE = ARGV[0] || "essentials"
require_relative('../lib/core')
Audit.refresh_from_schedule(TYPE)
