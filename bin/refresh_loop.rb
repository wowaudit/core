REGISTER = true
TYPE = ARGV[0] || "blizzard"
require_relative('../lib/core')
Wowaudit::Metrics.install!(TYPE)

begin
  Audit.refresh_from_schedule(TYPE)
rescue => e
  Sentry.capture_exception(e)
  raise
end
