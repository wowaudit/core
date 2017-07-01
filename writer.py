# -*- coding: utf-8 -*-
import csv, codecs, cStringIO, datetime, logging
from dateutil import tz
from constants import HEADER, TIME_ZONE, VALID_RAIDS

def error(message):
    logging.basicConfig(level=logging.ERROR)
    logger = logging.getLogger(__name__)
    logger.exception(message)
    return repr(message)

def log(level,message,team_id = False,character_id = False):
    print '{0}[{1}]{2}{3} - {4}'.format(
            {'info':'[INFO] ','error':'[ERROR]'}[level],
            datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),
            '[Team ID: {0}]'.format(team_id) if team_id else '',
            '[Character ID: {0}]'.format(character_id) if character_id else '',
            message )
    return True

def write_csv(csvfile,team):
    writer = UnicodeWriter(csvfile,delimiter=',', lineterminator='\n')
    utc_time = datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC'))
    europe_time = utc_time.astimezone(tz.gettz(TIME_ZONE))
    miss = 0
    first_row = list(HEADER)
    team_wide_data = [europe_time.strftime('%d-%m %H:%M'),team.name.encode('utf-8'),team.realm.encode('utf-8'),team.region,
                       team.version_message,team.warning_message,"patreon" if team.patreon else "no patreon", team.team_name.encode('utf-8')]
    first_row[0:len(team_wide_data)] = team_wide_data
    raids_header = []
    for raid in VALID_RAIDS:
        raids_header.append("{0}@{1}@".format('_'.join([boss['name'] for boss in raid['encounters']]),raid['name']))
    first_row[142] = ''.join(raids_header)

    writer.writerow(first_row)

    csv_data = sorted(team.csv_data,key=lambda x: x[0])

    for row in csv_data:
        new_row = []
        for i in row:
            if isinstance(i,unicode):
                new_row.append(i.encode('utf-8'))
            else:
                new_row.append(str(i))

        if len(new_row) == len(HEADER): writer.writerow(new_row)
        else:
            miss += 1
            log('error','Data row and header mismatch. Not writing this row',team.team_id)

class UnicodeWriter:

    def __init__(self, f, dialect=csv.excel, encoding="utf-8", **kwds):
        # Redirect output to a queue
        self.queue = cStringIO.StringIO()
        self.writer = csv.writer(self.queue, dialect=dialect, **kwds)
        self.stream = f
        self.encoder = codecs.getincrementalencoder(encoding)()

    def writerow(self, row):
        self.writer.writerow([s for s in row])
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
