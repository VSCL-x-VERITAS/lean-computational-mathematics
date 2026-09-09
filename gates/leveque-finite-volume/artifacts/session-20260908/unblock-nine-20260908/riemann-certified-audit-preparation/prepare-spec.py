"""Validate a fresh InfoCert spec; never invoke sealed preparation or roles."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os,re,sys
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
assert len(sys.argv)==3 and re.fullmatch('full-[0-9]+',sys.argv[1]) and re.fullmatch('spec-[0-9]+',sys.argv[2])
OUT=P/sys.argv[2];assert not OUT.exists()
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
environment=[]
def pin(value):
 assert set(value)=={'path','sha256'}
 path=R/value['path'];assert path.is_file() and sha(path)==value['sha256'],value
 environment.append(value);return path
def write(name,value):
 with (OUT/name).open('x',encoding='utf-8',newline='\n') as out:out.write(json.dumps(value,indent=2,ensure_ascii=False)+'\n')
def span(path,label):
 raw=path.read_bytes()
 return {'label':label,'source_path':path.relative_to(R).as_posix(),'source_sha256':sha(path),
  'start_byte':0,'end_byte_exclusive':len(raw),'span_sha256':hashlib.sha256(raw).hexdigest(),
  'exact_text':raw.decode('utf-8'),'first_line':1,'last_line':raw.count(b'\n')}
def axioms(text):
 result={}
 for name,body in re.findall(r"^'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.M):
  name=re.sub(r'\.\{[^}]*\}','',name);assert name not in result
  values={re.sub(r'\.\{[^}]*\}','',x.strip()) for x in body.split(',') if x.strip()}
  assert values<={'propext','Classical.choice','Quot.sound'},(name,values)
  result[name]=values
 for name in re.findall(r"^'([^']+)' does not depend on any axioms",text,re.M):
  name=re.sub(r'\.\{[^}]*\}','',name);assert name not in result;result[name]=set()
 return result

helper=D/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
nodes=[node for node in ast.parse(helper.read_bytes()).body if isinstance(node,ast.FunctionDef)
 and node.name in {'load_additional_supplement','load_source_context'}]
assert len(nodes)==2
ns={'Path':Path,'json':json,'hashlib':hashlib}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'::readonly-loaders','exec'),ns)
load=ns['load_additional_supplement']
inputs=read(P/'final-inputs.json');probe=read(P/'full-probe-readable-inputs.json')
assert inputs['schema']==1 and inputs['status']=='frozen-inputs-native-probe-required'
assert inputs['placement_receipt']['sha256']=='6d60dbcaede51de0977f67d33f95e4da7c4717af52e8adac5c9aeba051e03fcd'
assert inputs['placement_manifest']['sha256']=='ea3aea0ff19c73bc47235ff975028eb1c035dbcc49a905cfb34e52d61c3f26b3'
pin(inputs['placement_receipt']);pin(inputs['placement_manifest'])
for value in [probe['config'],probe['input'],*probe['pins']]:pin(value)
assert probe['config']==ref(P/'final-inputs.json')
folder=P/sys.argv[1];native=read(folder/'receipt.json')
assert native['exit_code']==0 and native['inputs_unchanged']
for value in native['input_pins']:pin(value)
for key in ('input','input_snapshot','output','stderr'):pin(native[key])
environment.append(ref(folder/'receipt.json'))
assert native['input']==probe['input']
assert native['command'][1:]==['env','lean',probe['input']['path']]
full=R/native['output']['path'];text=full.read_text(encoding='utf-8')
assert not re.search(r'\b(?:error|warning):|sorryAx',text)
assert not (R/native['stderr']['path']).read_bytes()
assert '⋯ ∧' not in text and '∧ ⋯' not in text
reports=axioms(text)
expected=set(probe['production_and_source_declarations']+probe['definition_declarations']+probe['joint_declarations'])
assert set(reports)==expected,(set(reports)-expected,expected-set(reports))
assert len(reports)==36
for phrase in ('HasRiemannAccuracy','reference_comparison','actual_two_face_source_application',
 'references_from_actual_primary','certified_nonconsistent','actual_update_error'):
 assert phrase in text

operator_ref=read(D/'measure-operator-evidence/additional-supplement.json')
operators,_,operator_pins=load(R,operator_ref)
norm_ref={'packet':{'path':(D/'fv-norm-complete-evidence/dependency-packet.json').relative_to(R).as_posix(),
 'sha256':'485da3e72c5590d346c920a4a9d392178800be8579cfebe9571126453142918f'},
 'environment_config':{'path':(D/'fv-norm-complete-evidence/environment-extension.json').relative_to(R).as_posix(),
 'sha256':'71b90143190e51646868ccea4c7f26edd66cc3cd77fb691b51c30c676ea2082c'}}
norms,_,norm_pins=load(R,norm_ref)
norm_spans=norms['native_output_spans'][-2:]
assert [entry['source_sha256'] for entry in norm_spans]==[
 'e442f4af3ada0a37b75529d58b2031cfb2b14c1951c788c322995c9a53a4350d',
 '2fbabfb6e24c386ce334047b7ffe0c9a65abaeb475bf23b550c7833caedc3a85']
bridge=read(D/'fv-operator-readiness/integral-successor-packet.json')['native_output_spans'][-1]
assert bridge['exact_text'] in norm_spans[0]['exact_text']
environment+=operator_pins+norm_pins+[ref(P/'full-probe-readable-inputs.json'),ref(P/'build-full-probe.py'),ref(P/'build-readable-probe.py'),ref(P/'run-native.py')]
dedup={}
for value in environment:
 assert sha(R/value['path'])==value['sha256']
 assert value['path'] not in dedup or dedup[value['path']]==value['sha256']
 dedup[value['path']]=value['sha256']
packet={'format':'proof-free-lean-environment-evidence-1',
 'scope':'Exact native types and definitions of the supplied routine, its accuracy property, admitted ordered problems, same-problem finite-time references, physical comparison, and complete concrete source application. Source interpretation is separately supplied.',
 'runtime':{'native_receipts':[ref(folder/'receipt.json')],
  'production_native_receipts':[value for value in inputs['evidence'] if value['path'].endswith(('/build-exit.json','/declarations-exit.json'))],
  'production_inventory':inputs['inventory'],'joint_application_input':inputs['joint_input'],
  'reused_generic_operator_packet':operator_ref,'reused_generic_norm_packet':norm_ref,
  'selected_norm_span_indices':[len(norms['native_output_spans'])-2,len(norms['native_output_spans'])-1],
  'finite_vector_integral_bridge_included_verbatim':True,
  'source_target':{key:inputs['source_target'][key] for key in ('path','sha256')}},
 'native_output_spans':[span(full,'Complete canonical source/core/certificate and actual joint application; deep terms enabled, proof bodies hidden')]+
  operators['native_output_spans']+norm_spans,
 'probe_commands':probe['commands']+operators['probe_commands'],
 'omissions':['No theorem proof body, prior audit finding or verdict, requested verdict, or new source interpretation is supplied.',
  'Native definition bodies retain mathematical inputs and operators; proof terms are hidden by pp.proofs=false.',
  'Only the two generic norm/integral bridge spans are reused from the FV norm packet; no FV-specific source-contract spans are included.',
  'Source, coordinator-selected interpretation, and inherited literal user interpretation have separate recorded authority and scope.']}
OUT.mkdir()
write('native-packet.json',packet)
write('native-environment.json',{'format':'pinned-audit-environment-extension-1',
 'environment_files':[{'path':path,'sha256':digest} for path,digest in sorted(dedup.items())]})
extra={'packet':ref(OUT/'native-packet.json'),'environment_config':ref(OUT/'native-environment.json')}
assert load(R,extra)[0]==packet
old_path=D/'local-riemann-routine-audit-preparation/audit-spec.json'
assert sha(old_path)=='240bdcf44aafd85a5dd16964a3244073e9796cfa38fc827191421dbd903846ac'
old=read(old_path);spec=json.loads(json.dumps(old))
spec.update(task_id='LEV-CH01-CERTIFIED-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908',
 key='certified-riemann-routine-interface',
 target={key:inputs['source_target'][key] for key in ('path','declaration')},additional_supplement=extra)
same=set(old)-{'task_id','key','target','additional_supplement'}
assert all(old[key]==spec[key] for key in same)
assert spec['choice_id']=='Q7' and spec['row_id']=='LEV-CH01-RIEMANN-INTERFACE-FLUX'
assert spec['pages']=='26,27,28'
assert spec['source_context_extension']['sha256']==inputs['source_context_sha256']
prior=S/'audits'/spec['prior_task'];task=read(prior/'audit-task.json')
context=ns['load_source_context'](R,spec['source_context_extension'],task['source'],spec['pages'],
 R.parent/'workflow-v5.0.1-local/chapter01-source-review')
previous=S/'audits'/old['task_id']
assert context['locations']==read(previous/'audit-task.json')['source']['locations']
cfg=read(S/spec['prior_config']);manifest=read(prior/'faithfulness/manifest.json')
recorded={value['path']:value['sha256'] for value in manifest['lean_environment']}
for path in cfg['lean']['environment_files']:assert sha(R/path)==recorded[path]
assert not (S/'audits'/spec['task_id']).exists()
assert not (D/(spec['task_id']+'.config.json')).exists()
write('audit-spec.json',spec)
write('preflight.json',{'schema':1,'status':'PASS_SPEC_ONLY','observed_at_utc':datetime.now(timezone.utc).isoformat(),
 'spec':ref(OUT/'audit-spec.json'),'preparer':ref(helper),'prior_spec':ref(old_path),
 'unchanged_spec_keys':sorted(same),'production_inputs':ref(P/'final-inputs.json'),
 'complete_probe':ref(P/'full-probe-readable-inputs.json'),'native_packet':extra,
 'source_context_extension':spec['source_context_extension'],'source':ref(R/spec['target']['path']),
 'preserved_primary_locations':task['source']['locations'],'selected_locations':context['locations'],
 'interpretation_receipts':read(R/spec['source_context_extension']['path'])['interpretation_receipts'],
 'production_and_source_declarations':7,'joint_declarations':7,'definition_declarations':22,
 'axiom_reports':len(reports),'native_spans':len(packet['native_output_spans']),'environment_pins':len(dedup),
 'complete_probe_characters':len(text),'complete_probe_bytes':full.stat().st_size,
 'actual_native_exit':0,'destination_absent_at_preflight':True,
 'historical_decision_not_role_input':ref(previous/'faithfulness/decision.json'),
 'preparer_invoked':False,'roles_invoked':False,'source_acceptance':False})
print(json.dumps({'spec':ref(OUT/'audit-spec.json'),'preflight':ref(OUT/'preflight.json'),'packet':extra},indent=2))
