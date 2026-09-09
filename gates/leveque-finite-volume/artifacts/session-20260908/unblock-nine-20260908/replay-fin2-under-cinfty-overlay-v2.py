"""Native lake child: exact Fin2 fixture, frozen C-infinity compiled overlay."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, re, shutil, subprocess, sys, time

assert os.name == 'nt' and os.environ.get('LEAN_PATH')
D = Path(__file__).resolve().parent
R = D.parent.parents[3]
O = D / 'dim-five-owner-overlay'
dest = D / 'dim-two-direction-cinfty-replay-02'
assert not dest.exists()
native = lambda p: '\\\\?\\' + os.path.abspath(p) if not os.path.abspath(p).startswith('\\\\?\\') else os.path.abspath(p)
def raw(p):
    with open(native(p), 'rb') as f:
        return f.read()
sha = lambda p: hashlib.sha256(raw(p)).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
assert sha(O / 'receipt.json') == '6d84c698bd2ddc3e203709f6686e85264b6da5f908fe5dc20d76b18348251e17'
assert sha(O / 'compiled-module-map.json') == '8a3964e7f6a9402aeb0a0ac7075f076e8044f0c9bcc90cb8fbd655dd9db3af01'
candidate = D / 'dim-two-direction-joint-witness/Candidate.lean'
assert sha(candidate) == '48d57797ff3c2074dabb6f72417f4eba54c8131b588dc59cf47d67d9ecc1a6fe'
module_map = json.loads(raw(O / 'compiled-module-map.json'))
bindings = {}
def walk(obj):
    if isinstance(obj, dict):
        if isinstance(obj.get('path'), str) and isinstance(obj.get('sha256'), str):
            assert obj['path'] not in bindings or bindings[obj['path']] == obj['sha256']
            bindings[obj['path']] = obj['sha256']
        for value in obj.values():
            walk(value)
    elif isinstance(obj, list):
        for value in obj:
            walk(value)
walk(module_map)
def verify():
    for path, digest in bindings.items():
        assert sha(R / path) == digest, path
verify()
dest.mkdir()
copy = dest / 'Candidate.lean'
with open(native(copy), 'xb') as f:
    f.write(raw(candidate))
env = dict(os.environ)
env['LEAN_PATH'] = native(O / 'overlay/lib03') + os.pathsep + env['LEAN_PATH']
lean = shutil.which('lean')
assert lean
record = {'format': 'fin2-cinfty-overlay-replay-1', 'overlay_receipt': ref(O / 'receipt.json'),
          'candidate': ref(copy), 'bindings_before': bindings, 'steps': [],
          'canonical_placement': False, 'source_acceptance': False,
          'started_at_utc': datetime.now(timezone.utc).isoformat()}
with open(native(dest / 'before.json'), 'xb') as f:
    f.write((json.dumps(record, indent=2) + '\n').encode())
def run(name, args):
    command = [lean, *args]
    start = time.monotonic()
    with open(native(dest / (name + '-output.txt')), 'xb') as stdout, open(native(dest / (name + '-stderr.txt')), 'xb') as stderr:
        p = subprocess.run(command, cwd=R, env=env, stdout=stdout, stderr=stderr)
    item = {'name': name, 'command': command, 'exit_code': p.returncode, 'elapsed_seconds': time.monotonic() - start,
            'stdout': ref(dest / (name + '-output.txt')), 'stderr': ref(dest / (name + '-stderr.txt'))}
    record['steps'].append(item)
    with open(native(dest / (name + '-exit.json')), 'xb') as f:
        f.write((json.dumps(item, indent=2) + '\n').encode())
    print(json.dumps(item), flush=True)
    assert p.returncode == 0, name
    verify()
    return raw(dest / (name + '-output.txt')).decode('utf-8')
deps = run('direct-dependencies', ['--deps', native(copy)])
project_deps = [line for line in deps.splitlines() if 'ComputationalMathematics' in line]
assert len(project_deps) == 2
assert all('/overlay/lib03/' in line.replace('\\', '/') for line in project_deps)
probe = O / 'overlay/IsolationProbe.lean'
record['isolation_probe'] = ref(probe)
run('isolation', [native(probe)])
output = run('full-joint', [native(copy)])
assert 'error:' not in output and 'warning:' not in output and 'sorryAx' not in output
expected = [item['name'] for item in json.loads(raw(D / 'dim-two-direction-joint-witness/declarations.json'))['declarations']]
reports = re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", output)
assert len(reports) == len(expected) == 52
assert [name for name, axioms in reports] == expected
for name, axioms in reports:
    assert set(a.strip() for a in axioms.split(',') if a.strip()) <= {'propext', 'Classical.choice', 'Quot.sound'}
assert sha(copy) == sha(candidate)
verify()
record.update(exit_code=0, declarations=52, bindings_unchanged=True, completed_at_utc=datetime.now(timezone.utc).isoformat(),
              limits='Exact Fin2 full application under corrected C-infinity/explicit-choice definitions. Admission, fixed-level accuracy and broad geometry-domain findings remain separate.')
with open(native(dest / 'receipt.json'), 'xb') as f:
    f.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'receipt': ref(dest / 'receipt.json'), 'exit_code': 0, 'declarations': 52}), flush=True)
