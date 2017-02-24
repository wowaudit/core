# -*- coding: utf-8 -*-
from constants import *
import sys, time, datetime
from scraper import Scraper
from dateutil import tz

try:
    mode = str(sys.argv[1])
    if mode not in MODES:
        raise Exception
    print '[INFO] [{0}] - Going to run in {1} mode'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),mode)
    if mode == 'snapshot_US' and datetime.datetime.weekday(datetime.datetime.now()) != 1:
        print "[INFO] [{0}] - It is not Tuesday, snapshots should not be reset for US. Aborting now.".format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'))
        sys.exit()
    if mode == 'snapshot_EU' and datetime.datetime.weekday(datetime.datetime.now()) != 2:
        print "[INFO] [{0}] - It is not Wednesday, snapshots should not be reset for EU. Aborting now.".format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'))
        sys.exit()

except Exception:
    mode = MODES[0]
    print '[INFO] [{0}] - No mode defined, going to run in {1} mode'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),mode)


try:
    amount = str(sys.argv[2])
    if amount != 'single' and amount != 'multi':
        amount = 'multi'
except Exception:
    amount = 'multi'

if mode in ['production','production_patreon']:
    if amount == 'single':
        print '[INFO] [{0}] - Going to run for one cycle, or until {1} seconds has passed'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),MAXIMUM_RUNTIME)
    else:
        print '[INFO] [{0}] - Cycling through guilds until {1} seconds has passed'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),MAXIMUM_RUNTIME)

try:
    guild_ids = str(sys.argv[3]).split(',')
    print '[INFO] [{0}] - Not using all guild IDs, but only the following: {1}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),', '.join(guild_ids))
except Exception:
    guild_ids = False

start_time = time.time()
keep_going = True
sleep_duration = 0
while keep_going:
    step_time = time.time()
    guilds = Scraper(mode,guild_ids,start_time)
    keep_going = guilds.run()

    if time.time() - step_time < CYCLE_MINIMUM and keep_going:
        sleep_duration = 3 + CYCLE_MINIMUM - (time.time() - step_time)

        if (time.time() + sleep_duration) - start_time < MAXIMUM_RUNTIME and amount == 'multi':
            print '[INFO] [{0}] - Full cycle complete faster than the minimum cycle time. Going to sleep for {1} seconds'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),round(sleep_duration,1))

            time.sleep(sleep_duration)
        else: keep_going = False
    if mode == 'debug': keep_going = True
    if amount == 'single' or mode in ['snapshot_US','snapshot_EU']: keep_going = False

print '[INFO] [{0}] - {1}. Aborting now.'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),'Reached the maximum runtime' if (time.time() + sleep_duration) - start_time >= MAXIMUM_RUNTIME else 'Done')

