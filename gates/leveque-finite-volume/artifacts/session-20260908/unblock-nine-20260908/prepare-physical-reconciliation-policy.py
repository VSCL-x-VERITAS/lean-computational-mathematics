"""Prepare current fingerprint selection for later actual committed-origin capture."""
from pathlib import Path
import hashlib, json, os
assert os.name == 'posix'
D = Path(__file__).resolve().parent
R = D.parent.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
read = lambda p: json.loads(p.read_bytes())
def create(p, obj):
    with p.open('xb') as f: f.write((json.dumps(obj, indent=2) + '\n').encode())
prior_path = D / 'final-reconciliation-mapping-inputs/preparation-policy.json'
prior = read(prior_path)
inventory_path = D / 'physical-syntax-fingerprints/current-expression-fingerprints.json'
assert sha(inventory_path) == '26817e845567840e94977e03a12fd89bb7b8ea3ba0ddc88d20c401e05036ac01'
inventory = read(inventory_path)
assert len(inventory['files']) == 183 and len(inventory['records']) == 1688
assert len({x['name'] for x in inventory['records']}) == 1688
for item in inventory['files']: assert sha(R / item['path']) == item['sha256']
assert len(prior['current_work_fingerprint_refs']) == 7
historical_owners = set()
for item in prior['current_work_fingerprint_refs']:
    assert sha(R / item['path']) == item['sha256']
    historical_owners.update(f['path'] for f in read(R / item['path'])['files'])
assert historical_owners <= {f['path'] for f in inventory['files']}
policy = json.loads(json.dumps(prior))
policy['origin_fingerprint_paths'][policy['merge_lane']] = [ref(inventory_path)['path']]
policy['current_work_fingerprint_refs'] = [ref(inventory_path)]
assert policy['origin_fingerprint_paths']['reorganization-baseline-inspection'] == prior['origin_fingerprint_paths']['reorganization-baseline-inspection']
assert {k:v for k,v in policy.items() if k not in ('origin_fingerprint_paths','current_work_fingerprint_refs')} == {k:v for k,v in prior.items() if k not in ('origin_fingerprint_paths','current_work_fingerprint_refs')}
out = D / 'physical-reconciliation-policy-preparation'
out.mkdir(exist_ok=False)
create(out / 'preparation-policy.json', policy)
create(out / 'derivation.json', {
 'format': 'physical-current-origin-fingerprint-selection-1',
 'prior_policy': ref(prior_path), 'successor_policy': ref(out / 'preparation-policy.json'),
 'current_inventory': ref(inventory_path), 'current_records': 1688, 'current_owners': 183,
 'retained_historical_owner_paths': len(historical_owners),
 'change': 'Replace seven historical/current overlapping fingerprint selections with the one exact consolidated current inventory for the merge lane. Preserve the inspection lane and every other policy field.',
 'unchanged_semantics': 'Existing declaration and nondeclaration mapping rules and Eq1.3 overrides remain unchanged. This selection does not assert equivalence of changed declarations or source acceptance.',
 'actual_origin_capture_performed': False, 'future_head_supplied': False,
 'commit_or_git_mutation': False, 'source_acceptance': False,
 'pending': 'Actual 41-row accepted closure, reviewed organization, ordinary source/evidence commit, committed-blob checks, actual origin inventories and separate structural catalogue review remain required.'})
create(out / 'receipt.json', {'policy':ref(out/'preparation-policy.json'), 'derivation':ref(out/'derivation.json')})
print(json.dumps(read(out/'receipt.json')))

