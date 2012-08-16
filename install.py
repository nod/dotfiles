# shameless port of https://github.com/aniero/dotfiles/blob/master/install.rb

from glob import glob
from os import environ, getcwd, symlink
from os.path import exists, expanduser, join, normpath
from platform import system
from sys import stderr

home = expanduser(environ['HOME'])

def install_sym(src, target):
    if exists(target):
        print >>stderr, "skipping %s, already exists" % target
    else:
        print "installing %s to %s" % (src, target)
        symlink(src, target)

for f in glob('*'):
    if any((f.startswith(x) for x in ('tig', 'README', 'install', 'tags'))):
        continue
    target = normpath(join(home, '.%s'%f))
    src = normpath(join(getcwd(), f))
    install_sym(src, target)

# install a symlink to tig if we're on osx
if 'Darwin' == system():
    target = normpath(join(home, '.bin/tig'))
    src = normpath(join(getcwd(), 'bin/tig-osx'))
    install_sym(src, target)

# we need a symlink for our ssh stuff.
# for now, just hardcode it to ~/.secrets/ssh
ssh_dir =  normpath(join(home, '.ssh'))
src = normpath(join(home, ".secrets/ssh"))
install_sym(src, ssh_dir)

