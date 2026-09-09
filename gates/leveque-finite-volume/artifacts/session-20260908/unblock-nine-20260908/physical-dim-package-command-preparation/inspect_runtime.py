"""Read-only POSIX runtime resolution and environment observations."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time

assert os.name != 'nt'
P = Path(__file__).resolve().parent
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
O = P / sys.argv[1]
O.mkdir(exist_ok=False)
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
found = {name: shutil.which(name) for name in ('lake', 'lean', 'printenv', 'python3')}
record = {'at': datetime.now(timezone.utc).isoformat(), 'cwd': str(Path.cwd()), 'executables': found,
          'inherited_LEAN_PATH': os.environ.get('LEAN_PATH'), 'PATH': os.environ.get('PATH'),
          'read_only_runtime_observation': True, 'semantic_roles': False}
for name in ('lake', 'lean'):
    path = Path(found[name])
    raw = path.read_bytes()
    record[name + '_file'] = {'path': str(path), 'sha256': sha(path), 'bytes': len(raw)}
    if len(raw) < 100000 and not raw.startswith(b'MZ'):
        (O / (name + '-exact.txt')).write_bytes(raw)
        record[name + '_script_text'] = raw.decode('utf-8')
(O / 'resolution.json').write_text(json.dumps(record, indent=2) + '\n', encoding='utf-8')
injected = dict(os.environ)
injected['LEAN_PATH'] = '/tmp/REVIEW_ONLY_LEAN_PATH_SENTINEL'
for label, args in [('environment', ['lake', 'env', 'printenv', 'LEAN_PATH']),
                    ('version', ['lake', 'env', 'lean', '--version'])]:
    started = time.monotonic()
    result = subprocess.run(args, cwd=R, env=injected, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (O / (label + '-stdout.txt')).write_bytes(result.stdout)
    (O / (label + '-stderr.txt')).write_bytes(result.stderr)
    (O / (label + '-exit.json')).write_text(json.dumps({'command': args, 'cwd': str(R),
        'injected_LEAN_PATH': injected['LEAN_PATH'], 'exit_code': result.returncode,
        'elapsed_ms': int((time.monotonic() - started) * 1000),
        'stdout_sha256': hashlib.sha256(result.stdout).hexdigest(),
        'stderr_sha256': hashlib.sha256(result.stderr).hexdigest()}, indent=2) + '\n', encoding='utf-8')
print(json.dumps(record, indent=2))
