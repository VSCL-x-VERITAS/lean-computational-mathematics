from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];D=S/'characteristic-converse-draft'
p=D/'CharacteristicConverse.lean';raw=p.read_bytes();sha=lambda b:hashlib.sha256(b).hexdigest()
(D/('first-draft-'+sha(raw)+'.bin')).write_bytes(raw)
queries=[
 ['rg','-n','IsLinearAdvectionSolution.*IsUniform|eq_travelingWave|constant.*characteristic|[Cc]haracteristic.*constant|converse.*advection','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean'],
 ['rg','-n','eigenbasis_coordinates_mulVec|constantCoefficientSystem_iff_eigenbasisAdvection|is_const_of_deriv_eq_zero','ComputationalMathematics/Analysis/PartialDifferentialEquations','.lake/packages/mathlib/Mathlib/Analysis/Calculus','-g','*.lean'],
 ['rg','-n','theorem HasFDerivAt.comp_hasDerivAt','-A','9','.lake/packages/mathlib/Mathlib/Analysis/Calculus/Deriv/Comp.lean']]
runs=[]
for argv in queries:
 r=subprocess.run(argv,cwd=R,capture_output=True);assert r.returncode in [0,1]
 runs.append({'argv':argv,'exit_code':r.returncode,'stdout':r.stdout.decode(),'stderr':r.stderr.decode()})
(D/'current-tree-search.json').write_text(json.dumps({'schema':1,'runs':runs,'selected':'Existing exact eigenbasis PDE decoupling, Mathlib Frechet chain rule along an explicit line and zero-derivative constancy. Existing translation geometry characterizes prescribed profiles but does not provide the converse for an independently supplied field.','absence_claim':'Bounded lexical misses only; no global semantic absence claim.','hypothesis':'Joint differentiability of Function.uncurry q is explicit. No source correspondence or exhaustive source interpretation is asserted.'},indent=2)+'\n',encoding='utf-8')
text=raw.decode();old='hF.comp_hasDerivAt t hcurve';assert text.count(old)==1
text=text.replace(old,'hF.comp_hasDerivAt (f := fun τ : ℝ => (x + speed * τ, τ)) t hcurve')
p.write_text(text,encoding='utf-8',newline='\n')
print(json.dumps({'before_sha256':sha(raw),'after_sha256':sha(p.read_bytes()),'repair':'Specify the characteristic path to prevent unification from choosing the fixed-first-coordinate curve. Original failure retained.'}))

