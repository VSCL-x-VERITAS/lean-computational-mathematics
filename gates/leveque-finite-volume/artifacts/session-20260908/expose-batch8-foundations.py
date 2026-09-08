"""Expose nine reviewed Analysis leaves; the generic jump leaf is reached through its Riemann bridge."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt=S/'root-batch8-placement-verification.json'
assert sha(receipt)=='cfa34484713dd89a97e0ab3bcaf67d5819b7dd003ea1447e924c97c4da7b1d39'
review=json.loads(receipt.read_bytes())
for f in review['files']:assert sha(R/f['path'])==f['sha256']
added=[f['module'] for f in review['files'] if f['module'].startswith('ComputationalMathematics.Analysis.')]
assert len(added)==9
assert 'import ComputationalMathematics.Topology.Order.Jump' in (R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataJump.lean').read_text(encoding='utf-8')
p=R/'ComputationalMathematics/Analysis.lean';before=p.read_bytes()
assert sha(p)=='87b14c218ee029592c732aaf1507c3adee301a56c1f05f382fe09460ee5d5592'
text=p.read_text(encoding='utf-8');imports=re.findall(r'^import (\S+)$',text,re.M)
assert not set(added)&set(imports)
start=text.index('import ');end=text.rindex('import ')+len('import '+imports[-1])
new=text[:start]+'\n'.join('import '+m for m in sorted(imports+added,key=str.casefold))+text[end:]
with (S/('batch8-analysis-before-'+sha(p)+'.bin')).open('xb') as f:f.write(before)
p.write_text(new,encoding='utf-8',newline='\n')
record={'schema':1,'path':p.relative_to(R).as_posix(),'before_sha256':hashlib.sha256(before).hexdigest(),'after_sha256':sha(p),'added_imports':added,'all_new_files':review['files'],'topology_entry':'The new Jump leaf is directly importable and re-exported by RiemannDataJump; its topology-only dependency boundary is retained. Existing Analysis and both complete-library roots expose every new result.','source_acceptance':False}
out=S/'batch8-analysis-imports.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'receipt':out.relative_to(R).as_posix(),'sha256':sha(out),'analysis_sha256':sha(p),'new_direct_imports':9,'new_leaves':10}))
