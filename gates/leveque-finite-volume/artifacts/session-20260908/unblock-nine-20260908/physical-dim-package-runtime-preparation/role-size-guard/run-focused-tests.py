"""Capture unchanged local fixtures only; never calls an operational role mode."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, subprocess, sys, time
P = Path(__file__).resolve().parent
disk = lambda p: '\\\\?\\' + str(p.resolve())
read = lambda p: Path(disk(p)).read_bytes()
sha = lambda p: hashlib.sha256(read(p)).hexdigest()
label = sys.argv[1]
assert label in ('guard', 'staged')
out = P / (label + '-fixture-run-01')
assert not Path(disk(out)).exists()
os.mkdir(disk(out))
script, tag = ('test_guard.py', 'tests-01') if label == 'guard' else ('run-staged-tests.py', 'staged-tests-01')
command = [sys.executable, '-X', 'utf8', '-B', str(P / script), tag]
start = datetime.now(timezone.utc).isoformat()
clock = time.monotonic()
result = subprocess.run(command, cwd=P, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
elapsed = time.monotonic() - clock
for name, data in [('output.txt', result.stdout), ('stderr.txt', result.stderr)]:
    with Path(disk(out / name)).open('xb') as stream:
        stream.write(data)
receipt = {'command': command, 'started_at_utc': start,
    'completed_at_utc': datetime.now(timezone.utc).isoformat(),
    'actual_exit_code': result.returncode, 'elapsed_seconds': elapsed,
    'output_sha256': sha(out / 'output.txt'), 'stderr_sha256': sha(out / 'stderr.txt'),
    'guard_sha256': sha(P / 'guard.py'), 'staged_sha256': sha(P / 'staged.py'),
    'test_entry_sha256': sha(P / script), 'capture_sha256': sha(Path(__file__)),
    'fixture_only': True, 'operational_plans_created': 0, 'actual_audit_or_model_invocations': 0}
with Path(disk(out / 'receipt.json')).open('x', encoding='utf-8', newline='\n') as stream:
    json.dump(receipt, stream, indent=2); stream.write('\n')
print(result.stdout.decode()); print(result.stderr.decode())
print(json.dumps({'receipt_sha256': sha(out / 'receipt.json'),
    'actual_exit_code': result.returncode, 'elapsed_seconds': elapsed}))
raise SystemExit(result.returncode)
