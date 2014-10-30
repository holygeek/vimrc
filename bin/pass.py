#!/usr/bin/env python

import subprocess

def get_pass(account=None):
        params = {
                'exec': '/usr/local/bin/pass',
                'command': 'show',
                'account': account,
        }
        cmd = "%(exec)s %(command)s %(account)s" % params
        output = subprocess.check_output(cmd, shell=True)
        return output.splitlines()[0]
