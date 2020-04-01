#!/usr/bin/env python
# shameless port of https://github.com/aniero/dotfiles/blob/master/install.rb

from __future__ import print_function

from glob import glob
from os import environ, getcwd, symlink, makedirs
from os.path import exists, expanduser, join, normpath
from platform import system
from sys import stderr

home = expanduser(environ['HOME'])

skiplist = (
  'README',
  'install',
  'macos',
  'tags',
)

def install_sym(src, target):
    if exists(target):
        print("skipping {}, already exists".format(target))
    else:
        print("installing {} to {}".format(src, target))
        symlink(src, target)

for d in ('~/tmp', '~/.venvs', '~/.secrets'):
    d_ = expanduser(d)
    if not exists(d_):
        print("making directory:", d_)
        makedirs(d_)
    else:
        print("skipping", d_, "already exists.")

for f in glob('*'):
    if any((f.startswith(x) for x in skiplist)):
        continue
    target = normpath(join(home, '.%s'%f))
    src = normpath(join(getcwd(), f))
    install_sym(src, target)

