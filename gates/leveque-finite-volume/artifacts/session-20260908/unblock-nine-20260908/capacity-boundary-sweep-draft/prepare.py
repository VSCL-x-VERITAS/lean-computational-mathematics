"""Additive coordinate-binder generalization from the exact frozen producer."""
from pathlib import Path
import hashlib, json, os
P = Path(__file__).resolve().parent
D = P.parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(), 'native-long-path-io.py', 'exec'), globals())
def ref(p):
    b=p.read_bytes(); return {'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def put(p,b):
    if not isinstance(b,bytes): b=(json.dumps(b,indent=2,ensure_ascii=False)+'\n').encode()
    with p.open('xb') as f:f.write(b)
    return ref(p)
src=D/'capacity-ghost-boundary-draft/native-01/Candidate.lean'
assert ref(src)['sha256']=='f0e3bf9abd1a997f46df663b657a142749213572bbb2ecd16bb71b94e55af2c2'
put(P/'Basis.lean.snapshot',src.read_bytes())
s=src.read_text(encoding='utf-8')
a=s.index('noncomputable def step (method : ℕ → Method data coord)')
b=s.index('\nend CapacityCoordinate',a)
old=s[a:b]
assert old.count('(method : ℕ → Method data coord)')==5
new=old.replace('(method : ℕ → Method data coord)','(method : ∀ k, Method data (coord k))')
header='''namespace CapacityBoundarySweep
open MeasureTheory NumStability NumStability.FiniteCoordinate NumStability.SequentialError CapacityCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : ℕ → LineCoordinates (m := m) D Cell Face Line}

'''
put(P/'Sweep.lean.fragment',(header+new+'\nend CapacityBoundarySweep\n').encode())
put(P/'derivation.json',{'source':ref(src),'snapshot':ref(P/'Basis.lean.snapshot'),
    'old_fixed_coordinate_segment_sha256':hashlib.sha256(old.encode()).hexdigest(),
    'old_segment':old,'binder_replacements':5,
    'replacement':'(method : ∀ k, Method data (coord k))',
    'generated_fragment':ref(P/'Sweep.lean.fragment'),
    'proof_bodies_unchanged':True})
print(json.dumps({'basis':ref(P/'Basis.lean.snapshot'),'fragment':ref(P/'Sweep.lean.fragment')}))
