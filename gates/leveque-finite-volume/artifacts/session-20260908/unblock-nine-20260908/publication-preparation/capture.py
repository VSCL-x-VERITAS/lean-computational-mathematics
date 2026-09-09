"""Capture a named local read-only preparation/test invocation and real exit."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import subprocess
import sys

p = argparse.ArgumentParser()
p.add_argument('--label', required=True)
p.add_argument('--posix', action='store_true')
p.add_argument('script')
p.add_argument('args', nargs=argparse.REMAINDER)
a = p.parse_args()
H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\' + str(H0)) if os.name == 'nt' else H0
assert a.label.replace('-', '').isalnum() and '/' not in a.script and '\\' not in a.script
script = H0 / a.script
assert script.is_file()
out = H / ('run-' + a.label)
out.mkdir()
if a.posix:
    root = H0.parents[5]
    command = [sys.executable, '-B', str(root.parent / 'workflow-v5.0.1-local/run_workflow_posix.py'), str(script), *a.args]
else:
    command = [sys.executable, '-B', str(script), *a.args]
result = subprocess.run(command, cwd=H0, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
with (out / 'output.txt').open('xb') as f: f.write(result.stdout)
receipt = {'schema': 1, 'command': command, 'exit_code': result.returncode,
           'script_sha256': hashlib.sha256(script.read_bytes()).hexdigest(),
           'output_sha256': hashlib.sha256(result.stdout).hexdigest(),
           'scope': 'read-only or synthetic local preparation; no operational staging'}
with (out / 'receipt.json').open('xb') as f: f.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
raise SystemExit(result.returncode)
