"""Expose the five reviewed reusable FV leaves through the existing Analysis entry."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
p=R/'ComputationalMathematics/Analysis.lean'; before=p.read_bytes()
assert sha(p)=='4a80b30f522472f8202d1aa25770d1de4012537eac666dd28397d8b9a1bb7444'
text=p.read_text(encoding='utf-8')
names=['CellAverageEstimates','PhysicalFluxAverage','FluxUpdateError','FluxUpdateErrorBounds','LinearRiemannFluxAverage']
added=['ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'+n for n in names]
files=[R/(m.replace('.','/')+'.lean') for m in added]
assert all(f.is_file() for f in files)
imports=re.findall(r'^import (\S+)$',text,re.M)
assert not set(added)&set(imports)
start=text.index('import ');end=text.rindex('import ')+len('import '+imports[-1])
new=text[:start]+'\n'.join('import '+m for m in sorted(imports+added,key=str.casefold))+text[end:]
snapshot=S/('fv-foundations-analysis-before-'+sha(p)+'.bin')
with snapshot.open('xb') as f:f.write(before)
p.write_text(new,encoding='utf-8',newline='\n')
record={'schema':1,'path':p.relative_to(R).as_posix(),'before_sha256':hashlib.sha256(before).hexdigest(),'after_sha256':sha(p),'added_imports':sorted(added),'files':[{'path':f.relative_to(R).as_posix(),'sha256':sha(f)} for f in files],'reason':'Every new Analysis leaf must be reachable through its established public entry point. The existing NumStability.Analysis forwarder inherits these imports.','source_wrappers_added':0,'source_acceptance':False}
out=S/'fv-foundations-analysis-imports.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'receipt_sha256':sha(out)}))

