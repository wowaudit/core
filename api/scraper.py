# -*- coding: utf-8 -*-
from guild import Guild
from execute_query import execute_query
from constants import *
import time

class Scraper(object):

    def __init__(self,mode,ids=False,start_time=time.time()):
        self.guilds = []
        self.done = {}
        self.mode = mode
        self.ids = ids
        self.start_time = start_time
        data = execute_query('SELECT guilds.guild_id, guilds.name, guilds.region, guilds.realm, guilds.key_code, guilds.last_checked, users.user_id, users.name, users.role, users.weekly_snapshot ' + \
                             ', users.legendaries, users.realm, users.per_spec, users.tier_data, users.status FROM guilds, users WHERE guilds.guild_id = users.guild_id ORDER BY guilds.last_checked ASC')
        count = 0
        for member in data:
            key_code = member[4]

            if key_code not in self.done:
                self.guilds.append(Guild(member,mode))
                self.done[key_code] = count
                count += 1
            else: self.guilds[self.done[key_code]].add_member(member)

    def check_all(self):
        count = 0
        for guild in self.guilds:
            count += 1
            if time.time() - self.start_time >= MAXIMUM_RUNTIME: return False

            if self.mode == 'production':
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
