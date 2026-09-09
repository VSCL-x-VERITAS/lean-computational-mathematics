"""Capture only local pure tests and frozen native-evidence reads."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess
import sys

D = Path(__file__).resolve().parent
label = sys.argv[1]
if not label.startswith('selftest-') or not label.removeprefix('selftest-').isdigit():
    raise ValueError('use a fresh selftest-NN label')
out = D/label
out.mkdir()
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
gate = D.parents[5]/'gates/leveque-finite-volume/chapter-01.json'
# D -> unblock -> session -> artifacts -> leveque gate -> gates -> Lean root.
before = sha(gate)
inputs = [{'path': str(p), 'sha256': sha(p)} for p in D.glob('*.py')]
command = [sys.executable, '-B', str(D/'selftest.py')]
start = datetime.now(timezone.utc).isoformat()
with (out/'output.txt').open('xb') as stdout, (out/'stderr.txt').open('xb') as stderr:
    run = subprocess.run(command, cwd=D, stdout=stdout, stderr=stderr)
receipt = {'command': command, 'started_at_utc': start, 'completed_at_utc': datetime.now(timezone.utc).isoformat(),
           'exit_code': run.returncode, 'stdout_sha256': sha(out/'output.txt'), 'stderr_sha256': sha(out/'stderr.txt'),
           'inputs': inputs, 'gate_sha256_before': before, 'gate_sha256_after': sha(gate),
           'scope': 'Syntax, pure synthetic guard tests and existing frozen native evidence only; no binder/audit/Git invocation.'}
with (out/'receipt.json').open('xb') as handle:
    handle.write((json.dumps(receipt, indent=2) + '\n').encode())
print(json.dumps(receipt))
if run.returncode:
    print((out/'stderr.txt').read_text())
if sha(gate) != before:
    raise ValueError('gate changed during tests; investigate external concurrent writes')
raise SystemExit(run.returncode)
