"""Verify frozen cache review references and retain root's bounded conclusion."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;P=S/'generated-capstone-cache-review'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
assert sha(P/'manifest.json')=='e2fbbf162beca25179499c53fcb5a04276cc16d6f072ca3af8fb9a9aef0f2f21'
m=read(P/'manifest.json')
for x in m['inputs']:assert sha(Path(x['path']))==x['sha256']
for x in m['files']:assert sha(P/x['path'])==x['sha256']
assert type(m['actual_review_exit']) is int and m['actual_review_exit']==0
e=read(P/'check-01.exit.json');assert type(e['exit_code']) is int and e['exit_code']==0
out=S/'root-generated-capstone-cache-review.json'
v=dict(schema=1,status='BOUNDED_REVIEW_COMPLETE',manifest_sha256=sha(P/'manifest.json'),native_review_exit=0,root_review='Read full independent reference review, check program, preservation map and restore helper. These are historical generated outputs, not canonical imported owners. Exact snapshots and exclusive missing-path restoration preserve old hash-bound verifiers; local exclusions and unchanged absolute-path relocation limits are explicit. Current layout retry and current exact existing-cache verification passed. No source or frozen audit alteration is required.',source_acceptance=False)
with out.open('x',encoding='utf-8') as f:json.dump(v,f,indent=2);f.write('\n')
print(json.dumps(dict(status=v['status'],sha256=sha(out))))

