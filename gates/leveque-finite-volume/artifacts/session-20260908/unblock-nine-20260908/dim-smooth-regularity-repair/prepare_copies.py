"""Artifact-only C-infinity proposal and exact scoped dependency diagnosis."""
import hashlib,json,re
from pathlib import Path
P=Path(__file__).resolve().parent;D=P.parent;R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
def sha(b):return hashlib.sha256(b).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p.read_bytes())}
def read(p):return json.loads(p.read_bytes())
def put(p,b):
 p.parent.mkdir(parents=True,exist_ok=True)
 with p.open('xb') as f:f.write(b)
def save(n,v):put(P/n,(json.dumps(v,indent=2,ensure_ascii=True)+'\n').encode())
invpath=D/'directional-high-resolution-production/production-files-frozen.json';inv=read(invpath)
changes=[];texts={};imports={}
pattern=re.compile(r'\bContDiff(?:On|At|WithinAt)? ℝ ⊤')
for item in inv['files']:
 path=R/item['path'];raw=path.read_bytes();assert sha(raw)==item['sha256'];text=raw.decode()
 texts[item['module']]=text;imports[item['module']]=re.findall(r'^import\s+(\S+)',text,re.M)
 found=[{'line':text[:m.start()].count('\n')+1,'before':m.group(),'after':m.group().replace('ℝ ⊤','ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)')} for m in pattern.finditer(text)]
 if found:
  before=P/'before'/item['path'];after=P/'proposed'/item['path']
  put(before,raw);put(after,pattern.sub(lambda m:m.group().replace('ℝ ⊤','ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)'),text).encode())
  changes.append({'owner':ref(path),'before':ref(before),'proposed':ref(after),'edits':found,'proof_tactics_changed':False})
modules={x['module'] for x in inv['files']};direct={x['owner']['path'][:-5].replace('/','.') for x in changes};affected=set(direct)
while True:
 more={m for m in modules if set(imports[m])&affected};new=affected|more
 if new==affected:break
 affected=new
fp=D/'dim-high-resolution-fingerprints/additional-expression-fingerprints.json';records=read(fp)['records']
seeds={
 'NumStability.LocalConservationLaw.SmoothReferenceOn','NumStability.LocalConservationLaw.SpatialSmoothReferenceOn',
 'NumStability.LocalLinearAdvection.smooth_reference_interior','NumStability.LocalLinearAdvection.interior_partials_continuous',
 'NumStability.LocalLinearAdvection.interior_differentiableAt','NumStability.LocalLinearAdvection.interior_mass_derivative',
 'NumStability.CFLUnitShift.smoothProfile_smooth','NumStability.CFLUnitShift.smooth_refinement',
 'NumStability.HighResolutionAdvectionLine.smooth_local_reference'}
known={r['name'] for r in records};assert seeds<=known
deps={r['name']:set(re.findall(r'Lean\.Expr\.const `([^\s]+)',str(r.get('type',''))+' '+str(r.get('value',''))+' '+str(r.get('recursor_values',''))))&known for r in records}
expr=set(seeds)
while True:
 new=expr|{n for n in known if deps[n]&expr}
 if new==expr:break
 expr=new
save('impact.json',{'status':'PROPOSAL_ONLY','source_acceptance':False,'production_inventory':ref(invpath),'native_fingerprints':ref(fp),
 'regularity_edit':{'from':'(⊤ : WithTop ℕ∞) = ω','to':'((⊤ : ℕ∞) : WithTop ℕ∞) = ∞','all_direct_occurrences':sum(len(x['edits']) for x in changes)},
 'changes':changes,'all_16_owners':[{'owner':{'path':x['path'],'sha256':x['sha256']},'module':x['module'],'direct_edit':x['module'] in direct,'affected_import_closure':x['module'] in affected,'imports':imports[x['module']]} for x in inv['files']],
 'native_expression_direct_seeds':sorted(seeds),'native_expression_transitive_affected':sorted(expr),
 'expression_scope':'Existing 293 native constants only; exact explicit constant references in type/value/recursor expressions. Semantic dependency set, not a claim every stored structural hash will differ. Re-extract after native repair.',
 'all_16_need_current_build_closure':True})
# Recheck old local PDE/characteristic proofs in a fresh namespace. This is one
# scratch Lean file, not an owner rebuild or an operational audit supplement.
subset=['ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference',
        'ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection']
rename={'NumStability.LocalConservationLaw':'NumStability.DimSmoothRepair.LocalConservationLaw',
        'NumStability.LocalLinearAdvection':'NumStability.DimSmoothRepair.LocalLinearAdvection'}
imps=sorted(set(i for m in subset for i in imports[m]))
body=[]
for m in subset:
 t=pattern.sub(lambda x:x.group().replace('ℝ ⊤','ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)'),texts[m]);t=re.sub(r'^import\s+\S+\s*\n','',t,flags=re.M)
 for old,new in rename.items():t=t.replace(old,new)
 body.append(t)
extra='''
open scoped ContDiff
namespace NumStability.DimSmoothRepair
theorem outer_top_eq_omega : (⊤ : WithTop ℕ∞) = ω := rfl
theorem inner_top_eq_infty : ((⊤ : ℕ∞) : WithTop ℕ∞) = ∞ := rfl
theorem infty_lt_omega : (∞ : WithTop ℕ∞) < ω := WithTop.coe_lt_top _
theorem smooth_on_iff_all_finite (f : ℝ → ℝ) (s : Set ℝ) :
    ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) f s ↔ ∀ n : ℕ, ContDiffOn ℝ n f s :=
  contDiffOn_infty
theorem analytic_on_implies_smooth (f : ℝ → ℝ) (s : Set ℝ)
    (h : ContDiffOn ℝ (⊤ : WithTop ℕ∞) f s) :
    ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) f s := h.of_le le_top
end NumStability.DimSmoothRepair
#check contDiffOn_infty
#check contDiffOn_omega_iff_analyticOn
#check ContDiffOn.continuousOn_fderiv_of_isOpen
'''
names=['outer_top_eq_omega','inner_top_eq_infty','infty_lt_omega','smooth_on_iff_all_finite','analytic_on_implies_smooth']
names=['NumStability.DimSmoothRepair.'+n for n in names]
names+=['NumStability.DimSmoothRepair.LocalLinearAdvection.'+n for n in ['interior_partials_continuous','interior_differentiableAt','interior_mass_derivative','interior_classical','characteristic_propagation','local_cell_average_shift']]
extra+='\n'.join('#check '+n+'\n#print axioms '+n for n in names)+'\n'
put(P/'LocalSmoothProbe.lean',('\n'.join('import '+i for i in imps)+'\n\n'+'\n\n'.join(body)+extra).encode())
# Historical scratch search is scoped and only reports occurrences; frozen
# attempts are never rewritten or reclassified as repaired.
scratch=[]
for directory in D.iterdir():
 if not directory.is_dir() or directory==P or not any(s in directory.name for s in ['dim-cfl','local-smooth','dim-local','dim-quality','dim-joint','directional-reference','directional-high-resolution']):continue
 for q in directory.rglob('*'):
  if q.is_file() and q.suffix in ('.lean','.fragment'):
   t=q.read_text(encoding='utf-8'); hits=[n+1 for n,l in enumerate(t.splitlines()) if pattern.search(l)]
   if hits:scratch.append({'file':ref(q),'lines':hits})
save('historical-scratch-occurrences.json',{'scope':'Named relevant D directories, Lean/fragment text only; not an exhaustive repository absence claim. Frozen files retained unchanged.','files':scratch})
save('source-and-mathlib-pins.json',{'mathlib':[ref(R/'.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff'/n) for n in ['Defs.lean','FTaylorSeries.lean','Operations.lean']],
 'interpretations':[ref(D/'selected-interpretations.json'),ref(D/'user-high-resolution-interpretation-20260908.json'),ref(D/'directional-complete-repair-review/source-context-with-user-high-resolution-v2.json')],
 'reviewed_roundtrip':ref(S/'audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/faithfulness/orchestration/r_final.json') if (S:=D.parent) else None,
 'source_images':[ref(D/'dimensional-method-audit-preparation/page-028.png'),ref(D/'directional-complete-repair-review/page-125.png'),ref(D/'directional-complete-repair-review/page-126.png')]})
print(json.dumps({'direct_files':len(changes),'direct_occurrences':sum(len(x['edits']) for x in changes),'import_affected_owners':len(affected),'expression_affected_constants':len(expr),'historical_scratch_files':len(scratch),'probe_sha256':sha((P/'LocalSmoothProbe.lean').read_bytes())}))
