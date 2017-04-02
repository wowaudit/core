from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz

try:
    region = str(sys.argv[1])
    if region not in ['EU','US']: raise Exception
    print '[INFO] [{0}] - Going to reset the snapshot of region {1}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),region)
except Exception:
    print 'Please specify a valid region.'
    sys.exit()

Scraper('snapshot_{0}'.format(region),guild_ids,start_time,'tornado').run()
