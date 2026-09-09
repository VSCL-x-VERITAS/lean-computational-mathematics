"""Assemble documentation/templates from the actual frozen read-only capture."""
import hashlib,json,sys,subprocess,ast
from pathlib import Path
P=Path(__file__).resolve().parent; D=P.parent; S=D.parent; R=S.parents[3]; W=R.parent
def sha(b): return hashlib.sha256(b).hexdigest()
def can(v): return json.dumps(v,sort_keys=True,separators=(',',':'),ensure_ascii=True).encode()
def load(p): return json.loads(p.read_bytes())
def ref(p): return {'path':p.relative_to(R).as_posix(),'sha256':sha(p.read_bytes())}
def save(n,v):
    with (P/n).open('xb') as f: f.write((json.dumps(v,indent=2,ensure_ascii=True)+'\n').encode())
obs=P/'observed-01'; summary=load(obs/'summary.json'); fps=load(obs/'fingerprint-inputs.json')
baseline=load(D/'reconciliation-concept-mapping/baseline-catalogue.json')
bi=load(D/'reconciliation-concept-mapping/reorganization-baseline-inspection/inventory.json')
bs=load(D/'reconciliation-concept-mapping/baseline-spec.json')
records={r['name']:r for f in fps for r in load(R/f['inventory']['path'])['records']}
old=[v for v in baseline['assets'] if v['kind']=='declaration' and v['lane_id']=='reorganization-baseline-inspection']
assert len(old)==559 and all(sha(can(records[v['declaration']]))==v['origin_content_sha256'] for v in old)
rows=load(obs/'source-row-assessment.json'); old32=[r for r in rows if r['old_context']['origin_status'] in ('PROVED','REUSED')]
assert len(old32)==32 and all(r['same_old_selected_contract'] for r in old32)
policy={'schema':1,'kind':'reconciliation-mapping-preparation-policy','status':'ROOT_REVIEW_REQUIRED','source_acceptance':False,
 'anchor':summary['anchor'],'merge_lane':'leveque-ch01-work','inspection_head':summary['observed_head'],
 'origin_fingerprint_paths':{'leveque-ch01-work':[x['inventory']['path'] for x in fps],
 'reorganization-baseline-inspection':[x['path'] for x in bs['lanes'][1]['fingerprints']]},
 'current_work_fingerprint_refs':[x['inventory'] for x in fps],
 'baseline_spec':ref(D/'reconciliation-concept-mapping/baseline-spec.json'),
 'declaration_rule':'Preserve named-declaration concepts and all existing Eq1.3 overrides. Do not merge differently named new source targets merely because they concern the same row.',
 'nondeclaration_rule':'For each same-kind/stable-key pair with different actual origin content hashes, propose separate origin-lane-qualified concept IDs, retaining common stable key, origin bytes and branch obligations.',
 'authority':'Proposed structural mapping only. A separate actual root review is mandatory before the existing emitter can materialize payloads.'}
save('preparation-policy.json',policy)
save('final-origin-inputs.template.json',{'schema':1,'kind':'explicit-final-origin-spec-input',
 'preparation_policy':ref(P/'preparation-policy.json'),'topology':{'path':'.formalization/library-topology.json','sha256':None},
 'origins':{lane:{'inventory':{'path':f'{P.relative_to(R).as_posix()}/committed-capture/{lane}/inventory.json','sha256':None},
 'context':{'path':f'{P.relative_to(R).as_posix()}/committed-capture/{lane}/origin-context.json','sha256':None}} for lane in policy['origin_fingerprint_paths']}})
future=load(D/'final-certified-complete-declarations/manifest.json')
rowmap=[]
for row in rows:
    v={'row':row['row'],'observed_status':row['status'],'old_status':row['old_context']['origin_status'],
       'old_selected_declarations':row['old_context'].get('declarations',[]),'new_primary':future['rows'].get(row['row']),
       'same_old_selected_contract':row.get('same_old_selected_contract'),'current_contract_ref':row.get('contract_ref'),
       'current_task_ref':row.get('task_ref'),'current_decision_ref':row.get('decision_ref')}
    if v['old_status'] in ('PROVED','REUSED'): v['assessment']='Retain exact existing selected source contract; mutable gate rebinding is separate provenance.'
    elif row['status'] in ('PROVED','REUSED'): v['assessment']='Newly selected qualified source contract; preserve prior nonaccepted targets/audits separately, no silent name replacement.'
    elif row['status']=='SKIPPED': v['assessment']='Retain exact skip; no declaration selected.'
    else: v['assessment']='Actual source audit is pending; final accepted contract/decision must be supplied before committed closed inventory.'
    rowmap.append(v)
save('per-row-selection-map.json',rowmap)
e=summary['changed_existing_controlled_payloads'][0]; pdf=bi['source_sha256']
transport={'id':'leveque-ch01-eigenvalue-propagation-selected-policy','change_class':'policy','old_module':e['module'],'new_module':e['module'],
 'old_declaration':e['declaration'],'new_declaration':e['declaration'],
 'old_hashes':{'source':pdf,'type':e['type_sha256'],'policy':e['old_policy_sha256'],'producer':e['old_producer_sha256'],'proof':e['proof_sha256']},
 'new_hashes':{'source':pdf,'type':e['type_sha256'],'policy':e['policy_sha256'],'producer':e['producer_sha256'],'proof':e['proof_sha256']},
 'faithfulness':'full-reaudit','affected_books':['leveque-finite-volume']}
save('eigenvalue-policy-transport.proposal.json',transport)
eq=S/'baseline-equation03-transport-draft'; eqt=load(eq/'transport-entry.draft.json')
assert records[eqt['old_declaration']]['type_sha256']==eqt['old_hashes']['type']
assert records[eqt['new_declaration']]['type_sha256']==eqt['new_hashes']['type']
assert records[eqt['old_declaration']]['value_sha256']==eqt['old_hashes']['proof']
assert records[eqt['new_declaration']]['value_sha256']==eqt['new_hashes']['proof']
save('controlled-transport-inputs.json',{'status':'ROOT_REVIEW_REQUIRED','source_acceptance':False,'source_hash_convention':'Exact immutable PDF bytes on both sides; source-selection and source-domain differences belong to the explicit policy payload. Source-row selection flags remain separately preserved in actual lane assets.',
 'eq13':{'transport':ref(eq/'transport-entry.draft.json'),'provenance':ref(eq/'draft-provenance.json'),'full_reaudit_evidence':ref(eq/'full-reaudit-evidence.json'),
 'retention':ref(eq/'declaration-retention.json'),'current_32_contracts_preserved':True,'same_current_native_type_and_proof_endpoints':True},
 'eigenvalue':{'transport_proposal':ref(P/'eigenvalue-policy-transport.proposal.json'),
 'old_asset_source_hash_present':any('source_hash' in a for a in bi['assets'] if a['kind']=='declaration' and a['name']==e['declaration']),
 'new_selection':next(r for r in rowmap if r['row']=='LEV-CH01-EIGENVALUES-WAVE-SPEEDS'),
 'limit':'Old occurrence has no selected-source hash: it was not origin-accepted. Both transport source hashes use the pinned book PDF provenance, not a fabricated old source acceptance. The old empty selected-contract policy and the new complete qualified contract remain distinct. Root must adopt this convention consistently.'},
 'other_867_new_declarations':'No replacement transport inferred across names. They remain new producers; selected source-row associations identify the seven accepted and two pending scope additions.',
 'native_retention':'All 559 old records equal the complete canonical serialized native record, not merely printed type hashes.'})
helpers=[D/'reconciliation-helpers'/x for x in ['common.py','build_lane_inventory.py','prepare_two_lane_bundle.py','mapping.schema.json']]
helpers += [D/'reconciliation-concept-mapping'/x for x in ['prepare_mapping_catalogue.py','emit_reviewed_mapping.py','capture-origin-context-v2.py']]
helpers += [D/'final-candidate-epoch-preparation'/x for x in ['candidate_checks.py','capture_checks.py','assemble_epoch.py','prepare_organization.py','required-commands.template.json','candidate-replay-inputs.template.json','collision-transport-review.template.json']]
helpers += [S/'final-epoch-asset-helper-draft/prepare_asset_bundle.py']
save('helper-pins.json',[ref(p) for p in helpers])
native='C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe'; launcher=(W/'workflow-v5.0.1-local/run_workflow_posix.py').as_posix()
prefix=[native,'-X','utf8','-B',launcher]
top=(R/'.formalization/library-topology.json').as_posix(); run=P/'committed-capture'
commands=[]
for lane,paths in policy['origin_fingerprint_paths'].items():
    inv=run/lane/'inventory.json'; ctx=run/lane/'origin-context.json'
    args=prefix+[(D/'reconciliation-helpers/build_lane_inventory.py').as_posix(),'--topology',top,'--lane',lane]
    for path in paths: args+=['--fingerprints',path]
    if lane==policy['merge_lane']: args+=['--require-closed']
    args+=['--output',inv.as_posix()]
    commands.append({'phase':'after-real-commit-and-authorized-topology-pin','operation':'actual-origin-inventory','lane':lane,'argv':args})
    commands.append({'phase':'after-corresponding-inventory','operation':'actual-origin-context','lane':lane,'argv':prefix+[(D/'reconciliation-concept-mapping/capture-origin-context-v2.py').as_posix(),'--inventory',inv.as_posix(),'--inventory-sha256','HASH_FROM_ACTUAL_INVENTORY','--topology',top,'--output',ctx.as_posix()]})
commands += [{'phase':'after-exact-two-origin-inputs-filled','operation':'derive-root-review-required-spec','argv':prefix+[(P/'derive_final_origin_spec.py').as_posix(),'--root',R.as_posix(),'--inputs',(P/'final-origin-inputs.json').as_posix(),'--inputs-sha256','HASH_FROM_ACTUAL_FINAL_ORIGIN_INPUTS','--output',(run/'catalogue-spec.json').as_posix()]},
 {'phase':'after-spec-reviewed','operation':'unchanged-catalogue','argv':prefix+[(D/'reconciliation-concept-mapping/prepare_mapping_catalogue.py').as_posix(),'--root',R.as_posix(),'--spec',(run/'catalogue-spec.json').as_posix(),'--spec-sha256','HASH_FROM_ACTUAL_CATALOGUE_SPEC','--output',(run/'catalogue.json').as_posix()]}]
save('origin-command-sequence.json',{'status':'UNEXECUTED','path_note':'Create fresh output parents before each run. After a later payload/evidence commit use a new directory and refill refs, never overwrite the first capture. Launcher converts absolute Windows path arguments to POSIX. No command here creates a request or candidate.', 'commands':commands,
 'next_exact_existing_commands':{'payloads':'emit_reviewed_mapping.py payloads --root ROOT --spec PAYLOAD_SPEC --spec-sha256 SHA --output NEW_DIR',
 'mapping':'emit_reviewed_mapping.py mapping --root ROOT --spec MAPPING_SPEC --spec-sha256 SHA --output NEW_FILE',
 'converter':'prepare_two_lane_bundle.py --preview ACTUAL_WORK --preview ACTUAL_INSPECTION --topology ACTUAL --request ACTUAL --status ACTUAL_CANDIDATE --mapping ACTUAL --epoch-schema PINNED_RELEASE_SCHEMA --output NEW_FILE'}})
save('finalization-input-status.json',{'status':'PREPARATION_ONLY','source_acceptance':False,'actual_current_summary':ref(obs/'summary.json'),
 'current_complete_declaration_manifest':ref(D/'final-certified-complete-declarations/manifest.json'),
 'current_graph_json':ref(S/'architecture-graphs/unblock-nine-certified-high-resolution-sorted-source.json'),
 'current_graph_markdown':ref(S/'architecture-graphs/unblock-nine-certified-high-resolution-sorted-source.md'),
 'manual_review_adoption':ref(D/'final-organization-manual-review/ROOT-ADOPTION.md'),
 'pending':{'accepted_info_contract_and_decision':None,'accepted_dim_contract_and_decision':None,'final_closed_gate_and_validator':None,
 'source_evidence_commit':None,'payload_and_replay_input_commit':None,'final_pinned_topology':None,'actual_origin_capture_refs':None,
 'root_mapping_review':None,'candidate_request_status':None,'candidate_validation_receipts':None},
 'not_unknown':{'source_pdf_sha256':pdf,'current_head':summary['observed_head'],'inspection_head':summary['observed_head'],
 'campaign_head':load(R/'.formalization/library-topology.json')['campaign_head'],'stable_destination':load(R/'.formalization/library-topology.json')['stable_destination'],
 'seven_current_fingerprints':ref(obs/'fingerprint-inputs.json'),'all_41_compiled_prospective_targets':ref(D/'final-certified-complete-declarations/manifest.json')}})
results=[]
for script in ['capture_current_mapping.py','derive_final_origin_spec.py','assemble_preparation.py']:
    ast.parse((P/script).read_bytes()); results.append({'case':'syntax-'+script,'result':'PASS'})
template=P/'final-origin-inputs.template.json'; output=P/'null-input-MUST-NOT-EXIST.json'
argv=[sys.executable,'-B',str(P/'derive_final_origin_spec.py'),'--root',str(R),'--inputs',str(template),'--inputs-sha256',sha(template.read_bytes()),'--output',str(output)]
run=subprocess.run(argv,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
(P/'null-input-rejection-output.txt').write_bytes(run.stdout)
assert run.returncode!=0 and not output.exists() and b'stale .formalization/library-topology.json' in run.stdout
results.append({'case':'null-final-input-refused','actual_exit':run.returncode,'output':ref(P/'null-input-rejection-output.txt'),'output_not_created':True})
results += [{'case':'all-559-whole-native-records-retained','result':'PASS'},{'case':'all-32-origin-accepted-contracts-retained','result':'PASS'},
 {'case':'Eq1.3-both-type-and-proof-current-endpoints-match-frozen-transport','result':'PASS'}]
save('checks.json',{'scope':'Actual read-only checks and missing-input rejection only; no operational origin construction, request, candidate, audit or acceptance.', 'results':results})
print(json.dumps({'status':'PREPARATION_ONLY','native_constants':len(records),'retained_whole_records':len(old),'source_rows':len(rowmap),'pending_rows':summary['open_rows'],'checks':len(results)}))
