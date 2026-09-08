"""Expose the six independently reviewed additive Analysis leaves."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
review=json.loads((S/'root-batch9-production-placement-verification.json').read_bytes())
assert review['status']=='PASS' and not review['source_acceptance']
for f in review['files']:assert sha(R/f['path'])==f['sha256']
added=[f['module'] for f in review['files']];assert len(added)==6
p=R/'ComputationalMathematics/Analysis.lean';before=p.read_bytes()
assert sha(p)=='6248fa8b7050cf55930c3c8c1c9e377574555d7b83db52d12e25cb7e5137d544'
text=p.read_text(encoding='utf-8');imports=re.findall(r'^import (\S+)$',text,re.M)
assert not set(added)&set(imports)
start=text.index('import ');end=text.rindex('import ')+len('import '+imports[-1])
new=text[:start]+'\n'.join('import '+m for m in sorted(imports+added,key=str.casefold))+text[end:]
with (S/('batch9-analysis-before-'+sha(p)+'.bin')).open('xb') as f:f.write(before)
p.write_text(new,encoding='utf-8',newline='\n')
data={'schema':1,'path':p.relative_to(R).as_posix(),'before_sha256':hashlib.sha256(before).hexdigest(),
 'after_sha256':sha(p),'added_imports':added,'all_new_files':review['files'],'source_acceptance':False,
 'review_sha256':sha(S/'root-batch9-production-placement-verification.json')}
out=S/'batch9-analysis-imports.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'status':'PASS','sha256':sha(out),'analysis_sha256':sha(p),'new_direct_imports':6}))
