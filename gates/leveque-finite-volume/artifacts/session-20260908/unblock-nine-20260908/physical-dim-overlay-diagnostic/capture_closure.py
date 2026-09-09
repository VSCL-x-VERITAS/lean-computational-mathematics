"""Capture actual compiled import closure and exact Lake environment, read-only."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time

P = Path(__file__).resolve().parent
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
if len(sys.argv) == 2 and sys.argv[1] == '--environment':
    assert os.name == 'nt'
    print(json.dumps({'environment': dict(os.environ), 'lean': shutil.which('lean')}))
    raise SystemExit(0)
assert os.name == 'nt' and len(sys.argv) == 2
O = P / sys.argv[1]
O.mkdir(exist_ok=False)
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
ref = lambda path: {'path': str(path), 'sha256': sha(path), 'bytes': path.stat().st_size}
records = []


def run(label, command):
    started = time.monotonic()
    with (O / (label + '-stdout.txt')).open('xb') as out, (O / (label + '-stderr.txt')).open('xb') as err:
        result = subprocess.run(command, cwd=R, stdout=out, stderr=err)
    record = {'command': command, 'cwd': str(R), 'exit_code': result.returncode,
              'elapsed_ms': int((time.monotonic() - started) * 1000),
              'stdout': ref(O / (label + '-stdout.txt')), 'stderr': ref(O / (label + '-stderr.txt'))}
    (O / (label + '-exit.json')).write_text(json.dumps(record, indent=2) + '\n', encoding='utf-8')
    records.append(record)
    assert result.returncode == 0, label


lake = 'C:/Users/qed_s/.elan/bin/lake.EXE'
run('environment', [lake, 'env', sys.executable, '-X', 'utf8', '-B', str(Path(__file__)), '--environment'])
run('closure', [lake, 'env', 'lean', '--run', str(P / 'Closure.lean'),
                'ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods'])
closure = json.loads((O / 'closure-stdout.txt').read_bytes())
assert len({item['module'] for item in closure}) == len(closure)
package = R / '.lake/packages/mathlib/.lake/build/lib/lean'
selected = [item for item in closure if item['module'].startswith('Mathlib.')]
artifacts = []
for item in selected:
    olean = Path(item['olean'])
    assert olean.resolve().is_relative_to(package.resolve())
    for suffix in ('.olean', '.olean.private', '.olean.server', '.ir'):
        path = olean.with_suffix(suffix)
        if path.exists():
            artifacts.append(ref(path))
record = {'format': 'actual-cached-module-closure-diagnostic-1', 'at': datetime.now(timezone.utc).isoformat(),
          'all_modules': len(closure), 'mathlib_modules': len(selected), 'artifacts': artifacts,
          'artifact_count': len(artifacts), 'artifact_bytes': sum(item['bytes'] for item in artifacts),
          'commands': records, 'probe': ref(P / 'Closure.lean'), 'runner': ref(Path(__file__)),
          'scope': 'Cached production import closure only. Future overlay isolation and fresh imports not yet tested.',
          'official_prepare': False, 'source_writes': False}
(O / 'receipt.json').write_text(json.dumps(record, indent=2) + '\n', encoding='utf-8')
print(json.dumps({key: record[key] for key in ('all_modules', 'mathlib_modules', 'artifact_count', 'artifact_bytes')}))
