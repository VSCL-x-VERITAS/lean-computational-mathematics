from pathlib import Path
import hashlib,json,re,subprocess
P=Path(__file__).resolve().parent;R=P.parents[5]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
rec=json.loads((P/'native02-receipt.json').read_bytes());assert rec['actual_exit_code']==0 and rec['dependencies_unchanged']
assert sha(R/rec['output']['path'])==rec['output']['sha256']
for x in rec['dependencies']: assert sha(R/x['path'])==x['sha256'],x['path']
out=(P/'native02-output.txt').read_text(encoding='utf-8-sig')
assert not re.search(r'error:|error\(|warning:|sorryAx',out)
names=json.loads((P/'declarations.json').read_bytes())
reports=re.findall(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",out,re.S)
assert len(reports)==len(names)==12
for name,ax in reports:assert set(x.strip() for x in ax.split(',') if x.strip())<={'propext','Classical.choice','Quot.sound'}
assert (P/'Check.lean').read_bytes()==(P/'native02-Check.lean').read_bytes()
review='''# Broader directional contract readiness

The main contract now omits exact constant-flux consistency. The remaining physical data, positive-dimensional state, positive admitted schedule, actual independent physical references, old-average and face-flux input errors, conservative prefix execution, line locality and conditional measured Cartesian realization are unchanged. The proof reuses the canonical balance, locality, error and Cartesian producers.

Exact consistency remains an optional observation theorem. `original_contract_recovered` reconstructs the entire old contract from the broader result plus its former consistency premise; its type and proof equal the old theorem by a compiled `rfl` comparison. No source judgment is inferred from that comparison.

The real-interval example uses the existing physical partition, actual shared endpoints with Dirac point-face measure, identity hyperbolic physical flux and nonconstant transported-step reference. Its numerical rule adds the fixed vector one to every left-state flux. It is provably not exactly consistent at the admitted zero state. The shared bias cancels in each flux difference, so every finite sweep equals the earlier nonconstant upwind sweep. The full broader conjunction is instantiated with actual input-residual bounds, never an output-error certificate. This proves strict generality with nonzero physical flux and positive state dimension.

The selected printed page 6 and recorded Q10 specify successive coordinate problems and the logical-grid/physical-volume convention, not the extra exact equal-state identity. This is a mathematical readiness repair, not an audit verdict. The existing source task and every prior role remain unchanged. No new interpretation is selected here.

Search/reuse: the current canonical `CoordinateLineBalance.advance_mass_balance`, `finite_line_mass_balance`, `advance_line_local`, `sweep_cons`, `DirectionalFiniteVolume.advance_error_le`, `cartesian_reference`, `CartesianCoordinateUpdate.cartesian_full_line_update` and `PhysicalIntervalSweep` already supply all geometry, integration and execution foundations. Shared additive bias cancellation is the only new generic algebra observation; it is a direct simplification of the existing executor and does not reprove integral basics. The currently developing LocalRiemannRoutine is not imported. Pinned Mathlib group simplification supplies cancellation.

Native01 is retained as a failed attempt: its generic mathematics checked, but nested witness notation was ambiguous. Native02 resolves only the witness type spelling and exits zero with twelve exact declaration/axiom reports and only the three allowed axioms. The source context remains raw26–28 of the pinned package; no external source was used.
'''
(P/'REVIEW.md').write_text(review,encoding='utf-8',newline='\n')
source_names=['selected-interpretations.json','dimensional-method-audit-preparation/source-context.json','dimensional-method-audit-preparation/page-028.png']
pins=[ref(P.parent/x) for x in source_names]
pins.append(ref(R/'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateDirectionalMethods.lean'))
(P/'source-and-reuse-pins.json').write_text(json.dumps({'files':pins,'native_dependencies':rec['dependencies'],'role_observation':'At read boundary only source_contract and blind_translation existed; no unfinished judge result was consumed.'},indent=2)+'\n',encoding='utf-8')
(P/'manifest.json').write_text(json.dumps({'files':[ref(f) for f in sorted(P.iterdir()) if f.is_file()]},indent=2)+'\n',encoding='utf-8')
(P/'final-receipt.json').write_text(json.dumps({'status':'native-checked-readiness-not-audit-verdict','manifest':ref(P/'manifest.json'),'native':ref(P/'native02-receipt.json'),'candidate':ref(P/'Candidate.lean'),'reports':12,'allowed_axioms':['propext','Classical.choice','Quot.sound'],'failed_attempts_retained':['native01']},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt':ref(P/'final-receipt.json'),'candidate':ref(P/'Candidate.lean')},indent=2))
