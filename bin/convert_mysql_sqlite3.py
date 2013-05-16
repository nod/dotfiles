#!/usr/bin/env python
#
# FOUND AT https://gist.github.com/100651
#
# Convert a mysql dump into a sqlite-compatible format.
# I wrote this for just one script... no guarantess that it will work with others...
# python fsql.py < mysqldump.sql > readyforsqlite.sql

import re
import sys

content = sys.stdin.read()

# unused commands
COMMAND_RE = re.compile(r'^(SET).*?;\n$', re.I | re.M | re.S)
content = COMMAND_RE.sub('', content)

# table constraints
TCONS_RE = re.compile(r'\)(\s*(CHARSET|DEFAULT|ENGINE)(=.*?)?\s*)+;', re.I | re.M | re.S)
content = TCONS_RE.sub(');', content)

# insert multiple values
INSERTVALS_RE = re.compile(r'^(INSERT INTO.*?VALUES)\s*\((.*)\);$', re.I | re.M | re.S)
INSERTVALS_SPLIT_RE = re.compile(r'\)\s*,\s*\(', re.I | re.M | re.S)

def insertvals_replacer(match):
    insert, values = match.groups()
    replacement = ''
    for vals in INSERTVALS_SPLIT_RE.split(values):
        replacement = '%s\n%s (%s);' % (replacement, insert, vals)
    return replacement

content = INSERTVALS_RE.sub(insertvals_replacer, content)

# write results to stdout
sys.stdout.write(content)
