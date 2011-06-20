#!/usr/bin/env python

"""
Copies text to 33ad.org/pb via the command line.

USAGE
=====
pb33.py < file
pb33.py file [ file ... ]
"""


import re
import pycurl
import StringIO
from BeautifulSoup import BeautifulSoup

usage = __doc__

def pb(data):
    out = StringIO.StringIO()
    c = pycurl.Curl()
    c.setopt(pycurl.WRITEFUNCTION, out.write)
    c.setopt(c.VERBOSE, True)
    c.setopt(c.FOLLOWLOCATION, True)
    c.setopt(c.POST, True)
    c.setopt(c.URL, "http://33ad.org/pb")
    c.setopt(c.HTTPPOST, [
        ("submit", "pasteit"),
        ("human2", "on"),
        ("_paste", data),
        ] )
    c.perform()
    c.close()

    result = out.getvalue()
    soup = BeautifulSoup(result)
    pbloc = soup.find('span','pbloc')
    return re.sub(r'.*?\s+', r'', pbloc.string)


def main():
    import sys,getopt
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h")
    except getopt.GetoptError, err:
        print str(err)
        return 2

    for o,v in opts:
        if o == "-h":
            print usage
            return

    if not args:
        print pb(sys.stdin.read())
    else:
        for arg in args:
            print pb(open(arg).read())


if __name__ == '__main__':
    main()

