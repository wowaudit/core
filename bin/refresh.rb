require_relative('../lib/core')
instance_name = `hostname`.strip
Audit.refresh(ARGV[0].split(','), instance_name.split('-').first)
