from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz
from writer import log

try:
    guild_ids = str(sys.argv[1]).split(',')
    log('info','Not using all guild IDs, but only the following: {0}'.format(', '.join(guild_ids)))
except Exception:
    guild_ids = False

start_time = time.time()
keep_going = True
while keep_going:
    guilds = Scraper('warcraftlogs',guild_ids,start_time,'tornado')
    keep_going = guilds.check_warcraftlogs()
    if time.time() - start_time > MAXIMUM_RUNTIME or guild_ids: keep_going = False

log('info','{0}. Aborting now.'.format('Reached the maximum runtime' if (time.time() - start_time >= MAXIMUM_RUNTIME) else 'Done'))

