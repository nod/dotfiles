#!/usr/bin/env python
#
# extracts urls from a text stream and can fetch them if requested
#
# CHANGELOG
# - 20090514 - made http protocol re case insensitive
# - 20090108 - added -u option to fetch url, then parse other urls from that.
#   Note that this will only get text from the src like http...  it won't get
#   relative URLs
# - 20081105 - initially written by jeremy kelley for school related work,
#   converted to free standing utility around nov 5, 2008
#

import os
import re
import sys
import getopt
import urllib2
from time import time


__version__ = "20090514.b"

# regex initially from http://www.noah.org/wiki/RegEx_Python#URL_regex_pattern
# but modifications have occurred to fix certain edge cases
pat_url = re.compile(
    'h..ps?://(?:[a-z]|[0-9]|[?$=/~\-_@.&+]|'
    '[!*\(\),]|(?:%[0-9a-f][0-9a-f]))+',
    re.IGNORECASE
    )
extract_urls = lambda s: [
    re.sub(re.compile(r'h..p(s?:)',re.IGNORECASE),r'http\1',x).strip() for x in re.findall(pat_url, s)
    ]


def use_BS(url, content):

    return []   # XXX this func is broken

    urls = []
    try:
        from BeautifulSoup import BeautifulSoup
    except: return urls
    from urlparse import urlparse
    u = urlparse(url)
    urlprefix = "http://%s" % u.hostname   # note this is possibly 
                                            # broken since it
                                            # doesn't handle port, etc.  whops
    urlpath = u.path

    bs = BeautifulSoup(content)
    for a in bs.findAll("a"):
        if not a['href'].startswith("http:"):
            if a['href'].startswith('/'): # non-relative url
                

                urls.append("%s%s" % (urlprefix,a['href']))
            else: # relative url
                urls.append("%s%s/%s" % (urlprefix,urlpath,a['href']))
        else: # technically, these should have been picked up already, but the
              # set lets us add them again
            urls.append(a['href'])
    return urls

def fetch(url, proxy=None):
    headers = {
        'User-Agent': 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)',
    }

    if proxy:
        # just use the same proxy for all three protocols
        proxy_hosts = dict([(x,proxy) for x in ('http','https','ftp')])
        proxy_support = urllib2.ProxyHandler(proxy_hosts)
        opener = urllib2.build_opener(proxy_support)
        urllib2.install_opener(opener) 

    req = urllib2.Request(url, headers=headers)

    try:
        return urllib2.urlopen(req)
    except urllib2.URLError, e:
        print >>sys.stderr, "WARNING", e
        exit()
      # (urllib2.HTTPError, urllib2.URLError):
      #  return ''


def harvest(urls, prefix=None, proxy=None):
    i=0
    for U in urls:
        if not U: continue
        newdir = "%s%d" % (prefix,i)
        try:
            os.mkdir(newdir)
        except OSError:
            print >>sys.stderr, "error creating dir: %s" % newdir
            exit()
        fetched = fetch(U,proxy)
        if fetched:
            open("%s/fetched" % newdir, "w").write(fetched.read())
            open("%s/headers" % newdir, "w").write("%s\n" % fetched.info())
        open("%s/url" % newdir, "w").write(U)
        open("%s/ts" % newdir, "w").write("%f" % time())
        i+=1
        print "%s  saved to  %s" % (U, newdir)


if __name__ == '__main__':
    from optparse import OptionParser
    usage = """usage: %prog [options] FILE

-. Extract and/or Fetch .-

Extracts URLs from text and Fetches if requested.  Use - for stdin.  Each
fetched url is placed in a new directory (defaults to 0,1,2,...) unless -p
is used to specify a path and prefix.

Examples:
    %prog blah.txt    <-- will print out all the URLs found in blah.txt
    %prog -f blah.txt <-- will print out and fetch all URLs found in blah.txt
    tail blah.txt | %prog -f -p /tmp/z -P somehost.com:8888 -  <-- extracts
        urls from the output of tailing blah.txt using the given proxy and then
        places them in /tmp/z0, /tmp/z1, etc
        
The output is one URL per line when not fetched, so you can chain this output
with other commands as needed like this:
    %prog input.txt | grep -v yahoo.com | xargs wget --mirror"""
    parser = OptionParser(usage)
    parser.add_option("-u", "--url", dest="url", default=False,
         help="use this url as the input text to parse for urls")
    parser.add_option("-f", "--fetch", dest="fetch", action="store_true",
         help="fetch all urls found")
    parser.add_option("-p", "--prefix", dest="prefix", default="",
         help="when fetching urls, prefix the results dir with this")
    parser.add_option("-P", "--proxy", dest="proxy", default=None,
         help="use this proxy when fetching.  looks like host:port")
    (options, args) = parser.parse_args()

    urls = set()

    if len(args) > 0 or options.url:
        try:
            if options.url:
                content = fetch(options.url).read()
                urls.update(extract_urls(content))
                urls.update(use_BS(options.url, content))
            for x in set(args):
                if x == '-':
                    f = sys.stdin
                else:
                    f = open(x)
                content = f.read()
                urls.update(extract_urls(content))
                urls.update(use_BS("%%URL%%",content))
        except KeyboardInterrupt:
            # don't gurp when someone hits ctl-c
            print >>sys.stderr, "ctl-c encountered. bailing out"
            exit()
    else:
        parser.print_help()         
        exit()

    if options.fetch:
        harvest(urls, options.prefix, options.proxy)
    else:
        if options.prefix: print >>sys.stderr, "WARNING: -p w/o -f is useless"
        if options.proxy: print >>sys.stderr, "WARNING: -P w/o -f is useless"
        print '\n'.join(urls)

