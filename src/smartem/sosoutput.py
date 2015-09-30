#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Output classes for ETL.
#
# Author: Just van den Broecke
#
from stetl.outputs.httpoutput import HttpOutput
from stetl.util import Util
from stetl.packet import FORMAT

log = Util.get_log('sosoutput')

class SOSTOutput(HttpOutput):
    """
    Output via SOS-T protocol over plain HTTP.

    consumes=FORMAT.record_array
    """

    def __init__(self, configdict, section):
        HttpOutput.__init__(self, configdict, section, consumes=FORMAT.record_array)
        self.content_type = self.cfg.get('content_type', 'application/json;charset=UTF-8')
        self.sos_request = self.cfg.get('sos_request', 'insert-observation')

        # Template file, to be used as POST body with substituted values
        self.template_file_ext = self.cfg.get('template_file_ext', 'json')
        self.template_file_root = self.cfg.get('template_file_root', 'sostemplates')
        self.template_file_path = '%s/%s.%s' % (self.template_file_root, self.sos_request, self.template_file_ext)

    def init(self):
        # read the SOS-request template once
        log.info('Init: read SOS-request template')
        template_file = open(self.template_file_path, 'r')
        log.info("file opened : %s" % self.template_file_path)

        # Read the template string
        self.template_str = template_file.read()

        # Cleanup
        template_file.close()

        # For insert-sensor we need the Procedure SML (XML) once and escape/insert this into
        # the JSON insert-sensor string.
        if self.sos_request == 'insert-sensor':
            f = open('%s/procedure-desc.xml' % self.template_file_root, 'r')
            proc_desc = f.read()
            proc_desc = proc_desc.replace('"', '\\"')
            proc_desc = proc_desc.replace('\n', '')
            self.template_str = self.template_str.replace('{procedure-desc.xml}', proc_desc)
            f.close()

    def create_payload(self, packet):
        record = packet.data
        payload = None

        # String substitution in template SOS-request based on Python String.format()
        # Field names in source record, usually from table, table (measurements_stations) must match substitutable args in
        # template request file.
        if self.sos_request == 'insert-sensor':
            payload = self.template_str.format(**record)

        elif self.sos_request == 'delete-sensor':
            payload = self.template_str.format(**record)

        elif self.sos_request == 'insert-observation':
            # Reformat time to: "yyyy-MM-dd'T'HH:mm:ssZ"  e.g. 2013-09-29T18:46:19+0100
            record['sample_time'] = record['sample_time'].strftime('%Y-%m-%dT%H:%M:%S+0100')

            payload = self.template_str.format(**record)
        else:
            log.error('Unsupported request: %s' % self.sos_request)

        return payload
