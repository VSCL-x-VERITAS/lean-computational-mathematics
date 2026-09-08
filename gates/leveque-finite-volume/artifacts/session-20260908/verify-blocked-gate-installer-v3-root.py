"""Verify the frozen independent installer review; perform no installation."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os
S=Path(__file__).resolve().parent;P=S/'blocked-gate-installer-independent-review'
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
m=P/'manifest.json';f=P/'final-receipt.json'
assert sha(m)=='1479a592c7b0bb42b09930991ecf2d083f6a891078e4acd93e3e4a0c22f5408a'
assert sha(f)=='302e65e3c308d7b60eec4b9d383263355cf3684c8de57732e73add0a68117019'
v=read(m);receipt=read(f)
assert type(v['actual_test_exit']) is int and v['actual_test_exit']==0 and v['checks']==13
for x in v['subjects']:assert sha(Path(x['path']))==x['sha256'],x
for x in v['files']:
 p=P/x['path'];assert sha(p)==x['sha256'] and p.stat().st_size==x['bytes'],x
e=read(P/'checks-01.exit.json')
assert type(e['exit_code']) is int and e['exit_code']==0
assert receipt['manifest_sha256']==sha(m)
assert receipt['review_sha256']==sha(P/'REVIEW.md')
assert receipt['checks_sha256']==sha(P/'checks.json')
assert receipt['exit_receipt_sha256']==sha(P/'checks-01.exit.json')
assert receipt['operational_installer_executed'] is False
out=S/'root-blocked-gate-installer-v3-review.json'
r=dict(schema=1,status='BOUNDED_REVIEW_COMPLETE',reviewed_at_utc=datetime.now(timezone.utc).isoformat(),manifest_sha256=sha(m),receipt_sha256=sha(f),installer_sha256=sha(S/'install-reviewed-blocked-gate-v3.py'),checks=13,actual_exit=0,root_review='Read the full V3 installer and independent check program and review. Exact cross-gate snapshot before released validation and repeated equality immediately before replacement address the isolated V1/V2 gaps. Root remains sole cooperative operational gate writer. This verifies frozen static/isolated evidence only; no actual preparation, installation or terminal certification performed.',source_acceptance=False,operational_installer_executed=False,limitations=['Cooperative single gate writer, not a multi-file transaction','After-replacement crash can leave installed bytes without a receipt; inspect actual state','Actual preparation, source/route/question freshness, released verify-installed, and final campaign checks remain mandatory'])
with out.open('x',encoding='utf-8') as h:json.dump(r,h,indent=2);h.write('\n')
print(json.dumps(dict(status=r['status'],sha256=sha(out),checks=13)))

