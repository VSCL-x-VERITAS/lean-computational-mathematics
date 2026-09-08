"""Keep the repository's one-space JSON indentation without semantic changes."""
from pathlib import Path
import hashlib, json, subprocess
S = Path(__file__).resolve().parent
R = S.parents[3]
p = R / 'docs/architecture/tiers.json'
before = p.read_bytes()
baseline = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', 'HEAD:docs/architecture/tiers.json'], cwd=R)
assert baseline.startswith(b'{\n "counts":')
value = json.loads(before)
after = (json.dumps(value, indent=1, ensure_ascii=False)+'\n').encode('utf-8')
assert json.loads(before) == json.loads(after)
(S / ('tiers-before-format-' + hashlib.sha256(before).hexdigest() + '.json')).write_bytes(before)
p.write_bytes(after)
record = {'path': p.relative_to(R).as_posix(), 'before_sha256': hashlib.sha256(before).hexdigest(),
    'sha256': hashlib.sha256(after).hexdigest(), 'parsed_json_unchanged': True,
    'change': 'Preserve baseline indent=1. Exact roles, rules, counts and introduction metadata unchanged.'}
(S / 'production-tier-format-receipt.json').write_text(json.dumps(record, indent=2)+'\n')
print(json.dumps(record))
