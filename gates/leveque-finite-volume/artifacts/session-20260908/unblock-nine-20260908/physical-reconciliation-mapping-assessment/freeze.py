"""Verify only this completed analysis and freeze review bindings; no origin operation."""
from pathlib import Path
import ast,hashlib,json,os
P=Path(__file__).resolve().parent;D=P.parent;R=D.parents[4]
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_bytes())
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def put(name,x):
 with (P/name).open('xb') as f:f.write((json.dumps(x,indent=2)+'\n').encode())
pins=read(P/'observed-01/input-pins.json')
for item in pins:assert sha(R/item['path'])==item['sha256'],item['path']
summary=read(P/'observed-01/summary.json')
assert (summary['native_records'],summary['native_owners'],summary['native_inventories'])==(1688,183,1)
assert summary['retained_baseline_records']==559 and summary['new_records']==1129
assert summary['all_protected_records_byte_equal_as_json_values']
assert summary['status_counts']=={'REUSED':17,'PROVED':22,'SKIPPED':16,'IN_PROGRESS':2}
assert len(summary['changed_existing_controlled_payloads'])==1
change=summary['changed_existing_controlled_payloads'][0]
assert change['declaration']=='NumStability.leveque01_eigenvalues_completeWavePropagation'
assert change['changes']=={'producer':False,'policy':True,'proof':False}
proposal=read(D/'final-reconciliation-mapping-inputs/eigenvalue-policy-transport.proposal.json')
# Endpoint identity is checked against the existing proposal by exact string presence.
assert change['old_policy_sha256'] in json.dumps(proposal) and change['policy_sha256'] in json.dumps(proposal)
rows=read(P/'observed-01/source-row-assessment.json')
assert sum(r.get('same_old_selected_contract') is True for r in rows)==32
assert sum(r.get('same_old_selected_contract') is False for r in rows)==7
native=read(P/'analysis-exit.json');assert native['exit_code']==0
assert native['stdout_sha256']==sha(P/'analysis-stdout.txt') and native['stderr_sha256']==sha(P/'analysis-stderr.txt')
script=ast.parse((P/'assess.py').read_text())
assert not any(isinstance(n,ast.Import) and any(a.name=='subprocess' for a in n.names) for n in ast.walk(script))
for file in P.glob('*.py'):ast.parse(file.read_text())
assert not (P/'observed-01/new-policy-proposals.json').exists()
assert not (P/'future-committed-capture').exists()
template=read(P/'final-origin-inputs.template.json')
assert template['topology']['sha256'] is None
assert all(v['sha256'] is None for origin in template['origins'].values() for v in origin.values())
inspection=read(D/'reconciliation-concept-mapping/reorganization-baseline-inspection/inventory.json')
assert len(inspection['assets'])==791 and len(inspection['branch']['unique_assets'])==697
put('verification.json',{'schema':1,'status':'ANALYSIS_BINDINGS_VERIFIED','source_acceptance':False,
 'bound_input_count':len(pins),'protected_records':559,'same_old_selected_contracts':32,
 'observed_closed_rows':39,'pending_rows':2,'inspection_assets':791,'inspection_unique_obligations':697,
 'actual_analysis_exit':ref(P/'analysis-exit.json'),'operational_commands_run':False,
 'limitations':'This is a worktree analysis with frozen scope provenance, not an origin inventory, final source judgment or candidate certification.'})
files=[ref(x) for x in sorted(P.rglob('*')) if x.is_file() and '__pycache__' not in x.parts]
put('manifest.json',{'schema':1,'status':'ROOT_REVIEW_REQUIRED','source_acceptance':False,'files':files})
put('final-receipt.json',{'schema':1,'status':'ROOT_REVIEW_REQUIRED','source_acceptance':False,
 'review':ref(P/'REVIEW.md'),'manifest':ref(P/'manifest.json'),'verification':ref(P/'verification.json'),
 'analysis_exit':ref(P/'analysis-exit.json'),'commands':ref(P/'origin-command-sequence.json'),
 'template':ref(P/'final-origin-inputs.template.json'),
 'summary':ref(P/'observed-01/summary.json'),'gate_mutated':False,'git_invoked':False})
print(json.dumps({'receipt':ref(P/'final-receipt.json'),'manifest':ref(P/'manifest.json'),
 'review':ref(P/'REVIEW.md'),'verified':True}))
