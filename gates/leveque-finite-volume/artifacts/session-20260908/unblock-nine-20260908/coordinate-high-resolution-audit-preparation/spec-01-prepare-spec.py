"""Prepare and validate a proof-free DIM spec; never run the released preparer or roles."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,re,sys
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
assert len(sys.argv)==3 and re.fullmatch('full-[0-9]+',sys.argv[1]) and re.fullmatch('spec-[0-9]+',sys.argv[2])
OUT=P/sys.argv[2]
assert not OUT.exists()
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
environment=[]
def pin(value):
 assert set(value)=={'path','sha256'}
 p=R/value['path'];assert p.is_file() and sha(p)==value['sha256'],value
 environment.append(value);return p
def write(name,value):
 with (OUT/name).open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(value,indent=2,ensure_ascii=False)+'\n')
def span(path,label):
 raw=path.read_bytes()
 return {'label':label,'source_path':path.relative_to(R).as_posix(),'source_sha256':sha(path),
  'start_byte':0,'end_byte_exclusive':len(raw),'span_sha256':hashlib.sha256(raw).hexdigest(),
  'exact_text':raw.decode('utf-8'),'first_line':1,'last_line':raw.count(b'\n')}
def axioms(text):
 result={}
 for name,body in re.findall(r"^'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.M):
  name=re.sub(r'\.\{[^}]*\}','',name)
  assert name not in result
  values={re.sub(r'\.\{[^}]*\}','',x.strip()) for x in body.split(',') if x.strip()}
  assert values<={'propext','Classical.choice','Quot.sound'},(name,values)
  result[name]=values
 for name in re.findall(r"^'([^']+)' does not depend on any axioms",text,re.M):
  name=re.sub(r'\.\{[^}]*\}','',name);assert name not in result;result[name]=set()
 return result
def native(label):
 folder=P/label;receipt=read(folder/'receipt.json')
 assert receipt['exit_code']==0 and receipt['inputs_unchanged']
 for value in receipt['input_pins']:pin(value)
 for key in ('input','input_snapshot','output','stderr'):pin(receipt[key])
 environment.append(ref(folder/'receipt.json'))
 output=R/receipt['output']['path'];text=output.read_text(encoding='utf-8')
 assert not re.search(r'\b(?:error|warning):|sorryAx',text)
 assert not (R/receipt['stderr']['path']).read_bytes()
 assert '⋯ ∧' not in text and '∧ ⋯' not in text
 return output,axioms(text),ref(folder/'receipt.json')

helper=D/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
nodes=[n for n in ast.parse(helper.read_bytes()).body if isinstance(n,ast.FunctionDef) and
 n.name in {'load_additional_supplement','load_source_context'}]
assert len(nodes)==2
ns={'Path':Path,'json':json,'hashlib':hashlib}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'::readonly-loaders','exec'),ns)
load=ns['load_additional_supplement']
inputs=read(P/'final-inputs.json');probe=read(P/'full-probe-inputs.json')
assert inputs['schema']==1 and inputs['status']=='frozen-inputs-native-probe-required'
placement_receipt={'path':(D/'directional-high-resolution-production/final-receipt.json').relative_to(R).as_posix(),
 'sha256':'a55bfd9c81215f00ecbc21fa24a03f12d6e6c3c47d50cd0cc107cc1cea26f87d'}
placement_manifest={'path':(D/'directional-high-resolution-production/manifest.json').relative_to(R).as_posix(),
 'sha256':'e02782a5458c5a10e3b292fa9c0e835856c57b198d718840ab707358546cf44e'}
pin(placement_receipt);pin(placement_manifest)
for value in [probe['config'],probe['input'],*probe['pins']]:pin(value)
assert probe['config']==ref(P/'final-inputs.json')
full,full_axioms,full_receipt=native(sys.argv[1])
expected=set(probe['production_and_source_declarations']+probe['joint_declarations'])
assert set(full_axioms)==expected,(set(full_axioms)-expected,expected-set(full_axioms))
geometry,geometry_axioms,geometry_receipt=native('geometry-02')
assert len(geometry_axioms)==8
operator_ref=read(D/'measure-operator-evidence/additional-supplement.json')
operators,_,operator_pins=load(R,operator_ref)
norm_ref={'packet':{'path':(D/'fv-norm-complete-evidence/dependency-packet.json').relative_to(R).as_posix(),
 'sha256':'485da3e72c5590d346c920a4a9d392178800be8579cfebe9571126453142918f'},
 'environment_config':{'path':(D/'fv-norm-complete-evidence/environment-extension.json').relative_to(R).as_posix(),
 'sha256':'71b90143190e51646868ccea4c7f26edd66cc3cd77fb691b51c30c676ea2082c'}}
norms,_,norm_pins=load(R,norm_ref)
norm_spans=norms['native_output_spans'][-2:]
assert [s['source_sha256'] for s in norm_spans]==[
 'e442f4af3ada0a37b75529d58b2031cfb2b14c1951c788c322995c9a53a4350d',
 '2fbabfb6e24c386ce334047b7ffe0c9a65abaeb475bf23b550c7833caedc3a85']
bridge=read(D/'fv-operator-readiness/integral-successor-packet.json')['native_output_spans'][-1]
assert bridge['exact_text'] in norm_spans[0]['exact_text']
environment+=operator_pins+norm_pins+[ref(P/'full-probe-inputs.json'),ref(P/'build-full-probe.py'),ref(P/'run-native.py')]
dedup={}
for value in environment:
 assert sha(R/value['path'])==value['sha256']
 assert value['path'] not in dedup or dedup[value['path']]==value['sha256']
 dedup[value['path']]=value['sha256']
packet={'format':'proof-free-lean-environment-evidence-1',
 'scope':'Exact native complete types, actual definitions and domains, same physical Cartesian data and constituent line methods, and the concrete complete-primary application. Source context and interpretation are separately supplied.',
 'runtime':{'native_receipts':[full_receipt,geometry_receipt],
  'production_and_joint_evidence':inputs['evidence'],'final_placement_receipt':placement_receipt,
  'reused_generic_operator_packet':operator_ref,'reused_generic_norm_packet':norm_ref,
  'selected_norm_span_indices':[len(norms['native_output_spans'])-2,len(norms['native_output_spans'])-1],
  'finite_vector_integral_bridge_included_verbatim':True,
  'source_target':{'path':inputs['source_target']['path'],'sha256':inputs['source_target']['sha256']}},
 'native_output_spans':[span(full,'Complete native source/core/family/geometry and actual joint application; deep terms enabled, proof bodies hidden'),
  span(geometry,'Measured Cartesian cell/face definitions, product-volume normalization and pushforward integral')]+
  operators['native_output_spans']+norm_spans,
 'probe_commands':probe['commands']+[x for x in (P/'GeometrySemantics.lean').read_text().splitlines() if x.startswith(('#check ','#print '))]+operators['probe_commands'],
 'omissions':['No theorem proof body, prior audit finding or verdict, requested verdict, or new source interpretation is supplied.',
  'Native definition bodies retain mathematical inputs and operators; proof terms are hidden by pp.proofs=false.',
  'Only the two generic norm/integral bridge spans are reused from the FV norm packet; no FV-specific source-contract spans are included.',
  'Source and coordinator/user interpretation evidence have their separate recorded authority and scope.']}
OUT.mkdir()
write('native-packet.json',packet)
write('native-environment.json',{'format':'pinned-audit-environment-extension-1',
 'environment_files':[{'path':p,'sha256':h} for p,h in sorted(dedup.items())]})
extra={'packet':ref(OUT/'native-packet.json'),'environment_config':ref(OUT/'native-environment.json')}
assert load(R,extra)[0]==packet
old_path=D/'dimensional-method-audit-preparation/audit-spec.json'
assert sha(old_path)=='e25d6d0a9baebea1d56b6d347c5f4cd85f3732add905318a956cf04078de81ff'
old=read(old_path)
context_path=D/'directional-complete-repair-review/source-context-with-user-high-resolution-v2.json'
assert sha(context_path)==inputs['source_context_sha256']
assert sha(context_path)=='71bd39828c9ba3c9d6dd49d9e84fe5f32c9b446ae830679607b7edfe3d2d2c5d'
spec=json.loads(json.dumps(old))
spec.update(task_id='LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908',
 key='coordinate-high-resolution-methods',pages='26,27,28,125,126',
 target={key:inputs['source_target'][key] for key in ('path','declaration')},
 source_context_extension=ref(context_path),additional_supplement=extra)
same=set(old)-{'task_id','key','pages','target','source_context_extension','additional_supplement'}
assert all(old[key]==spec[key] for key in same)
assert spec['choice_id']=='Q10' and spec['row_id']=='LEV-CH01-DIMENSIONAL-SPLITTING'
prior=S/'audits'/spec['prior_task'];task=read(prior/'audit-task.json')
context=ns['load_source_context'](R,spec['source_context_extension'],task['source'],spec['pages'],
 R.parent/'workflow-v5.0.1-local/chapter01-source-review')
cfg=read(S/spec['prior_config']);manifest=read(prior/'faithfulness/manifest.json')
recorded={x['path']:x['sha256'] for x in manifest['lean_environment']}
for path in cfg['lean']['environment_files']:assert sha(R/path)==recorded[path]
assert not (S/'audits'/spec['task_id']).exists()
assert not (D/(spec['task_id']+'.config.json')).exists()
write('audit-spec.json',spec)
write('preflight.json',{'schema':1,'status':'PASS_SPEC_ONLY','observed_at_utc':datetime.now(timezone.utc).isoformat(),
 'spec':ref(OUT/'audit-spec.json'),'preparer':ref(helper),'prior_spec':ref(old_path),
 'unchanged_spec_keys':sorted(same),
 'production_inputs':ref(P/'final-inputs.json'),'complete_probe':ref(P/'full-probe-inputs.json'),
 'native_packet':extra,'source_context_extension':spec['source_context_extension'],
 'preserved_primary_locations':task['source']['locations'],'selected_locations':context['locations'],
 'interpretation_receipts':read(context_path)['interpretation_receipts'],
 'production_and_source_declarations':len(probe['production_and_source_declarations']),
 'joint_declarations':len(probe['joint_declarations']),'geometry_normalization_reports':8,
 'native_spans':len(packet['native_output_spans']),'environment_pins':len(dedup),
 'actual_native_exits':[0,0],'destination_absent_at_preflight':True,
 'preparer_invoked':False,'roles_invoked':False,'source_acceptance':False})
print(json.dumps({'spec':ref(OUT/'audit-spec.json'),'preflight':ref(OUT/'preflight.json'),'packet':extra},indent=2))
