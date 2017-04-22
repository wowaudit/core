from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz

try:
    guild_ids = str(sys.argv[1]).split(',')
    print '[INFO] [{0}] - Not using all guild IDs, but only the following: {1}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),', '.join(guild_ids))
except Exception:
    guild_ids = False

start_time = time.time()
keep_going = True
while keep_going:
    guilds = Scraper('warcraftlogs',guild_ids,start_time,'tornado')
    keep_going = guilds.check_warcraftlogs()
    if time.time() - start_time > MAXIMUM_RUNTIME or guild_ids: keep_going = False

print '[INFO] [{0}] - {1}. Aborting now.'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),'Reached the maximum runtime' if (time.time() - start_time >= MAXIMUM_RUNTIME) else 'Done')

