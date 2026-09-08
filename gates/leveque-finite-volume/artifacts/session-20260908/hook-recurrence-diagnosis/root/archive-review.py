"""Hash-check bounded review inputs and preserve exact diagnostic bytes."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent;W=D.parents[1];R=W/'lean-computational-mathematics';L=W/'workflow-v5.0.1-local';A=R/'gates/leveque-finite-volume/artifacts/session-20260908/hook-recurrence-diagnosis'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
host=L/'chapter01-hook-host-diagnosis';ctx=L/'chapter01-hook-process-context';modes=L/'chapter01-hook-process-mode-tests'
roots=[(host/'final-receipt.json','b402a68c9841ff1e5c2f216f4a6c5cd90675aabda3c4d73b41561401ffdde7ec'),(host/'stop-layers-receipt.json','f0d2ba4fb5dbdc96326e50771cac81fe94b1e08fd04e42002393618972ea199b'),(ctx/'receipt.json','53c8d86d4ec77b50479097bda400b1db92cc972cfc3ad2b10204d6b08db73380'),(ctx/'source-manifest.json','0e4a85b1dac9c95fab2ed5269ad1560dab7157330ca98586d66ea9828819c4ef')]
pins={}
def walk(obj):
 if isinstance(obj,dict):
  if 'path' in obj and 'sha256' in obj:
   p=Path(obj['path']);assert p.is_absolute(),str(p)
   h=sha(p);assert h==obj['sha256'],str(p)
   if 'bytes' in obj:assert p.stat().st_size==obj['bytes'],str(p)
   pins[str(p)]=h
  for v in obj.values():walk(v)
 elif isinstance(obj,list):
  for v in obj:walk(v)
for p,h in roots:
 assert sha(p)==h,str(p);walk(json.loads(p.read_bytes()))
selected=[]
for folder,names in [(host,['collect-readonly.py','freeze.py','host-evidence.json','REVIEW.md','final-receipt.json','list-effective-stop.py','effective-stop-list.json','effective-stop-appserver-stderr.txt','STOP-LAYERS-ADDENDUM.md','freeze-stop-layers.py','stop-layers-receipt.json']),(ctx,['REVIEW.md','source-manifest.json','receipt.json','capture-direct-context.py','direct-context.json','direct-context-output.txt','direct-context-exit.json'])]:
 for name in names:selected.append((folder/name,folder.name+'/'+name))
for src in sorted(modes.rglob('*')):
 if src.is_file():selected.append((src,modes.name+'/'+src.relative_to(modes).as_posix()))
for src in sorted(D.iterdir()):
 if src.is_file():selected.append((src,'root/'+src.name))
for stem in ['recurrence-before-edit-preflight','recurrence-trackers']:
 for suffix in ['-output.txt','-exit.json']:
  src=L/'chapter01-final-checks'/(stem+suffix);selected.append((src,'checks/'+src.name))
A.mkdir(exist_ok=False);copied=[]
for src,name in selected:
 target=A/name;target.parent.mkdir(parents=True,exist_ok=True);data=src.read_bytes()
 with target.open('xb') as f:f.write(data)
 assert sha(target)==sha(src)
 copied.append({'path':target.relative_to(R).as_posix(),'source_path':str(src),'bytes':len(data),'sha256':sha(target)})
record={'kind':'root-verified-exact-recurrence-diagnostic-archive','review_input_pins_verified':len(pins),'input_pins':pins,'files':copied,'copied_count':len(copied),'operational_guard_or_hook_changed':False,'actual_host_cause_resolved':False,'pending':'Passive actual Stop observer and final checkpoint/validation results are subsequent artifacts, not yet asserted.'}
with (A/'archive-manifest.json').open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps({'archive':str(A),'files':len(copied),'input_pins_verified':len(pins),'manifest_sha256':sha(A/'archive-manifest.json')}))

