import MySQLdb, time
from auth import HOST, PORT, USER, PASSWORD, DB

def execute_query(query,vital=True,level=0):
    ''' Executes any given query. Vital queries will be retried upon failure until they succeed. '''

    db = MySQLdb.connect(unix_socket=HOST,port=PORT,user=USER,passwd=PASSWORD,db=DB,charset='utf8',use_unicode=True)

    try:
        cursor = db.cursor()

        if level >= 5:
            print 'Too many query attempts made. Forfeiting this query.'
            return False

        try:
            cursor.execute(query)
            db.commit()

            if query.split(' ')[0].upper() == 'SELECT':
                results = cursor.fetchall()
                cursor.close()
                return results

            cursor.close()
            return True

        except MySQLdb.Error, e:
            try: print 'Got a MySQL error ({1}: {2}) on the following query: {0}'.format(query,e.args[0],e.args[1])
            except IndexError: 'Got a MySQL error ({1}: {2}) on the following query: {0}'.format(query,e)

            db.rollback()
            cursor.close()

            if vital:
                time.sleep(5)
                return execute_query(query,True,level=level+1)
            else:
                return False
    except:
        cursor.close()
        return False
