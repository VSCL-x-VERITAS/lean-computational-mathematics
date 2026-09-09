from pathlib import Path
D = Path(__file__).resolve().parent
files = [D.parent/'dim-local-characteristic-witness/Connected.lean', D/'quality03-Quality.lean.snapshot']
imports = ['import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField\n', 'import Mathlib.Algebra.Order.Floor.Ring\n']
bodies=[]
for path in files:
    lines=path.read_text().splitlines(keepends=True)
    imports += [x for x in lines if x.startswith('import ') and x not in imports]
    bodies.append(''.join(x for x in lines if not x.startswith(('import ', '#check ', '#print '))))
(D/'Candidate.lean').write_bytes((''.join(imports)+'\n'+''.join(bodies)+(D/'Family.lean.fragment').read_text()).encode())
