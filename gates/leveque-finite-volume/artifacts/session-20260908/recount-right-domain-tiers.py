"""Refresh only measured tier census after a source-prefix-covered module addition."""
from pathlib import Path
import collections, hashlib, json, sys
S = Path(__file__).resolve().parent
R = S.parents[3]
sys.path.insert(0, str(R / 'tools/architecture'))
import check_tiers
path = R / 'docs/architecture/tiers.json'
before = path.read_bytes()
manifest = json.loads(before)
modules = check_tiers.production_modules(R)
prefixes = {r['prefix'].rstrip('.'): r['tier'] for r in manifest['prefixes']}
roles, decided = collections.Counter(), collections.Counter()
for module in modules:
    role, rule = check_tiers.resolve(module, manifest['exact'], prefixes)
    assert role != 'unclassified', module
    roles[role] += 1
    decided[rule] += 1
for rule in manifest['prefix_rules']:
    rule['modules_decided'] = decided[rule['rule_id']]
manifest['counts']['by_role'] = dict(sorted(roles.items()))
manifest['counts']['production_modules'] = len(modules)
assert len(modules) == 5921 and roles['source'] == 1505
assert manifest['counts']['exact_rules'] == 4927
assert not check_tiers.validate(R, manifest, modules)
snapshot = S / ('tiers-before-right-domain-recount-' + hashlib.sha256(before).hexdigest() + '.json')
assert not snapshot.exists()
snapshot.write_bytes(before)
payload = (json.dumps(manifest, indent=1, ensure_ascii=False)+'\n').encode()
path.write_bytes(payload)
receipt = {'schema':1, 'new_exact_rules':0, 'reason':'The reviewed source prefix already classifies the new wrapper; update the measured census and prefix use count.',
    'before_sha256':hashlib.sha256(before).hexdigest(), 'sha256':hashlib.sha256(payload).hexdigest(), 'counts':manifest['counts']}
(S / 'right-domain-tier-recount.json').write_text(json.dumps(receipt, indent=2)+'\n', encoding='utf-8')
print(json.dumps(receipt))

