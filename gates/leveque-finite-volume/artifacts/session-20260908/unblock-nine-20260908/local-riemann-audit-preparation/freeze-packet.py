"""Freeze bounded Info preparation and additive long-path recovery artifacts."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
I=Path(__file__).resolve().parent;D=I.parent;R=I.parents[5];F=D/'fv-local-domain-review'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
names=['CanonicalTypes.lean','native-inputs.json','native-types-output.txt','native-types-receipt.json',
 'source-context-extension.json','source-context-lineage.json','native-environment-packet.json',
 'native-environment-config.json','preparation-checks.json','REVIEW.md','page-026.png','page-027.png','page-028.png',
 'create-native-inputs.py','run-native-types.py','prepare-source-context.py','freeze-audit-spec.py','freeze-packet.py']
files=[ref(I/name) for name in names]+[ref(D/'local-riemann-information-interface-audit-spec.json')]
checks=json.loads((I/'preparation-checks.json').read_bytes());assert checks['all_exact_pins_verified'] and not checks['roles_invoked']
manifest=json.loads((I/'native-inputs.json').read_bytes())
for item in manifest['files']:assert sha(R/item['path'])==item['sha256']
record={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'status':'PREPARATION_COMPLETE_NO_AUDIT_VERDICT','files':files,'canonical_inputs':manifest['files'],
 'native_exit_code':0,'canonical_type_axiom_reports':34,'separate_witness_type_axiom_reports':17,
 'exact_pin_preflight':ref(I/'preparation-checks.json'),'helper':ref(D/'prepare-successor-audit-with-source-context-long-paths.py'),
 'audit_prepared_by_this_task':False,'roles_invoked':False,'production_mutations':False,
 'source_choice_unchanged':True,'primary_locator_unchanged':True,'gate_git_staging_mutations':False}
path=I/'final-receipt.json'
with path.open('x',encoding='utf-8',newline='\n') as f:json.dump(record,f,indent=2);f.write('\n')
recoveryfiles=[ref(F/name) for name in ['LONG-PATH-RECOVERY.md','native-long-path-io.py',
 'partial-prepare-recovery-support.py','build-long-path-preparer.py','check-long-path-recovery.py',
 'fv-partial-preparation-recovery.json','long-path-recovery-checks.json']]
recoveryfiles.append(ref(D/'prepare-successor-audit-with-source-context-long-paths.py'))
recovery={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'status':'GUARDED_RECOVERY_HELPER_TESTED',
 'files':recoveryfiles,'operational_task_mutations_by_this_task':False,'roles_invoked':False,
 'scope':'Read-only operational input verification and scratch long-path test. Root independently invokes operational recovery.'}
rp=F/'long-path-recovery-freeze.json'
with rp.open('x',encoding='utf-8',newline='\n') as f:json.dump(recovery,f,indent=2);f.write('\n')
print(json.dumps({'info_final_receipt':ref(path),'recovery_freeze':ref(rp),'spec':ref(D/'local-riemann-information-interface-audit-spec.json')}))
