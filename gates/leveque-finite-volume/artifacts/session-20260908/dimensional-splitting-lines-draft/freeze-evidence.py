"""Freeze scratch proof evidence and exact read-only source/reuse provenance."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,subprocess
assert os.name=='nt'
P=Path(__file__).resolve().parent; R=P.parents[4]; S=P.parent
def xp(p):
    p=str(p); prefix=chr(92)*2+'?'+chr(92)
    return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))
sha=lambda p:hashlib.sha256(xp(p).read_bytes()).hexdigest()
def record(p): return {'path':Path(p).relative_to(R).as_posix(),'sha256':sha(p)}
def write_new(name,obj):
    with (P/name).open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(obj,indent=2)+'\n')
assert not (P/'final-evidence.json').exists()
receipt=json.loads((P/'final-05-exit.json').read_bytes())
assert receipt['exit_code']==0
assert receipt['raw_output_sha256']==sha(P/'final-05-output.txt')
assert receipt['assembled_input_sha256']==sha(P/'final-05-input.lean')
assert receipt['input_files']=={n:sha(R/n) for n in receipt['input_files']}
output=(P/'final-05-output.txt').read_text(encoding='utf-8')
assert not re.search(r'\b(?:error|warning|sorryAx)\b',output)
axioms={name:sorted(x.strip() for x in body.split(',') if x.strip()) for name,body in
 re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",output,re.S)}
assert set(axioms)==set(receipt['checked_declarations'])
assert all(set(v)<={'propext','Classical.choice','Quot.sound'} for v in axioms.values())
assert not re.search(r'\b(sorry|admit|axiom|unsafe)\b',(P/'TensorLines.lean.fragment').read_text(encoding='utf-8'))

audit=S/'audits'/'LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908'
task=json.loads(xp(audit/'audit-task.json').read_bytes()); decision=audit/'faithfulness'/'decision.json'
assert sha(decision)=='f4bc6e665499951d8ddf5a80cba2f0c5ed5d548e97fef9fb9984a7b22012ccf8'
source=R/task['source']['path']; assert sha(source)==task['source']['sha256']
images=[]
for n,h in {27:'846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7',
28:'ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984'}.items():
    p=audit/'faithfulness'/'orchestration'/f'page-{n:03d}.png'; assert sha(p)==h
    images.append(record(p)|{'raw_page':n,'printed_page':n-22,'viewed':True})

base=S/'finite-volume-flux-error-estimate'/'combined-check.lean'
assert sha(base)=='e39e864134339eb5a6c639db0c995ffdf138b70cbebc407db72efd95c4afca22'
old=S/'finite-volume-flux-update-repair'/'candidate.lean'
assert sha(old)=='f90dbaa19d16da3617dac27e982557ebe501249afb03566b9bdb6b191ae935be'
oldreceipt=json.loads((S/'finite-volume-flux-update-repair'/'final-receipt.json').read_bytes())
basereceipt=json.loads((S/'finite-volume-flux-error-estimate'/'final-receipt.json').read_bytes())
assert oldreceipt['candidate']['sha256']==sha(old)
assert basereceipt['combined_check']['sha256']==sha(base)
assert old.read_bytes() in base.read_bytes()

queries=[
 ['rg','-n','coordinateLine|TensorGrid|tensorGrid|line_advance|directional.*flux|dimensionalSplitting|CoordinateSweepExecution|OneDimensionalHighResolution','ComputationalMathematics','--glob','*.lean'],
 ['rg','-n','coordinateLine|TensorGrid|tensorGrid|dimensionalSplitting|dimensional splitting','.lake/packages/mathlib/Mathlib','--glob','*.lean'],
 ['rg','-n','volume_pi_Ico_toReal|mul_prod_erase|update_idem|update_eq_self','.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean','.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean','.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean'],
 ['rg','-n','numericalUpdate_mass_balance|linearRule_eq_rectangle|selectedLinearFlux_eq_solver_average','gates/leveque-finite-volume/artifacts/session-20260908/finite-volume-flux-update-repair/candidate.lean','gates/leveque-finite-volume/artifacts/session-20260908/finite-volume-flux-error-estimate/solver-link-fragment.lean'],
 ['rg','-n','OneDimensionalFiniteVolumeGrid|riemannFiniteVolumeUpdate|adjacentCellRiemannProblem|CertifiedRectangleRiemannSolution|linearRectangleRiemannInterfaceFluxMethod|cellVolumeAverage_isCellVolumeAverage','ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume','--glob','*.lean']]
searches=[]
for i,command in enumerate(queries,1):
    result=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    assert result.returncode in (0,1)
    for suffix,raw in [('output.txt',result.stdout),('stderr.txt',result.stderr)]:
        with (P/f'search-{i}-{suffix}').open('xb') as f:f.write(raw)
    searches.append({'command':command,'cwd':str(R),'exit_code':result.returncode,
      'output':record(P/f'search-{i}-output.txt'),'stderr':record(P/f'search-{i}-stderr.txt')})

candidates=[
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/OperatorSplitting.lean',
  'CoordinateDirectionFamily, orderedOperatorSweep, coordinateFractionalSchedule, CoordinateSweepExecution',
  'Generic ordering/execution reused. Unrestricted old state maps are not used as directional solver semantics.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInterface.lean',
  'OneDimensionalFiniteVolumeGrid, OneDimensionalHyperbolicConservationLaw, adjacentCellRiemannProblem, riemannFiniteVolumeUpdate',
  'Exact positive widths, linked physical flux/Jacobian, adjacent numerical states, and conservative update reused.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RectangleRiemannInterface.lean',
  'CertifiedRectangleRiemannSolution, RectangleRiemannInterfaceFluxMethod, rectangleRiemannInterfaceFlux',
  'Exact returned-solution certificate and interface execution reused; an explicit physical-trace link additionally required.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRectangleRiemannInterface.lean',
  'linearHyperbolicConservationLaw, linearRectangleRiemannInterfaceFluxMethod',
  'Exact total concrete linear solver supplies nonvacuity.'),
 ('ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean',
  'cellVolumeAverage, IsCellVolumeAverage, cellVolumeAverage_isCellVolumeAverage',
  'Exact normalized full-dimensional physical reference reused; numerical arrays remain independent.'),
 (old.relative_to(R).as_posix(),'FVFluxUpdateDraft.numericalUpdate_mass_balance',
  'Frozen native-checked width-weighted producer reused verbatim as dependency, no prior-file edits.'),
 (base.relative_to(R).as_posix(),'FVFluxEstimateDraft.linearRule, selectedLinearFlux_eq_solver_average',
  'Frozen selected-solver rule and actual positive-duration physical-flux average reused exactly.'),
 ('.lake/packages/mathlib/Mathlib/MeasureTheory/Measure/Lebesgue/Basic.lean','Real.volume_pi_Ico_toReal',
  'Exact Cartesian volume normalization reused.'),
 ('.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean','Function.update_eq_self, Function.update_idem',
  'Exact line restriction and base invariance reused.'),
 ('.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean','Finset.mul_prod_erase',
  'Exact cell-volume width/area factorization reused.')]
reuse={'schema':1,'contract':'Full-state tensor-grid updates restrict exactly to certified one-dimensional conservative face-flux updates and compose sequentially.',
 'searches':searches,'candidates':[record(R/p)|{'declarations':d,'disposition':s} for p,d,s in candidates],
 'new_producer_reason':'No exact tensor-line wrapper found in recorded searches; old OperatorSplitting maps lack actual directional flux semantics. Search absence is not asserted globally.',
 'navigation_note':'An initial guessed Mathlib Measure/Pi.lean path was absent; actual Cartesian volume facts were then resolved in Measure/Lebesgue/Basic.lean. Full final searches are preserved.'}
write_new('reuse-search.json',reuse)

modules=sorted(set(re.findall(r'^import (.+)$',(P/'final-05-input.lean').read_text(encoding='utf-8'),re.M)))
imports=[]
for module in modules:
    if module.startswith('Mathlib.'):
        sourcepath=R/'.lake/packages/mathlib'/(module.replace('.','/')+'.lean')
        compiled=R/'.lake/packages/mathlib/.lake/build/lib/lean'/(module.replace('.','/')+'.olean')
    else:
        sourcepath=R/(module.replace('.','/')+'.lean')
        compiled=R/'.lake/build/lib/lean'/(module.replace('.','/')+'.olean')
    assert xp(sourcepath).is_file() and xp(compiled).is_file()
    imports.append({'module':module,'source':record(sourcepath),'compiled':record(compiled)})
final={'schema':1,'status':'scratch-compiled-frozen','frozen_at_utc':datetime.now(timezone.utc).isoformat(),
 'scope':'Only dimensional-splitting-lines-draft writes. No production, gate, ledger, audit, Git index or commit changes. No semantic/model roles or subagents.',
 'source':record(source),'source_locations':task['source']['locations'],'viewed_images':images,
 'old_task':record(audit/'audit-task.json'),'old_decision':record(decision),'old_report':record(audit/'faithfulness'/'report.md'),
 'draft':record(P/'TensorLines.lean.fragment'),'native_input':record(P/'final-05-input.lean'),
 'native_output':record(P/'final-05-output.txt'),'native_exit':record(P/'final-05-exit.json'),
 'actual_exit_code':0,'checked_declarations':axioms,'direct_imports':imports,
 'frozen_dependencies':[record(old),record(base),record(S/'finite-volume-flux-update-repair'/'final-receipt.json'),record(S/'finite-volume-flux-error-estimate'/'final-receipt.json')],
 'reuse_record':record(P/'reuse-search.json'),'review':record(P/'REVIEW.md'),
 'native_attempts':[record(p)|{'actual_exit_code':json.loads(p.read_bytes())['exit_code']} for p in sorted(P.glob('*-exit.json'))],
 'source_faithfulness':'Not audited or claimed. Cartesian tensor geometry and an exact-interface ordered sweep are explicit scoped foundations; logical rectangular geometry and the exhaustive high-resolution algorithm class remain unresolved. No user convention inferred.',
 'files':[record(p) for p in sorted(P.iterdir()) if p.is_file()]}
write_new('final-evidence.json',final)
print(json.dumps({'status':final['status'],'draft_sha256':sha(P/'TensorLines.lean.fragment'),
 'input_sha256':sha(P/'final-05-input.lean'),'output_sha256':sha(P/'final-05-output.txt'),
 'exit_sha256':sha(P/'final-05-exit.json'),'declarations':len(axioms),
 'evidence_sha256':sha(P/'final-evidence.json'),'reuse_sha256':sha(P/'reuse-search.json')}))
