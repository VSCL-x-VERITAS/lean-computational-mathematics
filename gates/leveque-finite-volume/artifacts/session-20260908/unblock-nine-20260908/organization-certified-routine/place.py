"""Classify and stage only the frozen four-file certified Riemann routine increment."""
from pathlib import Path
from datetime import datetime, timezone
import collections
import hashlib
import json
import os
import subprocess
import sys

assert os.name != 'nt', 'Use the POSIX launcher for worktree Git.'
F = Path(__file__).resolve().parent
D = F.parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def create(path, data):
    with path.open('xb') as stream:
        stream.write(data)
def writej(path, data):
    create(path, (json.dumps(data, indent=2) + '\n').encode())
def pinned(item):
    assert set(item) == {'path', 'sha256'}
    p = (R / item['path']).resolve()
    assert p.is_relative_to(R.resolve()) and p.is_file() and not p.is_symlink()
    assert ref(p) == item
    return p
assert len(sys.argv) == 3, 'PLAN_JSON PLAN_SHA256'
plan_path = Path(sys.argv[1]).resolve()
assert plan_path.parent == F.resolve() and sha(plan_path) == sys.argv[2]
plan = read(plan_path)
assert plan['format'] == 'certified-routine-organization-placement-plan-1'
assert plan['runner'] == ref(Path(__file__).resolve())
assert plan['input_commit'] == '5e3f63594aa964263469ada134aee2809559d50d'
assert plan['review'] == ref(F / 'REVIEW.md')
pinned(plan['production_receipt'])
files_path = pinned(plan['production_files'])
files = read(files_path)['files']
assert len(files) == 4 and len({x['path'] for x in files}) == 4
expected = {
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalRiemannRoutineAccuracy.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CertifiedRiemannRoutineUpdate.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples/BiasedCertifiedRiemannRoutine.lean',
    'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannCertifiedRoutineInterface.lean'}
assert {x['path'] for x in files} == expected
for item in files:
    assert item['module'] == item['path'].removesuffix('.lean').replace('/', '.')
    assert sha(R / item['path']) == item['sha256']
    assert item['declarations'] and len(set(item['declarations'])) == len(item['declarations'])
assert sum(len(x['declarations']) for x in files) == 7
git = lambda *args: subprocess.check_output(['git', '-c', 'core.longpaths=true', *args], cwd=R)
head = git('rev-parse', 'HEAD').decode().strip()
assert head == plan['input_commit']
assert git('branch', '--show-current').decode().strip() == 'work/formalization/leveque-finite-volume/1/codex'
for item in plan['before']:
    pinned(item)
expected_before = {
    'docs/architecture/tiers.json': 'dec437407b4f6432b291921fbe807114c9bfcb5b808bf5da4ae0f055e1d00c2a',
    'ComputationalMathematics/Analysis.lean': 'b47a4ed8b1c7403278b71016292a5cb6b945342cc2b37d67a728245b85d480de',
    'ComputationalMathematics/Source/LeVeque/Chapter01.lean': '0d9c7704cd7afd0705f1aef4a8ec53c30389c6bd25ca4949f9474b52e2ea6bb9'}
assert {x['path']: x['sha256'] for x in plan['before']} == expected_before
sys.path.insert(0, str(R / 'tools/architecture'))
import check_tiers as tiers
tier_path = R / 'docs/architecture/tiers.json'
manifest = read(tier_path)
tracked = set(tiers.production_modules(R))
new_modules = {item['module'] for item in files}
assert not tracked & new_modules, 'Unexpected pre-existing or concurrently staged owner'
modules = sorted(tracked | new_modules)
prefixes = {item['prefix']: item['tier'] for item in manifest['prefixes']}
reusable = sorted(item['module'] for item in files if '/Analysis/' in item['path'])
source = [item['module'] for item in files if '/Source/' in item['path']]
assert len(reusable) == 3 and len(source) == 1
unclassified = [name for name in modules if tiers.resolve(name, manifest['exact'], prefixes)[0] == 'unclassified']
assert sorted(unclassified) == reusable
assert tiers.resolve(source[0], manifest['exact'], prefixes)[0] == 'source'
now = datetime.now(timezone.utc).isoformat()
for name in reusable:
    assert not tiers.matching_prefixes(name, prefixes)
    manifest['exact'][name] = 'reusable'
    manifest['exact_rules'].append({'rule_id': 'exact:' + name, 'match_kind': 'exact', 'module': name,
        'role': 'reusable',
        'rationale': 'Generic supplied Riemann routine accuracy, certified local finite-volume error comparison or biased admissible example; the book-specific contract resides in Source/LeVeque.',
        'introduction': {'commit': head, 'date': now, 'determined_by': 'current_worktree_addition_at_recorded_input_commit'},
        'review': {'reviewer': 'Codex root executing the authorized Chapter 1 organization loop',
                   'status': 'accepted', 'review_date': now, 'evidence': plan['review']['path']},
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
    merged = imports.copy()
    for addition in sorted(new_imports):
        predecessors = [line for line in merged if line < addition]
        position = merged.index(max(predecessors)) + 1 if predecessors else 0
        merged.insert(position, addition)
    assert [line for line in merged if line not in new_imports] == imports
    final = ''.join(lines[:indices[0]]) + '\n'.join(merged) + '\n' + ''.join(lines[indices[-1] + 1:])
    assert len(final.splitlines()) == len(old.splitlines()) + len(additions)
    changes.append((path, final.encode()))
# All scope and current-byte guards finish before any production/index mutation.
before = []
for i, (path, _) in enumerate(changes):
    snapshot = F / ('before-' + str(i) + '.snapshot')
    create(snapshot, path.read_bytes())
    before.append({'file': ref(path), 'snapshot': ref(snapshot)})
assert git('rev-parse', 'HEAD').decode().strip() == head
for item in plan['before']:
    pinned(item)
for item in files:
    assert sha(R / item['path']) == item['sha256']
for path, raw in changes:
    path.write_bytes(raw)
paths = [item['path'] for item in files] + [path.relative_to(R).as_posix() for path, _ in changes]
git('add', '--', *paths)
for name in paths:
    assert git('show', ':' + name) == (R / name).read_bytes(), name
writej(F / 'receipt.json', {'format': 'certified-routine-organization-placement-1', 'input_commit': head,
    'plan': ref(plan_path), 'runner': ref(Path(__file__)), 'before': before,
    'after': [ref(path) for path, _ in changes], 'staged_exact_paths': paths,
    'counts': manifest['counts'], 'actual_tier_validation_failures': [], 'source_acceptance': False,
    'released_layout_and_build_checks_pending': True})
print(json.dumps(read(F / 'receipt.json')))
