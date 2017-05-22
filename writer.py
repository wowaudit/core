# -*- coding: utf-8 -*-
import csv, codecs, cStringIO, datetime, logging
from dateutil import tz
from constants import HEADER, TIME_ZONE, VALID_RAIDS

def error(message):
    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)
    logger.exception(message)
    return repr(message)

def log(level,message,guild_id = False,user_id = False):
    print '{0}[{1}]{2}{3} - {4}'.format(
            {'info':'[INFO] ','error':'[ERROR]'}[level],
            datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),
            '[Guild ID: {0}]'.format(guild_id) if guild_id else '',
            '[User ID: {0}]'.format(user_id) if user_id else '',
            message )

def write_csv(csvfile,guild):
    writer = UnicodeWriter(csvfile,delimiter=',', lineterminator='\n')
    utc_time = datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC'))
    europe_time = utc_time.astimezone(tz.gettz(TIME_ZONE))
    miss = 0
    first_row = list(HEADER)
    guild_wide_data = [europe_time.strftime('%d-%m %H:%M'),guild.name.encode('utf-8'),guild.realm.encode('utf-8'),guild.region,
                       guild.version_message,guild.warning_message,"patreon" if guild.patreon else "no patreon"]
    first_row[0:len(guild_wide_data)] = guild_wide_data
    raids_header = []
    for raid in VALID_RAIDS:
        raids_header.append("{0}@{1}@".format('_'.join([boss['name'] for boss in raid['encounters']]),raid['name']))
    first_row[142] = ''.join(raids_header)

    writer.writerow(first_row)

    csv_data = sorted(guild.csv_data,key=lambda x: x[0])

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
            log('error','Data row and header mismatch. Not writing this row',guild.guild_id)

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
