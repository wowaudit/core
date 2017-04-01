from execute_query import execute_query
import csv

''' Takes a Patreon export file. Adds new subscribers to the database and deactivates canceled Patreons. '''

class Patreons():

    def __init__(self):
        data = execute_query('SELECT patreon_id, email, pledge, full_name, active, discord_name, guild_id, manual FROM patreons')
        self.everyone = {}
        for patreon in data:
            self.add_existing(patreon)

    def add_existing(self,data):
        patreon_id, email, pledge, full_name, active, discord_name, guild_id, manual = data
        self.everyone[email] = Patreon(patreon_id, email, pledge, full_name, active, discord_name, guild_id, manual, False if not manual else True)

    def add_new(self,data):
        email = data[2]
        full_name = '{0} {1}'.format(data[0],data[1])
        pledge = data[3]
        self.everyone[email] = Patreon('new', email, pledge, full_name)

    def canceled_patreons(self):
        canceled = []
        for user in self.everyone:
            if not self.everyone[user].still_patreon: canceled.append(self.everyone[user])
        return canceled

class Patreon():

    def __init__(self, patreon_id, email, pledge, full_name, active = 1, discord_name = '', guild_id = 0, manual = 0, still_patreon = True):
        self.patreon_id = patreon_id
        self.active = active
        self.pledge = pledge
        try:
            self.full_name = full_name.encode('utf-8')
        except: self.full_name = full_name.decode('utf-8').encode('utf-8')
        try:
            self.discord_name = discord_name.encode('utf-8')
        except: self.discord_name = discord_name.decode('utf-8').encode('utf-8')

        self.guild_id = guild_id
        self.email = email
        self.manual = manual
        self.still_patreon = still_patreon

    def update(self, data):
        if data[3] != self.pledge: self.pledge = data[3]
        if '{0} {1}'.format(data[0],data[1]) != self.full_name: self.full_name = '{0} {1}'.format(data[0],data[1])
        self.active = 1

    def get_output(self):
        return [self.patreon_id, self.active, self.pledge, self.full_name, self.discord_name, self.guild_id, self.email, self.manual]

if __name__ == '__main__':

    url = raw_input('Enter export csv path: ')[:-1]
    patreons = Patreons()

    with open(url,'r') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row[-1]:
                email = row[2]
                if email not in patreons.everyone.keys(): patreons.add_new(row)
                else: patreons.everyone[email].update(row)

                patreons.everyone[email].still_patreon = True

    for user in patreons.canceled_patreons():
        execute_query('UPDATE patreons SET active = 0 WHERE email = \'{0}\''.format(user.email))
        if user.guild_id:
            execute_query('UPDATE guilds SET patreon = 0 WHERE guild_id = {0}'.format(user.guild_id))
            print 'Revoked Patreon access of user with guild ID {0}'.format(user.guild_id)
        patreons.everyone.pop(email,None)

    query_new = []
    query_update = []
    for user in patreons.everyone:
        if patreons.everyone[user].patreon_id == 'new':
            query_new.append('({0},{1},\'{2}\',\'{3}\',{4},\'{5}\',{6})'.format(*patreons.everyone[user].get_output()[1:]))
        else:
            query_update.append('({0},{1},{2},\'{3}\',\'{4}\',{5},\'{6}\',{7})'.format(*patreons.everyone[user].get_output()))

    if query_new: execute_query('REPLACE INTO patreons (active,pledge,full_name,discord_name,guild_id,email,manual) VALUES ' + ','.join(query_new),False)
    if query_update: execute_query('REPLACE INTO patreons VALUES ' + ','.join(query_update),False)
