import httplib
import json
import sys
import pycurl
from urllib import urlencode
from json import loads as json_loads
import StringIO


def blinkto(uri):
	headers = {'Content-type':'application/x-www-form-urlencoded', 'Accept':'text/plain'}
	params = urlencode({'uri':uri})
	conn = httplib.HTTPConnection('blink.to')
	conn.request('PUT', '/', params, headers)
	return json.loads(conn.getresponse().read()).get('uri')


def upload_file(fpath, passwd):
    out = StringIO.StringIO()
    c = pycurl.Curl()
    c.setopt(pycurl.WRITEFUNCTION, out.write)
    c.setopt(c.POST, True)
    c.setopt(c.URL, "http://33ad.org/tmp/up")
    c.setopt(c.HTTPPOST, [
        ("human", passwd),
        ("submit", "tmp it."),
        ("json", "1"),
        ("upfile", (c.FORM_FILE, fpath)),
        ] )
    c.perform()
    c.close()

    ret = json_loads(out.getvalue())
    return ret.get('uri')

