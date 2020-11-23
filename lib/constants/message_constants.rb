# User-facing messages

VERSION_MESSAGE = "Your spreadsheet is out of date, for more features make a new copy at https://wowaudit.com/copy"

NO_WARNING = "good|All added members are being tracked, there are no problems!"

INACTIVE_WARNING = "warning|Your sheet has stopped refreshing or will in a few days. Please check wowaudit.com and press the 'Keep/Resume Refreshing' button."

TRACK_WARNING = "warning|Not all added members are being tracked. Please check wowaudit.com and update the list of members."

ROLE_WARNING = "warning|Not all added members have a valid role for their class. Please check wowaudit.com and update the list of members."

# Back-end log messages

ERROR_API_LIMIT_REACHED = "API limit reached. Waiting one minute before trying again. "

ERROR_DATABASE_CONNECTION = "Encountered an error connection to the database. Waiting five minutes before trying again. "

ERROR_TEAM = "Encountered an error in refreshing this team: "

ERROR_TEAM_DELETED = "Could not refresh this team, it appears to have been deleted. "

ERROR_CHARACTER = "Encountered an error in refreshing this character. "

INFO_TEAM_STARTING = "Going to refresh this team now. "

INFO_TEAM_REFRESHED = "Finished refreshing the team's data. "

INFO_REALM_REFRESHED = "Finished refreshing character's dungeon level based on this realm's leaderboard. "

INFO_TEAM_EMPTY = "This team is empty, there is nothing to refresh. "

INFO_TEAM_UPDATED = "Stored the team's data in the database. "

INFO_TEAM_WRITTEN = "Wrote and uploaded the CSV file to the server. All done now. "

INFO_REGISTERED_WORKER = "Registered worker #{`hostname`.strip}."

INFO_STARTING_SCHEDULE = "Going to refresh according to the schedule. "

INFO_FINISHED_SCHEDULE = "Finished all guilds on the schedule. "

INFO_NO_SCHEDULE = "No work found. Generating own schedule. "

INFO_TIME_SINCE_LAST_REFRESH = "Time since last refresh for these teams is (on average) "

INFO_SCHEDULER_ADDED = "Assigned schedule to worker. "

INFO_SCHEDULER_DESTROYED_WORKER = "Destroyed worker due to inactivity. "

INFO_SCHEDULER_CYCLE_DONE = "Finished assigning schedules to all workers. Pausing for #{SCHEDULER_PAUSE_AFTER_CYCLE} second. "

INFO_WORKER_BUSY = "This worker hasn't started working on the newest schedule yet. "

INFO_ITEM_QUERY = "New legendary item discovered through the feed. Querying item info."
