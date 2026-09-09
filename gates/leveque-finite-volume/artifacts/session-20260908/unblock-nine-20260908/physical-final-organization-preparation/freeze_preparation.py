"""Freeze preparation artifacts; historical source pins are not rebound as current."""
from pathlib import Path
import ast,datetime,hashlib,json,os
P=Path(__file__).resolve().parent;D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(p,data):
    with p.open('x',encoding='utf-8',newline='\n') as f:json.dump(data,f,indent=2);f.write('\n')
scope=json.loads((P/'scope-01/unit-source-scope.json').read_bytes())
receipt=json.loads((P/'scope-01/receipt.json').read_bytes())
assert receipt['changed_lean']==149 and receipt['semantic_files']==220 and receipt['unit_files']==221
assert receipt['production_modules']==6024 and len(scope['staged_lean_paths'])==58
assert receipt['historical_owner_pins_changed']==9 and all(x['exit_code']==0 for x in receipt['commands'])
for item in receipt['commands']:
    assert ref(R/item['stdout']['path'])==item['stdout'] and ref(R/item['stderr']['path'])==item['stderr']
native=json.loads((P/'assembler-denial-tests-01/receipt.json').read_bytes())
assert all(x['actual_exit_code']==1 and x['expected_rejection'] and x['no_config_directory_created'] for x in native['tests'])
assert native['assembler_sha256']==sha(P/'assemble_config.py')
for name in ['inspect_scope.py','inspect_scope_v2.py','assemble_config.py','freeze_preparation.py']:ast.parse((P/name).read_bytes())
old_helpers=[]
for name in ['final-organization-successor-preparation/support.py',
             'final-organization-successor-preparation/capture_current_v2.py',
             'final-organization-successor-preparation/prepare_draft_v2.py',
             'final-candidate-epoch-preparation/prepare_organization.py',
             'final-organization-actual/config.json','final-organization-actual/organization-template.json']:
    old_helpers.append(ref(D/name))
files=[ref(p) for p in sorted(P.rglob('*')) if p.is_file()]
manifest={'format':'current-organization-scope-preparation-1','frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'status':'PROSPECTIVE_SCOPE_FROZEN_FINAL_CURRENT_INPUTS_PENDING',
    'actual_input_commit':scope['input_commit'],'anchor':scope['anchor'],
    'prospective_pre_repair_source_tree_sha256':scope['source_tree_sha256'],
    'actual_observed_counts':{'production_modules':6024,'semantic_files':220,'unit_files':221,'changed_lean':149,'staged_lean':58},
    'files':files,'preserved_old_helpers_and_config':old_helpers,'scope_receipt':ref(P/'scope-01/receipt.json'),
    'native_denial_tests':ref(P/'assembler-denial-tests-01/receipt.json'),
    'final_config_emitted':False,'organization_capture_runs':0,'organization_draft_runs':0,
    'organization_validator_runs':0,'git_mutations':0,'source_acceptance':False,
    'historical_scope_refs_not_asserted_current_after_planned_repair':True}
write(P/'manifest.json',manifest)
write(P/'receipt.json',{'format':'prospective-organization-preparation-freeze-1','manifest':ref(P/'manifest.json'),
    'review':ref(P/'REVIEW.md'),'commands':ref(P/'COMMANDS.md'),'scope_inspection_completed':True,
    'actual_git_exits_all_zero':True,'scope_receipt':ref(P/'scope-01/receipt.json'),
    'actual_denial_tests_exit_codes':[1,1],'denials_expected':True,
    'final_current_config_requires_new_inputs':True,'source_acceptance':False})
print(json.dumps({'manifest':ref(P/'manifest.json'),'receipt':ref(P/'receipt.json'),
    'inspector':ref(P/'inspect_scope_v2.py'),'assembler':ref(P/'assemble_config.py')},indent=2))
