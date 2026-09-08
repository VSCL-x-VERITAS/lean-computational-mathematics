from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,sys
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
label=sys.argv[1]
assert re.fullmatch('[a-z0-9-]+',label)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
def write(name,value):
 p=P/name;assert not p.exists(),p
 p.write_bytes(((json.dumps(value,indent=2)+'\n') if not isinstance(value,str) else value).encode())
 return p
native=P/(label+'-receipt.json');v=json.loads(native.read_bytes())
assert v['exit_code']==0 and v['inputs_unchanged']
for name,h in v['input_files'].items():assert sha(R/name)==h,name
out=P/(label+'-output.txt');assert sha(out)==v['output_sha256']
raw=out.read_text(encoding='utf-8')
assert not re.search(r'error:|warning:|sorryAx|Error pretty printing',raw)
pattern=r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)"
reports=[]
allowed={'propext','Classical.choice','Quot.sound'}
for match in re.finditer(pattern,raw,re.S):
 axioms=[a.strip() for a in (match.group(2) or '').split(',') if a.strip()]
 assert set(axioms)<=allowed,(match.group(1),axioms)
 reports.append(dict(declaration=match.group(1),axioms=axioms))
assert len(reports)==199,len(reports)
assert len({x['declaration'] for x in reports})==199
plan=json.loads((P/'placement-map.json').read_bytes());comparison=json.loads((P/'comparison-plan-04.json').read_bytes())
authored=[n for f in plan['files'] for n in f['declarations']]
assert len(authored)==41
expected=authored+[c['name'] for c in comparison['comparisons']]+comparison['support_declarations']
assert len(expected)==83 and set(expected)<={x['declaration'] for x in reports}
frozen=S/'information-coordinate-sweep-draft/full04-input.lean'
assert (P/(label+'-input.lean')).read_bytes().count(frozen.read_bytes())==1
decl=json.loads((P/'declarations-01-receipt.json').read_bytes());build=json.loads((P/'build-02-receipt.json').read_bytes())
assert decl['exit_code']==build['exit_code']==0 and decl['inputs_unchanged'] and build['inputs_unchanged']
for attempt in [decl,build]:
 for name,h in attempt['input_files'].items():assert sha(R/name)==h,name
for name,h in decl['compiled_production'].items():assert sha(R/name)==h,name
assert sha(P/'declarations-01-output.txt')==decl['output_sha256']
assert sha(P/'build-02-output.txt')==build['output_sha256']
files=[]
for f in plan['files']:
 p=R/f['path'];data=p.read_bytes()
 assert b'\r' not in data and data.endswith(b'\n')
 assert not re.search(rb'\b(sorry|admit|axiom)\b',data)
 files.append(dict(path=f['path'],module=f['module'],sha256=sha(p),declarations=f['declarations'],lines=len(data.decode().splitlines())))
inventory=write('normalized-files.json',dict(schema=1,files=files,authored_public_declaration_count=41))
axioms=write('axiom-verification.json',dict(schema=1,status='PASS',output=bind(out),reports=reports,total=199,production=41,comparisons=41,transport_support=1,inherited=116,allowed_axioms=sorted(allowed)))
comparison_validation=write('comparison-verification.json',dict(schema=1,status='PASS',plan=bind(P/'comparison-plan-04.json'),native_receipt=bind(native),native_output=bind(out),comparisons=comparison['comparisons'],support=comparison['support_declarations'],definitional_type_value_comparisons=35,inductive_predicate_function_equalities=1,heterogeneous_proof_comparisons_after_type_transport=5,note='The immutable preparation plan records validation pending at preparation time; this actual zero-exit receipt supplies its final validation.'))
review='''# Information coordinate production placement

The five new leaves contain 41 authored public declarations. They compose the existing information-only Riemann method with the existing coordinate-line update and ordered sweep executors. No old owner, source wrapper, aggregate, tier, gate, ledger, audit or Git object was changed by this placement.

`RiemannInformationCoordinateUpdate` binds the actual ordered neighboring states to the selected method result and its extraction. The arbitrary off-domain extension is a device for the existing total executor: every operational result assumes actual face or stage admission, and the face/update observations are proved independent of the extension. Positive supplied volumes yield the existing cell and finite-line shared-face mass balances. No returned field, exact solution, trace-integrability condition, total solver or accuracy assumption is introduced.

`RiemannInformationCoordinateSweep` requires admission on each actual preceding output. It preserves the existing ordered sweep, proves fallback independence and admission at arbitrary executed prefixes, and gives the two-stage mass balance. Locality continues to come from `CoordinateLineBalance.advance_line_local` and the existing sweep producers; no forwarding locality alias is placed.

`CartesianGridGeometry` takes a direct family of existing `OneDimensionalFiniteVolumeGrid` axes. Product cell volume and transverse face area are tied to Lebesgue measures by `Real.volume_pi_Ico_toReal`; shared faces retain their actual normal and transverse coordinates. The old frozen `TensorGrid` also contains a directions field. Every old geometry observation is compared at its actual `grid.axis` projection. No nominal grid equality, reverse reconstruction of that unused field, or choice of logical geometry is asserted.

`CartesianCoordinateUpdate` weights an arbitrary full-line numerical-flux rule by measured face area, proving that the actual Cartesian line restriction is the existing one-dimensional finite-volume update. This supplies a consumer for arbitrary externally supplied full-line processing. Admitted information-method specialization uses the same selected result and flux, and gives the measured cell balance. The full-line theorem does not assert consistency, accuracy, convergence, or implement reconstruction. The fallback rescaling used by the generic correspondence is valid because Cartesian face area is positive; admission ensures that fallback does not supply an operational observation.

`Examples.LeftStateCoordinateSweep` reuses the existing ordered-pair information method and unit-speed hyperbolic law. Two positive unit steps in distinct directions have different concrete cell outputs on the exact frozen stripe state. The witness has no space-time field and proves finite-step nonvacuity only. No duplicate scalar hyperbolicity helper, method-family alias, stripe alias, cell alias or line alias is placed.

The original placement map, build-01 snapshots and failure output are retained. The initial consumer translation needed parentheses around axis-family applications and removal of an obsolete local-line simplification; build-02 passed. The first comparison run incorrectly requested definitional equality for the two separately recursive sweep predicates. Its source and failure output are retained. The second run established the inductive predicate bridge but left the five heterogeneous theorem-type comparisons with unaligned polymorphic universe levels or unreduced aliases. The third run passed all 199 checks but reported comparison-only tactic warnings; the fourth removes the unreachable tactic and redundant sequence operators. The final run explicitly aligns the levels and reduces aliases after transport. It proves predicate function equality by induction on the ordered stage list, then transports the five affected theorem types explicitly and proves heterogeneous proof equality. The other 35 comparisons use native definitional type/value equality (proof irrelevance for theorem values). Thus no nominal or recursive definitional equality is claimed where only a compiled propositional bridge is established.

The final focused run includes the byte-exact complete frozen scratch input once, 41 production declaration/axiom checks, 41 preservation comparisons and one transport helper: 199 reports total including 116 inherited checks. Native exit is zero, there are no warnings or errors, and only `propext`, `Classical.choice` and `Quot.sound` occur. The run hashes the recursive project source/compiled import closure, direct Mathlib source/compiled boundaries, pinned toolchain/Mathlib revision and frozen prior native input receipts before and after execution. This is focused placement/type preservation, not a global build or final source audit.

The full-field specialization remains explicit in the unchanged frozen `FieldSpecialization.lean.fragment`, through the canonical `RiemannInformationFluxMethod.ofField` adapter. The new coordinate definitions compare to the information scratch definitions, so that checked specialization remains transportable without adding field assumptions to the new core. The old total exact time-one `TensorLinesDraft.LineSolver` is not placed. General logical geometry (Q10), conditional finite-volume accuracy (Q7), and source-wrapper selection remain separate pending interpretation/integration work. This packet claims reusable mathematical placement only and no source acceptance or local/global exhaustion.
'''
review_path=write('REVIEW.md',review)
commands=write('commands.json',dict(schema=1,build=build['command'],declarations=decl['command'],final=v['command'],cwd=v['cwd'],prepare_helpers=['place.py','repair-consumer-02.py','prepare-comparisons.py','prepare-comparisons-02.py','prepare-comparisons-03.py','prepare-comparisons-04.py'],runners=['run.py','run-preservation.py','run-preservation-03.py','run-preservation-04.py'],note='Do not rerun labels or one-shot placement helpers; artifacts are immutable. Root owns aggregate exposure and broad organization/build checks.'))
artifacts=[bind(p) for p in sorted(P.rglob('*')) if p.is_file() and p.name not in ['manifest.json','final-receipt.json','verification.json']]
manifest=write('manifest.json',dict(schema=1,status='PASS',source_acceptance=False,selected_source_target=False,files=files,normalized_inventory=bind(inventory),native_receipt=bind(native),native_output=bind(out),complete_input=bind(P/(label+'-input.lean')),frozen_input=bind(frozen),comparison_plan=bind(P/'comparison-plan-04.json'),comparison_validation=bind(comparison_validation),production_contracts=bind(P/'declarations-01-output.txt'),axioms=bind(axioms),review=bind(review_path),commands=bind(commands),reuse_review=bind(P/'reuse-review.json'),artifact_files=artifacts,dependency_pins=v['input_files'],scope='Only the five listed new canonical leaves and this new evidence folder; existing owners unchanged. Root must independently review before exposure.'))
final=write('final-receipt.json',dict(schema=1,status='PASS',completed_at_utc=datetime.now(timezone.utc).isoformat(),source_acceptance=False,manifest=bind(manifest),inventory=bind(inventory),native_receipt=bind(native),native_output=bind(out),complete_input=bind(P/(label+'-input.lean')),native_exit=0,inputs_unchanged=True,authored_public_declarations=41,comparison_declarations=41,transport_support_declarations=1,all_axiom_reports=199,review=bind(review_path)))
print(json.dumps(dict(manifest_sha256=sha(manifest),final_receipt_sha256=sha(final),inventory_sha256=sha(inventory),native_output_sha256=sha(out))))
