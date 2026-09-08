from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
pins={'cartesian-coordinate-line-composition-draft/final03-input.lean':'80c1f757cb9f214652494b6b7e4f8e6b962f3af16ea5f59ac955d2ad896d8c67','cartesian-coordinate-line-composition-draft/Composition.lean.fragment':'aecdafbf5fae8c5384a5df84f7e33cb0365b3e9b467d66b0aa5dcdfc0559c014','returned-field-production/final-receipt.json':'8e9aa4b4c6f2eb47ffdc237ddadc637bc8247c8ddbe3ba88a953f87778b10605','batch9-capstone-independent-review/REVIEW.md':'40268255c164bcae99a84caaebee31483d8e141addc975109e9d77607dafdbde'}
for p,h in pins.items():assert sha(S/p)==h,p
cmds=[['rg','-n','ReturnedFieldCoordinateSweepDraft|SweepAdmitted|guardedRule','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean'],['rg','-n','advance_mass_balance|advance_line_local|finite_line_mass_balance|sweep_cons|sweep_two_mass_balance|cellVolume_smul_finiteVolumeCellAverageUpdate|RiemannFieldFluxMethod','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume','-g','*.lean']]
search=[]
for i,cmd in enumerate(cmds):
 r=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);assert r.returncode==(1 if i==0 else 0)
 p=P/f'search-{i+1}.txt';assert not p.exists();p.write_bytes(r.stdout)
 search.append(dict(command=cmd,exit_code=r.returncode,output=bind(p)))
extra=['returned-field-interface-capstone-draft/final-receipt.json','returned-field-interface-capstone-draft/REVIEW.md','returned-field-interface-capstone-draft/preparation.json','current-thread-clarification-provenance-batch8.json','audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/audit-task.json','audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/decision.json','source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf']
v=dict(schema=1,status='unselected_scratch',source_acceptance=False,frozen_inputs=[bind(S/p) for p in list(pins)+extra],searches=search,read_only_review='Frozen Cartesian statements are correct for total exact time-one-trace solvers. This draft composes admitted returned-field methods without those three restrictions; geometry/accuracy/source representation remain separate.')
p=P/'preparation.json';assert not p.exists();p.write_bytes((json.dumps(v,indent=2)+'\n').encode());print(sha(p))
