require_relative('../lib/core')
instance_name = "bnet-regular-1" #`hostname`.strip
Audit.refresh_from_schedule(instance_name)
