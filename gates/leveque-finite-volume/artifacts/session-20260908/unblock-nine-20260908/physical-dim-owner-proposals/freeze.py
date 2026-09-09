"""Verify and freeze proposal-only owner snapshots; no production or Lean execution."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import re

R = Path(r'C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
P = R / 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/physical-dim-owner-proposals'
A = P / 'attempt-05'


def native(path):
    return '\\?\\' + str(path) if str(path).startswith('\\') else '\\\\?\\' + str(path)


def raw(path):
    with open(native(path), 'rb') as stream:
        return stream.read()


def ref(path):
    content = raw(path)
    return {'path': path.relative_to(R).as_posix(),
            'sha256': hashlib.sha256(content).hexdigest(), 'bytes': len(content)}


def write(path, value):
    content = value.encode('utf-8') if isinstance(value, str) else (
        json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode('utf-8')
    with open(native(path), 'xb') as stream:
        stream.write(content)
    return ref(path)


mapping = json.loads(raw(A / 'mapping.json'))
owners = {item['module']: item for item in mapping['files']}
pending = set(owners)
order = []
while pending:
    ready = sorted((module for module in pending
                    if not set(owners[module]['imports']) & pending), key=str.casefold)
    assert ready, 'Internal import cycle'
    order.extend(ready)
    pending.difference_update(ready)

for owner in owners.values():
    content = raw(R / owner['proposed']['path'])
    assert hashlib.sha256(content).hexdigest() == owner['proposed']['sha256']
    assert b'\r' not in content
    for token in ('CapacityZeroFlux', 'CapacitySmallBias', 'CapacityGhost',
                  'CapacityNetReferenceError', 'PhysicalCapacityBridge',
                  'CapacityPhysicalMesh', 'CapacityBoundarySweep',
                  'RefiningCartesianWitness', 'ZeroPhysicalRefinementWitness'):
        assert not re.search(r'(?<![\w.])' + token + r'(?!\w)', content.decode()), (owner['module'], token)

refs = mapping['input_files'] + [mapping['approved_plan'], mapping['final_admitted_receipt'],
    mapping['five_owner_regularity_group']['placement_receipt']]
refs.extend(item['file'] for item in json.loads(raw(A / 'direct-imports.json'))['imports'])
for item in refs:
    assert ref(R / item['path'])['sha256'] == item['sha256'], item['path']

preparation = json.loads(raw(P / 'prepare-05-exit.json'))
assert preparation['actual_exit'] == 0
assert ref(P / 'prepare-v5.py')['sha256'] == preparation['script_sha256']
assert ref(P / 'prepare-05-output.txt')['sha256'] == preparation['stdout_sha256']
assert ref(P / 'prepare-05-stderr.txt')['sha256'] == preparation['stderr_sha256']

verification = write(P / 'verification.json', {
    'schema': 1, 'status': 'PASS: proposal source bindings and static placement guards only',
    'mapping': ref(A / 'mapping.json'), 'actual_preparation': ref(P / 'prepare-05-exit.json'),
    'input_reference_occurrences_verified': len(refs),
    'unique_input_paths': len({item['path'] for item in refs}),
    'owners': len(owners), 'new_leaves': sum(item['change'] == 'new' for item in owners.values()),
    'lines': sum(item['lines'] for item in owners.values()),
    'new_leaf_authored_declarations': sum(len(item['declarations']) for item in owners.values()
                                          if item['change'] == 'new'),
    'all_snapshot_authored_declarations': sum(len(item['declarations']) for item in owners.values()),
    'recommended_build_order': order,
    'build_order_scope': 'Topological order for explicit edges among these 16 owners; Lake must also rebuild their existing dependencies and consumers.',
    'native_lean_run': False, 'production_written': False, 'source_acceptance': False,
    'verified_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat()})

inventory = write(P / 'proposed-files.json', {
    'schema': 1, 'status': 'PROPOSED; native placement/checks pending',
    'files': [{'path': item['target_path'], 'module': item['module'],
               'sha256': item['proposed']['sha256'], 'proposal': item['proposed'],
               'lines': item['lines'], 'declarations': item['declarations'],
               'exports': item['exports'], 'change': item['change'], 'role': item['role']}
              for item in mapping['files']]})

rows = '\n'.join('| ' + '/'.join(item['target_path'].split('/')[-2:]) + ' | ' +
    str(item['lines']) + ' | ' + str(len(item['declarations'])) + ' | ' + item['change'] + ' |'
    for item in mapping['files'])
review = write(P / 'REVIEW.md', '''# Physical DIM owner proposals

The final proposal is `attempt-05/proposed/`, with exact original-span and namespace mappings in `attempt-05/mapping.json`. It contains twelve new leaves, three changed mathematical owners, and one materially changed source owner. Production has not been written by this task. Native Lean elaboration and nominal transport remain root-owned and pending; the actual exit 0 recorded here is the artifact preparation script, not a Lean build.

The approved twelve-leaf map is retained. Five existing `NumStability.FiniteCoordinate.LineCoordinates` declarations move unchanged to `FiniteLineCoordinates`; the old two consumers import/reuse those same names. `PhysicalLineCapacity` uses actual measured cell volume and already integrated face flux. `CapacityCoordinateMethod` separates time-step admission and optional same-step stability. Only the stage-dependent sweep is extracted, avoiding a duplicate fixed-coordinate recursion. `PhysicalCellMesh` uses actual metric diameters, independently of capacities. `CoordinateLineVariation` is the single once-edge producer; the physical-family variation is a transparent specialization with the same finite-cell instance and supplied ghosts.

`PhysicalRefinementQuality` directly imports the upstream `Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries` owner and keeps genuine inner-infinity C∞, fixed law/measure/state data, actual measured projections, positive step availability, uniform constants before all later levels and admitted steps, and quantitative oscillation. Pairwise stability remains separate. The two zero-flux physical mean/face lemmas are sufficient for the generic zero-quality proofs; no zero-method alias or optional small-bias algorithm was added. Cartesian geometry and boundary regions are example owners; the full zero-flux family includes a genuine spatially nonconstant reference. The full source application remains a separate artifact.

The source replacement comes from the successful admitted successor, including `ValidSubsteps` and `admitted_specification`. It retains the same source theorem name with a materially different type. No equivalence to the old rejected source contract is asserted. Its assumptions are supplied measured directional balances; tensor/normal data do not establish continuum PDE equivalence. No universal geometry construction, integrated-flux hyperbolicity, or composite high temporal order is inferred.

| Owner suffix | Lines | Authored declarations | Change |
|---|---:|---:|---|
''' + rows + '''

The 149 declarations in new leaves include the five unchanged moved declarations. There are 169 declarations across all sixteen complete snapshots, including retained declarations in changed owners. Static inventories count explicit authored declarations, not automatically generated structure projections/recursors. The proposed-files inventory includes every explicit name and kind.

The mapping records simultaneous token/namespace substitutions and exact source-span hashes. It separately records the shared variation specialization and removal of one unused `SequentialError` namespace opening from the minimal method owner. New namespaces are `NumStability.FiniteCoordinate.PhysicalLine`, `NumStability.CapacityCoordinate` (with `Sweep`), `NumStability.PhysicalRefinementQuality`, `NumStability.PhysicalHighResolutionSweep`, `NumStability.RefiningCartesianGrid`, and `NumStability.ZeroFluxCartesianRefinement`. Mesh and variation declarations use their existing mathematical type namespaces. The generic constant-flux hyperbolicity proof is added to the current canonical hyperbolicity owner with explicit upstream derivative/basis imports.

All input and direct-import source bindings were reread. Direct-import provenance distinguishes proposal snapshots, current production sources, and pinned Mathlib sources; it is not a compiled dependency closure. Root's separate five-owner C∞/choice placement receipt is pinned. Those intentional current-source changes do not relabel any historical native receipt or old audit. Every earlier proposal attempt remains untouched: attempt 01 stopped on a nonunique source anchor; attempt 02 on a Windows long-path existence check; attempt 03 on the English word “admit” in a documentation comment. Attempts 04 and 05 passed static preparation. Actual output/exit sidecars for 02–05 are retained; 01 has the observed-failure record and partial generated files.

Root's remaining checks are native focused builds, all explicit declaration/axiom checks, unchanged-name/type checks for the five moved declarations and retained old owners, explicit field maps/round trips and commuting observations for renamed nominal structures, transparent variation reduction, and the full joint source application. The source theorem deliberately requires a fresh audit. No source acceptance, gate closure, publication, or complete import compatibility is certified by this proposal packet.
''')

artifacts = []
for folder, directories, files in os.walk(native(P)):
    directories[:] = sorted(name for name in directories if name != '__pycache__')
    for name in sorted(files):
        path = Path(folder.removeprefix('\\\\?\\')) / name
        if path.name not in {'manifest.json', 'receipt.json'}:
            artifacts.append(ref(path))
manifest = write(P / 'manifest.json', {'schema': 1,
    'scope': 'Append-only proposal snapshots and observed preparation attempts; no native Lean claims',
    'artifacts': artifacts})
receipt = write(P / 'receipt.json', {'schema': 1,
    'status': 'FROZEN PROPOSAL; root native placement and comparison pending',
    'mapping': ref(A / 'mapping.json'), 'proposed_files': inventory,
    'review': review, 'verification': verification, 'manifest': manifest,
    'actual_preparation_exit': 0, 'native_lean_run': False,
    'production_written': False, 'source_acceptance': False})
print(json.dumps({'receipt': receipt, 'mapping': ref(A / 'mapping.json'),
                  'inventory': inventory, 'review': review, 'verification': verification,
                  'manifest': manifest}, indent=2))
