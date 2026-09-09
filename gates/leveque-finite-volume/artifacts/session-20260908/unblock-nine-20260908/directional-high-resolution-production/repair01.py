from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[5]
base=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
changes={
 'FinitePhysicalUpdate.lean':('import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry',
   'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry\nimport ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance'),
 'RefiningLineMethod.lean':('import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference',
   'import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity\nimport ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference'),
 'HighResolutionCoordinateSweep.lean':('coordinate_highResolution_sourceContract','coordinate_highResolution_specification')}
records=[]
for name,(old,new) in changes.items():
    path=base/name;raw=path.read_bytes();snapshot=P/'build01-sources'/name
    snapshot.parent.mkdir(exist_ok=True);assert not snapshot.exists();snapshot.write_bytes(raw)
    text=raw.decode('utf-8');assert old in text;text=text.replace(old,new)
    path.write_text(text,encoding='utf-8',newline='\n')
    records.append({'path':path.relative_to(R).as_posix(),'before':hashlib.sha256(raw).hexdigest(),
     'snapshot':snapshot.relative_to(R).as_posix(),'after':hashlib.sha256(path.read_bytes()).hexdigest(),'replacement':[old,new]})
(P/'repair01.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(records,indent=2))
