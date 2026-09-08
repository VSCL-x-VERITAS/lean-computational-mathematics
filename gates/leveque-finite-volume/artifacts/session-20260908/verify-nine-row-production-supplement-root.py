"""Root verification of the bounded additive DIM review and its exact observed inputs."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'nine-row-production-supplement-batch10'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
m=P/'manifest.json';assert sha(m)=='b6396391f90f147610de38849cfcec09a3607a726db39d99eedc48458517525f'
for f in read(m)['files']:assert sha(P/f['path'])==f['sha256']
v=read(P/'verification.json')
assert v['counts']['all_native_reports']==199 and v['observed_file_count']==257
for f in v['observed_files']:assert sha(R/f['path'])==f['sha256'],f['path']
e=read(P/'verification-exit.json');assert type(e['exit_code']) is int and e['exit_code']==0
assert e.get('output_sha256',e.get('raw_output_sha256'))==sha(P/'verification-output.txt')
out=S/'root-nine-row-production-supplement-review.json'
value=dict(schema=1,status='PASS_WITHIN_STATED_CHECKS',reviewed_at_utc=datetime.now(timezone.utc).isoformat(),manifest_sha256=sha(m),observed_pins=257,actual_independent_exit=0,root_review='Read the complete supplement, verification program and mapping. The prior required DIM placement and final consumer evidence is discharged for the exact five-leaf source; root placement verification and exposure have now also completed. Broader graph, organization, accepted-row rebind and final gate checks remain ongoing. No additional necessary mathematical producer identified within the inspected prospective contracts; this is not source acceptance or a final exhaustion assertion.',source_acceptance=False,all_local_work_complete='NOT ASSERTED')
with out.open('x',encoding='utf-8') as f:json.dump(value,f,indent=2);f.write('\n')
print(json.dumps(dict(status=value['status'],sha256=sha(out))))

