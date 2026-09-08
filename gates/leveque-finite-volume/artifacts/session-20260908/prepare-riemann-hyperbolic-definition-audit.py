"""Freeze a new default-policy Riemann problem-data audit task."""
from pathlib import Path
import hashlib, json
S=Path(__file__).resolve().parent; R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old='LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION-PRODUCTION-20260908'
new='LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908'
prior=S/'audits'/old; dest=S/'audits'/new
assert sha(prior/'faithfulness/decision.json')=='5bcb31b0d05629a35f39086f22f044187188ad043dd38ebebdc8518b6987b825'
assert sha(S/'definition-repairs-production-verification.json')=='53b710615834dfb6522713c9c3b7489b56eeb55d8138497e1b130cb0314a86d5'
task=json.loads((prior/'audit-task.json').read_bytes())
assert sha(R/task['source']['path'])==task['source']['sha256']
task['task_id']=new
task['target']={'path':'ComputationalMathematics/Source/LeVeque/Chapter01/RiemannHyperbolicProblem.lean','declaration':'NumStability.leveque01_riemannProblem_iff_hyperbolicInitialData'}
assert sha(R/task['target']['path'])=='3a11addfd88714c7e3756b1675e199df23e472e43f7b738af996cff5656b8384'
task['audit_output']=(dest/'faithfulness').relative_to(R).as_posix()
dest.mkdir(exist_ok=False)
path=dest/'audit-task.json'; path.write_text(json.dumps(task,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
lineage={'schema':1,'task_id':new,'task_sha256':sha(path),'config_sha256':sha(S/'audit.config.json'),
 'target':task['target'],'target_source_sha256':sha(R/task['target']['path']),'pages_argument':'23,25,26,27,28',
 'prior_task':old,'prior_decision_sha256':sha(prior/'faithfulness/decision.json'),
 'production_verification_sha256':sha(S/'definition-repairs-production-verification.json'),
 'change':'Actual first-order governing equation and its same-matrix spectral condition, admissible two-state initial data, free origin, explicit distinct-jump subfamily. No solution existence or framework asserted. Exact source and locator unchanged; no user interpretation or acceptance inferred.'}
p=dest/'problem-data-lineage.json'; p.write_text(json.dumps(lineage,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'task':path.relative_to(R).as_posix(),'task_sha256':sha(path),'lineage_sha256':sha(p)}))
