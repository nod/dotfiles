import httplib
import json
import sys
import pycurl
from urllib import urlencode
from json import loads as json_loads
import StringIO


def upload_file(fpath, passwd, randomized=False):
    out = StringIO.StringIO()
    c = pycurl.Curl()
    c.setopt(pycurl.WRITEFUNCTION, out.write)
    c.setopt(c.POST, True)
    c.setopt(c.URL, "http://33ad.org/tmp/up")
    opts = [
        ("human", passwd),
        ("submit", "tmp it."),
        ("json", "1"),
        ("upfile", (c.FORM_FILE, fpath)),
        ]
    if randomized: opts.append(('random', '1'))
    c.setopt(c.HTTPPOST, opts)
    c.perform()
    c.close()

    ret = json_loads(out.getvalue())
    return ret.get('uri')

