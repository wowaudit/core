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

if region == 'US' and datetime.datetime.weekday(datetime.datetime.now()) != 1:
    print "[INFO] [{0}] - It is not Tuesday, snapshots should not be reset for US. Aborting now.".format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'))
    sys.exit()
elif region == 'EU' and datetime.datetime.weekday(datetime.datetime.now()) != 2:
    print "[INFO] [{0}] - It is not Wednesday, snapshots should not be reset for EU. Aborting now.".format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'))
    sys.exit()
else: Scraper('snapshot_{0}'.format(region),guild_ids,start_time,'tornado').run()
