"""Freeze this preparation only; no Git, native build, checker or gate write."""
from pathlib import Path
import hashlib
import json

P = Path(__file__).resolve().parent
R = P.parents[5]
D = P.parent
S = D.parent
sha = lambda b: hashlib.sha256(b).hexdigest()

def ref(p):
    return {'path':p.relative_to(R).as_posix(),'sha256':sha(p.read_bytes())}

def load(p): return json.loads(p.read_bytes())

def put(name,obj):
    with (P/name).open('x',encoding='utf-8',newline='\n') as f:
        f.write(json.dumps(obj,indent=2,ensure_ascii=True)+'\n')

def main():
    plan = load(D/'organization-certified-routine/plan.json')
    inventory_ref = plan['production_files']
    inventory_path = R/inventory_ref['path']
    assert ref(inventory_path) == inventory_ref
    inventory = load(inventory_path)
    files = inventory['files']
    assert len(files) == 4 and sum(len(x['declarations']) for x in files) == 7
    for item in files:
        assert ref(R/item['path'])['sha256'] == item['sha256']
    tier_receipt = S/'unblock-nine-final-current-tiers-exit.json'
    tier_output = S/'unblock-nine-final-current-tiers-output.txt'
    t = load(tier_receipt)
    assert type(t['exit_code']) is int and t['exit_code'] == 0
    assert t['command'] == ['/usr/bin/python3','tools/architecture/check_tiers.py']
    assert t['output_sha256'] == ref(tier_output)['sha256']
    put('certified-routine-addendum.json', {'status':'root-review-required',
        'production_inventory':inventory_ref,'production_receipt':plan['production_receipt'],
        'placement_review':ref(D/'organization-certified-routine/REVIEW.md'),
        'placement_receipt':ref(D/'organization-certified-routine/receipt.json'),
        'placement_review_config_entry':{
            'evidence':ref(D/'organization-certified-routine/REVIEW.md'),
            'rationale':'Three generic supplied certificate/update/example owners and one thin source wrapper; old Routine files are preserved.',
            'covered_source_paths':[x['path'] for x in files]},
        'actual_current_tier_receipt':ref(tier_receipt),'actual_current_tier_output':ref(tier_output),
        'remaining_root_runs_not_duplicated':['source-inventory','layout','compatibility','hygiene','full-build','graph'],
        'seventh_inventory_and_final_native_manifest':'pending frozen input; no count or source verdict inferred',
        'root_report_correction':'Ordinary commit and fast-forward HEAD:main publication are already authorized; protected campaign admission/stable promotion remain distinct.'})
    put('preparation-tool-result.json', {'tool':'exec_command','command':
        "& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -X utf8 -B '"+str(P/'assemble_blueprint.py').replace('\\','/')+"'",
        'exit_code':0,'wall_time_seconds':1.913416292,
        'output':'{"status": "root-review-required", "frozen_native_constants": 1419, "frozen_native_owners": 167, "read_only_inputs": 249, "blueprint_schema_refusal": "pending future inputs must be resolved", "operational_measurement_run": false}\r\n',
        'kind':'recorded actual preparation tool result; not an operational checker receipt'})
    inputs = load(P/'input-pins.json')['files']
    for item in inputs:
        assert ref(R/item['path']) == item, 'changed input: '+item['path']
    helpers = [D/'final-organization-successor-preparation'/name for name in
        ('capture_current_v2.py','prepare_draft_v2.py','support.py','receipt.json')]
    helpers += [D/'final-candidate-epoch-preparation'/name for name in
        ('prepare_organization.py','candidate_checks.py','organization-inputs.template.json')]
    put('derivation.json', {'status':'root-review-required','reused_helpers':[ref(x) for x in helpers],
        'modified_existing_helpers':False,'input_pin_count':len(inputs),'all_pinned_bytes_rechecked':True})
    package = [ref(p) for p in sorted(P.iterdir()) if p.is_file()]
    put('manifest.json', {'schema':1,'status':'preparation-frozen-root-review-required','files':package,
        'operational_measurement_run':False,'source_completion_claimed':False,'git_or_gate_mutation':False})
    put('receipt.json', {'schema':1,'status':'preparation-frozen-root-review-required',
        'manifest':ref(P/'manifest.json'),'review':ref(P/'REVIEW.md'),
        'preparation_validation':ref(P/'preparation-validation.json'),
        'known_snapshot':{'production_modules':6012,'frozen_native_constants':1419,'frozen_native_owners':167,
                          'certified_routine_new_owners':4,'certified_routine_authored_declarations':7},
        'final_inputs_pending':True,'operational_measurement_run':False})
    print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),
        'review':ref(P/'REVIEW.md'),'status':'root-review-required','operational_measurement_run':False}))

if __name__ == '__main__': main()
