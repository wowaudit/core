# -*- coding: utf-8 -*-
from json import loads
import datetime
import urllib2
import csv, codecs, cStringIO

def query_html(url):
    try:
        response = urllib2.urlopen(url)
        return (url,response)
    except urllib2.HTTPError:
        return (url,False)
    
class UnicodeWriter:
    """
    A CSV writer which will write rows to CSV file "f",
    which is encoded in the given encoding.
    """

    def __init__(self, f, dialect=csv.excel, encoding="utf-8", **kwds):
        # Redirect output to a queue
        self.queue = cStringIO.StringIO()
        self.writer = csv.writer(self.queue, dialect=dialect, **kwds)
        self.stream = f
        self.encoder = codecs.getincrementalencoder(encoding)()

    def writerow(self, row):
        self.writer.writerow([s.encode("utf-8") for s in row])
        # Fetch UTF-8 output from the queue ...
        data = self.queue.getvalue()
        data = data.decode("utf-8")
        # ... and reencode it into the target encoding
        data = self.encoder.encode(data)
        # write to the target stream
        self.stream.write(data)
        # empty queue
        self.queue.truncate(0)

    def writerows(self, rows):
        for row in rows:
            self.writerow(row)


REP_ORDERED = ['nightfallen','valarjar','wardens','dreamweavers','highmountain tribe','court of farondis']
REPUTATIONS = {1859:'nightfallen',1948:'valarjar',1894:'wardens',1883:'dreamweavers',1828:'highmountain tribe',1900:'court of farondis'}
CLASSES = {1:'Warrior',2:'Paladin',3:'Hunter',4:'Rogue',5:'Priest',6:'Death Knight',7:'Shaman',8:'Mage',9:'Warlock',10:'Monk',11:'Druid',12:'Demon Hunter'}
ITEMS = ['head','neck','shoulder','back','chest','wrist','hands','waist','legs','feet','finger1','finger2','trinket1','trinket2']
STANDINGS = {0:'Hated',1:'Hostile',2:'Unfriendly',3:'Neutral',4:'Friendly',5:'Honored',6:'Revered',7:'Exalted'}
ENCHANTS = ['neck','back','finger1','finger2']
REP_AMOUNT = {0:36000,1:3000,2:3000,3:3000,4:6000,5:12000,6:21000,7:999}

URL = "https://eu.api.battle.net/wow/character/{0}/{1}?fields=items,reputation,audit&apikey=xg7qvw9t36rdvwh8u67smuu5v8rbrvge"

members = {'stormrage':[('Kormash','tank'),('Flyinghai','tank'),('Noldorimbor','heal'),('Zamir','heal'),('Sagart','heal'),('Doobious','heal'),('Rørboss','heal'),('Nance','heal'),('Khlcsl','DPS'),('Zandare','DPS'),('Ozinaq','DPS'),('Maxeii','DPS'),('Marks','DPS'),('Alizs','DPS'),('Ancai','DPS'),('Notkatsuri','DPS'),('Katsuri','DPS'),('Awilda','DPS'),('Elvenadoren','DPS'),('Nagasquirt','DPS'),('Gingerbraid','DPS'),('Décoz','DPS'),('Sheday','DPS'),('Funkyhouse','DPS'),('Stormerino','DPS')]}

header = ['class','rank','avg_ilvl_eq','art_traits','art_ilvl','head_ilvl','head_id','head_icon','head_q','neck_ilvl','neck_id','neck_icon','neck_q', \
         'shoulder_ilvl','shoulder_id','shoulder_icon','shoulder_q','cloak_ilvl','cloak_id','cloak_icon','cloak_q','chest_ilvl','chest_id','chest_icon','chest_q', \
         'wrist_ilvl','wrist_id','wrist_icon','wrist_q','gloves_ilvl','gloves_id','gloves_icon','gloves_q','waist_ilvl','waist_id','waist_icon','waist_q', \
         'legs_ilvl','legs_id','legs_icon','legs_q','boots_ilvl','boots_id','boots_icon','boots_q','ring1_ilvl','ring1_id','ring1_icon','ring1_q','ring2_ilvl', \
         'ring2_id','ring2_icon','ring2_q','trinket1_ilvl','trinket1_id','trinket1_icon','trinket1_q','trinket2_ilvl','trinket2_id','trinket2_icon','trinket2_q', \
         'relic1_ilvl','relic1_id','relic1_icon','relic1_q','relic2_ilvl','relic2_id','relic2_icon','relic2_q','relic3_ilvl','relic3_id','relic3_icon','relic3_q', \
         'nightfallen_standing','nightfallen_value','valarjar_standing','valarjar_value','wardens_standing','wardens_value','dreamweavers_standing','dreamweavers_value',\
         'highmountain-tribe_standing','highmountain-tribe_value','court-of-farondis_standing','court-of-farondis_value','enchant_neck','enchant_cloak','enchant_ring1',\
         'enchant_ring2','missing_sockets','rep_value','role']

csv_data = []

def add_row(data,role):
    row_data = [data['name'], CLASSES[data['class']]]
    
    missing_enchants = []
    ilvl = 0.0
    for item in ITEMS:
        try: 
            if item in ENCHANTS:
                try: 
                    data['items'][item]['tooltipParams']['enchant']
                    missing_enchants.append(1)
                except KeyError: missing_enchants.append(0)  
                
            ilvl += data['items'][item]['itemLevel']
            row_data += [data['items'][item]['itemLevel'], data['items'][item]['id'], data['items'][item]['icon'], data['items'][item]['quality']]

        except KeyError: 
            row_data += ['', '', '', '']
    
    try:
        ilvl += data['items']['mainHand']['itemLevel']
        ilvl += data['items']['mainHand']['itemLevel']
        row_data.insert(2,data['items']['mainHand']['itemLevel'])
        
        total_traits = 0
        if data['items']['mainHand']['artifactTraits']: weapon = 'mainHand'
        else:
            try: 
                if data['items']['offHand']['artifactTraits']: weapon = 'offHand'
                else: weapon = False
            except: weapon = False

        if weapon:
            for trait in data['items'][weapon]['artifactTraits']:
                total_traits += int(trait['rank'])
    
            print total_traits
            total_traits -= len(data['items'][weapon]['relics'])
            row_data.insert(2,total_traits)  

            try: row_data += ['?',data['items'][weapon]['relics'][0]['itemId'],'','']
            except: row_data += ['','','','']
            
            try: row_data += ['?',data['items'][weapon]['relics'][1]['itemId'],'','']
            except: row_data += ['','','','']
        
            try: row_data += ['?',data['items'][weapon]['relics'][2]['itemId'],'','']
            except: row_data += ['','','','']
            
        else: 
            row_data.insert(2,0)
            row_data += ['', '', '', '', '', '', '', '', '', '', '', ''] #RELICS

    except KeyError: 
        row_data.insert(2,0)
        row_data.insert(2,0)
        row_data += ['', '', '', '', '', '', '', '', '', '', '', ''] #RELICS
    
    row_data.insert(2,round(ilvl / (len(ITEMS) + 2),2))
    
    reps = {}
    rep_value = 0
    for reputation in REPUTATIONS:
        for rep_data in data['reputation']:
            if rep_data['id'] == reputation:
                reps[REPUTATIONS[reputation]] = [STANDINGS[rep_data['standing']], rep_data['value']]
                rep_value += ( ( rep_data['standing'] - 2 ) + ( float(rep_data['value']) / REP_AMOUNT[rep_data['standing']] ) )
    
    for reputation in REP_ORDERED:
        row_data += reps[reputation]
    
    row_data += missing_enchants + [data['audit']['emptySockets']]
    row_data += [rep_value,role]
    
    return row_data

count = 0
for realm in members:
    for member in members[realm]:
        role = member[1]
        member = member[0]
        count += 1
        max_tries = 0
        data = query_html(URL.format(realm,member))[1]
        while not data:
            max_tries += 1
            print 'Got a gateway error while checking {0}. Retrying...'.format(member)
            data = query_html(URL.format(realm,member))[1]
            if max_tries >= 10:
                data = 'skip'
    
        csv_data.append(add_row(loads(data.read()),role))
        #csv_data.append([member,'',0]+['' for i in range(88)]+[role])
        
        if data == 'skip': print 'Skipped {0} due to a query error. Progress: {1}/{2}'.format(member,count,sum([len(members[i]) for i in members]))
        else: print 'Finished checking {0}. Progress: {1}/{2}'.format(member,count,sum([len(members[i]) for i in members]))
        

with open('/home/vanlankveld/public_html/scripts/ilvl_competition.csv','rb+') as csvfile:
    writer = UnicodeWriter(csvfile,delimiter=',', lineterminator='\n')
    header.insert(0,datetime.datetime.now().strftime('%d-%m %H:%M'))
    writer.writerow(header)
    csv_data = sorted(csv_data,key=lambda x: x[2])
    rank = 1
    print len(csv_data)
    for row in reversed(csv_data):
        new_row = [unicode(i) for i in row]
        if row[-1] == 'none': 
            new_row.insert(2,'-')
            
        else: 
            new_row.insert(2,unicode(rank))
            rank += 1
        if len(new_row) > 88:
            writer.writerow(new_row)
            print new_row

