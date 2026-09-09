"""Refresh generic proof-free native evidence only; no source-context or audit task creation."""
from pathlib import Path
from datetime import datetime,timezone
import ast,copy,hashlib,json,os,re
F=Path(__file__).resolve().parent;D=F.parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
assert os.name=='posix'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def write(name,value):
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:json.dump(value,out,indent=2,ensure_ascii=False);out.write('\n')
    return ref(F/name)
assert sha(F/'inputs.json')=='8e918fabd5f42579726ac982cfbc516af8f228c2f1fbae39555ea64958da1427'
inputs=read(F/'inputs.json')
for key in ('prior_packet','prior_environment','prior_native_receipt','prior_probe_manifest','probe','probe_bytes_identical_to','runner','runner_bytes_identical_to','launcher','io_helper','source_target','completed_current41','context_templates_unchanged'):
    pin=inputs[key];assert sha(R/pin['path'])==pin['sha256']
assert inputs['probe']['sha256']==inputs['probe_bytes_identical_to']['sha256']
assert inputs['runner']['sha256']==inputs['runner_bytes_identical_to']['sha256']
native_path=F/'native-01/receipt.json';native=read(native_path)
assert native['exit_code']==0 and native['inputs_unchanged']
assert native['input']==inputs['probe']
assert native['command'][1:]==['env','lean',inputs['probe']['path']]
pins=inputs['current_environment_from_prior']+native['input_pins']+[native[key] for key in ('input','input_snapshot','output','stderr')]
for pin in pins:assert sha(R/pin['path'])==pin['sha256'],pin['path']
full=R/native['output']['path'];raw=full.read_bytes();text=raw.decode('utf-8')
assert not (R/native['stderr']['path']).read_bytes()
assert not re.search(r'\b(?:error|warning):|sorryAx|native_decide',text)
assert '⋯ ∧' not in text and '∧ ⋯' not in text
reports={};normalize=lambda n:re.sub(r'\.\{[^{}]*\}$','',n)
for name,body in re.findall(r"^'([^']+)' depends on axioms:\s*\[([^]]*)\]",text,re.M):
    name=normalize(name);assert name not in reports
    body=re.sub(r'\.\{[^{}]*\}','',body)
    values={x.strip() for x in body.split(',') if x.strip()}
    assert values<={'propext','Classical.choice','Quot.sound'}
    reports[name]=sorted(values)
for name in re.findall(r"^'([^']+)' does not depend on any axioms",text,re.M):
    name=normalize(name);assert name not in reports;reports[name]=[]
assert len(reports)==36 and set(reports)==set(inputs['expected_declarations'])
old=read(R/inputs['prior_packet']['path']);packet=copy.deepcopy(old)
old_primary=old['native_output_spans'][0]
assert old_primary['start_byte']==0
span=copy.deepcopy(old_primary)
span.update(source_path=full.relative_to(R).as_posix(),source_sha256=sha(full),start_byte=0,end_byte_exclusive=len(raw),
    span_sha256=hashlib.sha256(raw).hexdigest(),exact_text=text,first_line=1,last_line=raw.count(b'\n'))
packet['native_output_spans'][0]=span
assert packet['native_output_spans'][1:]==old['native_output_spans'][1:]
assert packet['probe_commands']==old['probe_commands']
packet['runtime']['native_receipts']=[ref(native_path)]
packet['runtime']['historical_production_native_receipts']=old['runtime']['production_native_receipts']
descriptors=read(D/'physical-current-complete-declarations/execution-descriptors.json')
packet['runtime']['production_native_receipts']=[descriptors[k]['receipt'] for k in ('full_build','focused_build','complete_native')]
packet['runtime']['current_native_refresh']={'input':inputs['probe'],'identical_prior_input':inputs['probe_bytes_identical_to'],
    'current_source_target':inputs['source_target'],'prior_native_output_bytes_equal':text==old_primary['exact_text'],
    'qualification':'Exact same36 declarations and probe text under current compiled dependencies; no new source convention or acceptance supplied.'}
assert packet['scope']==old['scope'] and packet['omissions']==old['omissions']
pins += [ref(native_path),ref(F/'inputs.json'),inputs['launcher'],inputs['io_helper'],ref(Path(__file__)),
    *[descriptors[k][part] for k in ('full_build','focused_build','complete_native') for part in ('receipt','output')]]
dedup={}
for pin in pins:
    assert sha(R/pin['path'])==pin['sha256']
    assert pin['path'] not in dedup or dedup[pin['path']]==pin['sha256']
    dedup[pin['path']]=pin['sha256']
packet_ref=write('native-packet.json',packet)
env_ref=write('native-environment.json',{'format':'pinned-audit-environment-extension-1',
    'environment_files':[dict(path=path,sha256=digest) for path,digest in sorted(dedup.items())]})
extra={'packet':packet_ref,'environment_config':env_ref}
helper=D/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
nodes=[n for n in ast.parse(helper.read_bytes()).body if isinstance(n,ast.FunctionDef) and n.name=='load_additional_supplement']
assert len(nodes)==1
ns={'Path':Path,'json':json,'hashlib':hashlib}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'::read-only-loader','exec'),ns)
loaded,_,loaded_pins=ns['load_additional_supplement'](R,extra)
assert loaded==packet
extra_ref=write('additional-supplement.json',extra)
validation=write('packet-validation.json',dict(schema=1,status='NATIVE EVIDENCE REFRESH PASS; NO AUDIT OR CONTEXT ADOPTION',
    observed_at_utc=datetime.now(timezone.utc).isoformat(),additional_supplement=extra_ref,
    loader=ref(helper),loader_function_only='load_additional_supplement',top_level_preparer_executed=False,
    native_receipt=ref(native_path),actual_native_exit=0,axiom_reports=reports,report_count=36,
    native_characters=len(text),native_bytes=len(raw),native_spans=len(packet['native_output_spans']),environment_pins=len(dedup),
    old_primary_text_exactly_equal=text==old_primary['exact_text'],old_primary_output=dict(path=old_primary['source_path'],sha256=old_primary['source_sha256']),
    generic_operator_norm_spans_json_identical=True,all_probe_commands_json_identical=True,
    environment_changes=inputs['dependency_changes'],inputs=ref(F/'inputs.json'),
    target_source_unchanged=True,source_context_unchanged=True,interpretation_pending=True,
    audit_spec_created=False,audit_roles_invoked=False,source_acceptance=False))
print(json.dumps({'packet':packet_ref,'environment':env_ref,'additional_supplement':extra_ref,'validation':validation,
    'actual_native_exit':0,'reports':36,'characters':len(text),'bytes':len(raw),'environment_pins':len(dedup),
    'old_primary_text_equal':text==old_primary['exact_text']},indent=2))
