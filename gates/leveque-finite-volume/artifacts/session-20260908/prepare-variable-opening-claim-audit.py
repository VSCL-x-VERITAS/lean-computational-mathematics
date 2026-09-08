"""Align a fresh audit with the mathematical inventory row; preserve the paragraph audit."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
def bind(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
old='LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION-PRODUCTION-20260908'
new='LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908'
prior=S/'audits'/old;dest=S/'audits'/new
assert sha(prior/'faithfulness/decision.json')=='4c25a95e84a86fb7a3e126863ee1040ca77ee3862bd0d2317c01172f91896cbc'
task=read(prior/'audit-task.json');assert sha(R/task['source']['path'])==task['source']['sha256']
target_before=dict(task['target']);target_sha=sha(R/task['target']['path'])
gate=read(R/'gates/leveque-finite-volume/chapter-01.json')
rows=[r for r in gate['rows'] if r['id'] in {'LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION','LEV-CH01-WAVE-PROPAGATION-FRAMEWORK'}]
assert len(rows)==2
assert next(r for r in rows if r['id']=='LEV-CH01-WAVE-PROPAGATION-FRAMEWORK')['status']=='SKIPPED'
task['task_id']=new;task['audit_output']=(dest/'faithfulness').relative_to(R).as_posix()
task['source']['locations']=[{'location':'raw PDF page 30; printed Chapter 1 page 8','anchor':'Only the opening mathematical clause of the second paragraph, ending before the first comma: Hyperbolic equations with variable coefficients may not be in conservation form. The remainder of that paragraph is outside this selected clause.'}]
dest.mkdir(exist_ok=False)
p=dest/'audit-task.json';p.write_text(json.dumps(task,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
searches=[]
for i,command in enumerate([
 ['rg','-n','RepresentsScalarTransportFlux|coefficient_eq|exists_hyperbolic_variableCoefficient_without_localFlux','ComputationalMathematics','-g','*.lean'],
 ['rg','-n','RepresentsScalarTransportFlux|variableCoefficient.*[Cc]onservation|[Nn]onconservative','.lake/packages/mathlib/Mathlib/Analysis','-g','*.lean']],1):
 result=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert result.returncode in (0,1) and not result.stderr
 out=dest/f'reuse-search-{i}-output.txt';err=dest/f'reuse-search-{i}-stderr.txt'
 out.write_bytes(result.stdout);err.write_bytes(result.stderr)
 searches.append({'command':command,'exit_code':result.returncode,'stdout':bind(out),'stderr':bind(err)})
lineage={'schema':1,'task_id':new,'task_sha256':sha(p),'config_sha256':sha(S/'audit.config.json'),
 'target':target_before,'target_source_sha256':target_sha,'pages_argument':'23,25,26,27,30',
 'prior_task':old,'prior_decision_sha256':sha(prior/'faithfulness/decision.json'),
 'source_page':bind(prior/'faithfulness/orchestration/page-030.png'),'inventory_rows':rows,'reuse_searches':searches,
 'reuse_review':'The existing explicit smooth positive scalar obstruction is a compatible stronger witness for the opening possibility claim. Reuse it unchanged; do not add a duplicate projected source wrapper or reprove the coefficient obstruction. The independent audit must judge applicability and any genuine extra conclusions. The name searches are scoped, not a global absence proof.',
 'change':'The current inventory already separates the mathematical possibility clause from the later wave-propagation discussion. Only the locator is aligned to that clause. The full-paragraph rejection, separate methods row, fixed-state versus changed-density qualification, exact source bytes and existing target proof are preserved. No new user interpretation or acceptance is inferred.'}
p=dest/'opening-claim-lineage.json';p.write_text(json.dumps(lineage,indent=2)+'\n',encoding='utf-8')
assert task['target']==target_before and sha(R/task['target']['path'])==target_sha
print(json.dumps({'task':bind(dest/'audit-task.json'),'lineage':bind(p),'target_source_sha256':target_sha}))
