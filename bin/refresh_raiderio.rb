require_relative('../lib/core')
teams = ARGV[0].split(',') rescue nil
Audit.refresh_raiderio(teams)
