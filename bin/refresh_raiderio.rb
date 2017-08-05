require_relative('../lib/core')
teams = ARGV[0].split(',') rescue nil
instance_name = "raiderio-regular-1" #`hostname`.strip
Audit.refresh_without_schedule(instance_name, teams)
