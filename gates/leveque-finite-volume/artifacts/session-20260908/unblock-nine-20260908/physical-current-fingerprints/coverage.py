"""Read-only coverage boundary for current physical DIM fingerprints; POSIX Git only."""
from pathlib import Path
import collections
import hashlib
import json
import os
import subprocess

F = Path(__file__).resolve().parent
D = F.parent
S = D.parent
R = next(p for p in F.parents if (p / 'lean-toolchain').exists())
assert os.name == 'posix'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def ref(path):
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}


def write(name, value):
    with (F / name).open('x', encoding='utf-8', newline='\n') as stream:
        json.dump(value, stream, indent=2, ensure_ascii=False)
        stream.write('\n')
    return ref(F / name)


pins_path = D / 'final-reconciliation-mapping-inputs/observed-01/fingerprint-inputs.json'
pins = json.loads(pins_path.read_bytes())
assert len(pins) == 7
known = {}
names = {}
prior = []
for entry in pins:
    pin = entry['inventory']
    path = R / pin['path']
    assert sha(path) == pin['sha256']
    obj = json.loads(path.read_bytes())
    assert len(obj['files']) == entry['owners'] and len(obj['records']) == entry['records']
    for owner in obj['files']:
        assert owner['path'] not in known, 'Duplicate old owner'
        known[owner['path']] = {'prior_inventory': pin, 'prior_owner': owner,
            'current': ref(R / owner['path']),
            'source_unchanged': sha(R / owner['path']) == owner['sha256']}
    for row in obj['records']:
        assert row['name'] not in names, 'Duplicate old declaration'
        names[row['name']] = {'module': row['module'], 'prior_inventory': pin}
    prior.append({'inventory': pin, 'owners': len(obj['files']), 'records': len(obj['records'])})
assert len(known) == 171 and len(names) == 1426

build_path = D / 'physical-production-promotion/owners-native-03-receipt.json'
assert sha(build_path) == '662dfeb7725a719f41547caab64d62b321a4c6642ae4712fbd2d5de2b58d0abb'
build = json.loads(build_path.read_bytes())
assert build['actual_exit_code'] == 0
for owner in build['input_sources']:
    assert sha(R / owner['path']) == owner['sha256']
old_dim = json.loads((D / 'dim-high-resolution-fingerprints/additional-expression-fingerprints.json').read_bytes())
selected_paths = set(owner['path'] for owner in old_dim['files']) | set(
    owner['path'] for owner in build['input_sources'])
assert len(selected_paths) == 29
stale = [item for item in known.values() if not item['source_unchanged']]
unexpected = [item for item in stale if item['prior_owner']['path'] not in selected_paths]
new = selected_paths - set(known)
assert len(new) == 12
selected = [dict(**ref(R / path), module=path[:-5].replace('/', '.'),
                 prior=known.get(path), new=path in new) for path in sorted(selected_paths)]
head_cmd = ['git', '--no-optional-locks', 'rev-parse', 'HEAD']
head = subprocess.run(head_cmd, cwd=R, capture_output=True)
assert head.returncode == 0
assert head.stdout.decode().strip() == '5e3f63594aa964263469ada134aee2809559d50d'
report = {'schema': 1, 'status': 'STOP: unexpected stale owners' if unexpected else 'EXPECTED SCOPE ONLY',
    'seven_input_manifest': ref(pins_path), 'prior_inventories': prior,
    'prior_owner_count': len(known), 'prior_record_count': len(names),
    'current_build': ref(build_path), 'selected_owner_count': len(selected),
    'selected_owners': selected, 'new_owner_count': len(new),
    'all_stale_prior_owners': stale, 'unexpected_stale_prior_owners': unexpected,
    'retained_prior_owners': [item for path, item in sorted(known.items()) if path not in selected_paths],
    'intended_result': 'One consolidated inventory: remove every old record owned by any selected module, export all current 29 selected owners with the unchanged serializer/filter/parser, then combine with unchanged remaining owner records; no duplicate or stale owner rows.',
    'head_command': head_cmd, 'head_actual_exit': head.returncode,
    'head_stdout_sha256': hashlib.sha256(head.stdout).hexdigest(),
    'head_stderr_sha256': hashlib.sha256(head.stderr).hexdigest(),
    'input_commit': head.stdout.decode().strip(), 'production_mutation': False, 'source_acceptance': False}
result = write('coverage.json', report)
print(json.dumps({'coverage': result, 'selected': len(selected), 'new': len(new),
                  'stale_within_scope': len(stale) - len(unexpected),
                  'unexpected_stale': [item['prior_owner']['path'] for item in unexpected]}, indent=2))
assert not unexpected, 'Report to root before extending scope'
