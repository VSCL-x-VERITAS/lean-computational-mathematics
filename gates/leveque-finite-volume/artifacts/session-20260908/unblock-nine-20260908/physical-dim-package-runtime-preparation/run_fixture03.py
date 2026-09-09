from pathlib import Path
import hashlib
import json
import subprocess
import sys
from datetime import datetime, timezone
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
out = P / 'fixture-outer-03'
out.mkdir()
command = [sys.executable, '-X', 'utf8', '-B', str(R.parent / 'workflow-v5.0.1-local/run_workflow_posix.py'), str(P / 'test_runtime03.py')]
started = datetime.now(timezone.utc).isoformat()
with (out / 'stdout.txt').open('wb') as stdout, (out / 'stderr.txt').open('wb') as stderr:
    result = subprocess.run(command, cwd=R, stdout=stdout, stderr=stderr)
receipt = {'command': command, 'cwd': str(R), 'started_at': started, 'finished_at': datetime.now(timezone.utc).isoformat(), 'actual_exit_code': result.returncode,
           'stdout_sha256': hashlib.sha256((out / 'stdout.txt').read_bytes()).hexdigest(), 'stderr_sha256': hashlib.sha256((out / 'stderr.txt').read_bytes()).hexdigest()}
(out / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
print(json.dumps(receipt))
raise SystemExit(result.returncode)

