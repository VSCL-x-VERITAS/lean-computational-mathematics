"""Freeze this bounded preparation's deliverables without invoking operational workflows."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json
F=Path(__file__).resolve().parent;D=F.parent;R=F.parents[5]
sha=lambda raw:hashlib.sha256(raw).hexdigest()
def ref(path):return {'path':path.relative_to(R).as_posix(),'sha256':sha(path.read_bytes()),'bytes':len(path.read_bytes())}
names=['FINAL-REVIEW.md','local-law-production-freeze.json','production-inputs-local-law.json',
 'production-local-law-build-exit.json','production-local-law-build-output.txt',
 'production-local-law-declarations-exit.json','production-local-law-declarations-output.txt',
 'source-context-extension-pinned.json','local-law-native-environment-packet.json','local-law-native-environment-config.json',
 'source-context-helper-checks.json','fresh-audit-input-preflight.json',
 'source-context-support.py','build-source-context-helper.py','check-source-context-helper.py',
 'validate-fresh-audit-inputs.py','freeze-local-law-audit-inputs.py','run-production-local-law-check.py',
 'specialize-source-wrapper.py','freeze-review-packet.py','FiniteVolumeLocalFluxUpdate-generic-superseded.lean.fragment',
 'CheckProduction.lean']
files=[ref(F/name) for name in names]
files.extend(ref(D/name) for name in ('prepare-successor-audit-with-source-context.py','finite-volume-local-flux-update-audit-spec.json'))
manifest=json.loads((F/'production-inputs-local-law.json').read_bytes())
for item in manifest['files']:
 assert sha((R/item['path']).read_bytes())==item['sha256'];files.append(ref(R/item['path']))
parent=D/'prepare-successor-audit-with-companions.py'
assert sha(parent.read_bytes())=='a262f79466f9060695cda9dee41e65546858ab847fbdd4d0fc7d9abceffa8cad'
checks=json.loads((F/'source-context-helper-checks.json').read_bytes())
assert len(checks['tests'])==15 and not checks['roles_invoked']
receipt={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'status':'PREPARATION_COMPLETE_NO_AUDIT_VERDICT','files':files,'parent_preparer_unchanged':ref(parent),
 'native_exit_codes':{'focused_build':0,'declarations_and_consumers':0},'helper_fixture_and_read_only_checks':15,
 'read_only_preflight_prior_environment_files':54,'new_audit_not_prepared':True,'roles_invoked':False,
 'input_commit':'5e3f63594aa964263469ada134aee2809559d50d',
 'remaining_root_work':['Review additive helper/spec.','Prepare and run the fresh independent audit.','Complete organization/exposure, complete-manifest checks and additive fingerprints.','Bind outcomes and run campaign gate separately.']}
path=F/'final-preparation-receipt.json'
with path.open('x',encoding='utf-8',newline='\n') as f:json.dump(receipt,f,indent=2);f.write('\n')
print(json.dumps({'receipt':ref(path),'source_files':manifest['files']}))
