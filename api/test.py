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
while True:
    Scraper('debug',guild_ids,start_time,'tornado').run()
