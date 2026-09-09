"""Correct the context title in an additive record; preserve the first record."""
from pathlib import Path
import hashlib
import json
D = Path(__file__).resolve().parent
folder = D / 'directional-complete-repair-review'
old = folder / 'source-context-with-user-high-resolution.json'
assert hashlib.sha256(old.read_bytes()).hexdigest() == '95ab626e7f49eea06d080386316756a21de76e28f15319241ef94d5a0aaf8ed0'
data = json.loads(old.read_bytes())
anchor = data['inherited_locations'][-1]['anchor']
assert anchor.count('Section 6.3 High-Resolution Methods') == 1
data['inherited_locations'][-1]['anchor'] = anchor.replace('Section 6.3 High-Resolution Methods', 'Section 6.3 Preview of Limiters')
new = folder / 'source-context-with-user-high-resolution-v2.json'
with new.open('xb') as stream:
    stream.write((json.dumps(data, indent=2, ensure_ascii=False) + '\n').encode())
print(json.dumps({'path': str(new), 'sha256': hashlib.sha256(new.read_bytes()).hexdigest(),
                  'correction': 'Exact printed Section 6.3 title, checked against both rendered pages by the coordinator.',
                  'previous_record_preserved': True, 'no_prior_audit_input_changed': True}))
