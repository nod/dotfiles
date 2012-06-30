#!/usr/bin/env python

"""
Copies text to 33ad.org/pb via the command line.

USAGE
=====
pb33.py < file
pb33.py file [ file ... ]

pb33.py -g HASH

"""


import re
import pycurl
import StringIO
import urllib

try:
    from magic import from_buffer as magic_from_buffer
except ImportError:
    magic_from_buffer = lambda *a: ''

from BeautifulSoup import BeautifulSoup

usage = __doc__

def filetype_hilite(data):
    hilite = "" # no hilite
    filetype = magic_from_buffer(data)
    if filetype.startswith("ASCII text"):
        pytraceback_re = re.compile(
                r'^Traceback \(most recent call last\):$',
                re.MULTILINE)
        if pytraceback_re.search(data[:2048]):
            filetype = "pytb"
    html = urllib.urlopen('http://33ad.org/pb').read()
    soup = BeautifulSoup(html)
    hilite_values = [ f['value'] for f in soup.findAll('option') if f['value'] ]
    for h in hilite_values:
        if h in filetype.split():
            hilite = h
            break
    return hilite


def get(hash):
    u = urllib.urlopen('http://33ad.org/pb/{}?raw=1'.format(hash))
    print u.read()



def pb(data):
    hilite = filetype_hilite(data)
    out = StringIO.StringIO()
    c = pycurl.Curl()
    c.setopt(pycurl.WRITEFUNCTION, out.write)
    #c.setopt(c.VERBOSE, True)
    c.setopt(c.FOLLOWLOCATION, True)
    c.setopt(c.POST, True)
    c.setopt(c.URL, "http://33ad.org/pb")
    c.setopt(c.HTTPPOST, [
        ("submit", "pasteit"),
        ("hilite", str(hilite)),
        ("human2", "on"),
        ("_paste", data),
        ] )
    c.perform()
    c.close()

    result = out.getvalue()
    soup = BeautifulSoup(result)
    pbloc = soup.find('span','pbloc')
    if not pbloc:
        raise Exception, "result=%s" % result
    return re.sub(r'.*?\s+', r'', pbloc.string)


def main():
    import sys,getopt
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hg:")
    except getopt.GetoptError, err:
        print >>sys.stderr, str(err)
        return 2

    for o,v in opts:
        if o == "-h":
            print usage
            return
        if o == '-g':
            return get(v)

    if not args:
        print pb(sys.stdin.read())
    else:
        for arg in args:
            print pb(open(arg).read())


if __name__ == '__main__':
    main()
