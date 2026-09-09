from pathlib import Path
import re
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').exists())
base=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
core=(base/'DirectionalMethodSweep.lean').read_text()
start=core.index('    0 < m ∧')
stop=core.index(' := by',start)
conclusion=core[start:stop]
subs={'D':'(Fin 1)','m':'1','Point':'ℝ','FacePoint':'Unit','stages':'[(0, (1 : ℝ))]','reference':'(fun (_before : List (Fin 1 × ℝ)) (_d : Fin 1) (_dt : ℝ) => reference)','admitted':'(fun (_d : Fin 1) (_cell : Cell) (_dt : ℝ) (_line : ℤ → State) => True)'}
for a,b in subs.items():conclusion=re.sub(r'\b'+a+r'\b',lambda _:b,conclusion)
path=base/'Examples/PhysicalIntervalSweep.lean'
t=path.read_text()
assert 'theorem simultaneous_contract :=' in t
t=t.replace('theorem simultaneous_contract :=','theorem simultaneous_contract :\n'+conclusion+' :=')
path.write_text(t,encoding='utf-8',newline='\n')
