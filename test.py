from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz
from writer import log
from pympler.tracker import SummaryTracker, muppy, summary
tracker = SummaryTracker()

try:
    team_ids = str(sys.argv[1]).split(',')
    log('info','Not using all team IDs, but only the following: {0}'.format(', '.join(team_ids)))
except Exception:
    team_ids = False

start_time = time.time()
while True:
    Scraper('debug',team_ids,start_time,'tornado').run()
    sum1 = summary.summarize(muppy.get_objects())
    summary.print_(sum1)
    tracker.print_diff()
    print 'Amount of objects in memory: {0}'.format(len(muppy.get_objects()))
