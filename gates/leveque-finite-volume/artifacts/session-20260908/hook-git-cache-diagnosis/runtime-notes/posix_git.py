"""Run Git in the same POSIX runtime as the released formalization workflow."""
import os
import sys

if os.name == 'nt':
    raise SystemExit('Invoke this helper through run_workflow_posix.py.')
os.execv('/usr/bin/git', ['/usr/bin/git', *sys.argv[1:]])
