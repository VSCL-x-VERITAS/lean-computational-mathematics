"""Freeze only actually validated local InfoCert preparation evidence."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,sys
P=Path(__file__).resolve().parent;D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
assert len(sys.argv)==2 and re.fullmatch('spec-[0-9]+',sys.argv[1]);O=P/sys.argv[1]
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
bindings=[]
def pin(entry):
 path=R/entry['path'];assert path.is_file() and sha(path)==entry['sha256'],entry
 bindings.append(entry)
def write(path,value):
 with path.open('x',encoding='utf-8',newline='\n') as out:out.write(json.dumps(value,indent=2)+'\n')
run=read(P/(sys.argv[1]+'-exit.json'))
assert run['exit_code']==0 and sha(P/(sys.argv[1]+'-output.txt'))==run['output_sha256']
assert sha(P/'prepare-spec.py')==run['helper_sha256']==sha(P/run['helper_snapshot'])
preflight=read(O/'preflight.json');assert preflight['status']=='PASS_SPEC_ONLY'
for key in ('spec','preparer','prior_spec','production_inputs','complete_probe','source_context_extension','source','historical_decision_not_role_input'):
 pin(preflight[key])
for value in preflight['native_packet'].values():pin(value)
env=read(O/'native-environment.json')
for value in env['environment_files']:pin(value)
packet=read(O/'native-packet.json')
for entry in packet['native_output_spans']:
 path=R/entry['source_path'];assert sha(path)==entry['source_sha256']
 piece=path.read_bytes()[entry['start_byte']:entry['end_byte_exclusive']]
 assert piece.decode('utf-8')==entry['exact_text'] and hashlib.sha256(piece).hexdigest()==entry['span_sha256']
native=[]
for label in ('full-01','full-02'):
 item=read(P/label/'receipt.json');assert item['exit_code']==0 and item['inputs_unchanged']
 for value in item['input_pins']:pin(value)
 for key in ('input','input_snapshot','output','stderr'):pin(item[key])
 assert not (R/item['stderr']['path']).read_bytes()
 assert not re.search(rb'\b(?:error|warning):|sorryAx',(R/item['output']['path']).read_bytes())
 native.append(ref(P/label/'receipt.json'))
files=sorted(x for x in P.rglob('*') if x.is_file() and '__pycache__' not in x.parts)
manifest={'schema':1,'files':[ref(x) for x in files],
 'verified_binding_occurrences':len(bindings),'unique_bound_files':len({x['path'] for x in bindings}),
 'source_acceptance':False,'gate_mutations':False,'model_roles_invoked':False}
write(P/'manifest.json',manifest)
receipt={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'status':'FROZEN_SPEC_ONLY','task_id':read(O/'audit-spec.json')['task_id'],
 'manifest':ref(P/'manifest.json'),'spec':ref(O/'audit-spec.json'),'helper':ref(P/'prepare-spec.py'),
 'packet':ref(O/'native-packet.json'),'environment':ref(O/'native-environment.json'),
 'preflight':ref(O/'preflight.json'),'spec_check':ref(P/(sys.argv[1]+'-exit.json')),
 'native':native,'source':preflight['source'],'axiom_reports':preflight['axiom_reports'],
 'complete_probe_characters':preflight['complete_probe_characters'],
 'complete_probe_bytes':preflight['complete_probe_bytes'],
 'actual_native_exits':[0,0],'actual_spec_check_exit':0,
 'source_acceptance':False,'released_preparer_invoked':False,'model_roles_invoked':False,'git_invocations':0}
write(P/'receipt.json',receipt)
print(json.dumps({'receipt':ref(P/'receipt.json'),**receipt},indent=2))
