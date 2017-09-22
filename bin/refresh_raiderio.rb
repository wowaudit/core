require_relative('../lib/core')
teams = ARGV[0].split(',') rescue nil
instance_name = `hostname`.strip
Audit.refresh_without_schedule(instance_name, teams)
