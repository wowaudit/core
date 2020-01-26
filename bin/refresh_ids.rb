REGISTER = false
TYPE = ARGV[1] || "essentials"
require_relative('../lib/core')
Audit.refresh_without_schedule(TYPE, ARGV[0].split(","))
