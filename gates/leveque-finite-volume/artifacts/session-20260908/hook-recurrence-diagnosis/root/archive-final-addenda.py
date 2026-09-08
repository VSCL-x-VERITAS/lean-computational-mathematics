"""Add independently verified review and passive-observer preparation to the archive."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent;W=D.parents[1];R=W/'lean-computational-mathematics';L=W/'workflow-v5.0.1-local';A=R/'gates/leveque-finite-volume/artifacts/session-20260908/hook-recurrence-diagnosis'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
review=L/'chapter01-hook-process-context/archive-review.json';assert sha(review)=='70ea40a63974c14fedd47c2532413c8cfc61950885fa376dfe3c0e50b4b61396'
O=L/'chapter01-hook-stop-observer';prep=O/'preparation.json';assert sha(prep)=='755ea81fb7b80e8b2edd8fc44b17b0abce6d241320a7e82682d4b12c3d281aed'
for v in json.loads(prep.read_bytes())['files']:assert sha(Path(v['path']))==v['sha256']
smoke=json.loads((O/'smoke-01/completion.json').read_bytes())
assert smoke['exit_status']==0 and smoke['outcome']=='completed' and smoke['counts']['snapshot_errors']==0
assert sha(O/'smoke-01/events.jsonl')==smoke['events_sha256']
selected=[(review,'independent-archive-review.json'),(P:=Path(__file__),'root/'+P.name)]
for name in ['observe.py','README.md','preparation.json','smoke-01/ready.json','smoke-01/events.jsonl','smoke-01/completion.json']:selected.append((O/name,'passive-observer/'+name))
files=[]
for src,name in selected:
 target=A/name;target.parent.mkdir(parents=True,exist_ok=True)
 with target.open('xb') as f:f.write(src.read_bytes())
 assert sha(src)==sha(target)
 files.append({'path':target.relative_to(R).as_posix(),'source_path':str(src),'sha256':sha(target),'bytes':target.stat().st_size})
rec={'kind':'additive-reviewed-observer-and-independent-archive-review','files':files,'actual_smoke_exit':0,'actual_smoke_snapshots':smoke['counts']['snapshots'],'actual_host_event_observed':False,'smoke_only':'One-second passive smoke verified native API setup and output; no hook or gate was invoked.'}
with (A/'final-addenda-manifest.json').open('xb') as f:f.write((json.dumps(rec,indent=2)+'\n').encode())
print(json.dumps({'copied':len(files),'smoke_exit':0,'manifest_sha256':sha(A/'final-addenda-manifest.json')}))

