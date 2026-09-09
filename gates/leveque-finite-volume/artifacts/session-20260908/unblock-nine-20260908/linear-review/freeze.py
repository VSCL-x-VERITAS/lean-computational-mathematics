from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re
P=Path(__file__).resolve().parent;S=P.parents[1];R=S.parents[3]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
def write(name,v):
 p=P/name;assert not p.exists();p.write_bytes(((json.dumps(v,indent=2)+'\n') if not isinstance(v,str) else v).encode());return p
plan=json.loads((P/'native-plan.json').read_bytes());native=json.loads((P/'check-01-receipt.json').read_bytes());build=json.loads((P/'build-01-receipt.json').read_bytes())
assert native['exit_code']==build['exit_code']==0 and native['inputs_unchanged'] and build['inputs_unchanged']
pins={}
for v in [build,native]:
 for name,h in v['input_files'].items():assert sha(R/name)==h,name;pins[name]=h
 assert sha(R/v['output']['path'])==v['output']['sha256']
raw=(R/native['output']['path']).read_text(encoding='utf-8');assert not re.search(r'error:|warning:|sorryAx|Error pretty printing',raw)
pattern=r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)"
reports=[dict(declaration=m.group(1),axioms=[a.strip() for a in (m.group(2) or '').split(',') if a.strip()]) for m in re.finditer(pattern,raw,re.S)]
assert len(reports)==len(plan['expected_axiom_declarations'])==40
assert {r['declaration'] for r in reports}==set(plan['expected_axiom_declarations'])
for r in reports:assert set(r['axioms'])<={'propext','Classical.choice','Quot.sound'}
for f in plan['files']:
 p=R/f['path'];assert sha(p)==f['sha256'];assert b'\r' not in p.read_bytes()
 assert not re.search(rb'\b(sorry|admit|axiom)\b',p.read_bytes())
left=(R/plan['frozen_left']['path']).read_bytes();riemann=(R/plan['frozen_riemann']['path']).read_bytes();checks=(P/'check-01-input.lean').read_bytes()
assert checks.count(left)==1
span=plan['riemann_span'];assert riemann[span['byte_start']:span['byte_end']]==(R/span['path']).read_bytes()
assert checks.count((R/span['path']).read_bytes())==1
review=write('IMPLEMENTATION.md','''The two new source wrappers are complete and native-checked. The existing EigenvaluePropagation target and all older source declarations remain unchanged. The detailed source conventions are coordinator selections under the user's goal, bound by selected-interpretations.json; they are not represented as literal detailed user replies or facts stated explicitly by the book.

AcousticsLeftSolutionDomains preserves the frozen positive-physical-parameter composition verbatim in meaning: actual acoustic invariant equation, arbitrary geometric profiles, differentiable classical iff, and locally interval-integrable rectangle iff. Actual system and independently quantified profile remain distinct. The printed w2/q2 switch remains disclosed.

RiemannProblemDataClassification uses Fin(m+1), the actual principal/residual equation, the broad and distinct-jump data predicates, and the canonical fromStates constructor for the same governing equation. Its equal and unequal cases preserve an arbitrary origin value. Equal side states are not claimed to make the value at zero equal to those states; no solution-existence or solution-regularity claim is added. It does not replace a governing equation with an arbitrary predicate or restrict the representation to conservation laws.

The focused build passed. The complete check preserves the full frozen LEFT candidate bytes, including its independent nonconstant acoustic and nonsmooth-profile fixtures, and the exact positive-dimensional/equal-distinct/scalar-fixture span from the frozen RIEMANN capstone. Two native rfl comparisons verify full declaration type and proof-value equality with those frozen compositions (theorem proof irrelevance applies). Concrete target applications use the actual acoustic fixture and scalar unequal/equal initial data with an independent origin value 7. The unchanged complete EIGEN target is also checked. All 40 expected named axiom reports occur exactly once and use only propext, Classical.choice and Quot.sound; no warning, error or sorryAx occurs.

The initial review capture helper used an incorrect repository-parent index and failed before producing its receipt; its exact script is retained as capture-review-attempt01.py. The corrected helper verified 75 review pins. No Lean proof/build attempt failed. Native commands, full raw outputs, actual exits, source snapshots and pre/post source/compiled dependency hashes are retained. The source review and producer map are not an independent faithfulness audit.

Root next owns aggregate/tier exposure, organization/checkpoint work, and fresh independently judged tasks. Suggested fresh targets are the two new declarations and the unchanged complete EIGEN declaration, each with the appropriate Q3/Q4/Q9 qualification. Preserve all prior nonaccepted decisions. Include the exact native real-measure supplement for LEFT's rectangle branch; do not send source or interpretation material to the blind translator. No new audit role, gate/ledger edit, aggregate/tier change or Git operation was performed here.
''')
mapping=write('producer-map.json',dict(schema=1,files=plan['files'],source_interpretations=bind(S/'unblock-nine-20260908/selected-interpretations.json'),rows=[dict(row_id='LEV-CH01-ACOUSTICS-LEFT-MODE',choice='Q3',target=plan['files'][0],status='new-source-wrapper-native-checked',faithfulness_action='new-audit-required',frozen_composition=plan['frozen_left'],nonvacuity=['NumStability.LeftModeAlternativeEvidence.acoustic_nonvacuity','NumStability.LeftModeAlternativeEvidence.nonsmooth_profile_nonvacuity'],required_supplement='Exact native Real.measureSpace/volume normalization evidence for rectangle conservation'),dict(row_id='LEV-CH01-RIEMANN-INITIAL-VALUE-DEFINITION',choice='Q9',target=plan['files'][1],status='new-source-wrapper-native-checked',faithfulness_action='new-audit-required',frozen_composition=plan['frozen_riemann'],nonvacuity=['NumStability.ProspectiveSourceAlternatives.scalar_problem_fixture']),dict(row_id='LEV-CH01-EIGENVALUES-WAVE-SPEEDS',choice='Q4',target=plan['files'][2],status='existing-target-unchanged-native-checked',faithfulness_action='new-audit-required',required_mathematical_changes=[])],new_reusable_producer_required=False,old_apis_preserved=True,source_acceptance=False))
axioms=write('axiom-verification.json',dict(schema=1,status='PASS',output=native['output'],expected=plan['expected_axiom_declarations'],reports=reports))
artifacts=[bind(p) for p in sorted(P.rglob('*')) if p.is_file() and p.name not in ['manifest.json','final-receipt.json','verification.json']]
manifest=write('manifest.json',dict(schema=1,status='PASS',source_acceptance=False,files=plan['files'],review=bind(P/'review-before-implementation.json'),producer_map=bind(mapping),implementation=bind(review),build=bind(P/'build-01-receipt.json'),check=bind(P/'check-01-receipt.json'),native_output=native['output'],axiom_verification=bind(axioms),exact_comparisons=plan['comparisons'],input_files=pins,artifact_files=artifacts,new_audit_roles_run=False,git_operations=False,scope='Only the two new canonical source files and this review directory. Root owns all exposure, gate, ledger, audit and Git work.'))
receipt=write('final-receipt.json',dict(schema=1,status='PASS',created_utc=datetime.now(timezone.utc).isoformat(),manifest=bind(manifest),producer_map=bind(mapping),native_build_exit=0,native_check_exit=0,axiom_reports=40,new_public_source_declarations=2,unchanged_eigen_target=True,inputs_unchanged=True,source_acceptance=False,outputs=[build['output'],native['output']]))
print(json.dumps(dict(manifest=bind(manifest),receipt=bind(receipt),producer_map=bind(mapping),files=plan['files'])))
