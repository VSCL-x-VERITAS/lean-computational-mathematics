from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[5]
p=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/LocalLinearAdvection.lean'
raw=p.read_bytes();snap=P/'build03-sources'/p.name;snap.parent.mkdir(exist_ok=True);assert not snap.exists();snap.write_bytes(raw)
t=raw.decode();anchor='import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus'
assert anchor not in t
lines=t.splitlines();imports=sorted([l for l in lines if l.startswith('import ')]+[anchor]);t='\n'.join(imports)+'\n'+'\n'.join(l for l in lines if not l.startswith('import '))+'\n'
p.write_text(t,encoding='utf-8',newline='\n')
(P/'repair03.json').write_text(json.dumps({'path':p.relative_to(R).as_posix(),'before':hashlib.sha256(raw).hexdigest(),'snapshot':snap.relative_to(R).as_posix(),'after':hashlib.sha256(p.read_bytes()).hexdigest(),'change':'Direct import of actual Mathlib fundamental theorem owner found by project search.'},indent=2)+'\n',encoding='utf-8',newline='\n')
