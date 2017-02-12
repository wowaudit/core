# -*- coding: utf-8 -*-
from constants import *
import sys, time
from scraper import Scraper

try:
    mode = str(sys.argv[1])
    if mode not in MODES:
        raise Exception
    print "Running in {0} mode.".format(mode)
except Exception:
    mode = MODES[0]
    print 'No mode selected. Running in {0} mode.'.format(mode)

try:
    amount = str(sys.argv[2])
    if amount != 'single' and amount != 'multi':
        amount = 'multi'
except Exception:
    amount = 'multi'
if amount == 'single': print 'Going to run for only a single cycle'
else: print 'Going to keep cycling through guilds for {0} seconds'.format(MAXIMUM_RUNTIME)

try:
    guild_ids = str(sys.argv[3]).split(',')
    print 'Going to use only the following guild IDs: {0}'.format(','.join(guild_ids))
except Exception:
    guild_ids = False

start_time = time.time()
keep_going = True
sleep_duration = 0
while keep_going:
    step_time = time.time()
    guilds = Scraper(mode,guild_ids,start_time)
    keep_going = guilds.check_all()
    if time.time() - step_time < CYCLE_MINIMUM and keep_going:
        sleep_duration = 3 + CYCLE_MINIMUM - (time.time() - step_time)

        if (time.time() + sleep_duration) - start_time < MAXIMUM_RUNTIME and amount == 'multi':
            print 'Completed a full cycle faster than the minimum set time. Going to sleep for {0} seconds.'.format(round(sleep_duration,1))
            time.sleep(sleep_duration)
        else: keep_going = False
    if mode == 'debug': keep_going = True
    if amount == 'single': keep_going = False

print '{0}. Aborting now.'.format('Reached the maximum runtime' if (time.time() + sleep_duration) - start_time >= MAXIMUM_RUNTIME else 'Done')
