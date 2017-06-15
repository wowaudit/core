from execute_query_old import execute_query_old
from execute_query_new import execute_query_new

#INSTR(name, '(S)') > 0"

#1
def guilds_and_teams():
    data = execute_query_old("SELECT * FROM guilds WHERE INSTR(name, '(') = 0")
    base_query_guilds = "INSERT INTO guilds (id, region, realm, name, patreon) VALUES "
    guild_queries = []
    base_query_teams = "INSERT INTO teams (id, guild_id, key_code, name, last_refreshed, last_refreshed_wcl) VALUES "
    team_queries = []
    for guild in data:
        guild_id, name, region, realm, key_code, last_checked, last_checked_wcl, patreon = guild
        guild_queries.append("({0},\'{1}\',\'{2}\',\'{3}\',{4})".format(guild_id, region, realm.encode('utf-8').replace("'","\\'"), name.encode('utf-8'), patreon))
        team_queries.append("({0},{1},\'{2}\',\'Main\',{3},{4})".format(guild_id, guild_id, key_code, last_checked, last_checked_wcl))

    execute_query_new(base_query_guilds + ','.join(guild_queries))
    execute_query_new(base_query_teams + ','.join(team_queries))

#2
def delete_fake_teams():
    data = execute_query_old("SELECT * FROM guilds WHERE INSTR(name, '(S)') > 0")
    guilds = ["\'{0}\'".format(guild[1][:-4].encode('utf-8')) for guild in data]
    new_data = execute_query_new("SELECT * FROM guilds WHERE name IN ({0})".format(','.join(guilds)))
    ids = [str(guild[0]) for guild in new_data]
    execute_query_new("DELETE FROM guilds WHERE id IN ({0})".format(','.join(ids)))
    execute_query_new("DELETE FROM teams WHERE id IN ({0})".format(','.join(ids)))

#3
def safe_guilds():
    data = execute_query_old("SELECT * FROM guilds WHERE INSTR(name, '(S)') > 0")
    base_query_guilds = "INSERT INTO guilds (id, region, realm, name, patreon) VALUES "
    guild_queries = []
    base_query_teams = "INSERT INTO teams (id, guild_id, key_code, name, last_refreshed, last_refreshed_wcl) VALUES "
    team_queries = []
    for guild in data:
        guild_id, name, region, realm, key_code, last_checked, last_checked_wcl, patreon = guild
        guild_queries.append("({0},\'{1}\',\'{2}\',\'{3}\',{4})".format(guild_id, region, realm.encode('utf-8').replace("'","\\'"), name[:-4].encode('utf-8'), patreon))
        team_queries.append("({0},{1},\'{2}\',\'Main\',{3},{4})".format(guild_id, guild_id, key_code, last_checked, last_checked_wcl))

    execute_query_new(base_query_guilds + ','.join(guild_queries))
    execute_query_new(base_query_teams + ','.join(team_queries))

#4
def special_teams():
    data = execute_query_old("SELECT * FROM guilds WHERE INSTR(name, '(1)') > 0 OR INSTR(name, '(2)') > 0 OR INSTR(name, '(3)') > 0 OR INSTR(name, '(4)') > 0 \
                              OR INSTR(name, '(5)') > 0 OR INSTR(name, '(6)') > 0 OR INSTR(name, '(7)') > 0 OR INSTR(name, '(8)') > 0 OR INSTR(name, '(9)') > 0")
    base_query_teams = "INSERT INTO teams (id, guild_id, key_code, name, last_refreshed, last_refreshed_wcl) VALUES "
    team_queries = []
    for guild in data:
        old_id, name, region, realm, key_code, last_checked, last_checked_wcl, patreon = guild
        new_data = execute_query_new("SELECT * FROM guilds WHERE name = {0}".format("\'{0}\'".format(guild[1][:-4].encode('utf-8'))))
        guild_id = new_data[0][0]
        team_queries.append("({0},{1},\'{2}\',\'Team {3}\',{4},{5})".format(old_id, guild_id, key_code, name[-2] ,last_checked, last_checked_wcl))
    print team_queries
    execute_query_new(base_query_teams + ','.join(team_queries))

#5
def patreons():
    data = execute_query_old("SELECT * FROM patreons")
    base_query_patreons = "INSERT INTO patrons (name, email, pledge, active, manual, guild1) VALUES "
    patreon_queries = []
    for patreon in data:
        patreon_id, active, pledge, full_name, discord_name, guild_id, email, manual = patreon
        if guild_id > 0:
            patreon_queries.append("(\'{0}\',\'{1}\',{2},{3},{4},{5})".format(full_name.encode('utf-8').replace("'","\\'"),email,pledge,active,manual,guild_id))
    execute_query_new(base_query_patreons + ','.join(patreon_queries))

#6
def delete_fake_patreons():
    data = [i[0] for i in execute_query_new("SELECT id from guilds WHERE patreon > 0")]
    patreons = [i[0] for i in execute_query_new("SELECT guild1 from patrons")]
    fake = []
    for guild in data:
        if guild not in patreons:
            fake.append(str(guild))
    execute_query_new("UPDATE guilds SET patreon = 0 WHERE id IN ({0})".format(','.join(fake)))

#7
def characters():
    data = execute_query_old("SELECT * FROM users")
    base_query_characters = "INSERT IGNORE INTO characters (id, team_id, realm, name, weekly_snapshot, old_snapshots, warcraftlogs, \
                                                     legendaries, last_refresh, role, per_spec, status, tier_data) VALUES "
    cycle = 1
    character_queries = []
    for character in data:
        user_id, guild_id, realm, name, role, weekly_snapshot, legendaries, per_spec, status, tier_data, warcraftlogs, last_refresh, old_snapshots = character
        if legendaries:
            legendaries = legendaries.replace("'","\\'")
        else:
            legendaries = ""
        if realm:
            realm = realm.encode('utf-8').replace("'","\\'")
        else:
            realm = ""
        name = name.encode('utf-8').replace("'","\\'")
        if last_refresh:
            last_refresh = last_refresh.encode('utf-8').replace("'","\\'")
        else:
            last_refresh = ""
        if tier_data:
            tier_data = tier_data.replace("'","\\'")
        else:
            tier_data = ""
        if warcraftlogs:
            if "@" in warcraftlogs:
                warcraftlogs = ""
        try:
            character_queries.append("({0},{1},\'{2}\',\'{3}\',\'{4}\',\'{5}\',\'{6}\',\'{7}\',\'{8}\',\'{9}\',\'{10}\',\'{11}\',\'{12}\')".format(
            user_id, guild_id, realm, name, weekly_snapshot, old_snapshots, warcraftlogs, legendaries, last_refresh, role, per_spec, status, tier_data))
        except:
            print "Couldn't add a character."

        if len(character_queries) > 1000:
            execute_query_new(base_query_characters + ','.join(character_queries))
            character_queries = []
            print 'Transferred characters. Progress: {0}/{1}'.format(cycle * 1000, len(data))
            cycle += 1
    execute_query_new(base_query_characters + ','.join(character_queries))

#8
def wrong_realms():
    realms = [i[0] for i in execute_query_new("SELECT name FROM realms")]

    realms_dict = {}
    for realm in realms:
        realms_dict[to_slug(realm)] = realm

    realm_query = 'UPDATE guilds SET realm = CASE '

    guilds = execute_query_new("SELECT id, realm FROM guilds")
    for guild in guilds:
        if guild[1] not in realms:
            slugged = to_slug(guild[1])
            realm_query += 'WHEN id = {0} THEN \'{1}\' '.format(guild[0],realms_dict[slugged].encode('utf-8').replace("'","\\'"))

    print len(realm_query)
    execute_query_new(realm_query + ' ELSE realm END')

#9
def wrong_realms_characters():
    realms = [i[0] for i in execute_query_new("SELECT name FROM realms")]

    realms_dict = {"":""}
    for realm in realms:
        realms_dict[to_slug(realm)] = realm

    realm_query = 'UPDATE IGNORE characters SET realm = CASE '

    guilds = execute_query_new("SELECT id, realm FROM characters")
    for guild in guilds:
        if guild[1] not in realms:
            try:
                slugged = to_slug(guild[1])
                realm_query += 'WHEN id = {0} THEN \'{1}\' '.format(guild[0],realms_dict[slugged].encode('utf-8').replace("'","\\'"))
            except:
                slugged = ""
                realm_query += 'WHEN id = {0} THEN \'{1}\' '.format(guild[0],realms_dict[slugged].encode('utf-8').replace("'","\\'"))

    print realm_query
    execute_query_new(realm_query + ' ELSE realm END')

#helper
def to_slug(realm):
    realm = realm.replace(u"'",u"")
    realm = realm.replace(u"-",u"")
    realm = realm.replace(u" ",u"-")
    realm = realm.replace(u"(",u"")
    realm = realm.replace(u")",u"")
    realm = realm.replace(u'\xea',u"e")
    realm = realm.lower()
    return realm

wrong_realms_characters()
