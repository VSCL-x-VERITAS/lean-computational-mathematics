"""Bind an agreeing independent stronger audit to actual native applicability checks."""
from pathlib import Path
import hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
rel=lambda p:p.relative_to(R).as_posix()
bind=lambda p:{'path':rel(p),'sha256':sha(p)}
def write(p,v):
 with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(v,indent=2)+'\n')
taskid='LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908'
row='LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION'
taskpath=S/'audits'/taskid/'audit-task.json';task=read(taskpath);out=R/task['audit_output']
decision=read(out/'decision.json');manifest=read(out/'manifest.json');source=read(out/'agent_outputs/source_contract.json')
assert sha(out/'decision.json')=='df1b25f522c381164a7945df4b19660e7e03dc972bc419f19abb97d11ce7943e'
assert sha(out/'manifest.json')=='2771dd957242ab3a34c36bbacdbdb0db9222b7870d9a5a6f7baedcd57f9fd433'
assert decision['accepted'] is True and decision['adjudicated'] is False and decision['adjudication_reasons']==[]
assert decision['judge_classifications']=={'direct':'faithful-stronger','roundtrip':'faithful-stronger'}
assert [decision['implications'][d]['verdict'] for d in ['lean_implies_source','source_implies_lean']]==['yes','no']
check=S/'variable-opening-nonvacuity.lean';log=S/'variable-opening-nonvacuity-output.txt';exitpath=S/'variable-opening-nonvacuity-exit.json'
native=read(exitpath)
assert native['exit_code']==0 and native['command']=='lake env lean '+rel(check)
assert native['output_sha256']==sha(log)
text=log.read_text(encoding='utf-8-sig');assert not re.search(r'\b(?:error|warning):|sorryAx',text)
witness='NumStability.Chapter01Evidence.variableCoefficient_nonvacuous_instance'
for name in [task['target']['declaration'],witness,'NumStability.Chapter01Evidence.constantScalarTransportFlux_represents']:
 matches=re.findall(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',text)
 assert len(matches)==1 and {x.strip() for x in matches[0].split(',') if x.strip()}<={'propext','Classical.choice','Quot.sound'}
searches=[]
for i,cmd in enumerate([
 ['rg','-n','RepresentsScalarTransportFlux|leveque01_exists_hyperbolic_variableCoefficient_without_localFlux','ComputationalMathematics','-g','*.lean'],
 ['rg','-n','HasDerivAt.const_mul|theorem const_mul|RepresentsScalarTransportFlux','.lake/packages/mathlib/Mathlib/Analysis/Calculus','-g','*.lean']],1):
 run=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert run.returncode in (0,1) and not run.stderr
 output=S/f'variable-opening-strengthening-search-{i}-output.txt';error=S/f'variable-opening-strengthening-search-{i}-stderr.txt'
 with output.open('xb') as f:f.write(run.stdout)
 with error.open('xb') as f:f.write(run.stderr)
 searches.append({'argv':cmd,'exit_code':run.returncode,'stdout':bind(output),'stderr':bind(error)})
target=R/task['target']['path'];assert sha(target)==manifest['target']['sha256']
scope='The existing existential theorem supplies a globally smooth, everywhere positive scalar coefficient and a real eigenbasis at each spatial point, with no representing local flux for the unchanged state. The native witness adds that it differs from every constant coefficient: a constant c has the actual representing flux c times state by HasDerivAt.const_mul. This independently exercises the conservation predicate on a nonempty valid case and proves the selected witness is genuinely variable. It makes no claim excluding density transformations, integrating factors, or nonlocal fluxes.'
evidence={'schema':1,'row':row,'task_id':taskid,'classification':'faithful-stronger','task':bind(taskpath),'manifest':bind(out/'manifest.json'),'decision':bind(out/'decision.json'),'source_contract':bind(out/'agent_outputs/source_contract.json'),'target':task['target'],'target_sha256':sha(target),'applicability_audit':decision['implications']['lean_implies_source']['reasoning'],'genuine_strengthening':decision['implications']['source_implies_lean']['reasoning'],'remaining_source_uncertainties':decision['remaining_uncertainties'],'source_only_ambiguities':source['ambiguities'],'formal_nonvacuity_declaration':witness,'formal_nonvacuity_scope':scope,'native_check':bind(check),'native_output':bind(log),'native_exit':bind(exitpath),'native_receipt':native,'reuse_searches':searches,'reuse_review':'Reuse the exact existing source witness and generic local-flux obstruction; the scratch constant-coefficient calculation uses the pinned Mathlib derivative product API. No new production theorem is authored. Search misses are scoped, not global absence.','semantic_evidence_scope':'Both independent judges agree on yes/no faithful-stronger and the unchanged sealed decision records no adjudication trigger. No adjudicator or interpretation receipt is invented.'}
ep=S/'variable-opening-strengthening-evidence.json';write(ep,evidence)
proof=S/'variable-opening-proof-inputs.json';write(proof,{'schema':1,'input_commit':native['input_commit'],'files':[{**bind(target),'declarations':[task['target']['declaration']]}],'check_file':rel(check),'check_file_sha256':sha(check)})
pins=S/'variable-opening-binding-pins.json';write(pins,{'schema':1,'rows':[{'row':row,'task_id':taskid,'target':task['target'],'evidence':bind(ep),'manifest_sha256':sha(out/'manifest.json'),'decision_sha256':sha(out/'decision.json')}],'proof_manifest':bind(proof),'native_check':bind(check),'native_output':bind(log),'native_exit':bind(exitpath)})
print(json.dumps({'pins':bind(pins),'proof_manifest':bind(proof),'evidence':bind(ep)}))
