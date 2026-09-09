"""Actual POSIX fixture; never prepares an audit or runs a semantic role."""
from pathlib import Path
import hashlib
import importlib.util
import json
import os
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime, timezone

P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
D = P.parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
assert os.name != 'nt' and Path.cwd().resolve() == R
out = P / 'fixture-03'
out.mkdir()
spec = importlib.util.spec_from_file_location('adapter', P / 'lean_runtime.py')
adapter = importlib.util.module_from_spec(spec)
spec.loader.exec_module(adapter)
checks = []
def rejects(label, fn):
    try:
        fn()
    except ValueError as error:
        checks.append({'name': label, 'rejected': True, 'reason': str(error)})
    else:
        raise AssertionError(label)

with tempfile.TemporaryDirectory(prefix='formalization-faithfulness-guard-') as root:
    b = Path(root)
    assert adapter.infer_build(['--root', str(b), '-o', str(b / 'A.olean'), str(b / 'A.lean')], {'LEAN_PATH': str(b) + ':original'}) == b
    assert adapter.infer_build(['--run', 'dossier.lean'], {'LEAN_PATH': str(b) + ':original'}) == b
    assert adapter.infer_build(['--version'], {}) is None
    rejects('root mismatch', lambda: adapter.infer_build(['--root', str(b.parent)], {'LEAN_PATH': str(b)}))
    rejects('dossier no root', lambda: adapter.infer_build(['--run', 'dossier.lean'], {}))
    rejects('arbitrary existing directory', lambda: adapter.infer_build(['--root', str(R)], {'LEAN_PATH': str(R)}))
    rejects('missing snapshots', lambda: adapter.verify_fresh({'compiled': []}, {'expected_compiles': [{'module': 'A'}]}, b))

descriptor = json.loads((P / 'runtime-descriptor-v3.json').read_bytes())
fixture_source = D / 'physical-dim-overlay-diagnostic/AuditTarget.lean'
descriptor['expected_compiles'] = [x for x in descriptor['expected_compiles'] if x['module'].startswith('Mathlib.')]
descriptor['expected_compiles'].append({'module': 'AuditTarget', 'relative_source': 'AuditTarget.lean', 'source': ref(fixture_source)})
descriptor['task_id'] = 'DIAGNOSTIC-ONLY-NO-AUDIT-TASK'
descriptor['runtime_records'] = (out / 'runtime-records').relative_to(R).as_posix()
descriptor['fixture_only'] = True
descriptor_path = out / 'fixture-descriptor.json'
descriptor_path.write_text(json.dumps(descriptor, indent=2) + '\n')
command = ['python3', '-B', str(P / 'lean_runtime.py'), '--descriptor', str(descriptor_path), '--descriptor-sha256', sha(descriptor_path)]
records = []
def run(label, args, env, expected):
    started = datetime.now(timezone.utc).isoformat()
    completed = subprocess.run(command + args, cwd=R, env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (out / (label + '-stdout.txt')).write_bytes(completed.stdout)
    (out / (label + '-stderr.txt')).write_bytes(completed.stderr)
    item = {'label': label, 'command': command + args, 'started_at': started, 'finished_at': datetime.now(timezone.utc).isoformat(),
            'actual_exit_code': completed.returncode, 'expected_exit_code': expected,
            'stdout': ref(out / (label + '-stdout.txt')), 'stderr': ref(out / (label + '-stderr.txt'))}
    (out / (label + '-receipt.json')).write_text(json.dumps(item, indent=2) + '\n')
    records.append(item)
    print(json.dumps({'label': label, 'actual_exit_code': completed.returncode}), flush=True)
    assert completed.returncode == expected, label
    return completed

environment = dict(os.environ)
run('version', ['--version'], environment, 0)
captured = adapter.capture_environment(command[3:7])
(out / 'safe-captured-environment.json').write_text(json.dumps(captured, indent=2) + '\n')
assert ';' in captured['environment']['LEAN_PATH'], 'Actual Lake environment is not native semicolon form'
build = R / '.lake/formalization-faithfulness-runtime-fixture03'
build.mkdir()
environment['LEAN_PATH'] = str(build) + ':' + os.environ.get('LEAN_PATH', '')
for item in descriptor['expected_compiles']:
    destination = build / item['relative_source']
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(R / item['source']['path'], destination)
    run(item['module'].rsplit('.', 1)[-1], ['--root', str(build), '-o', str(destination.with_suffix('.olean')), str(destination)], environment, 0)
locals_path = out / 'local-modules.txt'
locals_path.write_text('Mathlib.Analysis.Calculus.ContDiff.Defs\nMathlib.Analysis.Calculus.ContDiff.FTaylorSeries\n')
dossier = R / '.faithfulness-audit/scripts/declaration_dossier.lean'
run('dossier', ['--run', str(dossier), 'AuditTarget', 'auditOverlayFixture', str(locals_path)], environment, 0)
state = json.loads((build / '.exact-lean-runtime.json').read_bytes())
assert len(state['compiled']) == 3
postchecks = [json.loads(p.read_bytes()) for p in Path(state['records_directory']).glob('*-postcheck.json')]
assert any(x.get('final_original_pins_unchanged') and x.get('all_expected_snapshots_fresh') == 3 for x in postchecks)
(out / 'receipt.json').write_text(json.dumps({'status': 'ACTUAL-POSIX-DIRECT-LEAN-FIXTURE-PASSED-NOT-AUDIT',
    'adapter': ref(P / 'lean_runtime.py'), 'descriptor': ref(descriptor_path), 'build': str(build),
    'guard_checks': checks, 'actual_records': records, 'safe_environment': ref(out / 'safe-captured-environment.json'),
    'original_closure_verified_at_initialization_and_final_dossier': True}, indent=2) + '\n')
print(json.dumps(ref(out / 'receipt.json')), flush=True)

