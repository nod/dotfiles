# shameless port of https://github.com/aniero/dotfiles/blob/master/install.rb

from glob import glob
from os import environ, getcwd, symlink
from os.path import exists, expanduser, join, normpath
from sys import stderr

home = expanduser(environ['HOME'])

for f in glob('*'):
    if any((f.startswith(x) for x in ('README', 'install', 'tags'))): continue
    target = normpath(join(home, '.%s'%f))
    if exists(target):
        print >>stderr, "skipping %s, already exists" % f
    else:
        src = normpath(join(getcwd(), f))
        print "installing %s to %s" % (src, target)
        symlink(src, target)


