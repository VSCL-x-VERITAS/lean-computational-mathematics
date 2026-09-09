"""Capture pure guard tests only. Never invoke a candidate or released operation."""
from pathlib import Path
import argparse
import hashlib
import json
import re
import subprocess
import sys
import time

p = argparse.ArgumentParser()
p.add_argument('--label', required=True)
a = p.parse_args()
assert re.fullmatch('[a-z0-9-]+', a.label), 'Fresh simple test label required'
base = Path(__file__).resolve().parent
target = base / (a.label + '-output.txt')
receipt = base / (a.label + '-receipt.json')
assert not target.exists() and not receipt.exists()
files = ['candidate_checks.py', 'capture_checks.py', 'assemble_epoch.py', 'prepare_organization.py', 'test_guards.py', 'run_guard_tests.py']
sha = lambda data: hashlib.sha256(data).hexdigest()
pins = [{'path': f, 'sha256': sha((base / f).read_bytes())} for f in files]
command = [sys.executable, '-X', 'utf8', '-B', str(base / 'test_guards.py')]
start = time.monotonic_ns()
result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=base)
elapsed = (time.monotonic_ns() - start) // 1000000
target.write_bytes(result.stdout)
receipt.write_text(json.dumps({'kind': 'pure-synthetic-guard-tests-not-candidate-validation',
    'command': command, 'exit_code': result.returncode, 'elapsed_ms': elapsed,
    'output_sha256': sha(result.stdout), 'inputs': pins}, indent=2) + '\n', encoding='utf-8', newline='\n')
sys.stdout.buffer.write(result.stdout)
raise SystemExit(result.returncode)
