"""Place checked exact-domain compositions and source-independent mass differentiation."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda b:hashlib.sha256(b).hexdigest()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip()=='3d205d6fae8a782939819ae24a0f11ecf1247e99'
checks=['transport-domain-draft-check','uniform-transport-domain-draft-check','rectangle-mass-derivative-corrected-check']
for label in checks:
 e=json.loads((S/(label+'-exit.json')).read_text());assert e['exit_code']==0
 out=(S/(label+'-output.txt')).read_text(encoding='utf-8')
 assert 'sorryAx' not in out and 'error:' not in out
assert sha((S/'user-transport-interpretation-20260908.json').read_bytes())=='26f16aeef42a0c7de4865c4c00e9ba223a9ae53604abf55da427171f6bf8e16b'
queries=[
 ['rg','-n','ae_hasDerivAt_intervalIntegral_pi|hasDerivAt_mass_ae|ae_hasDerivAt_integral|hasDerivAt.*mass','ComputationalMathematics','.lake/packages/mathlib/Mathlib'],
 ['rg','-n','theorem ae_hasDerivAt_integral|LocallyIntegrable.ae_hasDerivAt_integral|hasDerivAt_pi|intervalIntegral_comp_comm','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiationThm.lean','.lake/packages/mathlib/Mathlib/Analysis/Calculus/Deriv/Prod.lean','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean']]
search=[]
for argv in queries:
 p=subprocess.run(argv,cwd=R,capture_output=True)
 assert p.returncode in [0,1]
 search.append(dict(argv=argv,exit_code=p.returncode,stdout=p.stdout.decode('utf-8'),stderr=p.stderr.decode('utf-8')))
(S/'discontinuity-general-foundation/current-tree-search.json').write_text(json.dumps({'schema':1,'runs':search,'selected':'Lift Mathlib LocallyIntegrable.ae_hasDerivAt_integral coordinatewise with hasDerivAt_pi and the continuous linear projection integral identity, then apply the existing rectangle balance identity. Existing scalar Lebesgue differentiation avoids a duplicate proof. No current-project match for the proposed finite-vector mass bridge was returned by these bounded lexical queries.','rejected':'The scalar Mathlib theorem alone does not state the finite-vector conservation-law conclusion; the old fixed step witness does not establish a general temporal balance theorem.','absence_claim':'Scoped lexical search only.'},indent=2)+'\n',encoding='utf-8')
license='/-\nSPDX-License-Identifier: MIT\n-/\n\n'
files=[]
for eq,title,doc in [
 ('02','Uniform transport with explicit solution domains','The scalar equation is hyperbolic and is the one-component constant linear\nsystem. For a uniformly translated field, the classical and rectangle\nconservation predicates are characterized by differentiability and local\ninterval integrability of the initial profile.'),
 ('03','Translated profiles with explicit solution domains','Every real profile has unchanged shape and constant characteristic values.\nThe translated field is a classical solution exactly for differentiable\nprofiles and a rectangle conservation solution exactly for locally interval\nintegrable profiles.')]:
 draft=S/('transport-domain-draft/Equation'+eq+'SolutionDomains.lean')
 text=draft.read_text(encoding='utf-8')
 imports=text[:text.index('/-!')].strip()
 body=text[text.index('open MeasureTheory'):text.index('\n#check')].strip()
 description=('/-!\n# '+title+'\n\n'+doc+'\n\nThis source correspondence for Chapter 1 equations (1.2)-(1.3) uses the\ninterpretation explicitly adopted by the user on 2026-09-08. The original\nsource leaves the nonsmooth profile class unspecified. The convention and\nsource ambiguity are recorded separately in\n\x60user-transport-interpretation-20260908.json\x60 in the Chapter 1 session\nartifacts; this theorem does not assert that the convention is explicit in\nthe printed source.\n-/')
 target=R/('ComputationalMathematics/Source/LeVeque/Chapter01/Equation'+eq+'SolutionDomains.lean')
 assert not target.exists();target.write_text(license+imports+'\n\n'+description+'\n\n'+body+'\n',encoding='utf-8',newline='\n')
 decl='NumStability.leveque01_equation'+eq+('_uniformTransportDomains' if eq=='02' else '_solutionDomains')
 files.append({'path':target.relative_to(R).as_posix(),'sha256':sha(target.read_bytes()),'declarations':[decl],'draft_sha256':sha(draft.read_bytes())})
draft=S/'discontinuity-general-foundation/RectangleMassDerivative.lean';raw=draft.read_text(encoding='utf-8')
pi=raw[raw.index('theorem ae_hasDerivAt_intervalIntegral_pi'):raw.index('theorem IsRectangleConservationLawSolution')].strip()
mass=raw[raw.index('theorem IsRectangleConservationLawSolution'):raw.index('\nend NumStability')].strip()
generic=[
 ('ComputationalMathematics/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiation.lean',
 ['Mathlib.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiationThm','Mathlib.MeasureTheory.SpecificCodomains.Pi','Mathlib.Analysis.Calculus.Deriv.Prod'],
 'Almost-everywhere differentiation of finite-vector interval integrals',
 'Scalar Lebesgue differentiation lifts coordinatewise to finite real vectors.\nThe exceptional null set is independent of the lower integration endpoint.',
 pi,'NumStability.ae_hasDerivAt_intervalIntegral_pi'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/TemporalDerivative.lean',
 ['ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle','ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation'],
 'Temporal mass derivatives from rectangle conservation',
 'For any finite real state space and flux, rectangle conservation gives the\nmass-rate identity almost everywhere in time on each fixed spatial interval.\nThe exceptional null set may depend on that spatial interval.',
 mass,'NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae')]
for path,imports,title,doc,body,decl in generic:
 target=R/path;assert not target.exists();target.parent.mkdir(parents=True,exist_ok=True)
 target.write_text(license+'\n'.join('import '+m for m in imports)+'\n\n/-!\n# '+title+'\n\n'+doc+'\n-/\n\nopen MeasureTheory Set Filter\nopen scoped Topology\n\nnamespace NumStability\n\n'+body+'\n\nend NumStability\n',encoding='utf-8',newline='\n')
 files.append({'path':path,'sha256':sha(target.read_bytes()),'declarations':[decl],'draft_sha256':sha(draft.read_bytes())})
aggregates=[]
for path,mods in [
 ('ComputationalMathematics/Source/LeVeque/Chapter01.lean',[f['path'][:-5].replace('/','.') for f in files[:2]]),
 ('ComputationalMathematics/Analysis.lean',[files[3]['path'][:-5].replace('/','.')])]:
 target=R/path;before=target.read_bytes();lines=before.decode().splitlines();ids=[i for i,l in enumerate(lines) if l.startswith('import ')]
 assert ids==list(range(min(ids),max(ids)+1))
 imports={lines[i] for i in ids};assert all('import '+m not in imports for m in mods)
 lines[min(ids):max(ids)+1]=sorted(imports|{'import '+m for m in mods},key=str.casefold)
 target.write_text('\n'.join(lines)+'\n',encoding='utf-8',newline='\n')
 aggregates.append({'path':path,'before_sha256':sha(before),'sha256':sha(target.read_bytes())})
check=S/'interpreted-transport-production-checks.lean'
check.write_text('\n'.join('import '+f['path'][:-5].replace('/','.') for f in files)+'\n\n'+'\n'.join('#check '+d+'\n#print axioms '+d for f in files for d in f['declarations'])+'\n',encoding='utf-8',newline='\n')
record={'schema':1,'files':files,'aggregates':aggregates,'check_file_sha256':sha(check.read_bytes()),'user_interpretation_sha256':sha((S/'user-transport-interpretation-20260908.json').read_bytes()),'canonical_validation':'pending'}
(S/'interpreted-transport-production-inputs.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
paths=[f['path'] for f in files]+[a['path'] for a in aggregates]
subprocess.run(['git','-c','core.longpaths=true','add','--',*paths],cwd=R,check=True)
for path in paths:assert subprocess.check_output(['git','cat-file','blob',':'+path],cwd=R)==(R/path).read_bytes()
print(json.dumps({'placed':files,'exact_staged_bytes':True}))

