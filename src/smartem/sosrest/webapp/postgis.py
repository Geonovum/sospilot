# -*- coding: utf-8 -*-
#
# PostGIS support wrapper.
#
# Author: Just van den Broecke
#
from util import get_log

log = get_log("postgis")

try:
    import psycopg2
    import psycopg2.extensions
except ImportError:
    log.error("cannot find package psycopg2 for Postgres client support, please install psycopg2 first!")
    # sys.exit(-1)


class PostGIS:
    def __init__(self, config):
        # Lees de configuratie
        self.config = config

    def connect(self):
        try:
            conn_str = "dbname=%s user=%s host=%s port=%s" % (self.config['database'],
                                                              self.config['user'],
                                                              self.config.get('host', 'localhost'),
                                                              self.config.get('port', '5432'))
            log.info('Connecting to %s' % conn_str)
            conn_str += ' password=%s' % self.config['password']
            self.connection = psycopg2.connect(conn_str)
            self.cursor = self.connection.cursor()

            self.set_schema()
            log.debug("Connected to database %s" % (self.config['database']))
        except Exception, e:
            log.error("Cannot connect to database '%s'" % (self.config['database']))

    def disconnect(self):
        self.e = None
        try:
            self.connection.close()
        except (Exception), e:
            self.e = e
            log.error("error %s in close" % (str(e)))

        return self.e

    # Do the whole thing: connecting, query, and conversion of result to array of dicts (records)
    def do_query(self, query_str, table):
        self.connect()
    
        column_names = self.get_column_names(table, self.config.get('schema'))
        # print('cols=' + str(column_names))
    
        self.execute(query_str)
        records_vals = self.cursor.fetchall()
        
        # record is Python list of Python dict (multiple records)
        records = list()
    
        # Convert list of lists to list of dict using column_names
        for col_vals in records_vals:
            records.append(dict(zip(column_names, col_vals)))
        # print('stations=' + str(records))
        self.disconnect()
        return records

    def get_column_names(self, table, schema='public'):
        self.cursor.execute("select column_name from information_schema.columns where table_schema = '%s' and table_name='%s'" % (schema, table))
        column_names = [row[0] for row in self.cursor]
        return column_names

    def set_schema(self):
        # Non-public schema set search path
        if self.config['schema'] != 'public':
            # Always set search path to our schema
            self.execute('SET search_path TO %s,public' % self.config['schema'])
            self.connection.commit()

    def execute(self, sql, parameters=None):
        try:
            if parameters:
                self.cursor.execute(sql, parameters)
            else:
                self.cursor.execute(sql)

                # log.debug(self.cursor.statusmessage)
        except (Exception), e:
            log.error("error %s in query: %s with params: %s" % (str(e), str(sql), str(parameters)))
            #            self.log_actie("uitvoeren_db", "n.v.t", "fout=%s" % str(e), True)
            return -1

        return self.cursor.rowcount
