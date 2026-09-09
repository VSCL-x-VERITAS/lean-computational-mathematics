from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[5]
FV='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
CL='ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/'
changes={
 FV+'CoordinateLineMethod.lean': [('open DirectionalLine','open MeasureTheory DirectionalLine')],
 FV+'Examples/HighResolutionAdvectionLine.lean':[
  ('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift','import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift\nimport ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField'),
  ('open NumStability NumStability.DirectionalLine','open NumStability NumStability.LocalConservationLaw NumStability.DirectionalLine')],
 FV+'FinitePhysicalGeometry.lean': [('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry','import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity')],
 CL+'LocalRectangleReference.lean': [('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface','import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic')],
 FV+'RefiningLineMethod.lean': [('import Mathlib.Analysis.SpecialFunctions.Pow.Real','import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface\nimport Mathlib.Analysis.SpecialFunctions.Pow.Real')],
 CL+'LocalLinearAdvection.lean': [('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface','import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage')],
 FV+'FiniteCartesianGeometry.lean': []}
records=[]
for rel,reps in changes.items():
    path=R/rel;raw=path.read_bytes();snapshot=P/'build02-sources'/path.name
    snapshot.parent.mkdir(exist_ok=True);assert not snapshot.exists();snapshot.write_bytes(raw)
    text=raw.decode('utf-8')
    for old,new in reps:assert old in text;text=text.replace(old,new)
    text='\n'.join(l for l in text.splitlines() if not l.startswith(('#check ','#print axioms ')))+'\n'
    lines=text.splitlines();im=sorted(l for l in lines if l.startswith('import '));it=iter(im)
    text='\n'.join(next(it) if l.startswith('import ') else l for l in lines)+'\n'
    path.write_text(text,encoding='utf-8',newline='\n')
    records.append({'path':rel,'before':hashlib.sha256(raw).hexdigest(),'snapshot':snapshot.relative_to(R).as_posix(),
     'after':hashlib.sha256(path.read_bytes()).hexdigest(),'replacements':reps,
     'other_changes':'Remove scratch check commands; sort explicit imports.'})
(P/'repair02.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8',newline='\n')
print(len(records))
