import socket

instance = socket.gethostname().split('-')[0]

if instance == 'production': import production
elif instance == 'productionpatreon': import production_patreon
elif instance == 'productionpending': import production_pending
elif instance == 'productionplatinum': import production_platinum
elif instance == 'warcraftlogs': import warcraftlogs
