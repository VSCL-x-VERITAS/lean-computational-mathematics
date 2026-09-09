"""Place four frozen Routine leaves, classify their tiers and stage exact bytes."""
from pathlib import Path
from datetime import datetime, timezone
import collections
import hashlib
import json
import os
import subprocess
import sys
F = Path(__file__).resolve().parent
D = F.parent
S = D.parent
R = S.parents[3]
assert os.name != 'nt', 'Use the POSIX launcher for Git and released architecture tools.'
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
read = lambda path: json.loads(path.read_bytes())
ref = lambda path: {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
def create(path, raw):
    with path.open('xb') as stream:
        stream.write(raw)
def writej(path, data):
    create(path, (json.dumps(data, indent=2) + '\n').encode())
production = read(D / 'riemann-routine-production/receipt.json')
assert sha(D / 'riemann-routine-production/receipt.json') == '133d9adc7f9d23c16412193f571f0ad21d59a633827940586c0d4f1a391a08ba'
files = read(D / 'riemann-routine-production/files.json')['files']
assert len(files) == 4 and sum(len(item['declarations']) for item in files) == 22
for item in files:
    assert sha(R / item['path']) == item['sha256'] == production['final_production_hashes'][item['path']]
git = lambda *args: subprocess.check_output(['git', '-c', 'core.longpaths=true', *args], cwd=R)
head = git('rev-parse', 'HEAD').decode().strip()
assert head == '5e3f63594aa964263469ada134aee2809559d50d'
# The existing architecture census intentionally lists tracked files only.
git('add', '--', *[item['path'] for item in files])
for item in files:
    assert git('show', ':' + item['path']) == (R / item['path']).read_bytes()
sys.path.insert(0, str(R / 'tools/architecture'))
import check_tiers as tiers
tier_path = R / 'docs/architecture/tiers.json'
assert sha(tier_path) == '6868cb2ae8fcace8f06c4fcaf2b4d68cad1ee89a392dd59d70f0e5efe4136494'
manifest = read(tier_path)
modules = tiers.production_modules(R)
prefixes = {item['prefix']: item['tier'] for item in manifest['prefixes']}
reusable = sorted(item['module'] for item in files if '/Analysis/' in item['path'])
source = [item['module'] for item in files if '/Source/' in item['path']]
assert len(reusable) == 3 and len(source) == 1
unclassified = [name for name in modules if tiers.resolve(name, manifest['exact'], prefixes)[0] == 'unclassified']
assert sorted(unclassified) == reusable
assert tiers.resolve(source[0], manifest['exact'], prefixes)[0] == 'source'
now = datetime.now(timezone.utc).isoformat()
review = (F / 'REVIEW.md').relative_to(R).as_posix()
for name in reusable:
    assert not tiers.matching_prefixes(name, prefixes)
    manifest['exact'][name] = 'reusable'
    manifest['exact_rules'].append({'rule_id': 'exact:' + name, 'match_kind': 'exact', 'module': name,
        'role': 'reusable', 'rationale': 'Generic numerical Riemann information routine, local error propagation, or biased scalar example; the book-specific contract resides in Source/LeVeque.',
        'introduction': {'commit': head, 'date': now, 'determined_by': 'current_worktree_addition_at_recorded_input_commit'},
        'review': {'reviewer': 'Codex root executing the authorized Chapter 1 organization loop',
                   'status': 'accepted', 'review_date': now, 'evidence': review},
        'exception': None, 'file_present': True})
manifest['exact'] = dict(sorted(manifest['exact'].items()))
manifest['exact_rules'].sort(key=lambda item: item['rule_id'])
roles, decisions = collections.Counter(), collections.Counter()
for name in modules:
    role, rule_id = tiers.resolve(name, manifest['exact'], prefixes)
    assert role not in ('unclassified', 'mixed')
    roles[role] += 1
    decisions[rule_id] += 1
for rule in manifest['prefix_rules']:
    rule['modules_decided'] = decisions[rule['rule_id']]
manifest['counts'] = {'by_role': dict(sorted(roles.items())), 'exact_rules': len(manifest['exact']),
    'exact_rules_with_absent_file': sum(not (R / (name.replace('.', '/') + '.lean')).is_file() for name in manifest['exact']),
    'prefix_rules': len(prefixes), 'prefix_rules_deciding_nothing': sum(decisions['prefix:' + prefix] == 0 for prefix in prefixes),
    'production_modules': len(modules)}
assert not tiers.validate(R, manifest, modules)
changes = [(tier_path, (json.dumps(manifest, indent=1, ensure_ascii=False) + '\n').encode())]
for path, additions in [(R / 'ComputationalMathematics/Analysis.lean', reusable),
                        (R / 'ComputationalMathematics/Source/LeVeque/Chapter01.lean', source)]:
    old = path.read_text(encoding='utf-8')
    lines = old.splitlines(keepends=True)
    indices = [i for i, line in enumerate(lines) if line.startswith('import ')]
    assert indices == list(range(indices[0], indices[-1] + 1))
    imports = [line.rstrip('\n') for line in lines[indices[0]:indices[-1] + 1]]
    new_imports = ['import ' + name for name in additions]
    assert not set(imports) & set(new_imports)
    merged_imports = imports.copy()
    for addition in sorted(new_imports):
        predecessors = [line for line in merged_imports if line < addition]
        position = merged_imports.index(max(predecessors)) + 1 if predecessors else 0
        merged_imports.insert(position, addition)
    assert [line for line in merged_imports if line not in new_imports] == imports
    final = ''.join(lines[:indices[0]]) + '\n'.join(merged_imports) + '\n' + ''.join(lines[indices[-1] + 1:])
    assert len(final.splitlines()) == len(old.splitlines()) + len(additions)
    changes.append((path, final.encode()))
before = []
for i, (path, _) in enumerate(changes):
    snapshot = F / ('before-' + str(i) + '.snapshot')
    create(snapshot, path.read_bytes())
    before.append({'file': ref(path), 'snapshot': ref(snapshot)})
for path, raw in changes:
    path.write_bytes(raw)
paths = [item['path'] for item in files] + [path.relative_to(R).as_posix() for path, _ in changes]
git('add', '--', *paths)
for name in paths:
    assert git('show', ':' + name) == (R / name).read_bytes(), name
receipt = {'format': 'routine-organization-placement-1', 'input_commit': head, 'review': ref(F / 'REVIEW.md'),
           'production_receipt': ref(D / 'riemann-routine-production/receipt.json'),
           'before': before, 'after': [ref(path) for path, _ in changes],
           'staged_exact_paths': paths, 'counts': manifest['counts'], 'actual_tier_validation_failures': [],
           'source_acceptance': False, 'released_layout_and_build_checks_pending': True}
writej(F / 'receipt.json', receipt)
print(json.dumps(receipt))
