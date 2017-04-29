# -*- coding: utf-8 -*-
from guild import Guild
from execute_query import execute_query
from constants import *
from dateutil import tz
from auth import WCL_KEY
from json import loads
from writer import log, error
import time, requests, datetime

class Scraper(object):

    def __init__(self,mode,ids=False,start_time=time.time(),client='tornado'):
        self.guilds = []
        self.done = {}
        self.mode = mode
        self.client = client
        self.ids = ids
        self.start_time = start_time
        self.fetch_select(self.ids) if self.ids else self.allocate()

    def fetch_select(self,guilds):
        data = execute_query('SELECT guilds.guild_id, guilds.name, guilds.region, guilds.realm, guilds.key_code, guilds.last_checked, guilds.patreon, users.user_id, users.name, users.role, users.weekly_snapshot ' + \
                             ', users.legendaries, users.realm, users.per_spec, users.tier_data, users.status, users.warcraftlogs, users.last_refresh, users.old_snapshots FROM guilds, users WHERE guilds.guild_id = users.guild_id AND users.guild_id IN ({0})'.format(','.join(guilds)))
        self.store(data)

    def allocate(self):
        result = execute_query('SELECT guild_id, last_checked{0} FROM guilds WHERE patreon {1} {2} ORDER BY last_checked{0} ASC LIMIT {3}'.format('_wcl' if self.mode == 'warcraftlogs' else '','= 1' if self.mode == 'production_patreon' else 'IN (0,1)', 'AND last_checked > 0' if self.mode == 'debug' else '', MAX_ALLOCATED))

        guild_data = [str(guild[0]) for guild in result]
        last_refreshed = [int(guild[1]) for guild in result]
        if self.mode in ['production','production_patreon','warcraftlogs']:
            execute_query('UPDATE guilds SET last_checked{0} = {1} WHERE guild_id IN ({2})'.format('_wcl' if self.mode == 'warcraftlogs' else '',(datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds(),','.join(guild_data)))

        log('info','Allocated and going to refresh {0} guilds. Time since last refresh: Lowest {1} seconds, Highest {2} seconds, Average {3} seconds.'.format(
            MAX_ALLOCATED,
            round((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds()-max(last_refreshed),0),
            round((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds()-min(last_refreshed),0),
            round((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds()-(sum(last_refreshed) / float(len(last_refreshed))),0)),
            ', '.join(guild_data))

        self.fetch_select(guild_data)

    def store(self,data):
        count = 0
        for member in data:
            key_code = member[4]
            if key_code not in self.done:
                self.guilds.append(Guild(member,self.mode,self.client))
                self.done[key_code] = count
                count += 1
            else: self.guilds[self.done[key_code]].add_member(member)

    def run(self):
        return self.check_all()

    def check_all(self):
        if self.ids: return self.check_select()
        for guild in self.guilds:
            self.check_single(guild)
        return True

    def check_select(self):
        for guild in self.guilds:
            if str(guild.guild_id) in self.ids:
                self.check_single(guild)
        return True

    def check_single(self,guild,retry=False):
        try:
            guild.check()
            log('info','Finished refreshing.',guild.guild_id)
        except Exception as e:
            if not retry:
                guild.client = 'concurrent' if guild.client == 'tornado' else 'tornado'
                log('error','Encountered an error, trying with client {0} now. Error: {1}'.format(guild.client,error(e)),guild.guild_id)
                self.check_single(guild,True)
            else:
                log('error','Encountered an error, did not refresh. Error: {0}'.format(error(e)),guild.guild_id)

    def check_warcraftlogs(self):
        for guild in self.guilds:
            try:
                guild.update_warcraftlogs()
                log('info','Finished refreshing this guild.',guild.guild_id)
            except Exception as e:
                log('error','Encountered an error in refreshing the WCL data of this guild. Error: {0}'.format(error(e)),guild.guild_id)
        return True
