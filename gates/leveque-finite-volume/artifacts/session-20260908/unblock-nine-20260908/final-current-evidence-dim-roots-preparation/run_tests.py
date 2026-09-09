"""Capture focused guard tests through the actual POSIX launcher, never main."""
from pathlib import Path
from datetime import datetime, timezone
import argparse
import hashlib
import json
import subprocess
import sys
import time

p = argparse.ArgumentParser()
p.add_argument('attempt')
a = p.parse_args()
assert a.attempt.isalnum()
folder = Path(__file__).resolve().parent
D = folder.parent
R = D.parents[4]
W = R.parent
dest = folder / a.attempt
dest.mkdir(exist_ok=False)
sha = lambda x: hashlib.sha256(x.read_bytes()).hexdigest()
inputs = [Path(__file__), folder / 'guard_tests.py', D / 'prepare-final-current-evidence-inputs-dim-roots-v2.py',
          D / 'prepare-final-current-evidence-inputs.py', W / 'workflow-v5.0.1-local/run_workflow_posix.py']
pins = [{'path': str(x), 'sha256': sha(x)} for x in inputs]
command = [sys.executable, '-X', 'utf8', '-B', str(W / 'workflow-v5.0.1-local/run_workflow_posix.py'),
           str(folder / 'guard_tests.py')]
start = time.monotonic()
started = datetime.now(timezone.utc).isoformat()
with (dest / 'stdout.txt').open('xb') as out, (dest / 'stderr.txt').open('xb') as err:
    completed = subprocess.run(command, cwd=R, stdout=out, stderr=err)
record = {'command': command, 'started_at': started, 'finished_at': datetime.now(timezone.utc).isoformat(),
          'elapsed_ms': int((time.monotonic() - start) * 1000), 'exit_code': completed.returncode,
          'inputs': pins, 'inputs_unchanged': all(sha(Path(x['path'])) == x['sha256'] for x in pins),
          'stdout_sha256': sha(dest / 'stdout.txt'), 'stderr_sha256': sha(dest / 'stderr.txt'),
          'operational_assembler_invoked': False, 'semantic_roles': False, 'gate_mutation': False}
(dest / 'receipt.json').write_text(json.dumps(record, indent=2) + '\n', encoding='utf-8')
print(json.dumps(record))
if completed.returncode:
    print((dest / 'stderr.txt').read_text(encoding='utf-8'))
raise SystemExit(completed.returncode or (0 if record['inputs_unchanged'] else 2))
