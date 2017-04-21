import socket

instance = socket.gethostname().split('-')[0]

if instance == 'production': import production.py
elif instance == 'production_patreon': import production_patreon.py
elif instance == 'warcraftlogs': import warcraftlogs.py
elif instance == 'debug': import test.py
