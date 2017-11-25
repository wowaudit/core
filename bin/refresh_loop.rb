require_relative('../lib/core')
instance_name = ARGV[0] rescue nil
if instance_name
  Audit.refresh_from_schedule(instance_name)
