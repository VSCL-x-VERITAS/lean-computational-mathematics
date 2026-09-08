"""Expose the nine independently reviewed additive Analysis leaves."""
from pathlib import Path
import argparse,hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--review-sha256',required=True);a=p.parse_args()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
review_path=S/'root-batch10-production-placement-verification.json'
assert sha(review_path)==a.review_sha256
review=json.loads(review_path.read_bytes())
assert review['status']=='PASS' and review['source_acceptance'] is False
for f in review['files']:assert sha(R/f['path'])==f['sha256']
added=[f['module'] for f in review['files']];assert len(added)==len(set(added))==9
p=R/'ComputationalMathematics/Analysis.lean';before=p.read_bytes()
assert sha(p)=='7524f865840ee191683642b4e9bd10dd0264b5e9241c6132ca2c7e29d474e51b'
text=p.read_text(encoding='utf-8');imports=re.findall(r'^import (\S+)$',text,re.M)
assert not set(added)&set(imports)
start=text.index('import ');end=text.rindex('import ')+len('import '+imports[-1])
new=text[:start]+'\n'.join('import '+m for m in sorted(imports+added,key=str.casefold))+text[end:]
with (S/('batch10-analysis-before-'+sha(p)+'.bin')).open('xb') as f:f.write(before)
assert p.read_bytes()==before
p.write_text(new,encoding='utf-8',newline='\n')
data=dict(schema=1,path=p.relative_to(R).as_posix(),before_sha256=hashlib.sha256(before).hexdigest(),
 after_sha256=sha(p),added_imports=added,all_new_files=review['files'],source_acceptance=False,review_sha256=sha(review_path))
out=S/'batch10-analysis-imports.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps(dict(status='PASS',sha256=sha(out),analysis_sha256=sha(p),new_direct_imports=9)))

