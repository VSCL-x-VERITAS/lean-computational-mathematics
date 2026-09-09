"""Capture one pure spec-preflight invocation through the required POSIX launcher."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, re, subprocess, sys

P = Path(__file__).resolve().parent
R = P.parent.parents[4]
W = R.parent
assert len(sys.argv) == 3
script_name, label = sys.argv[1:]
assert re.fullmatch(r'prepare-spec(?:-v[0-9]+)?\.py', script_name)
assert re.fullmatch(r'spec-preflight-[0-9]+', label)
script = P / script_name
out = P / label
disk = lambda p: Path('\\\\?\\' + str(p.resolve()))
assert not disk(out).exists()
disk(out).mkdir()
sha = lambda p: hashlib.sha256(disk(p).read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
now = lambda: datetime.now(timezone.utc).isoformat()
launcher = W / 'workflow-v5.0.1-local/run_workflow_posix.py'
logical = script.as_posix()
assert logical.startswith('C:/')
command = [sys.executable, '-X', 'utf8', '-B', str(launcher), '/c/' + logical[3:]]
before = ref(script)
disk(out / script.name).write_bytes(disk(script).read_bytes())
start = now()
result = subprocess.run(command, cwd=R, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
disk(out / 'output.txt').write_bytes(result.stdout)
disk(out / 'stderr.txt').write_bytes(result.stderr)
receipt = {
    'command': command, 'cwd': str(R), 'started_at_utc': start,
    'finished_at_utc': now(), 'actual_exit_code': result.returncode,
    'script_before': before, 'script_after': ref(script),
    'launcher': {'path': str(launcher), 'sha256': sha(launcher)},
    'output': ref(out / 'output.txt'), 'stderr': ref(out / 'stderr.txt'),
    'released_preparation_run': False, 'roles_run': False,
}
disk(out / 'receipt.json').write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
print(result.stdout.decode('utf-8', errors='replace'))
print(result.stderr.decode('utf-8', errors='replace'))
print(json.dumps({'receipt': ref(out / 'receipt.json'), 'actual_exit_code': result.returncode}, indent=2))
assert receipt['script_before'] == receipt['script_after']
raise SystemExit(result.returncode)
