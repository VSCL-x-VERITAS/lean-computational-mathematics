"""Capture synthetic tests only through the unchanged POSIX launcher."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys
import time

P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p/'lean-toolchain').is_file())
W = R.parent
argv = [sys.executable, '-X', 'utf8', '-B', str(W/'workflow-v5.0.1-local/run_workflow_posix.py'), str(P/'test_guards.py'), '-v']
out = P/'tests-01-output.txt'
receipt = P/'tests-01-exit.json'
if out.exists() or receipt.exists():
    raise SystemExit('Refusing to overwrite test evidence')
start = time.monotonic()
with out.open('xb') as stream:
    result = subprocess.run(argv, stdout=stream, stderr=subprocess.STDOUT, cwd=R)
value = {'schema':1, 'kind':'synthetic-guard-tests-only', 'argv':argv,
         'exit_code':result.returncode, 'elapsed_ms':int((time.monotonic()-start)*1000),
         'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),
         'operational_capture_run':False, 'git_run':False}
with receipt.open('x', encoding='utf-8', newline='\n') as stream:
    stream.write(json.dumps(value,indent=2)+'\n')
print(json.dumps(value,indent=2))
raise SystemExit(result.returncode)
