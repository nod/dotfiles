"""
Echo stdin to stdout, replacing all instances of current working directory
with '.'.

Useful for things like converting long dir names in tracebacks into relative
dir names.
"""
import os
import sys

def main():

    cwd = os.path.join(os.getcwd(), '')
    abbr = '.' + os.sep

    for line in sys.stdin:
        print line.replace(cwd, abbr)[:-1]


if __name__ == '__main__':
    sys.exit(main())

