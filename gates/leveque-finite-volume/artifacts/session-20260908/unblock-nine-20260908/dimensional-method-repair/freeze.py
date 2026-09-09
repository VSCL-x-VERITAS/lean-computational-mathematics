"""Freeze exact scratch evidence after actual native success; no audit action."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent
R=next(x for x in P.parents if (x/'lean-toolchain').exists())
S=R/'gates/leveque-finite-volume/artifacts/session-20260908'
D=S/'unblock-nine-20260908'
A=S/'audits/LEV-CH01-COORDINATE-SPLITTING-INTERPRETED-PRODUCTION-20260908'
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
ref=lambda f:dict(path=f.relative_to(R).as_posix(),sha256=sha(f))
read=lambda f:json.loads(f.read_text(encoding='utf-8-sig'))
def new(name,value):
 f=P/name
 with f.open('x',encoding='utf-8',newline='\n') as stream:stream.write(json.dumps(value,indent=2)+'\n')
 return ref(f)
native=read(P/'final-native-receipt.json')
assert native['actual_exit_code']==0 and type(native['actual_exit_code']) is int
assert native['checks_passed'] and native['inputs_preserved'] and native['dependencies_post_equal']
for item in [native['candidate'],native['checks'],native['exact_native_input'],native['output'],native['runner'],*native['dependencies_pre']]:
 assert sha(R/item['path'])==item['sha256'],item
assert len(native['declaration_reports'])==15 and all(x['allowed'] for x in native['declaration_reports'])
assert sha(A/'faithfulness/decision.json')=='4dde8fca096bef0991e92c33df868619b73962d1b03c589e02175a70ac26f568'
assert sha(D/'selected-interpretations.json')=='cfde240a9dda9a58be99f85369b43e99003b0024c7147a33ffa8b071ca7dcf34'
task=read(A/'audit-task.json')
assert sha(R/task['source']['path'])==task['source']['sha256']
assert sha(R/task['target']['path'])=='97243527d30b5e798ec00646a7eb12ec0a5ab0c068e77d5ed7dd2dcd57c63445'
pins=[ref(D/'selected-interpretations.json'),ref(A/'audit-task.json'),ref(A/'faithfulness/decision.json'),
 ref(A/'faithfulness/report.md'),ref(A/'faithfulness/inputs/declaration_dossier.md'),
 ref(A/'faithfulness/orchestration/page-028.png'),ref(R/task['source']['path']),ref(R/task['target']['path']),
 ref(D/'coordinate-splitting-audit-spec.json'),
 ref(D/'numerics-audit-preparation/dimensional-companion-environment-packet.json')]
for name in ('CoordinateLineBalance','CoordinateLineSweep','CartesianCoordinateUpdate','CartesianGridGeometry',
             'FluxUpdateError','FluxUpdateErrorBounds','LocalFluxBalance','CellAverage','CellVolumeAverage',
             'RiemannInformationFluxMethod','RiemannInformationFluxError'):
 pins.append(ref(R/f'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/{name}.lean'))
for name in ('MeasureTheory/Integral/IntervalIntegral/Basic','Analysis/Normed/Group/Basic','Data/ENNReal/Real'):
 pins.append(ref(R/f'.lake/packages/mathlib/Mathlib/{name}.lean'))
selection=read(D/'selected-interpretations.json')
decls=[x['name'] for x in native['declaration_reports'] if x['name'].startswith('NumStability.DirectionalMethodRepair.')]
files=[ref(f) for f in sorted(P.iterdir()) if f.is_file() and f.name not in ('manifest.json','final-receipt.json')]
manifest=new('manifest.json',{
 'format':'substantive-directional-method-scratch-repair-1',
 'status':'FROZEN-SCRATCH-NATIVE-VERIFIED-NOT-AUDITED',
 'candidate':ref(P/'Candidate.lean'),'primary':'NumStability.DirectionalMethodRepair.directional_splitting_contract',
 'authored_declarations_checked':decls,'reused_witness_checked':'NumStability.LeftStateCoordinateSweep.left_two_stage_nonvacuity',
 'native':ref(P/'final-native-receipt.json'),'review':ref(P/'REVIEW.md'),'files':files,'review_inputs':pins,
 'original_Q10':next(x for x in selection['choices'] if x['choice_id']=='Q10'),
 'prior_decision':{'accepted':False,'classification':'undetermined','lean_implies_source':'no','source_implies_lean':'unclear'},
 'preservation':{'source_sha256':task['source']['sha256'],'old_target_sha256':sha(R/task['target']['path']),
                 'original_audit_unchanged':True,'interpretation_receipt_unchanged':True},
 'substantive_new_linkage':['actual scoped hyperbolic physical normal flux integrated over supplied shared faces',
  'independent finite-substep physical cell/flux balance with existing normalized cell averages',
  'actual intermediate-state admission and state-domain membership',
  'constant consistency only for admitted positive-step constant inputs',
  'computed numerical update error from old/face input errors; no output-error premise',
  'same-executor Cartesian line realization and rectangle-PDE reference bridge'],
 'limits':['no finite/periodic boundary-extension coverage theorem',
  'no inferred chart/normal or arbitrary facePoint identification',
  'no complete PhysicalData Cartesian constructor or simultaneous full-primary nonvacuity witness',
  'no high-resolution/convergence/unconditional accuracy or full multidimensional evolution theorem',
  'no source acceptance, production placement, gate/ledger/ref/commit changes or semantic role'],
})
receipt=new('final-receipt.json',{
 'status':'FROZEN-SCRATCH-CANDIDATE','candidate':ref(P/'Candidate.lean'),'manifest':manifest,
 'review':ref(P/'REVIEW.md'),'native_receipt':ref(P/'final-native-receipt.json'),
 'actual_native_exit':0,'exact_declarations_checked':len(native['declaration_reports']),
 'authored_checked':len(decls),'allowed_axioms_only':True,'input_and_dependency_hashes_rechecked':True,
 'source_acceptance':False,'production_changed':False,'gate_or_audit_changed':False,
 'remaining_work':'Root review of exact applicability, optional full physical-realization witness, canonical placement and fresh independent audit.',
})
print(json.dumps({'candidate':ref(P/'Candidate.lean'),'manifest':manifest,'receipt':receipt},indent=2))
