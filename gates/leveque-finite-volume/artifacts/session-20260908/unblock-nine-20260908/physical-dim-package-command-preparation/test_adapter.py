"""Actual isolated POSIX adapter test; no official prepare or semantic roles."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import time

assert os.name != 'nt'
P = Path(__file__).resolve().parent
R = next(path for path in P.parents if (path / 'lean-toolchain').is_file())
adapter = P / 'lean_command.py'
spec = importlib.util.spec_from_file_location('tested_command', adapter)
a = importlib.util.module_from_spec(spec)
spec.loader.exec_module(a)
O = P / sys.argv[1]
O.mkdir(exist_ok=False)
BUILD = Path(tempfile.mkdtemp(prefix='dim-package-command-'))
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
ref = lambda path: {'path': str(path), 'sha256': sha(path), 'bytes': path.stat().st_size}
records, checks = [], []
initial = [ref(adapter), ref(Path(__file__)), ref(R / a.PACKAGE)]
for rel, digest in a.SOURCES.items():
    source = R / '.lake/packages/mathlib' / rel
    assert sha(source) == digest
    initial.append(ref(source))
    target = BUILD / rel
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(source.read_bytes())


def compile_args(source):
    return ['--root', str(BUILD), '-o', str(source.with_suffix('.olean')), str(source)]


def reject(name, arguments):
    try:
        a.command(arguments)
    except ValueError:
        checks.append(name)
        return
    raise AssertionError('Expected rejection: ' + name)


def run(name, args, env):
    argv = [sys.executable, '-B', str(adapter), *args]
    start, started = time.monotonic(), datetime.now(timezone.utc).isoformat()
    with (O / (name + '-stdout.txt')).open('xb') as out, (O / (name + '-stderr.txt')).open('xb') as err:
        completed = subprocess.run(argv, cwd=R, env=env, stdout=out, stderr=err)
    record = {'command': argv, 'dispatched_command': a.command(args), 'cwd': str(R),
              'started_at': started, 'elapsed_ms': int((time.monotonic() - start) * 1000),
              'exit_code': completed.returncode, 'stdout': ref(O / (name + '-stdout.txt')),
              'stderr': ref(O / (name + '-stderr.txt'))}
    (O / (name + '-exit.json')).write_text(json.dumps(record, indent=2) + '\n', encoding='utf-8')
    records.append(record)
    assert completed.returncode == 0, name


ordinary = BUILD / 'Ordinary.lean'
ordinary.write_text('def unboundIdentity (x : α) := x\n', encoding='utf-8')
assert a.command(compile_args(ordinary)) == ['lake', 'env', 'lean', *compile_args(ordinary)]
checks.append('ordinary argv exact; autoImplicit remains default')
for relative in a.SOURCES:
    assert a.command(compile_args(BUILD / relative)) == ['lake', 'env', 'lean', *a.OPTIONS, *compile_args(BUILD / relative)]
    checks.append('only package flags for ' + relative)
renamed = BUILD / 'Renamed.lean'
renamed.write_bytes((BUILD / next(iter(a.SOURCES))).read_bytes())
assert a.command(compile_args(renamed)) == ['lake', 'env', 'lean', *compile_args(renamed)]
checks.append('matching hash at another module name does not dispatch')
mirror = BUILD / next(iter(a.SOURCES))
original = mirror.read_bytes()
mirror.write_bytes(original + b'\n')
reject('changed mirrored bytes rejected', compile_args(mirror))
mirror.write_bytes(original)
reject('source outside build root rejected', ['--root', str(BUILD), '-o', str(BUILD / 'bad.olean'), str(adapter)])
reject('nonstandard output for mirror rejected', ['--root', str(BUILD), '-o', str(BUILD / 'bad.olean'), str(mirror)])
reject('unrecognized flags rejected', ['-DautoImplicit=true', *compile_args(ordinary)])
dossier = BUILD / 'Runner.lean'
dossier.write_text('def main (args : List String) : IO Unit := do\n  IO.println (String.intercalate "," args)\n', encoding='utf-8')
run_args = ['--run', str(dossier), 'AuditTarget', 'Sample.target', str(BUILD / 'local-modules.txt')]
assert a.command(run_args) == ['lake', 'env', 'lean', *run_args]
checks.append('dossier run argv unchanged')
environment = dict(os.environ)
environment['LEAN_PATH'] = str(BUILD) + (':' + environment['LEAN_PATH'] if environment.get('LEAN_PATH') else '')
(O / 'inputs.json').write_text(json.dumps({'inputs': initial, 'build_root': str(BUILD),
    'dispatch_checks': checks, 'LEAN_PATH': environment['LEAN_PATH']}, indent=2) + '\n', encoding='utf-8')
for relative in a.SOURCES:
    run(Path(relative).stem, compile_args(BUILD / relative), environment)
run('ordinary', compile_args(ordinary), environment)
run('dossier', run_args, environment)
assert (O / 'dossier-stdout.txt').read_text().strip() == ','.join(run_args[2:])
assert all(sha(Path(item['path'])) == item['sha256'] for item in initial)
result = {'format': 'exact-package-command-adapter-test-1', 'inputs': initial, 'build_root': str(BUILD),
          'checks': checks, 'records': records, 'all_actual_exit_zero': True, 'inputs_unchanged': True,
          'scratch_outputs': [ref(path) for path in sorted(BUILD.rglob('*')) if path.is_file()],
          'official_preparation': False, 'roles': False, 'canonical_writes': False}
(O / 'receipt.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'receipt': ref(O / 'receipt.json'), 'compile_and_run_count': len(records), 'dispatch_checks': len(checks)}))
