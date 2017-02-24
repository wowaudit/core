# -*- coding: utf-8 -*-
import csv, codecs, cStringIO, datetime
from dateutil import tz
from constants import HEADER, TIME_ZONE

def write_csv(csvfile,name,realm,region,version_message,warning_message,csv_data,mode,guild_id):
    writer = UnicodeWriter(csvfile,delimiter=',', lineterminator='\n')
    utc_time = datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC'))
    europe_time = utc_time.astimezone(tz.gettz(TIME_ZONE))

    miss = 0
    first_row = list(HEADER)
    if mode == 'production_patreon': guild_wide_data = [datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M'),name,realm,region,version_message,warning_message,"patreon"]
    else: guild_wide_data = [europe_time.strftime('%d-%m %H:%M'),name,realm,region,version_message,warning_message,"no patreon"]
    first_row[0:len(guild_wide_data)] = guild_wide_data
    writer.writerow(first_row)

    csv_data = sorted(csv_data,key=lambda x: x[0])

    for row in csv_data:
        new_row = []
        for i in row:
            if isinstance(i,int) or isinstance(i,float):
                new_row.append(unicode(i))
            else:
                try: new_row.append(i.encode('utf-8'))
                except: new_row.append(i)

        if len(new_row) == len(HEADER): writer.writerow(new_row)
        else:
            miss += 1
            print '[ERROR][{0}][Guild ID: {1}] - Data row and header mismatch. Not writing this row'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),guild_id)

    print '[INFO] [{0}][Guild ID: {1}] - CSV file written successfully, total rows: {2}'.format(datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC')).astimezone(tz.gettz(TIME_ZONE)).strftime('%d-%m %H:%M:%S'),guild_id,len(csv_data) - miss)

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
