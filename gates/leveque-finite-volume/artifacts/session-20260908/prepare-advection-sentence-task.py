"""Prepare a fresh sentence-scoped conserved-mass audit without changing history."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_text(encoding='utf-8'))
old='LEV-CH01-ADVECTION-LINEAR-FLUX-CANONICAL-20260908'
new='LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908'
prior=S/'audits'/old;dest=S/'audits'/new
assert sha(prior/'faithfulness/decision.json')=='82c70fc8aae81f9790650f4e5ed6410008c1bb222dd908a5f89691b4db94c329'
assert sha(S/'advection-flux-scope-review/locator-proposal.md')=='d5b69774441b8147c4a627c8117ccb0264459d61f77d25f093cdd0a5d83748a6'
assert sha(S/'advection-flux-scope-review/review.md')=='564260801384e93f7cc58889685296d0e30a8ca22a21fa8522931b7b9bf5f0c2'
task=read(prior/'audit-task.json')
assert sha(R/task['source']['path'])==task['source']['sha256']
assert sha(R/task['target']['path'])=='f57692cff2099eb9d755a3867856aeca95100f7a97ce76a067c4db71474730b7'
assert subprocess.check_output(['git','-c','core.longpaths=true','cat-file','blob','9e2225705fed906b1120d55105d607baabef57c9:'+task['target']['path']],cwd=R)==(R/task['target']['path']).read_bytes()
gate=read(R/'gates/leveque-finite-volume/chapter-01.json')
rows={r['id']:r for r in gate['rows']}
assert rows['LEV-CH01-ADVECTION-LINEAR-FLUX']['status']=='READY'
assert rows['LEV-CH01-NONCONSERVATION-SOURCE-TERMS']['status']=='READY'
task['task_id']=new
task['source']['locations']=[{
 'location':'raw PDF page 26; printed Chapter 1 page 4; Section 1.1.1, paragraph immediately after (1.10)',
 'anchor':'Select exactly the THIRD sentence of the paragraph immediately after (1.10): it begins "For example, the advection equation (1.2)" and ends with the linear-flux assertion f(q) = ubar*q and its terminal period. The whole selected sentence includes conserved contaminant mass, flow down the pipe, the exact flux, and the reference to (1.2). Retain the entire page as context. The following FOURTH sentence, beginning "If the total mass of contaminant is not conserved" and ending "elsewhere.", is adjacent context and is separately inventoried as LEV-CH01-NONCONSERVATION-SOURCE-TERMS; it is not a conclusion selected by this task.'
}]
task['audit_output']=(dest/'faithfulness').relative_to(R).as_posix()
assert not dest.exists();dest.mkdir()
path=dest/'audit-task.json';path.write_text(json.dumps(task,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
record={'schema':1,'task_id':new,'task_sha256':sha(path),'config_sha256':sha(S/'audit.config.json'),
 'target':task['target'],'target_source_sha256':sha(R/task['target']['path']),'pages_argument':'23,25,26',
 'prior_task':old,'prior_rejection_sha256':sha(prior/'faithfulness/decision.json'),
 'scope_review_sha256':sha(S/'advection-flux-scope-review/review.md'),
 'locator_proposal_sha256':sha(S/'advection-flux-scope-review/locator-proposal.md'),
 'unchanged_separate_source_term_row':rows['LEV-CH01-NONCONSERVATION-SOURCE-TERMS']}
receipt=dest/'sentence-scope-lineage.json';receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'task':path.relative_to(R).as_posix(),'task_sha256':sha(path),'lineage_sha256':sha(receipt)}))

