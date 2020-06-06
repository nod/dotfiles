import atexit
import os.path

import rlcompleter
import readline
if 'libedit' in readline.__doc__: # on osx with bogus built readline lib
    readline.parse_and_bind ("bind ^I rl_complete")


def _tb():
    import traceback
    from pygments import highlight
    from pygments.lexers import PythonTracebackLexer
    from pygments.formatters import TerminalFormatter
    import sys
    import StringIO
    old_stdout = sys.stdout
    old_stderr = sys.stderr
    sys.stdout = StringIO.StringIO()
    sys.stderr = StringIO.StringIO()
    self.print_exc(cls, *a, **ka)
    text_out = highlight(
        sys.stdout.getvalue(),
        PythonTracebackLexer,
        TerminalFormatter )
    text_err = highlight(
        sys.stderr.getvalue(),
        PythonTracebackLexer,
        TerminalFormatter )
    sys.stdout = old_stdout
    sys.stderr = old_stderr
    sys.stdout.write(text_out)
    sys.stderr.write(text_err)
