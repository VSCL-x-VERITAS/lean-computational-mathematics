"""Filesystem-only preparation; never run an organization checker or Git."""
from pathlib import Path
import hashlib
import importlib.util
import json
import sys

sys.dont_write_bytecode = True
P = Path(__file__).resolve().parent
R = P.parents[5]
S = R / 'gates/leveque-finite-volume/artifacts/session-20260908'
D = S / 'unblock-nine-20260908'
H = D / 'final-organization-successor-preparation'
E = D / 'final-candidate-epoch-preparation'
sha = lambda raw: hashlib.sha256(raw).hexdigest()
observed = {}

def raw(path):
    path = Path(path)
    data = path.read_bytes()
    observed[path] = sha(data)
    return data

def ref(path):
    path = Path(path)
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(raw(path))}

def read(path):
    return json.loads(raw(path))

def put(name, data):
    with (P / name).open('x', encoding='utf-8', newline='\n') as f:
        f.write(json.dumps(data, indent=2, ensure_ascii=True) + '\n')

def main():
    topology = read(R / '.formalization/library-topology.json')
    campaign = next(x for x in topology['campaigns'] if x['id'] == 'leveque-finite-volume-main-2026q3')
    old = D / 'final-current-organization-review'
    baseline_path = old / 'protected-anchor-layout-exceptions.json'
    baseline = read(baseline_path)
    policy = read(R / 'docs/architecture/layout-exceptions.json')
    prior_reviews = read(old / 'supporting-review-pins.json')['files']
    review_paths = [R / x['path'] for x in prior_reviews]
    for item in prior_reviews:
        assert sha(raw(R / item['path'])) == item['sha256'], item['path']
    additions = [
        D/'organization-riemann-routine/REVIEW.md', D/'organization-riemann-routine/receipt.json',
        D/'riemann-routine-production/files.json',
        D/'organization-high-resolution/REVIEW.md', D/'organization-high-resolution/plan.json',
        D/'organization-high-resolution/receipt.json',
        D/'directional-high-resolution-production/production-files-frozen.json',
        D/'directional-high-resolution-production/final-receipt.json',
    ]
    # A completed root placement is an observed checkpoint, not a final check.
    cert_receipt = D/'organization-certified-routine/receipt.json'
    if cert_receipt.exists():
        additions.extend([D/'organization-certified-routine/REVIEW.md',
                          D/'organization-certified-routine/plan.json', cert_receipt])
    review_paths.extend(additions)
    reviews = [ref(p) for p in dict.fromkeys(review_paths)]
    fingerprints = []
    records, owners = {}, {}
    inventory_paths = [S/'chapter01-current-expression-fingerprints-24b3.json',
        S/'baseline-equation03-expression-fingerprints.json',
        D/'final-fingerprints/additional-expression-fingerprints.json',
        D/'local-replacement-fingerprints/additional-expression-fingerprints.json',
        D/'riemann-routine-fingerprints/additional-expression-fingerprints.json',
        D/'dim-high-resolution-fingerprints/additional-expression-fingerprints.json']
    for path in inventory_paths:
        data = read(path)
        provenance = []
        if path.parent != S:
            for name in ('final-receipt.json', 'fingerprint-receipt.json', 'declaration-mapping.json'):
                q = path.parent / name
                if q.exists(): provenance.append(ref(q))
        else:
            # These older inventories are also pinned by the full DIM export input closure.
            provenance.append(ref(D/'dim-high-resolution-fingerprints/inputs.json'))
            provenance.append(ref(D/'dim-high-resolution-fingerprints/final-receipt.json'))
        fingerprints.append({'inventory':ref(path), 'expected_records':len(data['records']),
            'expected_files':len(data['files']), 'provenance':provenance})
        for item in data['files']:
            assert ref(R/item['path'])['sha256'] == item['sha256'], item['path']
            if item['path'] in owners: assert owners[item['path']] == item['sha256']
            owners[item['path']] = item['sha256']
        for item in data['records']:
            if item['name'] in records: assert records[item['name']] == item
            records[item['name']] = item
    assert (len(records), len(owners)) == (1419, 167)
    put('frozen-evidence-catalog.json', {'status':'root-review-required',
        'historical_review_chain':reviews, 'fingerprints':fingerprints,
        'merged_frozen_native_constants':len(records),'merged_frozen_native_owners':len(owners),
        'certified_routine_fingerprint_pending':True,
        'limits':'Review references are provenance; their former source census and applicability are not promoted to the final tree.'})

    template = read(E/'organization-inputs.template.json')
    old_tools = template['tools']
    tool_changes = []
    for key, previous in list(old_tools.items()):
        current = ref(R/previous['path'])
        if current != previous: tool_changes.append({'tool':key, 'historical':previous,'observed':current})
        old_tools[key] = current
    # Still deliberately unusable: root must freeze final policies and approve scope.
    put('organization-template.current-snapshot.json', template)
    config = read(H/'config.template.json')
    config['pending_inputs'] = [
        'Final certified-routine native fingerprint inventory and immutable validation provenance',
        'Final unchanged source/import closure, exact measured module/native census and graph JSON/Markdown pair',
        'Actual four successful current check receipt/output pairs with exact two-token commands',
        'Final 41-target declaration manifest and actual native output including certified-routine successor',
        'Final gate/topology/HEAD/source-tree pins; do not infer source acceptance from native checks',
        'Root-reviewed full changed-source coverage, six manual/measured scope lists, and four applicability reviews',
        'New organization template with final tool/policy pins after all production exposure changes',
    ]
    config['fingerprints'] = fingerprints
    config['expected_counts'].update(total_rows=57, formalizable_rows=41, skipped_rows=16)
    config['placement_reviews'] = [{'evidence':ref(old/'REVIEW.md'),
        'rationale':'Historical whole-unit assessment; root must refresh current exact changed-source coverage.',
        'covered_source_paths':[]},
        {'evidence':ref(D/'organization-riemann-routine/REVIEW.md'),
         'rationale':'Four additive Routine owners retain older Method APIs and distinct contract domains.',
         'covered_source_paths':[x['path'] for x in read(D/'riemann-routine-production/files.json')['files']]},
        {'evidence':ref(D/'organization-high-resolution/REVIEW.md'),
         'rationale':'Sixteen additive quality/reference/execution/geometry/example/source owners; old contracts unchanged.',
         'covered_source_paths':[x['path'] for x in read(D/'directional-high-resolution-production/production-files-frozen.json')['files']]}]
    config['scope_assessment']['rationale'] = None
    put('config.blueprint.json', config)
    source_inventory = read(D/'organization-high-resolution/receipt.json')
    checkpoint = {'high_resolution_placement':ref(D/'organization-high-resolution/receipt.json'),
                  'high_resolution_counts':source_inventory['counts']}
    if cert_receipt.exists():
        cert = read(cert_receipt)
        checkpoint.update(certified_routine_placement=ref(cert_receipt),
                          certified_routine_counts_observed=cert.get('counts'),
                          certified_routine_native_fp_not_yet_claimed=True)
    put('scope-and-ratchet-blueprint.json', {
        'status':'root-review-required', 'scope':'All canonical and compatibility Chapter01 owners, all frozen native owners, transitive project imports, and the single Analysis exposure boundary.',
        'protected_anchor':topology['shared_anchor'], 'topology_observed':ref(R/'.formalization/library-topology.json'),
        'actual_campaign_owner':campaign['owner'], 'baseline':ref(baseline_path),
        'baseline_provenance':ref(old/'current-source-observation.json'),
        'baseline_legacy_sets':baseline['legacy'], 'current_policy':ref(R/'docs/architecture/layout-exceptions.json'),
        'current_policy_legacy_sets':policy['legacy'],
        'current_measured_debt_sets':None,
        'why_null':'Policy exception lists are not current_debt results; only root final measurement establishes current sets.',
        'current_placement_checkpoint':checkpoint,'final_scope_lists':None,
        'manual_lists':['duplicate_wrappers','canonical_placement_pending'],
        'required_measured_lists':['unexpected_changes','unclassified_modules','mixed_pending_split','placeholder_findings'],
        'approved_exceptions':{},'pending_asset_ids':[],
        'proposed_findings':'No new duplicate or mixed owner is indicated by the reviewed placements. This is a review proposal; exact all-changed-path coverage and root adoption remain required.',
        'template_pin_changes_observed':tool_changes,
        'old_graph_is_historical':ref(S/'architecture-graphs/unblock-nine-final-source.json'),
        'native_41_checkpoint':{'manifest':ref(D/'high-resolution-complete-declarations/manifest.json'),
            'receipt':ref(S/'unblock-nine-high-resolution-complete-declarations-exit.json'),
            'output':ref(S/'unblock-nine-high-resolution-complete-declarations-output.txt'),
            'limit':'Actual zero before final Info certificate target; refresh exact row mapping and native check after its replacement.'}})
    checks = {k:['/usr/bin/python3','tools/architecture/'+name] for k,name in {
        'layout':'check_layout.py','tiers':'check_tiers.py',
        'compatibility':'check_compatibility.py','hygiene':'check_placeholders.py'}.items()}
    put('commands-and-receipts.json', {'status':'template-not-executed','cwd':'repository root',
        'execution_route':'Windows Python -B workflow-v5.0.1-local/run_workflow_posix.py SCRIPT ARGS',
        'actual_checker_argv_required':checks,
        'receipt_required_fields':{'exit_code':'integer 0 (boolean rejected)',
            'elapsed_ms':'actual nonnegative integer','output_sha256':'SHA256 of exact raw output bytes',
            'input_commit':'actual original 40-hex HEAD','command':'exact two-token checker argv above'},
        'graph_capture_argv':['/usr/bin/python3','tools/architecture/generate_baseline.py',
            '--strict-source','--no-build','--output-dir',S.relative_to(R).as_posix()+'/architecture-graphs',
            '--name','<fresh-final-name>'],
        'capture_argv':['/usr/bin/python3',(H/'capture_current_v2.py').relative_to(R).as_posix(),
            '--repo','<POSIX R>','--config','<repo-relative-final-config>','--config-sha256','<actual SHA256>',
            '--out','<fresh repo-relative session capture directory>'],
        'draft_argv':['/usr/bin/python3',(H/'prepare_draft_v2.py').relative_to(R).as_posix(),
            '--repo','<POSIX R>','--config','<same config>','--config-sha256','<same SHA256>',
            '--capture-manifest','<actual capture manifest path>','--capture-sha256','<actual SHA256>',
            '--out','<fresh repo-relative session draft directory>'],
        'measurement_argv':['/usr/bin/python3',(E/'prepare_organization.py').relative_to(R).as_posix(),
            '--root','<POSIX R>','--inputs','<actual reviewed inputs path>','--inputs-sha256','<actual SHA256>',
            '--output','<fresh measurement directory>'],
        'measurement_outputs':['organization.json','measurement-receipt.json'],
        'measurement_is_not':'A gate verdict, 41-row acceptance, candidate validation, admission or publication.'})
    spec = importlib.util.spec_from_file_location('reviewed_organization_support',H/'support.py')
    support = importlib.util.module_from_spec(spec); spec.loader.exec_module(support)
    rejection = None
    try: support.schema(config)
    except ValueError as ex: rejection = str(ex)
    assert rejection == 'pending future inputs must be resolved'
    put('preparation-validation.json', {'status':'root-review-required',
        'checks':{'six_fingerprint_inventories_hash_bound':True,
                  'all_167_current_native_owner_bytes_match':True,
                  'merged_records_are_1419':True,
                  'blueprint_rejected_by_reviewed_final_config_schema':rejection},
        'operational_checkers_executed':[], 'git_commands_executed':[],
        'global_or_source_completion_claimed':False})
    for path,digest in observed.items():
        assert sha(path.read_bytes()) == digest, 'input changed while preparing: '+str(path)
    put('input-pins.json', {'status':'snapshot-provenance-not-final-freshness',
        'files':[{'path':p.relative_to(R).as_posix(),'sha256':h} for p,h in sorted(observed.items())]})
    print(json.dumps({'status':'root-review-required','frozen_native_constants':len(records),
        'frozen_native_owners':len(owners),'read_only_inputs':len(observed),
        'blueprint_schema_refusal':rejection,'operational_measurement_run':False}))

if __name__ == '__main__': main()
