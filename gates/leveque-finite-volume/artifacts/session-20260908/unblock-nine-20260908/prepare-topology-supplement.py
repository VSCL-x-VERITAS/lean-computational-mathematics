"""Freeze exact native topology declarations for fresh dependency review."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent
S=D.parent
R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def createj(p,v):
 with p.open('xb') as f:f.write((json.dumps(v,indent=2,ensure_ascii=False)+'\n').encode())
out=S/'unblock-nine-topology-final-output.txt'
receipt=S/'unblock-nine-topology-final-exit.json'
run=json.loads(receipt.read_bytes())
assert run['exit_code']==0 and run['output_sha256']==sha(out)
raw=out.read_bytes()
assert b'error:' not in raw
probe=D/'TopologyDeclarations.lean'
paths=[probe,out,receipt,D/'capture-check.py',R/'lean-toolchain',R/'lake-manifest.json']
for module in ['Topology/Defs/Filter','Topology/Defs/Basic','Topology/Neighborhoods']:
 paths += [R/('.lake/packages/mathlib/Mathlib/'+module+'.lean'),
  R/('.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/'+module+'.olean')]
assert all(p.is_file() for p in paths)
packet={'format':'proof-free-lean-environment-evidence-1',
 'scope':'Exact native declarations characterizing neighborhood filters and limits; contains no source correspondence claim or prior judgment.',
 'runtime':{'command_receipt':ref(receipt),'probe':ref(probe),
  'environment_files':[ref(p) for p in paths[4:]],'native_lake':run['native_lake']},
 'native_output_spans':[{'source_path':out.relative_to(R).as_posix(),'source_sha256':sha(out),
  'start_byte':0,'end_byte_exclusive':len(raw),'span_sha256':sha(out),'exact_text':raw.decode('utf-8'),
  'first_line':1,'last_line':raw.count(b'\n')}],
 'probe_commands':['#check @nhds_def','#check @mem_nhds_iff','#print TopologicalSpace',
  '#print Filter.Tendsto','#print nhdsWithin','#print axioms nhds_def','#print axioms mem_nhds_iff'],
 'omissions':['No target proof, source interpretation, prior audit output or requested classification is included.']}
packetpath=D/'topology-dependency-packet.json'
configpath=D/'topology-environment-extension.json'
createj(packetpath,packet)
createj(configpath,{'format':'pinned-audit-environment-extension-1','environment_files':[ref(p) for p in paths]})
spec=json.loads((D/'material-interface-audit-spec.json').read_bytes())
prior=spec['task_id']
spec.update(task_id='LEV-CH01-MATERIAL-INTERFACE-TOPOLOGY-INTERPRETED-PRODUCTION-20260908',
 prior_task=prior,prior_config='unblock-nine-20260908/'+prior+'.config.json',
 additional_supplement={'packet':ref(packetpath),'environment_config':ref(configpath)})
specpath=D/'material-interface-topology-audit-spec.json'
createj(specpath,spec)
createj(D/'topology-supplement-lineage.json',{'actual_native_exit_code':0,'prior_audit':prior,
 'prior_decision':ref(S/'audits'/prior/'faithfulness/decision.json'),'target_changed':False,
 'change':'Additional exact native dependency declarations, independently reviewed in a fresh audit.',
 'packet':ref(packetpath),'extension':ref(configpath),'spec':ref(specpath),
 'initial_probe_failure_preserved':ref(S/'unblock-nine-topology-dependency-exit.json')})
print(json.dumps({'packet':ref(packetpath),'extension':ref(configpath),'spec':ref(specpath)}))
