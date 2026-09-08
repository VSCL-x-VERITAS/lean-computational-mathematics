"""Derive one fresh measure-evidence audit from the completed unresolved linear Riemann run."""
from pathlib import Path
import ast,hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
old='LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION-PRODUCTION-20260908'
new='LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908'
d=S/'audits'/old;o=d/'faithfulness'
assert sha(o/'decision.json')=='b525d59b4604c818a66ed4c9453e4a1cb26c42eda6862f2cdc09b7b7f6cd8094'
receipt=read(d/'root-pipeline-receipt.json');assert receipt['exit_code']==0
assert sha(d/'root-pipeline-output.txt')==receipt['stdout_sha256']
assert sha(d/'root-pipeline-stderr.txt')==receipt['stderr_sha256']
src=S/'prepare-cell-average-measure-context.py';assert sha(src)=='e540962a7d63afd25d63edc74d5e468c10d09f1137fe26e2fcea48d6ccd99841'
code=src.read_text()
def replace_once(a,b):
 global code
 assert code.count(a)==1,(a,code.count(a));code=code.replace(a,b)
replace_once("OLD = 'LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-CANONICAL-20260908'","OLD = "+repr(old))
replace_once("TASK = 'LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908'","TASK = "+repr(new))
code=code.replace('audit-cell-average-measure-context.config.json','audit-linear-riemann-measure-context.config.json')
start=code.index('old_hashes = ');end=code.index('\nfor name,h in old_hashes.items()',start)
code=code[:start]+'old_hashes = '+repr({n:sha(o/n) for n in ['manifest.json','decision.json','report.md']})+code[end:]
target=read(d/'audit-task.json')['target']
replace_once("assert sha(R/task['target']['path'])=='4c9e8eee7c8cfce7fa381cf1de2892d5b2326b46aacbbf3a2bff4efad1eca816'","assert sha(R/task['target']['path'])=="+repr(sha(R/target['path'])))
start=code.index('image_hashes=');end=code.index("\nprefix=(tr/'r.py')",start)
images={p:sha(o/'orchestration'/('page-'+p.zfill(3)+'.png')) for p in ['23','25','27','28']}
replacement="image_hashes="+repr(images)+"\nfor page,h in image_hashes.items():\n    src=S/'audits'/OLD/'faithfulness/orchestration'/('page-'+page.zfill(3)+'.png')\n    assert sha(src)==h\n    (tr/src.name).write_bytes(src.read_bytes())"
code=code[:start]+replacement+code[end:]
replace_once("'pages_argument':'23,26,27'","'pages_argument':'23,25,27,28'")
ast.parse(code)
dest=S/'prepare-linear-riemann-measure-context.py';assert not dest.exists();dest.write_text(code,encoding='utf-8',newline='\n')
lineage={'schema':1,'parent':src.name,'parent_sha256':sha(src),'derived':dest.name,'derived_sha256':sha(dest),'old_task':old,'old_decision_sha256':sha(o/'decision.json'),'new_task':new,'target':target,'target_source_sha256':sha(R/target['path']),'source_and_target_unchanged':True,'changes':['Exact task/config substitution and pinned original-run identity','Reuse exact primary renders from the completed original audit, avoiding mutable shared render paths','Same 51-file native environment and proof-free measure spans','No interpretation, new theorem, or judge conclusion inserted'],'remaining_scope':'Fresh judges must still decide spectral representative and all-real-time conclusion correspondence. This evidence repair alone does not establish either implication.'}
p=S/'linear-riemann-measure-context-derivation.json';assert not p.exists();p.write_text(json.dumps(lineage,indent=2)+'\n',encoding='utf-8')
print(json.dumps(lineage))

