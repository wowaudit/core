#UNUSED
from execute_query import execute_query
import csv

''' Takes a Patreon export file. Adds new subscribers to the database and deactivates canceled Patreons. '''

class Patreons():

    def __init__(self):
        data = execute_query('SELECT patreon_id, email, pledge, full_name, active, discord_name, team_id, manual FROM patreons')
        self.everyone = {}
        for patreon in data:
            self.add_existing(patreon)

    def add_existing(self,data):
        patreon_id, email, pledge, full_name, active, discord_name, team_id, manual = data
        self.everyone[email] = Patreon(patreon_id, email, pledge, full_name, active, discord_name, team_id, manual, False if not manual else True)

    def add_new(self,data):
        email = data[2]
        full_name = '{0} {1}'.format(data[0],data[1])
        pledge = data[3]
        self.everyone[email] = Patreon('new', email, pledge, full_name)

    def canceled_patreons(self):
        canceled = []
        for character in self.everyone:
            if not self.everyone[character].still_patreon:
                if self.everyone[character].active == 1:
                    canceled.append(self.everyone[character])
        return canceled

class Patreon():

    def __init__(self, patreon_id, email, pledge, full_name, active = 1, discord_name = '', team_id = 0, manual = 0, still_patreon = True):
        self.patreon_id = patreon_id
        self.active = active
        self.pledge = pledge
        try:
            self.full_name = full_name.encode('utf-8').replace("'","\\'")
        except: self.full_name = full_name.decode('utf-8').encode('utf-8').replace("'","\\'")
        try:
            self.discord_name = discord_name.encode('utf-8').replace("'","\\'")
        except: self.discord_name = discord_name.decode('utf-8').encode('utf-8').replace("'","\\'")

        self.team_id = team_id
        self.email = email
        self.manual = manual
        self.still_patreon = still_patreon

    def update(self, data):
        if data[3] != self.pledge: self.pledge = data[3]
        if '{0} {1}'.format(data[0],data[1]) != self.full_name: self.full_name = '{0} {1}'.format(data[0],data[1]).replace("'","\\'")
        self.active = 1

    def get_output(self):
        return [self.patreon_id, self.active, self.pledge, self.full_name, self.discord_name, self.team_id, self.email, self.manual]

if __name__ == '__main__':

    url = raw_input('Enter export csv path: ')[:-1]
    patreons = Patreons()

    with open(url,'r') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row[-1]:
                email = row[2]
                if email not in patreons.everyone.keys():
                    patreons.add_new(row)
                else: patreons.everyone[email].update(row)
                patreons.everyone[email].still_patreon = True

    for character in patreons.canceled_patreons():
        execute_query('UPDATE patreons SET active = 0 WHERE patreon_id = {0}'.format(character.patreon_id))
        if character.team_id:
            execute_query('UPDATE teams SET patreon = 0 WHERE team_id = {0}'.format(character.team_id))
            print 'Revoked Patreon access of character with team ID {0}'.format(character.team_id)
        patreons.everyone.pop(email,None)

    query_new = []
    query_update = []
    for character in patreons.everyone:
        if patreons.everyone[character].patreon_id == 'new':
            query_new.append('({0},{1},\'{2}\',\'{3}\',{4},\'{5}\',{6})'.format(*patreons.everyone[character].get_output()[1:]))
        else:
            query_update.append('({0},{1},{2},\'{3}\',\'{4}\',{5},\'{6}\',{7})'.format(*patreons.everyone[character].get_output()))

    if query_new:
        execute_query('REPLACE INTO patreons (active,pledge,full_name,discord_name,team_id,email,manual) VALUES ' + ','.join(query_new),False)
        print 'Added {0} new Patreons!'.format(len(query_new))
    if query_update:
        execute_query('REPLACE INTO patreons VALUES ' + ','.join(query_update),False)

    for signup in execute_query('SELECT * FROM patreon_signups'):
        signup_id, name, mail, region, realm, team_name = signup
        if mail.lower() in [i.lower() for i in patreons.everyone.keys()]:

            team_id = execute_query('SELECT team_id FROM teams WHERE realm = \'{0}\' AND region = \'{1}\' AND name = \'{2}\''.format(realm.replace("'","\\'").encode('utf-8'),region,team_name.encode('utf-8')))
            try:
                team_id = team_id[0][0]
                go = True
            except:
                print 'No team ID found for this signup entry'
                go = False
            if go:
                execute_query('UPDATE teams SET patreon = 1 WHERE team_id = {0}'.format(team_id))
                execute_query('UPDATE patreons SET active = 1 AND team_id = {0} WHERE email = \'{1}\''.format(team_id,mail))
                execute_query('DELETE FROM patreon_signups WHERE patreon_email = \'{0}\''.format(mail))
                print 'Automatically upgraded Patreon status for {0}, team ID {1}'.format(mail,team_id)

    print 'Done!'
