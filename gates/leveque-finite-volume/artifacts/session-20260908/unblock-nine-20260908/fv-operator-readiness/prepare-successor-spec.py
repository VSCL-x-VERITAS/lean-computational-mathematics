"""Write a fresh spec and evidence only. Do not invoke released preparation or roles."""
from datetime import datetime, timezone
from pathlib import Path
import ast
import hashlib
import json
import os

D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
W=R.parent
S=D.parent.parent
M=D.parent/'measure-operator-evidence'
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),
             'native-long-path-io','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(p,obj):
    with p.open('xb') as handle:handle.write((json.dumps(obj,indent=2,ensure_ascii=False)+'\n').encode())

helper=D.parent/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
nodes=[n for n in ast.parse(helper.read_bytes()).body if isinstance(n,ast.FunctionDef)
       and n.name in {'load_additional_supplement','load_source_context','merge_additional_supplement'}]
assert len(nodes)==3
ns={'Path':Path,'hashlib':hashlib,'json':json}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'::read-only-loaders','exec'),ns)
load=ns['load_additional_supplement']
old_spec_path=D.parent/'finite-volume-local-flux-update-audit-spec.json'
assert sha(old_spec_path)=='f7fd48ecc297b53af91f1f3cc11262956c72d8e58c998fb3bc4e300a68b4473d'
old=read(old_spec_path)
local,local_raw,local_pins=load(R,old['additional_supplement'])
operator_ref=read(M/'additional-supplement.json')
operators,operator_raw,operator_pins=load(R,operator_ref)
native=read(D/'native-01/receipt.json')
assert native['exit_code']==0 and native['inputs_unchanged']
output=D/'native-01/output.txt';raw=output.read_bytes()
assert sha(output)==native['output_sha256']
start=raw.index('⋯ : ∀ {α : Type u_1}'.encode())
end=raw.index(b'protected def ENNReal.toNNReal',start)
exact=raw[start:end]
assert b'MeasureTheory.Integrable f' in exact and 'Fin m → ℝ'.encode() in exact
assert b'MeasureTheory.L1.integral' in exact
bridge={'label':'Native integral_eq specialization to the actual finite real-vector codomain',
    'source_path':output.relative_to(R).as_posix(),'source_sha256':sha(output),
    'start_byte':start,'end_byte_exclusive':end,
    'span_sha256':hashlib.sha256(exact).hexdigest(),'exact_text':exact.decode(),
    'first_line':raw[:start].count(b'\n')+1,'last_line':raw[:end].count(b'\n')}
packet={'format':'proof-free-lean-environment-evidence-1',
    'scope':'Unchanged local-law declaration evidence plus unchanged generic measure/operator evidence and an exact native integral_eq specialization to Fin m → ℝ. This supplies dependency definitions only.',
    'runtime':{'reused_local_packet':old['additional_supplement'],
        'reused_operator_packet':operator_ref,'native_bridge_receipt':ref(D/'native-01/receipt.json'),
        'native_bridge_probe':ref(D/'PiNorm.lean')},
    'native_output_spans':local['native_output_spans']+operators['native_output_spans']+[bridge],
    'probe_commands':local['probe_commands']+operators['probe_commands']+[
        '#check fun {α : Type*} [MeasurableSpace α] (μ : MeasureTheory.Measure α) (f : α → Fin m → ℝ) (hf : MeasureTheory.Integrable f μ) => MeasureTheory.integral_eq f hf'],
    'omissions':['No source theorem, interpretation, target signature, target proof, or prior judgment is changed or added.',
        'Prior decisions are not included in this evidence packet. Both implications remain for fresh independent review.',
        'The norm/conversion outputs from the bridge probe are not supplied as extra native spans here; the separate readiness packet retains them.',
        'The old local and operator packet spans are copied exactly. Their native probes are not rerun.']}
packet_path=D/'integral-successor-packet.json';write(packet_path,packet)
pins=local_pins+operator_pins
pins += read(D/'environment-extension.json')['environment_files']
dedup={}
for item in pins:
    assert sha(R/item['path'])==item['sha256']
    assert item['path'] not in dedup or dedup[item['path']]==item['sha256']
    dedup[item['path']]=item['sha256']
config_path=D/'integral-successor-environment.json'
write(config_path,{'format':'pinned-audit-environment-extension-1',
    'environment_files':[{'path':p,'sha256':h} for p,h in sorted(dedup.items())]})
extra={'packet':ref(packet_path),'environment_config':ref(config_path)}
assert load(R,extra)[0]==packet
spec=json.loads(json.dumps(old))
spec.update(task_id='LEV-CH01-FV-LOCAL-FLUX-UPDATE-OPERATOR-QUALIFIED-20260908',
    key='finite-volume-local-flux-update-operator',additional_supplement=extra)
spec_path=D.parent/'finite-volume-local-flux-update-operator-audit-spec.json'

prior=S/'audits'/spec['prior_task']
prior_task=read(prior/'audit-task.json')
current=S/'audits'/old['task_id']
current_task=read(current/'audit-task.json')
context=ns['load_source_context'](R,spec['source_context_extension'],prior_task['source'],
    spec['pages'],W/'workflow-v5.0.1-local/chapter01-source-review')
assert context['locations']==current_task['source']['locations']
assert spec['target']==old['target']==current_task['target']
assert sha(R/spec['target']['path'])=='669f818bde8cc0e616ad63a9bcc5d05791da132d4edcdb2d6286a769193fde7b'
same_keys=set(old)-{'task_id','key','additional_supplement'}
assert all(spec[k]==old[k] for k in same_keys)
assert sha(D.parent/'selected-interpretations.json')=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
prior_config=read(S/spec['prior_config'])
prior_manifest=read(prior/'faithfulness/manifest.json')
recorded={x['path']:x['sha256'] for x in prior_manifest['lean_environment']}
for path in prior_config['lean']['environment_files']:
    assert path in recorded and sha(R/path)==recorded[path],path

base=read(S/'audits'/spec['supplement_task']/'dependency-environment-packet.json')
merged=json.loads(ns['merge_additional_supplement'](
    (S/'audits'/spec['supplement_task']/'dependency-environment-packet.json').read_bytes(),
    base['native_output_spans'],packet,packet_path.read_bytes(),extra))
current_packet=read(current/'dependency-environment-packet.json')
assert merged['native_output_spans'][:len(current_packet['native_output_spans'])]==current_packet['native_output_spans']
assert len(merged['native_output_spans'])==len(current_packet['native_output_spans'])+len(operators['native_output_spans'])+1
destination=S/'audits'/spec['task_id']
assert not destination.exists()
assert not (D.parent/(spec['task_id']+'.config.json')).exists()
write(spec_path,spec)
write(D/'successor-preflight.json',{'schema':1,'status':'PASS_SPEC_ONLY_NO_AUDIT_PREPARATION',
    'observed_at_utc':datetime.now(timezone.utc).isoformat(),
    'spec':ref(spec_path),'helper':ref(helper),'prior_spec':ref(old_spec_path),
    'immediate_completed_task':old['task_id'],'immediate_completed_manifest':ref(current/'faithfulness/manifest.json'),
    'unchanged_primary_target':ref(R/spec['target']['path']),
    'unchanged_current_source_selection':current_task['source'],
    'unchanged_source_context_extension':spec['source_context_extension'],
    'unchanged_selection_receipt':ref(D.parent/'selected-interpretations.json'),
    'unchanged_keys_compared':sorted(same_keys),
    'lineage_note':'The original pre-extension locator/config lineage is retained exactly, so the same inherited context is applied once; immediate completed task and manifest are recorded separately here and are not provided as judgments to auditors.',
    'verified_prior_environment_files':len(prior_config['lean']['environment_files']),
    'unchanged_current_native_spans':len(current_packet['native_output_spans']),
    'added_unchanged_operator_spans':len(operators['native_output_spans']),
    'added_native_bridge_spans':1,'actual_native_exit':0,'native_receipt':ref(D/'native-01/receipt.json'),
    'packet_loader_verified':True,'source_context_loader_verified':True,
    'destination_absent_at_preflight':True,'released_prepare_invoked':False,
    'roles_invoked':False,'prior_audits_modified':False,'source_acceptance':False})
print(json.dumps({'spec':ref(spec_path),'preflight':ref(D/'successor-preflight.json'),
    'additional_supplement':extra},indent=2))
