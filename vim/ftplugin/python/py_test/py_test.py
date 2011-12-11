import os
from os.path import relpath, sep, splitdrive, splitext
import re
import vim

# regular expressions used to detect test method and test class names

test_method_re = re.compile('''
    [ ]*        # optional preceding whitespace
    def         # the def keyword
    \ (test\w+) # a space then the (captured) test name
    \(          # open paren marks the end of the test name
''', re.VERBOSE)

test_class_re = re.compile('''
    [ ]*            # optional preceding whitespace
    class           # the class keyword
    \ (             # start capture of class name
      \w*[tT]est\w* # match classes named 'XtestX'
    )
    [ ]*\(          # open paren marks the end of the class name
''', re.VERBOSE)

def run_python_tests(external=0):
    _run_unittest("%", external, verbose=True)

def run_single_test_method(external):
    '''
    Runs the single test method currently under the text cursor
    '''
    if vim.current.buffer.name is None:
        print 'Not a file'
        return

    current_file = relpath(vim.current.buffer.name)
    current_line_no = vim.current.window.cursor[0] - 1

#    vim.command('silent wall')

    # find the names of the test method and the test class under the cursor
    line, method = _find_prior_matching_line(current_line_no, test_method_re)
    if method is None:
        vim.command("""call RedBar("Can't find test method")""")
        return
    _, klass = _find_prior_matching_line(line, test_class_re)
    if klass is None:
        vim.command("""call RedBar("Can't find test class")""")
        return

    # create command of the form
    # nosetests -s package1.package2.module.class.method
    #module = _filename_to_module(current_file)
    dotted_method_name = '%s:%s.%s' % (current_file, klass, method)
    _run_unittest(dotted_method_name, external, verbose=True)


def _filename_to_module(filename):
    pathname = splitext( splitdrive(filename)[1] )[0]
    return pathname.replace(sep, '.')


def _run_unittest(test, external, verbose=False):
    # create command of the form
    #   nosetests test.py:class.method
    # and run asynchronously
    verbose_flag = '-s' if verbose else ''
    #command = 'python -m unittest %s%s' % (verbose_flag, test,)
    command = 'nosetests -x %s %s' % (verbose_flag, test,)
    #print command
    vim.command("silent compiler pyunit")
    vim.command("call RunCommand('%s', %d)" % (command, external))


def _find_prior_matching_line(line_number, pattern):
    '''
    Starting at given line number and working upwards towards start of file,
    look for first line which matches the given regex pattern. Return line
    number and match group 1. (e.g. method name or class name extracted from
    a matching line defining a method or class)
    '''
    testName = None
    while line_number >= 0:
        line = vim.current.buffer[line_number]
        if pattern.match(line):
            testName = pattern.match(line).groups(1)[0]
            break
        line_number -= 1
    return line_number, testName
