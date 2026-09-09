"""Capture a native-Python pure test run with real exit; no gate/validator invocation."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
NAMES = ['qualified_row_support_v2.py', 'bind-qualified-row-v2.py', 'validate-closed-row-audits-v5.py',
         'test-qualified-refinement-v2.py', 'run-qualified-refinement-tests.py',
         'qualified_row_support.py', 'bind-qualified-row.py', 'validate-closed-row-audits-v4.py',
         'protected-baseline.json', 'selftest.py']


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    label = sys.argv[1]
    assert label.startswith('qualified-refinement-tests-') and label.replace('-', '').isalnum()
    output = HERE/label
    output.mkdir()
    paths = [HERE/name for name in NAMES]
    before = {str(path): sha(path) for path in paths}
    for index, path in enumerate(paths):
        (output/(str(index).zfill(2) + '-' + path.name + '.snapshot')).write_bytes(path.read_bytes())
    gate = ROOT/'gates/leveque-finite-volume/chapter-01.json'
    gate_before = sha(gate)
    command = [sys.executable, '-B', str(HERE/'test-qualified-refinement-v2.py')]
    started = datetime.now(timezone.utc).isoformat()
    start = time.perf_counter()
    run = subprocess.run(command, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    elapsed = time.perf_counter() - start
    (output/'stdout.txt').write_bytes(run.stdout)
    (output/'stderr.txt').write_bytes(run.stderr)
    record = {'schema': 1, 'command': command, 'cwd': str(ROOT), 'started_at_utc': started,
              'elapsed_seconds': elapsed, 'exit_code': run.returncode,
              'stdout_sha256': sha(output/'stdout.txt'), 'stderr_sha256': sha(output/'stderr.txt'),
              'inputs_before': before, 'inputs_after': {str(path): sha(path) for path in paths},
              'gate_before_sha256': gate_before, 'gate_after_sha256': sha(gate),
              'operational_validator_or_binder_invoked': False}
    (output/'receipt.json').write_text(json.dumps(record, indent=2) + '\n', encoding='utf-8', newline='\n')
    print(json.dumps(record, indent=2))
    if run.returncode:
        sys.stdout.buffer.write(run.stdout)
        sys.stderr.buffer.write(run.stderr)
    return run.returncode


if __name__ == '__main__':
    raise SystemExit(main())
