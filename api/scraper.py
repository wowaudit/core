# -*- coding: utf-8 -*-
from guild import Guild
from execute_query import execute_query
from constants import *
from auth import WCL_KEY
from json import loads
import time, requests, datetime

class Scraper(object):

    def __init__(self,mode,ids=False,start_time=time.time()):
        self.guilds = []
        self.done = {}
        self.mode = mode
        self.ids = ids
        self.start_time = start_time
        if self.mode == 'production_patreon':
            data = execute_query('SELECT guilds.guild_id, guilds.name, guilds.region, guilds.realm, guilds.key_code, guilds.last_checked, users.user_id, users.name, users.role, users.weekly_snapshot ' + \
                                 ', users.legendaries, users.realm, users.per_spec, users.tier_data, users.status, users.warcraftlogs FROM guilds, users WHERE guilds.guild_id = users.guild_id AND guilds.patreon = 1 ORDER BY guilds.last_checked ASC')

        else:
            data = execute_query('SELECT guilds.guild_id, guilds.name, guilds.region, guilds.realm, guilds.key_code, guilds.last_checked, users.user_id, users.name, users.role, users.weekly_snapshot ' + \
                                 ', users.legendaries, users.realm, users.per_spec, users.tier_data, users.status, users.warcraftlogs FROM guilds, users WHERE guilds.guild_id = users.guild_id ORDER BY guilds.last_checked ASC')

        count = 0
        for member in data:
            if len(self.guilds) >= MAX_ALLOCATED and self.mode == 'production' and not self.ids: break
            key_code = member[4]

            if key_code not in self.done:
                if self.mode == 'snapshot_EU':
                    self.guilds.append(Guild(member,mode,'EU'))
                elif self.mode == 'snapshot_US':
                    self.guilds.append(Guild(member,mode,'US'))
                else:
                    wself.guilds.append(Guild(member,mode))
                self.done[key_code] = count
                count += 1
            else: self.guilds[self.done[key_code]].add_member(member)

        self.allocate()

    def allocate(self):
        if self.mode in ['production','production_patreon']:
            execute_query('UPDATE guilds SET last_checked = {0} WHERE guild_id IN ({1})'.format((datetime.datetime.now()-datetime.datetime(2017,1,1)).total_seconds(),','.join([str(guild.guild_id) for guild in self.guilds])))

    def run(self):
        if self.mode in ['debug','production','production_patreon']:
            return self.check_all()

        if self.mode in ['snapshot_EU','snapshot_US']:
            execute_query('UPDATE users SET weekly_snapshot = \'\' WHERE guild_id IN (SELECT guild_id from guilds WHERE region = \'{0}\')'.format(self.mode.split("_")[1]))
            return self.check_all()

        if self.mode == "warcraftlogs":
            self.check_warcraftlogs()

    def check_all(self):
        count = 0
        for guild in self.guilds:
            count += 1
            if self.mode in ['production','production_patreon']:
                if time.time() - self.start_time >= MAXIMUM_RUNTIME: return False
                if self.ids:
                    if str(guild.guild_id) in self.ids:
                        try:
                            guild.check()
                            print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                        except:
                            print 'Encountered an error when checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                else:
                    try:
                        guild.check()
                        print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                    except:
                        print 'Encountered an error when checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))

            if self.mode in ['snapshot_US','snapshot_EU']:
                if guild.region == self.mode.split('_')[1]:
                    if self.ids:
                        if str(guild.guild_id) in self.ids:
                            try:
                                guild.check()
                                print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                            except:
                                print 'Encountered an error when checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                    else:
                        try:
                            guild.check()
                            print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                        except:
                            print 'Encountered an error when checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))

            if self.mode == 'debug':
                if self.ids:
                    if str(guild.guild_id) in self.ids:
                        guild.check()
                        print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))
                else:
                    guild.check()
                    print 'Finished checking guild with ID {0}. Progress in this cycle: {1}/{2}'.format(guild.guild_id,count,len(self.guilds))

        return True

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



