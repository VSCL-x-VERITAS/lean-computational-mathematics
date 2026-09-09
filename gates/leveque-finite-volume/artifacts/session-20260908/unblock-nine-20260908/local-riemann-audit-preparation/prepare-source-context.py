"""Pin the unchanged Info primary locator and explicit inherited equation context."""
from pathlib import Path
import hashlib,json
I=Path(__file__).resolve().parent;D=I.parent;R=I.parents[5];S=D.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
prior=S/'audits/LEV-CH01-RIEMANN-INFORMATION-INTERFACE-INTERPRETED-PRODUCTION-20260908'
task=json.loads((prior/'audit-task.json').read_bytes())
assert sha(R/task['source']['path'])==task['source']['sha256']=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
images=[]
for page in (26,27,28):
 source=R.parent/'workflow-v5.0.1-local/chapter01-source-review'/('page-'+str(page).zfill(3)+'.png')
 target=I/source.name
 with target.open('xb') as f:f.write(source.read_bytes())
 images.append({'page':page,**ref(target)})
receipt=S/'user-discontinuity-interpretation-20260908.json'
assert sha(receipt)=='b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
extension={'format':'pinned-source-context-extension-1',
 'source':{key:task['source'][key] for key in ('path','sha256')},
 'primary_locations':task['source']['locations'],
 'inherited_locations':[{'location':'raw PDF page 26; printed Chapter 1 page 4',
 'anchor':'Inherited equation (1.10) and its immediately following explanation of interval mass changing only through physical endpoint fluxes, explicitly underlying the selected Section 1.2 finite-volume interface workflow.'}],
 'pages':[26,27,28],'images':images,'interpretation_receipts':[ref(receipt)]}
with (I/'source-context-extension.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(extension,f,indent=2,ensure_ascii=False);f.write('\n')
lineage={'schema':1,'prior_task':task['task_id'],'prior_task_metadata':ref(prior/'audit-task.json'),
 'prior_primary_locations_unchanged':True,'source_context_extension':ref(I/'source-context-extension.json'),
 'inherited_receipt':ref(receipt),
 'source_boundary':'The primary selection remains the existing Sections 1.1.2/1.2 cell-average and interface Riemann-information-flux workflow. The added locator supplies explicitly inherited (1.10) endpoint-flux conservation. Raw pages 26,27,28 retain the prior source-facing image coverage; no independent shock-tracking or multidimensional assertions are selected.',
 'interpretation_authority':'Q7 is coordinator-selected under the user objective. The literal earlier Eq1.10 user answer is separately preserved with its original scope. No prior judge output is supplied.',
 'audit_prepared':False,'roles_invoked':False}
with (I/'source-context-lineage.json').open('x',encoding='utf-8',newline='\n') as f:json.dump(lineage,f,indent=2);f.write('\n')
print(json.dumps(lineage))
