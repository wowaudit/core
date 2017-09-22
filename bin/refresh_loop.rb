require_relative('../lib/core')
instance_name = `hostname`.strip
Audit.refresh_from_schedule(instance_name)
