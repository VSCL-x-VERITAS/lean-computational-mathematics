"""Freeze only after actual completed fixture evidence; never invokes preparation."""
from pathlib import Path
import hashlib
import json
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p / 'lean-toolchain').is_file())
D = P.parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
fixture = P / 'fixture-03/receipt.json'
outer = P / 'fixture-outer-03/receipt.json'
data = json.loads(fixture.read_bytes())
assert data['status'] == 'ACTUAL-POSIX-DIRECT-LEAN-FIXTURE-PASSED-NOT-AUDIT'
assert [r['actual_exit_code'] for r in data['actual_records']] == [0]*5
assert json.loads(outer.read_bytes())['actual_exit_code'] == 0
adapter = P / 'lean_runtime.py'
assert data['adapter'] == ref(adapter)
guards = P / 'guard-test-receipt.json'
g = json.loads(guards.read_bytes())
assert g['count'] == 12 and all(x['pass'] for x in g['checks']) and g['adapter_sha256'] == sha(adapter)
descriptor = P / 'runtime-descriptor-v3.json'
desc = json.loads(descriptor.read_bytes())
assert len(desc['expected_compiles']) == 42 and len(desc['artifacts']) == 9547
capture = R / desc['environment_capture']['path']
assert ref(capture) == desc['environment_capture']
environment = [ref(adapter), ref(descriptor), ref(capture), ref(fixture), ref(outer), ref(guards),
    ref(D / 'physical-dim-overlay-diagnostic/closure01/receipt.json'),
    ref(D / 'physical-dim-overlay-diagnostic/overlay01/receipt.json'),
    ref(D / 'physical-failed-preparation-module-order.json'), ref(R / '.lake/packages/mathlib/lakefile.lean')]
extension = {'format': 'exact-package-command-extension-1',
    'task_id': 'LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908',
    'row_id': 'LEV-CH01-DIMENSIONAL-SPLITTING',
    'target_file': 'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean',
    'target_declaration': 'NumStability.leveque01_coordinateHighResolutionMethods_sourceContract',
    'command': ['python3', '-B', adapter.relative_to(R).as_posix(), '--descriptor', descriptor.relative_to(R).as_posix(), '--descriptor-sha256', sha(descriptor)],
    'adapter': ref(adapter), 'descriptor': ref(descriptor), 'environment_files': environment}
extension_path = P / 'compiler-command-extension.json'
with extension_path.open('x', encoding='utf-8') as f:
    f.write(json.dumps(extension, indent=2)+'\n')
review = '''CURRENT SUPPORTED RUNTIME PROPOSAL — NOT AN AUDIT RESULT

The unchanged released preparer may select this supported lean.command. It retains the original source snapshot bytes, module order, dossier program and validator. Only the two exact mirrored Mathlib source hashes receive the three ordinary options read from the pinned Mathlib lakefile. Other source and dossier arguments are forwarded to the pinned native Lean executable.

Initialization obtains the real canonical Lake environment through a small pinned native Python capture, publishing compiler-path variables only. The adapter puts the converted native temporary root first. Lake's recorded final caller POSIX path tail remains as observed; it is not used as evidence for resolution. The temporary basename must have the released formalization-faithfulness- prefix. All 9,547 original closure artifacts and all 42 source inputs are checked once at initialization and once after the final dossier. Per-call tool, source, order, output and state checks remain mandatory.

Complete temporary Mathlib/project package overlays avoid Lean's package-prefix partial-root failure. Initial artifacts are hardlinks. Each output and all its artifact siblings are detached before compilation; original caches are never compiler output paths. The exact released scanner orders Defs before its public FTaylorSeries import, so Defs initially imports the pinned cached FTaylorSeries. This is not a cache-free topological rebuild. Fresh FTaylorSeries is subsequently required. The final dossier requires every expected fresh compilation and unchanged fresh output hashes. Earlier unchanged-dossier negative shadow tests fail on either missing fresh Mathlib module, establishing the overlay route rather than relying on successful compilation alone.

The actual POSIX fixture exercised --version, Defs, FTaylorSeries, the consumer and unchanged dossier, all exit 0. Final closure checks passed. The fixture has three compile inputs, not the official 42; it does not claim that the new official preparation has run. Twelve pure safety checks and four fixture guards passed. Native execution receipts are written before postchecks; postcheck receipts separately preserve validation success or failure.

Historical failed attempts remain: initial wrong-cwd assertion occurred before any compiler; fixtures 01 and 02 failed in native-Lake-to-POSIX-Python capture before compilation. Native Python capture resolved that transport failure without altering source or compiler semantics. The empty environment-failure-stdout.private.txt remains private and requires exact publication exclusion.

Root review, coherent new helper pins and actual released preparation are still required. No source acceptance, INFO authority, gate closure or publication is asserted.
'''
(P/'RUNTIME-REVIEW.md').write_text(review, encoding='utf-8')
files = [adapter, descriptor, capture, fixture, outer, guards, extension_path, P/'RUNTIME-REVIEW.md',
         P/'test_guards.py', P/'test_runtime03.py', P/'run_fixture03.py', P/'freeze_runtime.py']
for directory in ['fixture-01','fixture-02','fixture-03','fixture-outer-01','fixture-outer-02','fixture-outer-03']:
    files.extend(p for p in (P/directory).rglob('*') if p.is_file())
files = sorted(set(files))
manifest = {'status': 'SUPPORTED-COMMAND-PROPOSAL-REVIEW-ONLY', 'files': [ref(p) for p in files],
    'private_exclusions': [{'path': (P/'environment-failure-stdout.private.txt').relative_to(R).as_posix(), 'reason': 'Private diagnostic capture; do not publish even when empty.'}],
    'compiled_outputs': 'Ignored .lake/formalization-faithfulness-runtime-fixture03; binaries not published.',
    'extension': ref(extension_path), 'official_preparation_run': False}
with (P/'runtime-manifest.json').open('x', encoding='utf-8') as f:
    f.write(json.dumps(manifest, indent=2)+'\n')
receipt = {'status': manifest['status'], 'manifest': ref(P/'runtime-manifest.json'), 'extension': ref(extension_path),
    'fixture': ref(fixture), 'outer': ref(outer), 'adapter': ref(adapter), 'descriptor': ref(descriptor),
    'actual_fixture_exit_codes': [0]*5, 'guard_count': 16, 'official_preparation_run': False}
with (P/'runtime-receipt.json').open('x', encoding='utf-8') as f:
    f.write(json.dumps(receipt, indent=2)+'\n')
print(json.dumps(ref(P/'runtime-receipt.json')))
