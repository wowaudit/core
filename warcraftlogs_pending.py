from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz
from execute_query import execute_query
from writer import log

start_time = time.time()
keep_going = True
while keep_going:
    team_ids = [str(i[0]) for i in execute_query('SELECT team_id FROM pending_changes_wcl LIMIT {0}'.format(MAX_ALLOCATED))]
    if not team_ids:
        log('info','No pending teams. Sleeping for one minute.')
        time.sleep(60)
    else:
        teams = Scraper('warcraftlogs',team_ids,start_time,'tornado')
        keep_going = teams.check_warcraftlogs(True)
        execute_query('DELETE FROM pending_changes_wcl WHERE team_id IN ({0})'.format(','.join(team_ids)))
    if time.time() - start_time > MAXIMUM_RUNTIME: keep_going = False

log('info','{0}. Aborting now.'.format('Reached the maximum runtime' if (time.time() - start_time >= MAXIMUM_RUNTIME) else 'Done'))

