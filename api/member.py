# -*- coding: utf-8 -*-
from constants import *
import time

class Member(object):

    def __init__(self,data):
        self.user_id, self.name, self.role, self.snapshot, self.legendary_snapshot, self.realm, self.spec_data, self.tier_data, self.status = data[6:]
        self.name = self.name.encode('utf-8')
        self.realm = self.realm

        self.legendaries = []
        if self.legendary_snapshot:
            for legendary in self.legendary_snapshot.split('|'):
                self.legendaries.append(legendary)

        try: self.dungeon_snapshot = int(loads(self.snapshot)['dungeons'])
        except: self.dungeon_snapshot = 'not there'

        try: self.wq_snapshot = int(loads(self.snapshot)['wqs'])
        except: self.wq_snapshot = 'not there'

        try: self.ap_snapshot = int(loads(self.snapshot)['ap'])
        except: self.ap_snapshot = 'not there'

        try: self.tier_data = loads(self.tier_data)
        except: self.tier_data = {"head":0,"shoulder":0,"back":0,"chest":0,"hands":0,"legs":0}

        self.specs = {}
        count = 1

        try:
            if self.spec_data.split('|')[:-1]:
                for spec in self.spec_data.split('|')[:-1]:
                    traits, max_ilvl = spec.split('_')
                    self.specs[count] = (traits,max_ilvl)
                    count += 1
                self.max_ilvl = self.spec_data.split('|')[-1]
            else:
                self.specs = {1:(0,0),2:(0,0),3:(0,0),4:(0,0)}
                self.max_ilvl = 0

        except:
            self.specs = {1:(0,0),2:(0,0),3:(0,0),4:(0,0)}
            self.max_ilvl = 0
