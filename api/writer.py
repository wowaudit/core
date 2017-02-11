# -*- coding: utf-8 -*-
import csv, codecs, cStringIO, datetime
from dateutil import tz
from constants import *

def write_csv(csvfile,name,realm,region,version_message,warning_message,csv_data):
    writer = UnicodeWriter(csvfile,delimiter=',', lineterminator='\n')
    utc_time = datetime.datetime.utcnow().replace(tzinfo=tz.gettz('UTC'))
    europe_time = utc_time.astimezone(tz.gettz('Europe/Amsterdam'))
    writer.writerow([europe_time.strftime('%d-%m %H:%M'),name,realm,region,version_message,warning_message]+HEADER)
    csv_data = sorted(csv_data,key=lambda x: x[2])
    rank = 1
    for row in reversed(csv_data):
        new_row = []
        for i in row:
            if isinstance(i,int) or isinstance(i,float):
                new_row.append(unicode(i))
            else:
                try: new_row.append(i.encode('utf-8'))
                except: new_row.append(i)

        if row[-1] == 'none':
            new_row.insert(2,'-')

        else:
            new_row.insert(2,unicode(rank))
            rank += 1
        if len(new_row) > 88:
            writer.writerow(new_row)

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
