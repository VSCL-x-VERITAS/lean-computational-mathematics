"""Freeze a checked artifact-only geometry bridge and explicit reuse limits."""
from pathlib import Path
import hashlib, json

D = Path(__file__).resolve().parent
S = D.parent
R = S.parents[3]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
out = D / 'physical-capacity-line-bridge'
out.mkdir()
source = D / 'PhysicalCapacityBridge.lean'
native = S / 'unblock-nine-capacity-line-bridge-native-02-exit.json'
output = S / 'unblock-nine-capacity-line-bridge-native-02-output.txt'
record = json.loads(native.read_bytes())
assert record['exit_code'] == 0 and record['output_sha256'] == sha(output)
text = output.read_text(encoding='utf-8')
assert 'sorryAx' not in text and 'error:' not in text and 'warning:' not in text
names = ['capacity_pos', 'capacity_cell', 'advance_eq', 'projection_cell', 'advance_line_local', 'weighted_mass_balance']
for name in names:
    assert text.count("'PhysicalCapacityBridge." + name + "' depends on axioms:") == 1
assert text.count('depends on axioms:') == len(names)
frozen = out / 'PhysicalCapacityBridge.lean'
with frozen.open('xb') as f:
    f.write(source.read_bytes())
owners = ['CoordinateLineMethod', 'FinitePhysicalGeometry', 'FinitePhysicalUpdate', 'CellVolumeAverage', 'LocalFluxBalance', 'CoordinateLineBalance']
prefix = R / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
reuse = {
    'search_terms': ['capacity', 'advance_eq', 'cellVolume_smul_finiteVolumeCellAverageUpdate', 'finite_mass_balance'],
    'selected': ['LineCoordinates.lookup_cell', 'LineCoordinates.extract_cell', 'LineCoordinates.extract_local', 'PhysicalData.cellVolume_pos', 'FiniteCoordinate.advance', 'finiteVolumeCellAverageUpdate', 'FiniteCoordinate.finite_mass_balance'],
    'related_not_substitutable': {
        'LineRealization.advance_eq': 'Requires common line-area volume/flux factorization; this new bridge intentionally has no such premise.',
        'CoordinateLineBalance.advance': 'Already supports arbitrary supplied volumes on a full tensor index; it does not identify an arbitrary finite physical cell partition and guarded lookup with that same measured cell mean.'
    },
    'duplicate_avoidance': 'Reuse the existing extraction/locality and finite physical update/mass proofs. Only the physical-capacity lookup and supplied integrated line-flux correspondence are new.',
    'observed_source_owners': [ref(prefix / (name + '.lean')) for name in owners],
    'search_limit': 'Scoped current-library search and exact producer inspection; no global semantic-absence claim.',
}
with (out / 'reuse.json').open('xb') as f:
    f.write((json.dumps(reuse, indent=2) + '\n').encode())
review = '''# Physical-capacity bridge: artifact-only foundation

The checked theorem identifies the existing finite physical update with the actual supplied one-dimensional flux-difference update. At every active cell, its line capacity is exactly the positive measure of that physical cell, and its projected state is exactly the existing measured cell average. The face rule uses the supplied already-integrated numerical flux unchanged. Shared line/face indices connect the same two face values to the same cell. No linewide area factor, cell-width factorization, or inference about an integrated hyperbolic law is used.

The generic update is the existing finiteVolumeCellAverageUpdate. Weighted mass balance is a direct application of FiniteCoordinate.finite_mass_balance; extraction and locality reuse the existing LineCoordinates proofs. The theorem applies to arbitrary positive finite measured cell volumes satisfying the explicitly supplied line incidence/index map. The fallback capacity one is used only where the guarded lookup has no physical cell; no physical meaning or smooth projection is asserted there.

Native attempt 02 exited zero and checked all six theorem axiom lists with no warnings, errors, or sorryAx. Attempt 01 is retained with its exact source snapshot and actual failure: a split-branch binder named the equality instead of the cell. Its wrapper also encountered a terminal encoding error after writing the actual Lean failure receipt; attempt 02 used UTF-8 explicitly. Failed elaboration output is not accepted proof evidence.

This is not a source-faithfulness decision or a high-resolution construction. It does not establish order, oscillation bounds, admission of jump data, a refinement geometry, boundary projection accuracy, or availability of good solvers on every physical domain. It is the small exact operator/projection foundation on which those separate statements can be built. The finite physical error and chronological sweep APIs remain available for reuse.

No production source, compiled output, aggregate, gate, index, or Git reference was modified. This packet is a proposal; any future canonical placement needs organization and fresh checks for the final target and dependencies.
'''
with (out / 'REVIEW.md').open('xb') as f:
    f.write(review.encode())
manifest = {
    'format': 'physical-capacity-line-bridge-1', 'source': ref(frozen),
    'native': ref(native), 'native_output': ref(output), 'native_exit_code': 0,
    'theorems': ['PhysicalCapacityBridge.' + n for n in names],
    'failed_source': ref(D / 'PhysicalCapacityBridge.native-01.lean'),
    'failed_native': ref(S / 'unblock-nine-capacity-line-bridge-native-01-exit.json'),
    'reuse': ref(out / 'reuse.json'), 'review': ref(out / 'REVIEW.md'),
    'source_acceptance': False, 'production_placement': False,
    'scope': 'Same physical capacities, same measured active-cell projections, same supplied line numerical flux, exact operator equality, locality, and weighted mass balance.'
}
with (out / 'manifest.json').open('xb') as f:
    f.write((json.dumps(manifest, indent=2) + '\n').encode())
print(json.dumps({'manifest': ref(out / 'manifest.json'), 'source': ref(frozen), 'native_exit_code': 0}))
