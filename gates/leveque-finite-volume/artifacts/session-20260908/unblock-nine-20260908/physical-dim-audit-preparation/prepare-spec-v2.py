"""POSIX-only pure preparation/preflight. Does not invoke audit preparation or roles."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os,re
assert os.name=='posix','Run through the POSIX launcher; only extracted read-only loaders are executed.'
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent;R=S.parents[3];W=R.parent
OUT=P/'spec-01';assert not OUT.exists()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
read=lambda p:json.loads(p.read_bytes())
environment={}
def pin(value):
 assert isinstance(value,dict) and 'path' in value and 'sha256' in value
 path=value['path'];digest=value['sha256']
 assert '\\' not in path and ':' not in path and not Path(path).is_absolute()
 assert all(x not in ('','.','..') for x in path.split('/'))
 p=R/path;assert p.is_file() and sha(p)==digest,(path,'changed pin')
 assert path not in environment or environment[path]==digest,(path,'conflicting pin')
 environment[path]=digest
 return p
def write(name,obj):
 p=OUT/name
 with p.open('x',encoding='utf-8',newline='\n') as stream:
  stream.write(json.dumps(obj,ensure_ascii=False,indent=2)+'\n')
 return ref(p)
def span(p,label):
 raw=p.read_bytes()
 return {'label':label,'source_path':p.relative_to(R).as_posix(),'source_sha256':sha(p),
  'start_byte':0,'end_byte_exclusive':len(raw),'span_sha256':hashlib.sha256(raw).hexdigest(),
  'exact_text':raw.decode(),'first_line':1,'last_line':raw.count(b'\n')}
def axioms(text):
 result={}
 for name,body in re.findall(r"^'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.M):
  name=re.sub(r'\.\{[^}]*\}','',name);assert name not in result
  values={re.sub(r'\.\{[^}]*\}','',x.strip()) for x in body.split(',') if x.strip()}
  assert values<={'propext','Classical.choice','Quot.sound'},(name,values)
  result[name]=sorted(values)
 for name in re.findall(r"^'([^']+)' does not depend on any axioms",text,re.M):
  name=re.sub(r'\.\{[^}]*\}','',name);assert name not in result;result[name]=[]
 return result

helper=D/'prepare-successor-audit-with-dim-module-roots-v2.py'
assert sha(helper)=='ca25290925de0bb5f8d135c82b380077f7ee0e1a015fca7e6f00031d138f8b54'
tree=ast.parse(helper.read_bytes())
function_names={'load_additional_supplement','load_source_context','load_dim_module_roots','merge_additional_supplement'}
nodes=[]
for node in tree.body:
 if isinstance(node,ast.FunctionDef) and node.name in function_names:nodes.append(node)
 elif isinstance(node,ast.Assign) and all(isinstance(t,ast.Name) and t.id.startswith('DIM_MODULE_') for t in node.targets):nodes.append(node)
assert len([n for n in nodes if isinstance(n,ast.FunctionDef)])==4
ns={'Path':Path,'json':json,'hashlib':hashlib}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'::read-only-loaders','exec'),ns)

inventory=read(P/'probe-sources-02/probe-inventory.json')
native_path=P/'native-02/receipt.json';native=read(native_path)
assert native['actual_exit_code']==0 and native['inputs_unchanged']
before=read(pin(native['inputs_before']));after=read(pin(native['inputs_after']));assert before==after
external=[]
for item in before:
 if ':' in item['path'] or '\\' in item['path']:external.append(item)
 else:pin(item)
assert len(external)==1 and external[0]['sha256']=='58da8685e404b9ad5bf7a5aadbe8fa4d3856d0d37feb61186a577171340dfd81'
pin(native['environment']);pin(ref(native_path));pin(ref(P/'run-probes-v2.py'));pin(ref(P/'prepare-probes-v2.py'))
pin(ref(P/'probe-sources-02-prepare-receipt.json'))
spans=[];commands=[];counts={};ellipsis_review=[]
for group,record in zip(inventory['groups'],native['groups'],strict=True):
 assert record['actual_exit_code']==0 and record['input']==group['input']
 input_path=pin(record['input']);output=pin(record['output']);err=pin(record['stderr'])
 assert not err.read_bytes()
 pin(ref(P/'native-02'/(Path(group['file']).stem+'-receipt.json')))
 text=output.read_text(encoding='utf-8');assert not re.search(r'\b(?:error|warning):|sorryAx',text)
 reports=axioms(text);expected=set(group['print']+group['check'])
 assert set(reports)==expected and len(reports)==group['expected_axiom_reports']
 assert '...' not in text
 for number,line in enumerate(text.splitlines(),1):
  if '⋯' not in line:continue
  assert group['file'] not in {'Contract.lean','Regularity.lean'}
  if 'lookup_cell := ⋯' in line:reason='Suppressed proofs of lookup consistency and soundness; actual maps/extraction are present.'
  elif 'incidence := ⋯' in line:reason='Suppressed Incidence proof; four incidence proposition fields are printed separately.'
  elif "Finset.univ.sup' ⋯" in line:reason='Suppressed nonempty-finite-set proof to sup; actual diameter function and partition nonemptiness remain explicit.'
  elif any(x in line for x in ['cells_nonempty := ⋯','disjoint_cells := ⋯','positive := ⋯','left_incidence := ⋯','hyperbolic := ⋯']):
   reason='Suppressed physical/partition proof fields, whose full propositions are printed in their structures.'
  elif 'Option.some ⟨Function.update line d j, ⋯⟩' in line:reason='Suppressed subtype membership proof for the explicitly supplied active-cell lookup.'
  else:raise AssertionError((group['file'],number,line,'unreviewed elision'))
  ellipsis_review.append({'file':group['file'],'line':number,'exact_line':line,'reason':reason})
 spans.append(span(output,group['scope']))
 commands+=group['commands'];counts[group['file']]={'bytes':len(output.read_bytes()),'axiom_reports':len(reports)}

operator_ref=read(D/'measure-operator-evidence/additional-supplement.json')
operators,_,operator_pins=ns['load_additional_supplement'](R,operator_ref)
norm_ref=read(D/'fv-norm-complete-evidence/additional-supplement.json')
norms,_,norm_pins=ns['load_additional_supplement'](R,norm_ref)
norm_spans=norms['native_output_spans'][-2:]
assert [s['source_sha256'] for s in norm_spans]==[
 'e442f4af3ada0a37b75529d58b2031cfb2b14c1951c788c322995c9a53a4350d',
 '2fbabfb6e24c386ce334047b7ffe0c9a65abaeb475bf23b550c7833caedc3a85']
for v in operator_pins+norm_pins:pin(v)
topology_path=D/'topology-dependency-packet.json';topology=read(topology_path)
pin(ref(topology_path))
for v in topology['runtime']['environment_files']:pin(v)
pin(topology['runtime']['command_receipt']);pin(topology['runtime']['probe'])
for s in topology['native_output_spans']:
 raw=pin({'path':s['source_path'],'sha256':s['source_sha256']}).read_bytes()
 exact=raw[s['start_byte']:s['end_byte_exclusive']]
 assert exact==s['exact_text'].encode() and hashlib.sha256(exact).hexdigest()==s['span_sha256']
spans+=operators['native_output_spans']+norm_spans+topology['native_output_spans']
commands+=operators['probe_commands']+topology['probe_commands']
assert len({(x['source_path'],x['start_byte'],x['end_byte_exclusive']) for x in spans})==len(spans)

old_path=D/'coordinate-high-resolution-audit-preparation/spec-02/audit-spec.json';old=read(old_path)
context=D/'dim-inherited-hyperbolicity-context/source-context-v3.json'
assert sha(context)=='d7a7c44b22d98b4d2125f1438f7ee7315893302ef9202fa9bcb13d9450910206'
spec=json.loads(json.dumps(old))
spec.update(task_id='LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908',
 key='physical-high-resolution-coordinate-sweep',pages='25,26,27,28,125,126',source_context_extension=ref(context))
extension_path=D/'dim-module-root-preparation/spec-extension-v2.json'
extension=read(extension_path);assert set(extension)=={'module_source_root_extension'}
spec.update(extension)
module_plan=ns['load_dim_module_roots'](R,spec)
prior=S/'audits'/spec['prior_task'];task=read(prior/'audit-task.json')
context_data=ns['load_source_context'](R,spec['source_context_extension'],task['source'],spec['pages'],
 W/'workflow-v5.0.1-local/chapter01-source-review')
cfg=read(S/spec['prior_config']);old_manifest=read(prior/'faithfulness/manifest.json')
recorded={v['path']:v['sha256'] for v in old_manifest['lean_environment']}
for path in cfg['lean']['environment_files']:
 assert path in recorded and sha(R/path)==recorded[path],(path,'base environment changed')
target=R/spec['target']['path'];target_ref=pin(ref(target))
for owner in inventory['current_owners']:pin(owner['file'])
assert target_ref==target
assert not (S/'audits'/spec['task_id']).exists()
assert not (D/(spec['task_id']+'.config.json')).exists()

base_packet_path=S/'audits'/spec['supplement_task']/'dependency-environment-packet.json'
base_bytes=base_packet_path.read_bytes();base=read(base_packet_path);base_spans=base['native_output_spans']
for s in base_spans:
 raw=(R/s['source_path']).read_bytes();exact=raw[s['start_byte']:s['end_byte_exclusive']]
 assert hashlib.sha256(raw).hexdigest()==s['source_sha256']
 assert exact==s['exact_text'].encode() and hashlib.sha256(exact).hexdigest()==s['span_sha256']
 assert 'leveque01' not in s['exact_text']

packet={'format':'proof-free-lean-environment-evidence-1',
 'scope':'Exact native primary, nested physical-family contracts, supplied measured directional balance, operators, Cartesian geometry, C-infinity regularity, and complete canonical joint applicability. Source context and interpretation are separate inputs.',
 'runtime':{'native_receipt':ref(native_path),'native_groups':[ref(P/'native-02'/(Path(g['file']).stem+'-receipt.json')) for g in inventory['groups']],
  'canonical_joint_verification':ref(D/'physical-dim-canonical-comparisons/final-receipt.json'),
  'target':ref(target),'native_binary_identity':external[0],
  'generic_operator_packet':operator_ref,'generic_norm_packet':norm_ref,
  'selected_norm_span_indices':[len(norms['native_output_spans'])-2,len(norms['native_output_spans'])-1],
  'topology_packet':ref(topology_path)},
 'native_output_spans':spans,'probe_commands':commands,
 'omissions':['Theorem proof bodies and proof-valued application bodies are not printed.',
  'Only proof fields are suppressed; complete mathematical predicates, data, operators and effective domains are present.',
  'No previous audit findings or verdicts, requested classification, or source interpretation is included in this native evidence.',
  'The generic norm spans omit all old FV source-contract spans. Existing real-measure evidence is separately inherited unchanged.',
  'Blind roles receive only the released exact masked packet; this supplement does not extend blind stdin.']}
OUT.mkdir()
packet_ref=write('native-packet.json',packet)
config_ref=write('native-environment.json',{'format':'pinned-audit-environment-extension-1',
 'environment_files':[{'path':p,'sha256':h} for p,h in sorted(environment.items())]})
extra={'packet':packet_ref,'environment_config':config_ref}
assert ns['load_additional_supplement'](R,extra)[0]==packet
spec['additional_supplement']=extra
same=set(old)-{'task_id','key','pages','source_context_extension','additional_supplement'}
assert all(spec[k]==old[k] for k in same)
merged=ns['merge_additional_supplement'](base_bytes,base_spans,packet,(OUT/'native-packet.json').read_bytes(),extra)
assert len(merged)<1048576,('native merged packet exceeds conservative prompt limit',len(merged))
spec_ref=write('audit-spec.json',spec)
review_ref=write('ellipsis-review.json',{'status':'all native elisions are proof fields; no semantic expression elision',
 'native_group_counts':counts,'elisions':ellipsis_review,
 'regularity':'Actual native output distinguishes Option.none analytic branch and Option.some finite-order tower; inner ENat top is printed via WithTop.some.',
 'source_acceptance':False})
preflight=write('preflight.json',{'schema':1,'status':'PASS_SPEC_ONLY','utc':datetime.now(timezone.utc).isoformat(),
 'spec':spec_ref,'preparer':ref(helper),'module_extension':ref(extension_path),
 'module_plan':spec['module_source_root_extension'],'prior_spec':ref(old_path),'unchanged_spec_keys':sorted(same),
 'primary_locations_preserved':task['source']['locations'],'source_context':ref(context),
 'selected_source_locations':context_data['locations'],'interpretation_receipts':read(context)['interpretation_receipts'],
 'native_receipt':ref(native_path),'notation_only_placement_deltas':inventory['notation_only_placement_deltas'],'native_groups':counts,'actual_native_exits':[0]*len(counts),
 'native_output_bytes':sum(v['bytes'] for v in counts.values()),
 'all_selected_span_bytes':sum(len(s['exact_text'].encode()) for s in spans),
 'additional_packet_json_bytes':(OUT/'native-packet.json').stat().st_size,
 'merged_inherited_plus_additional_native_json_bytes':len(merged),
 'full_role_stdin_bytes':None,'full_role_stdin_size_status':'pending official task preparation and exact role packet; do not infer from native packet size',
 'environment_pins':len(environment),'native_ellipsis_review':review_ref,
 'preparer_invoked':False,'roles_invoked':False,'source_acceptance':False})
print(json.dumps({'spec':spec_ref,'preflight':preflight,'native_packet':extra,
 'native_bytes':sum(v['bytes'] for v in counts.values()),'merged_native_json_bytes':len(merged)},indent=2))
