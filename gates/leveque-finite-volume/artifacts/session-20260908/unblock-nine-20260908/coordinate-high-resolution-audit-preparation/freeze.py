"""Freeze the actual checked DIM spec preparation; no audit or gate operation."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re
P=Path(__file__).resolve().parent;R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def read(p):return json.loads(p.read_bytes())
def write(name,data):
 with (P/name).open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(data,indent=2)+'\n')
preflight=read(P/'spec-02/preflight.json');assert preflight['status']=='PASS_SPEC_ONLY'
assert read(P/'spec-02-exit.json')['exit_code']==0
resolutions=[]
for label in ('geometry-01','geometry-02','full-01'):
 folder=P/label;r=read(folder/'receipt.json')
 for key in ('input_snapshot','output','stderr'):
  value=r[key];assert sha(R/value['path'])==value['sha256']
 assert r['inputs_unchanged']
 for value in r['input_pins']:
  p=R/value['path']
  if sha(p)==value['sha256']:continue
  assert label=='geometry-01' and p==P/'GeometrySemantics.lean'
  snap=R/r['input_snapshot']['path'];assert sha(snap)==value['sha256']
  resolutions.append({'receipt':ref(folder/'receipt.json'),'original':value,'snapshot':ref(snap)})
for label in ('spec-01','spec-02'):
 r=read(P/(label+'-exit.json'))
 assert sha(P/r['helper_snapshot'])==r['helper_sha256']
 assert sha(P/(label+'-output.txt'))==r['output_sha256']
 if sha(P/'prepare-spec.py')!=r['helper_sha256']:
  resolutions.append({'receipt':ref(P/(label+'-exit.json')),
   'original_helper_path':(P/'prepare-spec.py').relative_to(R).as_posix(),
   'original_sha256':r['helper_sha256'],'snapshot':ref(P/r['helper_snapshot'])})
full=(P/'full-01/output.txt').read_bytes()
assert read(P/'full-01/receipt.json')['exit_code']==0
assert read(P/'geometry-02/receipt.json')['exit_code']==0
assert 'sorryAx' not in full.decode() and not re.search(rb'\b(?:error|warning):',full)
write('verification.json',{'schema':1,'status':'PASS_SPEC_ONLY','historical_input_resolutions':resolutions,
 'full_native_exit':0,'geometry_native_exit':0,'spec_validation_exit':0,
 'production_declarations':150,'joint_declarations':41,'generic_geometry_axiom_reports':8,
 'full_probe_bytes':len(full),'full_probe_characters':len(full.decode('utf-8')),
 'source_context':preflight['source_context_extension'],'preparer_invoked':False,'roles_invoked':False,
 'source_acceptance':False})
files=[ref(p) for p in sorted(P.rglob('*')) if p.is_file() and '__pycache__' not in p.parts and p.name not in ('manifest.json','final-receipt.json')]
write('manifest.json',{'schema':1,'status':'FROZEN_SPEC_ONLY','files':files,'source_acceptance':False})
result={'schema':1,'status':'PASS_SPEC_ONLY','frozen_at_utc':datetime.now(timezone.utc).isoformat(),
 'manifest':ref(P/'manifest.json'),'spec':ref(P/'spec-02/audit-spec.json'),
 'preflight':ref(P/'spec-02/preflight.json'),'helper':ref(P/'prepare-spec.py'),
 'packet':ref(P/'spec-02/native-packet.json'),'environment':ref(P/'spec-02/native-environment.json'),
 'full_probe':ref(P/'CompleteTypesFull.lean'),'full_native_receipt':ref(P/'full-01/receipt.json'),
 'full_native_output':ref(P/'full-01/output.txt'),'full_probe_bytes':len(full),
 'full_probe_characters':len(full.decode('utf-8')),'actual_native_exit':0,'actual_spec_validation_exit':0,
 'source_target':read(P/'final-inputs.json')['source_target'],'verification':ref(P/'verification.json'),
 'preparer_invoked':False,'roles_invoked':False,'source_acceptance':False}
write('final-receipt.json',result)
print(json.dumps({'receipt':ref(P/'final-receipt.json'),**{k:result[k] for k in
 ['spec','helper','packet','environment','full_probe_characters','full_probe_bytes','manifest']}},indent=2))
