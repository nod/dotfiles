#!/usr/bin/env python

#
# Copyright 2011 Collective Labs
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

"""
  %prog -d acct.blinksend.com -u blinksend_user file1 [ file2 ... ]

Uploads a file to BlinkSend via the command line.  There's not a lot of
error checking, so cross your fingers...

CONFIGURATION
=============
The script will first look for an environment variable BLINKSEND_PASSWD
containing the user's password.  If that doesn't exist, the password
will be requested via prompt.
"""
usage = __doc__

import os,sys
import pycurl
import json
import StringIO
from BeautifulSoup import BeautifulSoup
import tempfile


def blinksend_login(curl, domain, email, passwd):
    """login to the given blinksend domain as the given user"""
    out = StringIO.StringIO()
    curl.setopt(pycurl.WRITEFUNCTION, out.write)
    curl.setopt(curl.POST, True)
    curl.setopt(curl.URL,
            "%s/session/login" % domain)
    curl.setopt(curl.HTTPPOST, [
        ("email", email),
        ("password", passwd),
        ] )
    curl.perform()


def create_docid(curl, domain, title):
    """create a docid in the given blinksend domain"""
    out = StringIO.StringIO()
    curl.setopt(pycurl.WRITEFUNCTION, out.write)
    curl.setopt(curl.POST, True)
    curl.setopt(curl.URL, "%s/api/doc/new" % domain)
    curl.setopt(curl.HTTPPOST, [
        ("title", title),
        ("descr", 'auto-uploaded'),
        ] )
    curl.perform()

    data = out.getvalue()
    data = json.loads(data)
    if not data.get('status') == "ok":
        raise Exception, "failed creating docid: data=",data
    docid = data['message'].get('docid')
    return docid


def upload_file(curl, domain, docid, fpath):
    """upload the given file and associate it with the given docid"""
    out = StringIO.StringIO()
    curl.setopt(pycurl.WRITEFUNCTION, out.write)
    curl.setopt(curl.POST, True)
    curl.setopt(curl.URL, "%s/api/doc/file" % domain)
    curl.setopt(curl.HTTPPOST, [
        ("docid", str(docid)),
        ("upfile", (curl.FORM_FILE, fpath)),
        ] )
    curl.perform()
    data = json.loads(out.getvalue())
    if data['status'] != "ok":
        raise Exception, "failed to upload: data=",data


def send_url(curl, domain, docid):
    """create a generic send url for the given docid"""
    out = StringIO.StringIO()
    curl.setopt(pycurl.WRITEFUNCTION, out.write)
    curl.setopt(curl.POST, False)
    url = "%s/doc/%s/genericsend" % (domain, docid)
    curl.setopt(curl.URL, str(url))
    curl.perform()

    html = out.getvalue()
    soup = BeautifulSoup(html)
    link = soup.find('input', id='bs_link')
    return link['value']


def blinksend_upload(domain, user, passwd, filename, verbose=False):
    """all the steps necessary to upload a given file to blinksend"""
    c = pycurl.Curl()
    cookie_file = tempfile.NamedTemporaryFile()
    c.setopt(pycurl.VERBOSE, verbose)
    c.setopt(pycurl.COOKIEFILE, cookie_file.name)
    c.setopt(pycurl.COOKIEJAR, cookie_file.name)
    c.setopt(pycurl.FOLLOWLOCATION, 1)

    blinksend_login(c, domain, user, passwd)
    docid = create_docid(c, domain, os.path.basename(filename))
    upload_file(c, domain, docid, filename)
    url = send_url(c, domain, docid)

    cookie_file.close()
    return url


def main():
    from optparse import OptionParser

    parser = OptionParser(usage)
    parser.add_option("-d", "--domain", dest="domain",
            default=False, help=("blinksend domain to upload to") )

    parser.add_option("-u", "--user", dest="user",
            default=False, help=("blinksend user to authenticate as."
                " BLINKSEND_USER environment variable will be used"
                " if this is not set."
                ) )

    parser.add_option("-p", "--password", dest="passwd",
            default=False,
            help=("blinksend password."
                " BLINKSEND_PASSWD environment variable will be used"
                " if this is not set.")
            )

    parser.add_option("-S", "--no-ssl", dest="ssl",
            action="store_false", default=True,
            help=("dont use https (for local testing)") )

    parser.add_option("-v", "--verbose", dest="verbose",
            action="store_true", default=False,
            help=("verbose curl output") )

    (options, args) = parser.parse_args()

    if len(args) == 0:
        parser.print_help()
        exit()

    dom_ = options.domain or os.environ.get('BLINKSEND_DOMAIN')
    if not dom_:
        dom_ = raw_input("Blinksend domain (blah.blinksend.com):")
    domain = "http%s://%s" % ('s' if options.ssl else '', dom_)

    user = options.user or os.environ.get('BLINKSEND_USER')
    if not user:
        user = raw_input("Blinksend user:")

    passwd = options.passwd or os.environ.get('BLINKSEND_PASSWD')
    if not passwd:
        import getpass
        passwd = getpass.getpass("Blinksend password:")

    for filename in args:
        print blinksend_upload(domain, user, passwd,
                filename, verbose=options.verbose)


if __name__ == "__main__":
    main()
