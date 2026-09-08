"""Freeze actual native results and exact six-leaf placement; no source edits."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess,sys
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def record(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p),'bytes':p.stat().st_size}
def git(*args):return subprocess.check_output(['git','-c','core.longpaths=true',*args],cwd=R)
initial=json.loads((P/'initial-placement.json').read_bytes())
mapping=json.loads((P/'comparison-inputs.json').read_bytes())
modules=[x['module'] for x in initial['created']]
allowed={'propext','Classical.choice','Quot.sound'}
def axioms(path):
 text=path.read_text(encoding='utf-8')
 assert not re.search(r'\b(?:sorryAx|warning:|error:|declaration uses .sorry.)',text),text
 out={}
 for name,terms in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",text):
  terms=[x.strip() for x in terms.split(',') if x.strip()];assert set(terms)<=allowed,(name,terms)
  assert name not in out;out[name]=terms
 for name in re.findall(r"'([^']+)' does not depend on any axioms",text):
  assert name not in out;out[name]=[]
 return out
checks=axioms(P/'declarations01-output.txt')
assert set(checks)==set(mapping['canonical_declarations']),(len(checks),len(mapping['canonical_declarations']))
comparison_axioms=axioms(P/'comparisons01-output.txt')
expected={f'NumStability.JumpBalancePlacementCheck.identity_{i:02d}' for i in range(1,25)}
expected|={'NumStability.JumpBalancePlacementCheck.'+x for x in ['interface_alias','interface_discontinuity','riemann_pair','local_medium_bundle','stationary_step_alias','stationary_step_integrability']}
assert set(comparison_axioms)==expected
receipts=[]
for label in ['build01','declarations01','comparisons01']:
 path=P/(label+'-exit.json');r=json.loads(path.read_bytes());assert r['exit_code']==0
 assert r['output_sha256']==sha(P/(label+'-output.txt'))
 for p,h in r['input_sha256'].items():assert sha(R/p)==h,(p,h)
 receipts.append({'receipt':record(path),'raw_output':record(P/(label+'-output.txt')),'result':r})
files=[];direct={}
for item in initial['created']:
 p=R/item['path'];text=p.read_text(encoding='utf-8');assert sha(p)==item['initial_sha256']
 assert '\r' not in p.read_bytes().decode()
 code=re.sub(r'/-[\s\S]*?-/', '', text)
 assert not re.search(r'\b(?:sorry|admit|axiom)\b',code)
 assert not git('ls-tree','--name-only',initial['input_commit'],'--',item['path']).strip()
 imports=re.findall(r'^import (\S+)',text,re.M)
 assert imports==sorted(imports)
 if item['module']=='ComputationalMathematics.Topology.Order.Jump':assert all(x.startswith('Mathlib.Topology.') for x in imports)
 if item['module'].endswith('.ConservationLaws.RectangleBalance'):assert imports==['ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle']
 files.append({**record(p),'module':item['module'],'direct_imports':imports,
  'compiled':record(R/'.lake/build/lib/lean'/(item['module'].replace('.','/')+'.olean'))})
 for m in imports:
  if m.startswith('Mathlib.'):
   src=R/'.lake/packages/mathlib'/(m.replace('.','/')+'.lean')
   ole=R/'.lake/packages/mathlib/.lake/build/lib/lean'/(m.replace('.','/')+'.olean')
  else:
   src=R/(m.replace('.','/')+'.lean');ole=R/'.lake/build/lib/lean'/(m.replace('.','/')+'.olean')
  direct[m]={'module':m,'source':record(src),'compiled':record(ole)}
searches=[('new-producer-inventory',['rg','-n',r'^(def HasJumpAt|def IsRectangleBalanceLawSolution)','ComputationalMathematics']),
 ('existing-reuse',['rg','-n',r'theorem (IsRiemannData\.(tendsto_left|tendsto_right)|riemannData_intervalIntegrable|ae_hasDerivAt_intervalIntegral_pi)|def IsBalanceLawSolutionAt',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataRegularity.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean',
 'ComputationalMathematics/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiation.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/BalanceLaw.lean']),
 ('mathlib-jump-predicate',['rg','-n',r'HasJumpAt|JumpDiscontinu|jump_discontinu','.lake/packages/mathlib/Mathlib/Topology','.lake/packages/mathlib/Mathlib/Analysis','-g','*.lean']),
 ('mathlib-reuse',['rg','-n',r'theorem (Filter.Tendsto\.(fst_nhds|snd_nhds|prodMk_nhds)|tendsto_nhds_unique |LocallyIntegrable.ae_hasDerivAt_integral)',
 '.lake/packages/mathlib/Mathlib/Topology/Constructions/SumProd.lean',
 '.lake/packages/mathlib/Mathlib/Topology/Separation/Hausdorff.lean',
 '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiationThm.lean'])]
search_records=[]
for label,cmd in searches:
 out=P/(label+'.stdout.txt');err=P/(label+'.stderr.txt')
 assert not out.exists() and not err.exists()
 r=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert r.returncode==(1 if label=='mathlib-jump-predicate' else 0),(label,r.returncode)
 out.write_bytes(r.stdout);err.write_bytes(r.stderr)
 search_records.append({'label':label,'command':cmd,'cwd':str(R),'exit_code':r.returncode,'stdout':record(out),'stderr':record(err)})
frozen=[]
for rel,h in initial['frozen_inputs'].items():
 p=S/rel;assert sha(p)==h;frozen.append(record(p))
old_owners=[
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataRegularity.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/Riemann.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/BalanceLaw.lean',
 'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/TemporalDerivative.lean',
 'ComputationalMathematics/Source/LeVeque/Chapter01/MaterialInterfaceRiemannData.lean',
 'ComputationalMathematics/Source/LeVeque/Chapter01/NonconservationSourceTerms.lean']
for p in old_owners:assert hashlib.sha256(git('show',initial['input_commit']+':'+p)).hexdigest()==sha(R/p)
lean_version=subprocess.check_output(['C:/Users/qed_s/.elan/bin/lean.exe','--version'],cwd=R)
(P/'native-version.txt').write_bytes(lean_version)
mathlib=git('-C','.lake/packages/mathlib','rev-parse','HEAD').decode().strip()
assert mathlib=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
result={'kind':'six-leaf-jump-balance-generic-production-placement','frozen_at_utc':datetime.now(timezone.utc).isoformat(),
 'input_commit':initial['input_commit'],'head_at_freeze':git('rev-parse','HEAD').decode().strip(),
 'scope':'Six new canonical leaves plus this evidence directory only. No source wrapper, existing declaration owner, aggregate, tier, gate, ledger, audit or Git edits.',
 'source_faithfulness_verdict':None,'frozen_drafts':frozen,'canonical_files':files,'direct_dependencies':list(direct.values()),
 'native_receipts':receipts,'canonical_axiom_checks':checks,'comparison_axiom_checks':comparison_axioms,
 'comparisons':mapping,'reuse_searches':search_records,'existing_owners_unchanged':[record(R/p) for p in old_owners],
 'native_version':record(P/'native-version.txt'),'mathlib_revision':mathlib,
 'decisions':[
 'HasJumpAt is a real-domain topology predicate with arbitrary topological codomain; T2Space remains explicit only for noncontinuity.',
 'No PDE import enters topology core. Product-trace equivalence retains both inequalities.',
 'IsRiemannData.hasJumpAt reuses the existing trace producers; no duplicate trace or integrability proof is added.',
 'HasMaterialStateInterfaceAt and its conjunction wrappers are not promoted. Six compiled bridges retain the omitted conveniences only in comparison evidence.',
 'RectangleBalance has only the existing Rectangle import. Its finite-vector a.e. derivative reuses the existing interval-integral differentiation producer in a separate leaf.',
 'Linear-amplitude results and explicit signed nonsmooth examples are isolated. stationaryStep and its integrability alias are eliminated in favor of riemannData and its existing integrability theorem.',
 'No source-facing interpretation or acceptance is inferred. The local-medium bundle is checked only as a scratch reconstruction and is not a canonical source certificate.'],
 'limits':[
 'The canonical equalities compare definition meaning and theorem types under unfolding and Lean proof irrelevance; they do not claim identical proof syntax or full normalization fingerprints.',
 'The mass-derivative exceptional set may depend on each fixed spatial interval; finite real vectors are retained.',
 'Ordinary locally integrable source fields and autonomous fluxes are retained; no measure-valued source, constitutive law, physical material domain, or solution classification is added.']}
dest=P/'placement-manifest.json';assert not dest.exists()
dest.write_bytes((json.dumps(result,indent=2)+'\n').encode())
print(json.dumps({'manifest':str(dest),'sha256':sha(dest),'canonical_files':len(files),'canonical_declarations':len(checks),
 'comparison_checks':len(comparison_axioms),'all_native_exits': [r['result']['exit_code'] for r in receipts]}))
