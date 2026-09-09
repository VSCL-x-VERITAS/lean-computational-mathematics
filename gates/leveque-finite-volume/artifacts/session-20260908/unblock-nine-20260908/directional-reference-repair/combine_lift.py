from pathlib import Path
P=Path(__file__).resolve().parent
parts=[(P/name).read_text(encoding='utf-8').split('\n#check')[0] for name in ('Geometry.lean','Projection.lean')]
imports=['import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianDirectionalReference']
body=[]
for part in parts:
    for line in part.splitlines():
        if line.startswith('import '):
            if line not in imports:imports.append(line)
        else:body.append(line)
(P/'Lift.lean').write_text('\n'.join(imports+body)+'\n'+(P/'lift.fragment').read_text(encoding='utf-8'),encoding='utf-8',newline='\n')
