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
while True:
    Scraper('debug',guild_ids,start_time,'tornado').run()