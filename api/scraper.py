# -*- coding: utf-8 -*-
from guild import Guild
from execute_query import execute_query
from constants import *
from dateutil import tz
from auth import WCL_KEY
from json import loads
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
        data = execute_query('SELECT guilds.guild_id, guilds.name, guilds.region, guilds.realm, guilds.key_code, guilds.last_checked, users.user_id, users.name, users.role, users.weekly_snapshot ' + \
                             ', users.legendaries, users.realm, users.per_spec, users.tier_data, users.status, users.warcraftlogs, users.last_refresh FROM guilds, users WHERE guilds.guild_id = users.guild_id AND users.guild_id IN ({0})'.format(','.join(guilds)))
        self.store(data)

    def allocate(self):
        allocations = MAX_ALLOCATED if self.mode not in ['snapshot_EU','snapshot_US','warcraftlogs'] else 1000000
        guild_data = [str(guild[0]) for guild in execute_query('SELECT guild_id FROM guilds WHERE patreon = {0} {1} ORDER BY last_checked ASC LIMIT {2}'.format(1 if self.mode == 'production_patreon' else 'patreon', 'AND last_checked > 0' if self.mode == 'debug' else '', allocations))]

        if self.mode in ['production','production_patreon']:
            execute_query('UPDATE guilds SET last_checked = {0} WHERE guild_id IN ({1})'.format((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds(),','.join(guild_data)))

        self.fetch_select(guild_data)

    def store(self,data):
        count = 0
        for member in data:
            key_code = member[4]
            if key_code not in self.done:
                if self.mode == 'snapshot_EU':
                    self.guilds.append(Guild(member,self.mode,self.client,'EU'))
                elif self.mode == 'snapshot_US':
                    self.guilds.append(Guild(member,self.mode,self.client,'US'))
                else:
                    self.guilds.append(Guild(member,self.mode,self.client,))
                self.done[key_code] = count
                count += 1
            else: self.guilds[self.done[key_code]].add_member(member)

    def run(self):
        if self.mode in ['debug','production','production_patreon']:
            return self.check_all()

        if self.mode in ['snapshot_EU','snapshot_US']:
            execute_query('UPDATE users SET weekly_snapshot = \'\' WHERE guild_id IN (SELECT guild_id from guilds WHERE region = \'{0}\')'.format(self.mode.split("_")[1]))
            return self.check_all()

        if self.mode == "warcraftlogs":
            self.check_warcraftlogs()

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
            print '[INFO] [{0}][Guild ID: {1}] - Finished refreshing. Total time since last refresh was {2} seconds'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),
                   guild.guild_id,round((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds()-guild.last_checked,0))
        except Exception, e:
            if not retry:
                guild.client = 'concurrent' if guild.client == 'tornado' else 'tornado'
                print '[ERROR][{0}][Guild ID: {1}] - Encountered an error, trying with client {2} now. Error: {3}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),
                       guild.guild_id,guild.client,repr(e))
                self.check_single(guild,True)
            else:
                print '[ERROR][{0}][Guild ID: {1}] - Encountered an error, did not refresh. Total time since last refresh was {2} seconds. Error: {3}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),
                       guild.guild_id,round((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds()-guild.last_checked,0),repr(e))


    def check_warcraftlogs(self):
        count = 0
        for guild in self.guilds:
            count += 1
            if self.ids:
                if str(guild.guild_id) in self.ids:
                    guild.update_warcraftlogs()
                    print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
            else:
                guild.update_warcraftlogs()
                print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))



