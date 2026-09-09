"""Additive evidence/spec construction only: no preparation, roles, Git, or gate writes."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os,re
E=Path(__file__).resolve().parent; D=E.parent; S=D.parent
R=next(p for p in E.parents if (p/'lean-toolchain').is_file()); W=R.parent
shim=D/'fv-local-domain-review/native-long-path-io.py'
exec(compile(shim.read_bytes(),str(shim),'exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
def write(p,j):
 with p.open('xb') as h:h.write((json.dumps(j,indent=2,ensure_ascii=False)+'\n').encode())
def span(path,label):
 raw=path.read_bytes()
 return dict(label=label,source_path=path.relative_to(R).as_posix(),source_sha256=sha(path),
  start_byte=0,end_byte_exclusive=len(raw),span_sha256=sha(path),exact_text=raw.decode(),
  first_line=1,last_line=raw.count(b'\n'))
def verify_native(folder,probe,runner):
 receipt=read(folder/'receipt.json'); output=folder/'output.txt'
 assert type(receipt['exit_code']) is int and receipt['exit_code']==0
 assert receipt['inputs_unchanged'] and sha(output)==receipt['output_sha256']
 assert sha(probe)==receipt['input_snapshot_sha256']
 assert sha(runner)==receipt['runner_sha256']
 assert not re.search(r'\b(?:warning|error):|sorryAx',output.read_text())
 for x in receipt['inputs']:
  assert x['sha256_before']==x['sha256_after']==sha(R/x['path']),x['path']
 return receipt
helper=D/'prepare-successor-audit-with-source-context-long-paths.py'
assert sha(helper)=='fc1afd7578e69927edca25788423334f3947b8d58e348b176ae0a1cd3d64318e'
nodes=[n for n in ast.parse(helper.read_bytes()).body if isinstance(n,ast.FunctionDef)
 and n.name in {'load_additional_supplement','load_source_context','merge_additional_supplement'}]
assert len(nodes)==3
ns={'Path':Path,'hashlib':hashlib,'json':json}
exec(compile(ast.Module(body=nodes,type_ignores=[]),str(helper)+'::read-only-loaders','exec'),ns)
load=ns['load_additional_supplement']
oldpath=D/'finite-volume-local-flux-update-operator-audit-spec.json'
old=read(oldpath)
assert old['additional_supplement']['packet']['sha256']=='1d9e38b8f9bc407956a5b12dcb84337a599a2bea639d3b149aa9ac8efd98c453'
base,basebytes,basepins=load(R,old['additional_supplement'])
legacy=D/'fv-operator-readiness'
legacy_receipt=verify_native(legacy/'native-01',legacy/'PiNorm.lean',legacy/'run-probe.py')
native=verify_native(E/'native-02',E/'NormInstances.lean',E/'run-probe.py')
assert (E/'NormInstances.lean').read_bytes()==(E/'native-02/NormInstances.lean.snapshot').read_bytes()
commands=[line for line in (E/'NormInstances.lean').read_text().splitlines()
 if line.startswith(('#check ','#print ','#synth '))]
expected=[line.removeprefix('#print axioms ') for line in commands if line.startswith('#print axioms ')]
text=(E/'native-02/output.txt').read_text()
matches=re.findall(r"^'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)",text,re.M)
normalize=lambda name:re.sub(r'\.\{[^}]*\}','',name)
observed={normalize(name):[normalize(x.strip()) for x in axioms.split(',') if x.strip()] for name,axioms in matches}
expected=[('FiniteRealVectorNormEvidence.'+n if n in {
 'ring_norm_eq_addCommGroup_norm','ring_norm_eq_addGroup_norm','ring_norm_eq_sup',
 'ring_norm_le_iff_abs','ring_norm_le_iff_abs_of_pos','ofReal_ring_norm_eq_enorm','ring_norm_smul',
 'integral_enorm_eq_ring_norm','generic_integral_enorm_eq_ring_norm'} else n) for n in expected]
assert len(matches)==len(expected)==17 and set(observed)==set(expected)
assert all(set(a)<={'propext','Classical.choice','Quot.sound'}for a in observed.values())
for needle in ['Pi.nonUnitalSeminormedRing','Finset.univ.sup','@NormedRing.toNorm',
 '@NormedAddCommGroup.toNorm','@NormedAddGroup.toNorm','@NormedAddGroup.toENormedAddMonoid',
 '@NormedAddCommGroup.toENormedAddCommMonoid','|v i| ≤ r','|c| * ‖v‖']:
 assert needle in text,needle
newspans=[span(legacy/'native-01/output.txt','Previously retained native finite-vector norm and integral characterizations'),
 span(E/'native-02/output.txt','Exact finite-real-vector norm projections, coordinate bounds, extended norms, and scaling')]
legacy_commands=[line for line in (legacy/'PiNorm.lean').read_text().splitlines()
 if line.startswith(('#check ','#print ','#synth '))]
packet=dict(format='proof-free-lean-environment-evidence-1',
 scope='Unchanged local/operator/integral declarations with exact native finite-real-vector norm-instance characterizations. Only definition bodies and theorem types are displayed.',
 runtime=dict(reused_packet=old['additional_supplement'],legacy_native_receipt=ref(legacy/'native-01/receipt.json'),
  new_native_receipt=ref(E/'native-02/receipt.json'),new_probe=ref(E/'NormInstances.lean')),
 native_output_spans=base['native_output_spans']+newspans,
 probe_commands=base['probe_commands']+legacy_commands+commands,
 omissions=['No source target, proof, interpretation, prior judgment, requested classification or acceptance is added.',
 'Every previous local/operator/integral native span is retained byte-for-byte.',
 'The new equalities concern exact finite-real-vector norm and extended-norm instances only; they do not choose a source interpretation.',
 'Selected source and compiled dependencies are pinned; this is not a blanket transitive environment inventory.'])
packetpath=E/'dependency-packet.json'; write(packetpath,packet)
pins=list(basepins)
for folder,receipt,probe,runner in [(legacy/'native-01',legacy_receipt,legacy/'PiNorm.lean',legacy/'run-probe.py'),
 (E/'native-02',native,E/'NormInstances.lean',E/'run-probe.py')]:
 pins.extend(dict(path=x['path'],sha256=x['sha256_before'])for x in receipt['inputs'])
 pins.extend(ref(p)for p in [folder/'receipt.json',folder/'output.txt',probe,runner])
 pins.extend(ref(p)for p in folder.iterdir()if p.name.endswith('.snapshot'))
dedup={}
for item in pins:
 assert sha(R/item['path'])==item['sha256']
 assert item['path'] not in dedup or dedup[item['path']]==item['sha256']
 dedup[item['path']]=item['sha256']
configpath=E/'environment-extension.json'
write(configpath,dict(format='pinned-audit-environment-extension-1',
 environment_files=[dict(path=p,sha256=h)for p,h in sorted(dedup.items())]))
extra=dict(packet=ref(packetpath),environment_config=ref(configpath))
assert load(R,extra)[0]==packet
write(E/'additional-supplement.json',extra)
spec=json.loads(json.dumps(old))
spec.update(task_id='LEV-CH01-FV-LOCAL-FLUX-UPDATE-NORM-COMPLETE-PRODUCTION-20260908',
 key='finite-volume-local-flux-update-norm-complete',additional_supplement=extra)
samekeys=set(old)-{'task_id','key','additional_supplement'}
assert all(spec[k]==old[k]for k in samekeys)
assert spec['task_id'].endswith('-PRODUCTION-20260908')
current=S/'audits'/old['task_id']; current_task=read(current/'audit-task.json')
decision=current/'faithfulness/decision.json'
assert sha(decision)=='2fa401b7a73b382e108d45903600185c6631ba522ab809b523c8d7a20f7f2ad8'
assert read(decision)['accepted'] is False and read(decision)['classification']=='undetermined'
prior=S/'audits'/spec['prior_task']; prior_task=read(prior/'audit-task.json')
context=ns['load_source_context'](R,spec['source_context_extension'],prior_task['source'],
 spec['pages'],W/'workflow-v5.0.1-local/chapter01-source-review')
assert context['locations']==current_task['source']['locations']
assert spec['target']==old['target']==current_task['target']
assert sha(R/spec['target']['path'])=='669f818bde8cc0e616ad63a9bcc5d05791da132d4edcdb2d6286a769193fde7b'
assert sha(D/'selected-interpretations.json')=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
prior_config=read(S/spec['prior_config']); prior_manifest=read(prior/'faithfulness/manifest.json')
recorded={x['path']:x['sha256']for x in prior_manifest['lean_environment']}
for path in prior_config['lean']['environment_files']:
 assert path in recorded and sha(R/path)==recorded[path],path
inherited_path=S/'audits'/spec['supplement_task']/'dependency-environment-packet.json'
inherited=read(inherited_path)
merged=json.loads(ns['merge_additional_supplement'](inherited_path.read_bytes(),
 inherited['native_output_spans'],packet,packetpath.read_bytes(),extra))
current_packet=read(current/'dependency-environment-packet.json')
assert merged['native_output_spans'][:len(current_packet['native_output_spans'])]==current_packet['native_output_spans']
assert len(merged['native_output_spans'])==len(current_packet['native_output_spans'])+2
assert not (S/'audits'/spec['task_id']).exists()
assert not (D/(spec['task_id']+'.config.json')).exists()
specpath=E/'audit-spec.json';write(specpath,spec)
write(E/'successor-preflight.json',dict(schema=1,status='PASS_SPEC_ONLY_NO_AUDIT_PREPARATION',
 observed_at_utc=datetime.now(timezone.utc).isoformat(),spec=ref(specpath),helper=ref(helper),
 prior_spec=ref(oldpath),historical_completed_decision=ref(decision),
 historical_completed_manifest=ref(current/'faithfulness/manifest.json'),
 unchanged_target=ref(R/spec['target']['path']),unchanged_source=current_task['source'],
 unchanged_source_context_extension=spec['source_context_extension'],
 unchanged_selection_receipt=ref(D/'selected-interpretations.json'),unchanged_keys=sorted(samekeys),
 retained_current_native_spans=len(current_packet['native_output_spans']),added_native_spans=2,
 native_actual_exit=0,native_axiom_reports=17,native_axioms=observed,
 packet_loader_verified=True,source_context_loader_verified=True,
 released_prepare_invoked=False,roles_invoked=False,source_acceptance=False,
 lineage='Original config and pre-extension locator retained; completed decision appears only in this historical preflight, never in the role evidence packet.'))
write(E/'manifest.json',dict(schema=1,status='NATIVE_AND_PREFLIGHT_PASS',source_acceptance=False,
 files=[ref(p)for p in sorted(E.rglob('*'))if p.is_file() and '__pycache__' not in p.parts],
 runner_derivation=dict(parent=ref(legacy/'run-probe.py'),changes=['probe filename','four norm dependency modules']),
 preparer_derivation=dict(parent=ref(legacy/'prepare-successor-spec.py'),
 changes=['retain entire old additional packet','append existing omitted norm outputs and new exact instance bridges',
 'new production-suffixed task ID','historical decision in preflight only']),
 native_actual_exit=0,axiom_reports=17,new_bridge_declarations=9))
write(E/'receipt.json',dict(schema=1,status='PASS_EVIDENCE_AND_SPEC_ONLY',source_acceptance=False,
 manifest=ref(E/'manifest.json'),spec=ref(specpath),preflight=ref(E/'successor-preflight.json'),
 additional_supplement=extra,native_receipt=ref(E/'native-02/receipt.json'),
 unchanged_target=ref(R/spec['target']['path']),native_actual_exit=0,axiom_reports=17))
print(json.dumps(dict(receipt=ref(E/'receipt.json'),spec=ref(specpath),preflight=ref(E/'successor-preflight.json'),
 additional_supplement=extra),indent=2))
