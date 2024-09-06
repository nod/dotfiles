#!/usr/bin/env python3
# shameless port of https://github.com/aniero/dotfiles/blob/master/install.rb

from __future__ import print_function

from glob import glob
from os import environ, getcwd, symlink, makedirs
from os.path import exists, expanduser, join, normpath
from platform import system
from sys import stderr

home = expanduser(environ['HOME'])

def install_sym(src, target):
    if exists(target):
        print("skipping {}, already exists".format(target))
    else:
        print("installing {} to {}".format(src, target))
        symlink(src, target)

for f in glob('*'):
    if any((f.startswith(x) for x in ('nope', 'README', 'install', 'tags', 'archive'))):
        continue
    target = normpath(join(home, '.%s'%f))
    src = normpath(join(getcwd(), f))
    install_sym(src, target)

# if 'Darwin' == system():
    # install a symlink to tig since we're on osx
    # target = normpath(join(home, '.bin/tig'))
    # src = normpath(join(getcwd(), 'bin/tig-osx'))
    # install_sym(src, target)

for d in ('~/tmp', '~/.venvs'):
    d_ = expanduser(d)
    if not exists(d_):
        print("making directory:", d_)
        makedirs(d_)
    else:
        print("skipping", d_, "already exists.")

# we need a symlink for our ssh stuff.
# for now, just hardcode it to ~/.secrets/ssh
ssh_dir =  normpath(join(home, '.ssh'))
src = normpath(join(home, ".secrets/ssh"))
install_sym(src, ssh_dir)

