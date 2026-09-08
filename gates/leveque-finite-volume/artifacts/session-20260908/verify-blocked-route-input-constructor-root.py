"""Root read/hash review of the frozen request-only input constructor."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os
S=Path(__file__).resolve().parent;P=S/'blocked-route-input-preparation-batch10'
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
assert sha(P/'manifest.json')=='a61d2b6f6e273313559ed77e56a7b36296026dce56873d6a9ef269ad7fe10466'
m=read(P/'manifest.json')
for x in m['inputs']:assert sha(Path(x['path']))==x['sha256']
for x in m['files']:
 p=P/x['path'];assert sha(p)==x['sha256'] and p.stat().st_size==x['bytes']
e=read(P/'checks-02.exit.json');assert type(e['exit_code']) is int and e['exit_code']==0
assert m['tests']==17 and read(P/'checks.json')['count']==17
r=dict(schema=1,status='BOUNDED_REVIEW_COMPLETE',reviewed_at_utc=datetime.now(timezone.utc).isoformat(),manifest_sha256=sha(P/'manifest.json'),constructor_sha256=sha(P/'construct_request.py'),tests=17,actual_exit=0,review='Read complete constructor, exact input contract, and static/rejection tests. Root supplies every status, narrative, completion and evidence reference. Constructor reuses pinned transition/provenance/native receipt guards and copies references into a new request; it does not install or synthesize completeness. Supplied current context and operational base are separately rechecked by the later frozen preparer. No real complete request exists yet.',source_acceptance=False,operational_request_created=False)
out=S/'root-blocked-route-input-constructor-review.json'
with out.open('x',encoding='utf-8') as f:json.dump(r,f,indent=2);f.write('\n')
print(json.dumps(dict(status=r['status'],sha256=sha(out))))

