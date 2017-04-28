# -*- coding: utf-8 -*-
import csv, codecs, cStringIO, datetime
from dateutil import tz
from constants import HEADER, TIME_ZONE

def log(level,message,guild_id = False,user_id = False):
    print '{0}[{1}]{2}{3} - {4}'.format(
            {'info':'[INFO] ','error':'[ERROR]'}[level],
            datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),
            '[Guild ID: {0}]'.format(guild_id) if guild_id else '',
            '[User ID: {0}]'.format(user_id) if user_id else '',
            message )

def write_csv(csvfile,name,realm,region,version_message,warning_message,csv_data,patreon,guild_id):
    writer = UnicodeWriter(csvfile,delimiter=',', lineterminator='\n')
    utc_time = datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC'))
    europe_time = utc_time.astimezone(tz.gettz(TIME_ZONE))
    miss = 0
    first_row = list(HEADER)
    guild_wide_data = [europe_time.strftime('%d-%m %H:%M'),name.encode('utf-8'),realm.encode('utf-8'),region,version_message,warning_message,"patreon" if patreon else "no patreon"]
    first_row[0:len(guild_wide_data)] = guild_wide_data
    writer.writerow(first_row)

    csv_data = sorted(csv_data,key=lambda x: x[0])

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
            log('error','Data row and header mismatch. Not writing this row',guild_id)

    log('info','CSV file written successfully, total rows: {0}'.format(len(csv_data) - miss),guild_id)

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
