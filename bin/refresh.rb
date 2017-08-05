require_relative('../lib/core')
instance_name = "bnet-regular-1" #`hostname`.strip
Audit.refresh(ARGV[0].split(','), instance_name.split('-').first)
