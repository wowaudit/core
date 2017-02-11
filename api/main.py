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
    mode = 'debug'
    print 'No mode selected. Running in debug mode.'

try:
    guild_ids = str(sys.argv[2]).split(',')
    print 'Going to cycle through the following guild IDs: {0}'.format(','.join(guild_ids))
except Exception:
    guild_ids = False

start_time = time.time()
keep_going = True
while keep_going:
    step_time = time.time()
    guilds = Scraper(mode,guild_ids,start_time)
    keep_going = guilds.check_all()
    if time.time() - step_time < CYCLE_MINIMUM and keep_going:
        sleep_duration = 3 + CYCLE_MINIMUM - (time.time() - step_time)

        if (time.time() + sleep_duration) - start_time < MAXIMUM_RUNTIME:
            print 'Completed a full cycle faster than the minimum set time. Going to sleep for {0} seconds.'.format(round(sleep_duration,1))
            time.sleep(sleep_duration)
        else: keep_going = False
    if DEBUG_MODE == 'debug':
        keep_going = True

print 'Reached the maximum runtime. Aborting now.'
