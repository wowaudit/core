from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz
from writer import log

try:
    team_ids = str(sys.argv[1]).split(',')
    log('info','Not using all team IDs, but only the following: {0}'.format(', '.join(team_ids)))
except Exception:
    team_ids = False

start_time = time.time()
keep_going = True
while keep_going:
    teams = Scraper('production_platinum',team_ids,start_time,'tornado')
    keep_going = teams.run()
    if time.time() - start_time > MAXIMUM_RUNTIME or team_ids: keep_going = False

log('info','{0}. Aborting now.'.format('Reached the maximum runtime' if (time.time() - start_time >= MAXIMUM_RUNTIME) else 'Done'))

