from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz
from json import loads, dumps
from execute_query import execute_query

def reset_m_data(region,team_ids=False):
    if region:
        m_data = execute_query('SELECT id, warcraftlogs FROM characters WHERE team_id IN (SELECT id from teams WHERE guild_id IN (SELECT id FROM guilds WHERE region = \'{0}\'))'.format(region))
    elif team_ids:
        m_data = execute_query('SELECT id, warcraftlogs FROM characters WHERE team_id IN ({0})'.format(','.join(team_ids)))
    else:
        m_data = False
    count = 0
    if m_data:
        base_spec_query = 'UPDATE characters SET warcraftlogs = CASE '
        for character in m_data:
            try: data = loads(character[1])
            except: data = False
            if data:
                try: data['weekly_highest_m'] = 0
                except: pass
                base_spec_query += 'WHEN id = {0} THEN \'{1}\' '.format(character[0],dumps(data).replace("'","\\'"))
                count += 1
                if count > 1000:
                    execute_query(base_spec_query + ' ELSE warcraftlogs END',False)
                    base_spec_query = 'UPDATE characters SET warcraftlogs = CASE '
                    count = 0
        execute_query(base_spec_query + ' ELSE warcraftlogs END',False)

try:
    region = str(sys.argv[1])
    if region not in ['EU','US','TW','KR']: raise Exception
    print '[INFO] [{0}] - Going to reset the snapshot of region {1}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),region)
except Exception:
    print 'Please specify a valid region.'
    sys.exit()

try:
    team_ids = str(sys.argv[2]).split(',')
    print '[INFO] [{0}] - Not using all team IDs, but only the following: {1}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),', '.join(team_ids))
except Exception:
    team_ids = False

if team_ids:
    execute_query('UPDATE characters SET weekly_snapshot = \'\' WHERE team_id IN ({0})'.format(','.join(team_ids)))
    print '[INFO] [{0}] - Snapshot resetted successfully for teams {1}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),','.join(team_ids)   )
    reset_m_data(False, team_ids)
else:
    if region == 'US' and datetime.datetime.weekday(datetime.datetime.now()) != 1:
        print "[INFO] [{0}] - It is not Tuesday, snapshots should not be reset for US. Aborting now.".format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'))
        sys.exit()
    elif region == 'EU' and datetime.datetime.weekday(datetime.datetime.now()) != 2:
        print "[INFO] [{0}] - It is not Wednesday, snapshots should not be reset for EU. Aborting now.".format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'))
        sys.exit()
    elif region == 'KR' and datetime.datetime.weekday(datetime.datetime.now()) != 3:
        print "[INFO] [{0}] - It is not Thursday, snapshots should not be reset for KR. Aborting now.".format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'))
        sys.exit()
    elif region == 'TW' and datetime.datetime.weekday(datetime.datetime.now()) != 3:
        print "[INFO] [{0}] - It is not Thursday, snapshots should not be reset for TW. Aborting now.".format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'))
        sys.exit()
    else:
        execute_query('UPDATE characters SET weekly_snapshot = \'\' WHERE team_id IN (SELECT id from teams WHERE guild_id IN (SELECT id FROM guilds WHERE region = \'{0}\'))'.format(region))
        print '[INFO] [{0}] - Snapshot resetted successfully of region {1}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),region)
        reset_m_data(region)
