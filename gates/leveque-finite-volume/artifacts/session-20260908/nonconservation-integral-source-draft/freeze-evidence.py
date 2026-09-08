"""Read-only provenance checks; writes only this task's final evidence records."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,subprocess
assert os.name=='nt'
P=Path(__file__).resolve().parent; R=P.parents[4]; S=P.parent
def xp(p):
    p=str(p); prefix=chr(92)*2+'?'+chr(92)
    return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))
sha=lambda p:hashlib.sha256(xp(p).read_bytes()).hexdigest()
def rel(p): return Path(p).relative_to(R).as_posix()
def record(p): return {'path':rel(p),'sha256':sha(p)}
def write_new(name,obj):
    with (P/name).open('x',encoding='utf-8',newline='') as f: f.write(json.dumps(obj,indent=2)+'\n')
assert not (P/'final-evidence.json').exists()
receipt=json.loads((P/'final-03-exit.json').read_bytes())
assert receipt['exit_code']==0
assert receipt['raw_output_sha256']==sha(P/'final-03-output.txt')
assert receipt['assembled_input_sha256']==sha(P/'final-03-input.lean')
assert receipt['input_files']=={n:sha(P/n) for n in receipt['input_files']}
output=(P/'final-03-output.txt').read_text(encoding='utf-8')
assert not re.search(r'\b(?:error|warning|sorryAx)\b',output)
axioms={name:sorted(x.strip() for x in body.split(',') if x.strip()) for name,body in
 re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",output,re.S)}
assert set(axioms)==set(receipt['checked_declarations'])
assert all(set(v)<={'propext','Classical.choice','Quot.sound'} for v in axioms.values())
for name in receipt['input_files']:
    assert not re.search(r'\b(sorry|admit|axiom|unsafe)\b',(P/name).read_text(encoding='utf-8'))

audit=S/'audits'/'LEV-CH01-NONCONSERVATION-SOURCE-TERMS-PRODUCTION-20260908'
decision=audit/'faithfulness'/'decision.json'
assert sha(decision)=='c48f5b9e8e6121f618e8f54292a56c4f7f3daad9df513794a904bdfb2abaefe3'
task=json.loads(xp(audit/'audit-task.json').read_bytes())
source=R/task['source']['path']; assert sha(source)==task['source']['sha256']
image_hashes={26:'c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d',
 27:'846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7'}
images=[]
for n,h in image_hashes.items():
    p=audit/'faithfulness'/'orchestration'/f'page-{n:03d}.png'
    assert sha(p)==h
    images.append(record(p)|{'raw_page':n,'printed_page':n-22,'viewed':True})

queries=[
 ['rg','-n','RectangleBalance|IsBalanceLawSolution|integral_internalProduction|source_integral|net production|nonconservation_requires','ComputationalMathematics','--glob','*.lean'],
 ['rg','-n','RectangleBalance|BalanceLaw|balance law|internal production|conservation law','.lake/packages/mathlib/Mathlib','--glob','*.lean'],
 ['rg','-n','integral_smul|integral_const|integral_congr|theorem integral_add','.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean'],
 ['rg','-n','riemannData_intervalIntegrable|not_continuousAt_zero|ae_hasDerivAt_intervalIntegral_pi','ComputationalMathematics/Analysis/PartialDifferentialEquations','ComputationalMathematics/MeasureTheory','--glob','*.lean']]
searches=[]
for i,command in enumerate(queries,1):
    result=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    assert result.returncode in (0,1)
    for suffix,raw in [('output.txt',result.stdout),('stderr.txt',result.stderr)]:
        with (P/f'search-{i}-{suffix}').open('xb') as f:f.write(raw)
    searches.append({'command':command,'cwd':str(R),'exit_code':result.returncode,
      'output':record(P/f'search-{i}-output.txt'),'stderr':record(P/f'search-{i}-stderr.txt')})

candidates=[
 {'path':'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean',
  'declarations':['IsRectangleConservationLawSolution'],'disposition':'Exact homogeneous predicate reused, including finite-mass and boundary-flux integrability.'},
 {'path':'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/BalanceLaw.lean',
  'declarations':['IsBalanceLawSolutionAt','nonconservation_requires_nonzero_source','integral_any_source_eq_massDefect'],
  'disposition':'Existing actual classical source relation reused in the constructed-family bridge. Earlier classical residual necessity is retained, but its old qx/interchange domain is not substituted for rectangle balance.'},
 {'path':'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean',
  'declarations':['riemannData_intervalIntegrable'],'disposition':'Exact local interval integrability of the step reused.'},
 {'path':'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataRegularity.lean',
  'declarations':['IsRiemannData.not_continuousAt_zero'],'disposition':'Actual strict-trace discontinuity reused.'},
 {'path':'ComputationalMathematics/MeasureTheory/Integral/IntervalIntegral/LebesgueDifferentiation.lean',
  'declarations':['ae_hasDerivAt_intervalIntegral_pi'],'disposition':'Exact finite-vector a.e. derivative of indefinite integrals reused.'},
 {'path':'.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean',
  'declarations':['intervalIntegral.integral_add','intervalIntegral.integral_smul','intervalIntegral.integral_const','intervalIntegral.integral_congr'],
  'disposition':'Exact integral algebra and actual interval constant normalization used.'},
 {'path':'.lake/packages/mathlib/Mathlib/Analysis/Calculus/Deriv/Mul.lean',
  'declarations':['HasDerivAt.smul_const','HasDerivAt.const_mul'],
  'disposition':'Exact temporal derivatives of the constructed amplitude used.'}]
for c in candidates:c['sha256']=sha(R/c['path'])
reuse={'schema':1,'contract':'Rectangle mass difference equals integrated boundary exchange plus integrated spatial production; no spatial derivative and no source sign.',
 'searches':searches,'candidates':candidates,
 'new_producer_reason':'No exact balance-with-production predicate found in the recorded searches. Existing classical necessity has a narrower applicability contract. This does not claim global semantic absence.',
 'search_notes':'Initial navigation included an overly broad theorem-source pattern with irrelevant other-book matches. The final exact patterns above scope the material mathematical candidates and preserve full raw output.'}
write_new('reuse-search.json',reuse)

imports=[]
for line in (P/'RectangleBalance.lean').read_text(encoding='utf-8').splitlines():
    if line.startswith('import '):
        mod=line[len('import '):]; path=R/(mod.replace('.','/')+'.lean')
        olean=R/'.lake/build/lib/lean'/(mod.replace('.','/')+'.olean')
        assert path.is_file() and olean.is_file()
        imports.append({'module':mod,'source':record(path),'compiled':record(olean)})
attempts=[]
for path in sorted(P.glob('*-exit.json')):
    r=json.loads(path.read_bytes()); attempts.append(record(path)|{'actual_exit_code':r['exit_code']})
final={'schema':1,'status':'scratch-compiled-frozen','frozen_at_utc':datetime.now(timezone.utc).isoformat(),
 'scope':'Writes only nonconservation-integral-source-draft. No production, gate, ledger, sealed audit, index or commit changes. No model role or subagent invocation.',
 'source':record(source),'source_locations':task['source']['locations'],'viewed_source_images':images,
 'prior_task':record(audit/'audit-task.json'),'prior_decision':record(decision),'prior_report':record(audit/'faithfulness'/'report.md'),
 'generic_draft':record(P/'RectangleBalance.lean'),'wrapper_proposal':record(P/'SourceWrapperProposal.lean.fragment'),
 'native_input':record(P/'final-03-input.lean'),'native_output':record(P/'final-03-output.txt'),
 'native_exit':record(P/'final-03-exit.json'),'actual_exit_code':0,'checked_declarations':axioms,
 'direct_imports':imports,'reuse_record':record(P/'reuse-search.json'),'review':record(P/'REVIEW.md'),
 'native_attempts':attempts,
 'remaining_source_scope':'No user interpretation was inferred. Source does not exhaustively specify nonconservative model classes or precise temporal semantics at every nonsmooth event. The rectangle/source-density convention is explicit and awaits independent task review; source-faithfulness is not claimed.',
 'measure_evidence':'Selected real volume and native interval constant algebra are used. A future fresh audit may bind the previously compiled exact native measure supplement; this does not alter the old sealed evidence gap.',
 'files':[record(p) for p in sorted(P.iterdir()) if p.is_file()]}
write_new('final-evidence.json',final)
print(json.dumps({'status':final['status'],'generic_sha256':sha(P/'RectangleBalance.lean'),
 'wrapper_sha256':sha(P/'SourceWrapperProposal.lean.fragment'),'native_input_sha256':sha(P/'final-03-input.lean'),
 'native_output_sha256':sha(P/'final-03-output.txt'),'native_exit_sha256':sha(P/'final-03-exit.json'),
 'declarations':len(axioms),'evidence_sha256':sha(P/'final-evidence.json'),'reuse_sha256':sha(P/'reuse-search.json')}))
