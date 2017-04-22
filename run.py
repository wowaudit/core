import socket

instance = socket.gethostname().split('-')[0]

if instance == 'production': import production.py
elif instance == 'productionpatreon': import production_patreon.py
elif instance == 'productionpending': import production_pending.py
elif instance == 'warcraftlogs': import warcraftlogs.py
elif instance == 'debug': import test.py
