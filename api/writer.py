# -*- coding: utf-8 -*-
import csv, codecs, cStringIO, datetime
from dateutil import tz
from constants import HEADER

def write_csv(csvfile,name,realm,region,version_message,warning_message,csv_data,mode):
    writer = UnicodeWriter(csvfile,delimiter=',', lineterminator='\n')
    utc_time = datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC'))
    europe_time = utc_time.astimezone(tz.gettz('Europe/Amsterdam'))

    first_row = list(HEADER)
    if mode == 'production_patreon': guild_wide_data = [europe_time.strftime('%d-%m %H:%M'),name,realm,region,version_message,warning_message,"patreon"]
    else: guild_wide_data = [europe_time.strftime('%d-%m %H:%M'),name,realm,region,version_message,warning_message,"no patreon"]
    first_row[0:len(guild_wide_data)] = guild_wide_data
    writer.writerow(first_row)

    csv_data = sorted(csv_data,key=lambda x: x[2])
    for row in reversed(csv_data):
        new_row = []
        for i in row:
            if isinstance(i,int) or isinstance(i,float):
                new_row.append(unicode(i))
            else:
                try: new_row.append(i.encode('utf-8'))
                except: new_row.append(i)

        if len(new_row) == len(HEADER): writer.writerow(new_row)
        else: print 'Row data length and header length mismatch. Not writing this row.'

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
