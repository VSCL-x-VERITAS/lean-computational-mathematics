"""Release exact root-adopted inputs for actual organization capture and measurement."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
read=lambda p:json.loads(p.read_bytes())
def bound(item):
    p=R/item['path']
    assert p.resolve().is_relative_to(R) and not p.is_symlink()
    assert sha(p)==item['sha256'],item['path']
    return p
def create(p,obj):
    with p.open('xb') as f:f.write((json.dumps(obj,indent=2)+'\n').encode())
manual_path=P/'manual-current-01/review-data.json'
desc_path=P/'manual-current-01/execution-descriptors.json'
assert sha(manual_path)=='a5b8859bdf4fd0c69abb6523ece91ad3ead106a123496c83b9afe0a577278d63'
assert sha(desc_path)=='57aa767a7d3c23b85e0393e7f7db1916d1b0ec3fb06bb861b21bd3c83be7d8c2'
manual=read(manual_path);desc=read(desc_path)
assert manual['status']=='root-review-required'
assert len(manual['source_files'])==221 and len(manual['reviewed_changed_source_paths'])==149
assert all(value==[] for value in manual['scope_assessment']['unit_scope'].values())
for item in manual['source_files']+manual['review_evidence']:bound(item)
verification=read(P/'manual-current-01/verification.json')
assert verification['production_sources_checked']==6024
assert verification['current_native_owners_checked']==183 and verification['current_native_records']==1688
assert verification['complete_native_reports']==41
assert verification['actual_four_checker_exits']==[0,0,0,0]
assert verification['actual_full_and_focused_build_exits']==[0,0]
assert verification['actual_graph_exit']==verification['actual_complete_native_exit']==0
run=read(P/'manual-current-01/verification-run-04/receipt.json')
assert run.get('actual_exit_code',run.get('exit_code'))==0
root_review=ref(P/'ROOT-CURRENT-REVIEW.md')
manual['status']='root-reviewed-current-organization-scope'
manual['kind']='root-adopted-current-organization-manual-review'
manual['review_evidence'] += [ref(manual_path),ref(desc_path),root_review,
 ref(P/'manual-current-01/verification.json'),ref(P/'manual-current-01/verification-run-04/receipt.json')]
manual['scope_assessment']['rationale']+=' Root adopts this assessment under the separate current review; actual organization measurement remains required.'
out=P/'root-current-adoption-01'
out.mkdir(exist_ok=False)
create(out/'manual-review.json',manual)
keys=['scope','scope_receipt','all_production_sources','graph','graph_execution','fingerprints',
      'complete_declaration_manifest','complete_native','checker_executions','placement_reviews']
ready={k:desc[k] for k in keys}
ready.update(schema=1,status='ROOT_RELEASED_CURRENT_ORGANIZATION_INPUTS',
 manual_review=ref(out/'manual-review.json'),root_adoption=root_review,
 topology=ref(R/'.formalization/library-topology.json'),
 gate=ref(P/'current-gate-snapshot-01.json'))
assert ready['gate']['sha256']=='96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
assert read(P/'current-gate-snapshot-01-receipt.json')['operational_gate_unchanged']
assert len(ready['fingerprints'])==1
for execution in [ready['graph_execution'],ready['complete_native'],*ready['checker_executions'].values()]:
    receipt=read(bound(execution['receipt']));bound(execution['output'])
    assert receipt['exit_code']==0 and receipt['command']==execution['expected_command']
    for item in execution['evidence']:bound(item)
    execution['evidence'] += [root_review,ref(out/'manual-review.json')]
    execution['applicability_rationale']+=' Root adopted the exact current applicability review before release.'
create(out/'ready-inputs.json',ready)
create(out/'receipt.json',{'manual_review':ref(out/'manual-review.json'),
 'ready_inputs':ref(out/'ready-inputs.json'),'root_review':root_review,
 'organization_measurement_runs':0,'gate_mutations':0,'source_acceptance_added':False})
print(json.dumps(read(out/'receipt.json')))

