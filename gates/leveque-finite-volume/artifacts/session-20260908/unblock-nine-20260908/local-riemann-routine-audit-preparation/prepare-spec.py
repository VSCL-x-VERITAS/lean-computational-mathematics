"""Build a proof-free Routine successor spec, invoking only read-only preparer functions."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os,re
D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
S=D.parent.parent;P=D.parent/'riemann-routine-production'
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'long-path-io','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(p,value):
    with p.open('xb') as h:h.write((json.dumps(value,indent=2,ensure_ascii=False)+'\n').encode())
def pin(item):
    p=R/item['path'];assert sha(p)==item['sha256'];return ref(p)
def span(path,start=0,end=None,label='Exact native output'):
    raw=path.read_bytes();end=len(raw) if end is None else end;piece=raw[start:end]
    return {'label':label,'source_path':path.relative_to(R).as_posix(),'source_sha256':sha(path),
        'start_byte':start,'end_byte_exclusive':end,'span_sha256':hashlib.sha256(piece).hexdigest(),
        'exact_text':piece.decode(),'first_line':raw[:start].count(b'\n')+1,'last_line':raw[:end].count(b'\n')}
def axiom_names(text):
    rows=re.findall(r"^'([^']+)' depends on axioms:\s*\[([^\]]*)\]",text,re.M)
    for _,items in rows:
        assert {re.sub(r'\.\{[^}]*\}','',x.strip()) for x in items.split(',')} <= {'propext','Classical.choice','Quot.sound'}
    return [name for name,_ in rows]

helper=D.parent/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
nodes=[n for n in ast.parse(helper.read_bytes()).body if isinstance(n,ast.FunctionDef)
    and n.name in {'load_additional_supplement','load_source_context'}]
assert len(nodes)==2
ns={'Path':Path,'json':json,'hashlib':hashlib}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'::loaders','exec'),ns)
load=ns['load_additional_supplement']
assert sha(P/'receipt.json')=='133d9adc7f9d23c16412193f571f0ad21d59a633827940586c0d4f1a391a08ba'
assert sha(P/'manifest.json')=='54942e13c3f38db8e467a5bbd0eab9c3bd919bcf3638d2a146d92f3a650321c0'
production=read(P/'manifest.json');inventory=read(P/'files.json')
assert sum(len(x['declarations']) for x in inventory['files'])==22
environment=[pin(x) for x in production['files']+production['production_compiled']]
for entry in production['dependencies']:
    environment.extend(pin(entry[k]) for k in ('source','compiled'))
for item in production['runtime']:
    path=R/item['path'];assert sha(path)==item['sha256']
    if path.is_relative_to(R):environment.append(ref(path))

receipts=[];outputs={}
for label in ['unblock-nine-routine-declarations-02','unblock-nine-routine-applicability-04']:
    entry=next(x for x in production['native'] if x['label']==label)
    for key in ['receipt','output','input']:environment.append(pin(entry[key]))
    receipt=read(R/entry['receipt']['path'])
    assert receipt['exit_code']==entry['actual_exit']==0
    path=R/entry['output']['path'];assert sha(path)==receipt['output_sha256']
    raw=path.read_bytes();assert not re.search(rb'\b(?:error|warning):|sorryAx',raw)
    receipts.append(pin(entry['receipt']));outputs[label]=path
old_output=outputs['unblock-nine-routine-declarations-02'];raw=old_output.read_bytes()
assert set(axiom_names(raw.decode()))=={n for x in inventory['files'] for n in x['declarations']}
first_end=raw.index(b'NumStability.LocalRiemannInformation.routine_local_interface_contract.')
second_start=raw.index(b'NumStability.BiasedLocalRiemannRoutine.law :')
second_end=raw.index(b'NumStability.leveque01_localRiemannRoutineInterface_sourceContract.')
routine_spans=[span(old_output,0,first_end,'Routine producers: exact native types and axiom reports'),
    span(old_output,second_start,second_end,'Biased scalar routine: exact native example types and axiom reports'),
    span(outputs['unblock-nine-routine-applicability-04'],label='Actual primary-target application: exact native types and axiom reports')]
assert len(axiom_names(routine_spans[0]['exact_text']))+len(axiom_names(routine_spans[1]['exact_text']))==20
assert len(axiom_names(routine_spans[2]['exact_text']))==2

complete=read(D/'native-full-exit.json');assert complete['exit_code']==0 and complete['inputs_unchanged']
full_output=D/'native-full-output.txt';assert sha(full_output)==complete['stdout_sha256']
full_text=full_output.read_text();assert not re.search(r'\b(?:error|warning):|sorryAx',full_text)
assert '⋯ ∧' not in full_text and '∧ ⋯' not in full_text
assert len(axiom_names(full_text))==2
assert 'rightSolverBound + rightComparison' in full_text
routine_spans.append(span(full_output,label='Routine definitions and complete source/core native types; deep terms enabled, proofs hidden'))
environment += [pin(x) for x in complete['input_pins']]
environment += [ref(x) for x in [D/'native-full-exit.json',full_output,D/'native-full-stderr.txt',D/'run-native-full.py',P/'files.json']]
receipts.append(ref(D/'native-full-exit.json'))

operator_reference=read(D.parent/'measure-operator-evidence/additional-supplement.json')
operators,_,operator_pins=load(R,operator_reference)
norm_reference={'packet':{'path':(D.parent/'fv-norm-complete-evidence/dependency-packet.json').relative_to(R).as_posix(),
    'sha256':'485da3e72c5590d346c920a4a9d392178800be8579cfebe9571126453142918f'},
    'environment_config':{'path':(D.parent/'fv-norm-complete-evidence/environment-extension.json').relative_to(R).as_posix(),
    'sha256':'71b90143190e51646868ccea4c7f26edd66cc3cd77fb691b51c30c676ea2082c'}}
norms,_,norm_pins=load(R,norm_reference)
norm_spans=norms['native_output_spans'][-2:]
assert norm_spans[0]['source_sha256']=='e442f4af3ada0a37b75529d58b2031cfb2b14c1951c788c322995c9a53a4350d'
assert norm_spans[1]['source_sha256']=='2fbabfb6e24c386ce334047b7ffe0c9a65abaeb475bf23b550c7833caedc3a85'
bridge=read(D.parent/'fv-operator-readiness/integral-successor-packet.json')['native_output_spans'][-1]
assert bridge['exact_text'] in norm_spans[0]['exact_text']
environment += operator_pins+norm_pins
dedup={}
for entry in environment:
    assert sha(R/entry['path'])==entry['sha256']
    assert entry['path'] not in dedup or dedup[entry['path']]==entry['sha256']
    dedup[entry['path']]=entry['sha256']
packet={'format':'proof-free-lean-environment-evidence-1',
    'scope':'Exact native Routine declarations and concrete applicability, generic measure/integral semantics, and the actual finite-real-vector norm/extended-norm instances. All source interpretation is separately supplied.',
    'runtime':{'native_receipts':receipts,'reused_generic_operator_packet':operator_reference,
        'reused_generic_norm_packet':norm_reference,'selected_norm_span_indices':[len(norms['native_output_spans'])-2,len(norms['native_output_spans'])-1],
        'finite_vector_integral_bridge_included_verbatim':True,
        'source':ref(R/'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalRoutineInterface.lean')},
    'native_output_spans':routine_spans+operators['native_output_spans']+norm_spans,
    'probe_commands':[x for x in (P/'Declarations.lean').read_text().splitlines() if x.startswith(('#check ','#print '))]+
        [x for x in (D/'CompleteTypesFull.lean').read_text().splitlines() if x.startswith(('#check ','#print '))]+
        operators['probe_commands'],
    'omissions':['No proof body, prior audit judgment, requested verdict, new source interpretation or independent source claim is supplied.',
        'Two older native capstone spans with pretty-printer omissions are replaced by the newly captured complete types; the old output bytes remain unchanged.',
        'Only the two generic norm spans are reused from the FV norm packet; FV-specific source/local-law contract spans are not copied.',
        'Existing successful native probes are reused; only the source/core pretty-print capture is new.']}
write(D/'native-packet.json',packet)
write(D/'native-environment.json',{'format':'pinned-audit-environment-extension-1',
    'environment_files':[{'path':p,'sha256':h} for p,h in sorted(dedup.items())]})
extra={'packet':ref(D/'native-packet.json'),'environment_config':ref(D/'native-environment.json')}
assert load(R,extra)[0]==packet

old_spec_path=D.parent/'local-riemann-information-interface-audit-spec.json'
assert sha(old_spec_path)=='955333b82fac3f9773a407b3860c171927afed1f20e481933c36d589c58bd962'
old=read(old_spec_path);spec=json.loads(json.dumps(old))
spec.update(task_id='LEV-CH01-LOCAL-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908',
    key='local-riemann-routine-interface',target={'path':'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannLocalRoutineInterface.lean',
    'declaration':'NumStability.leveque01_localRiemannRoutineInterface_sourceContract'},additional_supplement=extra)
assert spec['task_id'].endswith('-PRODUCTION-20260908')
assert sha(R/spec['target']['path'])=='040ea61593eebde326af7ee10b68f228c76186834907e3d27e2f5ac9007ed8ef'
same=set(old)-{'task_id','key','target','additional_supplement'}
assert all(old[k]==spec[k] for k in same)
prior=S/'audits'/spec['prior_task'];task=read(prior/'audit-task.json')
context=ns['load_source_context'](R,spec['source_context_extension'],task['source'],spec['pages'],
    R.parent/'workflow-v5.0.1-local/chapter01-source-review')
previous=S/'audits'/old['task_id']
assert context['locations']==read(previous/'audit-task.json')['source']['locations']
cfg=read(S/spec['prior_config']);manifest=read(prior/'faithfulness/manifest.json')
recorded={x['path']:x['sha256'] for x in manifest['lean_environment']}
for path in cfg['lean']['environment_files']:assert sha(R/path)==recorded[path]
assert not (S/'audits'/spec['task_id']).exists()
assert not (D.parent/(spec['task_id']+'.config.json')).exists()
write(D/'audit-spec.json',spec)
write(D/'preflight.json',{'schema':1,'status':'PASS_SPEC_ONLY','observed_at_utc':datetime.now(timezone.utc).isoformat(),
    'spec':ref(D/'audit-spec.json'),'helper':ref(helper),'producer_receipt':ref(P/'receipt.json'),
    'producer_manifest':ref(P/'manifest.json'),'prior_spec':ref(old_spec_path),'unchanged_spec_keys':sorted(same),
    'preserved_source_locations':context['locations'],'preserved_source_context':spec['source_context_extension'],
    'source':ref(R/spec['target']['path']),'native_packet':extra,'native_spans':len(packet['native_output_spans']),
    'production_declarations':22,'fixture_declarations':2,'complete_type_native_exit':0,
    'old_norm_and_integral_native_evidence_reused':True,'destination_absent_at_preflight':True,
    'preparer_invoked':False,'roles_invoked':False,'source_acceptance':False})
print(json.dumps({'spec':ref(D/'audit-spec.json'),'preflight':ref(D/'preflight.json'),
    'packet':extra,'native_spans':len(packet['native_output_spans'])},indent=2))
