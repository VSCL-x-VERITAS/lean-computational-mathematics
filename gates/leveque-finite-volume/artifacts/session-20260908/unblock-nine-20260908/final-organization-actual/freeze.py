"""Freeze successful capture/draft and exact historical gate input; no adoption."""
from pathlib import Path
import hashlib
import json

P=Path(__file__).resolve().parent
R=P.parents[5]
D=P.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pin=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
read=lambda p:json.loads(p.read_bytes())
def put(name,obj):
    with (P/name).open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(obj,indent=2)+'\n')

c=read(P/'config.json')
for phase in ('prepare','capture','draft'):
    rec=read(P/('run-'+phase+'-01/receipt.json'))
    assert type(rec['exit_code']) is int and rec['exit_code']==0
    assert rec['output_sha256']==sha(P/('run-'+phase+'-01/output.txt'))
cap=read(P/'capture/capture-manifest.json')
draft=read(P/'draft/draft-manifest.json')
for manifest in (cap,draft):
    assert manifest['config']==pin(P/'config.json')
    assert manifest['status']=='root-review-required'
    assert manifest['operational_measurement_run'] is False
    for ref in manifest['files']:assert pin(R/ref['path'])==ref
summary=read(P/'draft/draft-summary.json')
assert summary['source_files']==209 and summary['changed_source_paths']==137
assert summary['production_source_tree_sha256']==c['source_tree_sha256']
assert summary['four_receipts_actual_exit_zero'] is True and summary['final_measurement_run'] is False
gate_path=R/c['gate']['path']
assert pin(gate_path)==c['gate']
raw=gate_path.read_bytes()
with (P/'gate-at-capture.json').open('xb') as f:f.write(raw)
gate=json.loads(raw)
assert sum(x['status'] in ('PROVED','REUSED') for x in gate['rows'])==39
snapshot=pin(P/'gate-at-capture.json')
assert snapshot['sha256']==c['gate']['sha256']
put('historical-input-bindings.json',{'schema':1,'status':'EXPLICIT_HISTORICAL_EXECUTION_INPUT_MAPPING',
    'executed_config':pin(P/'config.json'),'field':'/gate','original_input':c['gate'],
    'immutable_exact_snapshot':snapshot,
    'gate_observed':{'total_rows':len(gate['rows']),'closed_rows':39,'formalizable_rows':41,'skipped_rows':16},
    'root_adoption':{
        'scope':'Historical provenance interpretation only; current operative final gate remains separate.',
        'text':'Agreed with minimal explicit archival mapping after actualcapture/draft freeze: preserve executedconfig unchanged, freeze exact gate-at-capture bytes, record config#/gate originalpath/oldSHA→snapshot and sourcecode support. Rootadopts historical provenance interpretation only; currentoperative finalgate remainsseparate. Include mapping in finalclosure reviewinputs; no pretend executionunderrewrittenconfig/no unsupported recursiveconsumerclaim. Gatehold remains throughactualdraft; notifybefore releasing.'},
    'consumer_code':[pin(D/'final-candidate-epoch-preparation/prepare_organization.py'),
                     pin(D/'final-candidate-epoch-preparation/candidate_checks.py')],
    'consumer_rules':[
        'prepare_organization.measure binds each directly listed review_evidence/source_files entry; it does not recursively turn nested FileRefs in the executed config into current inputs.',
        'candidate_checks.load_inputs binds the explicit immutable_inputs list, the independently selected final PASS gate, actual complete audit output and current organization measurement.',
        'Final closure review must list this mapping and snapshot as historical provenance, retain the executed config bytes, and use the actual final gate SHA separately.',
        'Do not list original live gate path with its old SHA as an operative current input after closure; do not claim this config was rerun with the archival snapshot path.',
        'A future recursive evidence consumer requires explicit support for this archival mapping; no such support is assumed here.'],
    'source_capture_rerun_required_for_gate_status_change_only':False,
    'executed_config_rewritten':False,'gate_mutated':False})
put('verification.json',{'status':'ACTUAL_READONLY_CAPTURE_AND_DRAFT_COMPLETE_ROOT_REVIEW_REQUIRED',
    'config':pin(P/'config.json'),'capture_manifest':pin(P/'capture/capture-manifest.json'),
    'draft_manifest':pin(P/'draft/draft-manifest.json'),'summary':summary,
    'historical_gate_mapping':pin(P/'historical-input-bindings.json'),
    'counts':c['expected_counts'],'all_manifests_and_actual_outputs_hash_checked':True,
    'source_changes_during_capture_or_draft':[],'measurement_run':False,'source_acceptance_claimed':False})
files=[pin(p) for p in sorted(P.rglob('*')) if p.is_file()]
put('manifest.json',{'schema':1,'status':'FROZEN_ACTUAL_DRAFT_ROOT_REVIEW_REQUIRED','files':files,
    'gate_modified':False,'measurement_run':False})
put('receipt.json',{'schema':1,'status':'FROZEN_ACTUAL_DRAFT_ROOT_REVIEW_REQUIRED',
    'manifest':pin(P/'manifest.json'),'verification':pin(P/'verification.json'),
    'config':pin(P/'config.json'),'organization_inputs_draft':pin(P/'draft/organization-inputs.draft.json'),
    'historical_gate_mapping':pin(P/'historical-input-bindings.json'),
    'actual_exits':{'prepare':0,'capture':0,'draft':0},
    'measurement_run':False,'root_review_and_measurement_pending':True})
assert gate_path.read_bytes()==raw
print(json.dumps({'receipt':pin(P/'receipt.json'),'manifest':pin(P/'manifest.json'),
    'draft_inputs':pin(P/'draft/organization-inputs.draft.json'),
    'status':'root-review-required','gate_hold_may_be_released_after_root_notification':True},indent=2))
