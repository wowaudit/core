from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz
from execute_query import execute_query

start_time = time.time()
keep_going = True
while keep_going:
    guild_ids = [str(i[0]) for i in execute_query('SELECT guild_id FROM pending_changes LIMIT {0}'.format(MAX_ALLOCATED))]
    if not guild_ids:
        print 'No pending guilds. Sleeping for one minute.'
        time.sleep(60)
    else:
        print 'Refreshing {0} pending guilds.'.format(len(guild_ids))
        guilds = Scraper('production',guild_ids,start_time,'tornado')
        keep_going = guilds.run()
        execute_query('DELETE FROM pending_changes WHERE guild_id IN ({0})'.format(','.join(guild_ids)))
    if time.time() - start_time > MAXIMUM_RUNTIME: keep_going = False

print '[INFO] [{0}] - {1}. Aborting now.'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),'Reached the maximum runtime' if (time.time() - start_time >= MAXIMUM_RUNTIME) else 'Done')

