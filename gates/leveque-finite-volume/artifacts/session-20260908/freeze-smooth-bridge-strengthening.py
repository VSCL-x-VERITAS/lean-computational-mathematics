from pathlib import Path
import hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
task='LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH-CANONICAL-20260908';out=S/'audits'/task/'faithfulness'
decision=json.loads((out/'decision.json').read_bytes());assert sha(out/'decision.json')=='923861c4036334a4c9cff5e5ebb3f3ffc9329c40c1fab4f1f0ad9559a0c58b53'
assert decision['accepted'] and decision['adjudicated'] and decision['classification']=='faithful-stronger'
name='NumStability.Chapter01Evidence.smoothBridge_additionalInstance'
native_exit=S/'smooth-bridge-additional-instance-exit.json';e=json.loads(native_exit.read_bytes());assert e['exit_code']==0
native_output=S/'smooth-bridge-additional-instance-output.txt';assert sha(native_output)==e['output_sha256']
check=S/'smooth-bridge-additional-instance.lean';assert e['argv']==['lake','env','lean',check.relative_to(R).as_posix()]
text=native_output.read_text();match=re.search(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',text);assert match
axioms=sorted({x.strip() for x in match.group(1).split(',') if x.strip()});assert set(axioms)<={'propext','Classical.choice','Quot.sound'}
paths=['ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/StationaryJump.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataRegularity.lean',
 '.lake/packages/mathlib/Mathlib/Analysis/Calculus/Deriv/Basic.lean',
 '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean']
command=['rg','-n','riemannData_intervalIntegrable|discontinuous_stationary_conservative_residual|hasDerivAt_const|intervalIntegrable_const',*paths]
search=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE);assert search.returncode==0
log=S/'smooth-bridge-strengthening-reuse-search.txt';assert not log.exists();log.write_bytes(search.stdout+search.stderr)
record={'schema':1,'task_id':task,'classification':'faithful-stronger','decision_sha256':sha(out/'decision.json'),
 'applicability_audit':decision['implications']['lean_implies_source']['reasoning'],
 'source_precision_notes':decision['remaining_uncertainties'],
 'independent_nonstationary_example':decision['implications']['source_implies_lean']['reasoning'],
 'formal_nonvacuity_declaration':name,'formal_nonvacuity_scope':'Positive-dimensional stationary spatial jump at positive time; every exact analytic premise and the target conclusion hold. It supplements the adjudicator nonstationary example, without replacing the source-scope judgment.',
 'witness_files':[{'path':p.relative_to(R).as_posix(),'sha256':sha(p)} for p in [check,native_output,native_exit]],
 'native_exit':e,'axioms':axioms,
 'reuse_search':{'command':command,'exit_code':search.returncode,'output_path':log.relative_to(R).as_posix(),'output_sha256':sha(log),
  'sources':[{'path':p,'sha256':sha(R/p)} for p in paths],
  'selected_producers':['discontinuous_stationary_conservative_residual','riemannData_intervalIntegrable','hasDerivAt_const','intervalIntegrable_const','leveque01_integralLaw_impliesDifferentialLaw_of_smooth'],
  'disposition':'Compose existing producers into an evidence-only witness; no duplicate production theorem or source replacement.'}}
destination=S/'smooth-bridge-strengthening-evidence.json';assert not destination.exists();destination.write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({'evidence_sha256':sha(destination),'witness_sha256':sha(check),'native_output_sha256':sha(native_output),'axioms':axioms}))
