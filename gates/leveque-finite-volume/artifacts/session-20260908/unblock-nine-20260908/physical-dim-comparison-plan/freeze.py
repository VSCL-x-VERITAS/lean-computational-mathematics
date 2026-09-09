"""Freeze a bounded comparison plan. Pure filesystem; no Lean/Git/gate actions."""
from pathlib import Path
import hashlib
import json
from datetime import datetime, timezone

HERE = Path(__file__).resolve().parent
D = HERE.parent
R = D.parents[4]

def long(p):
    return Path('\\\\?\\' + str(p.resolve()))

def read(p):
    return long(p).read_bytes()

def digest(data):
    return hashlib.sha256(data).hexdigest()

def pin(rel, expected=None):
    p = D / rel
    data = read(p)
    sha = digest(data)
    if expected is not None:
        assert sha == expected, (rel, sha, expected)
    return {'path': str(p.relative_to(R)).replace('\\', '/'), 'sha256': sha, 'bytes': len(data)}

def create(name, obj):
    p = HERE / name
    assert not long(p).exists(), f'refuse overwrite: {p}'
    data = (json.dumps(obj, ensure_ascii=False, indent=2) + '\n').encode()
    long(p).write_bytes(data)
    return {'path': str(p.relative_to(R)).replace('\\', '/'), 'sha256': digest(data), 'bytes': len(data)}

checked = [
 ('physical-dim-promotion-review/mapping.json', '37d6e19cca93d27e70267ed2702ea11a6e53af907256f8c418b7299cf0b20a4b'),
 ('physical-refinement-quality-draft/native-02/Candidate.lean', 'c2b8d278def563d0e181536f745a18e5e461b7a595089bc639c87c736aee7415'),
 ('physical-zero-quality-draft/native-01/Candidate.lean', 'f368d77ab6d81cda6e964a8d127fb276a5ae40cb723f2957c0e5ee36917873af'),
 ('physical-high-resolution-sweep-draft/native-03/Candidate.lean', '73daca68c54303af3d73dd4916b2792b33b44c0b258e8c136ae95cc82525304e'),
 ('physical-admitted-high-resolution-sweep/native-01/Candidate.lean', 'eb6aa5a41ea1abd167458966052144d6d4f5ee076d442c39f578681c9b3881bc'),
 ('physical-admitted-high-resolution-sweep/Admitted.lean.fragment', '03c64cec39d5524374b65ff9d5a6d01afdf360abfbb6b685763aa5a70bf384e1'),
 ('physical-admitted-high-resolution-sweep/SourceTarget.lean.fragment', 'bd33a9b4db94efe7f5021a7e9d682528e239560298ec09413b58bd0282e0646c'),
 ('physical-refinement-cartesian-witness/Candidate.lean', '1175232570694d374b25fbc1924070aac56b39a4af876d9276f3945f7d596945'),
 ('physical-refinement-cartesian-witness/receipt.json', '66680c0bafc83d9f224b1446058a5779e7843d2c49f16e9e3e9b4f3600663b1d'),
 ('physical-zero-refinement-witness/Candidate.lean', 'b8108141b6286c790e19c3d3db5d24bab08f26f03a2f225b007c0b4f9274f48a'),
 ('physical-zero-refinement-witness/receipt.json', '5511d3fed5c9f656080fea03040b0a3eb95b5a20d502c103b08d098722b7139d'),
 ('physical-refinement-joint-primary/Candidate.lean', 'efb2bb40cfe02895b7b1b017701ec09c036f88475566704d9da1f087d3eec3bb'),
 ('physical-refinement-joint-primary/receipt.json', 'dd91c1d55da7dda077e61244131d1ff29832c5e5a08c8f11ebd0f4ec4f0ce6e7'),
 ('physical-capacity-line-bridge/PhysicalCapacityBridge.lean', 'c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc'),
 ('physical-production-promotion/five-owner-placement/receipt.json', '2227c1f334d0afe41a2522e4fd1e58715004558a3c8a621a9592933170e505d8'),
]
unfixed = [
 'capacity-coordinate-realization-draft/Realization.lean.fragment',
 'capacity-ghost-boundary-draft/Ghost.lean.fragment',
 'capacity-net-reference-error-draft/NetError.lean.fragment',
 'capacity-boundary-sweep-draft/Sweep.lean.fragment',
 'capacity-boundary-sweep-draft/StageLaws.lean.fragment',
 'physical-refinement-quality-draft/PhysicalRefinement.lean.fragment',
 'physical-zero-quality-draft/ZeroQuality.lean.fragment',
 'physical-high-resolution-sweep-draft/Sweep.lean.fragment',
 'physical-refinement-joint-primary/base-provenance.json',
 'physical-refinement-joint-primary/copied-inputs.json',
]
pins = [pin(*x) for x in checked] + [pin(x) for x in unfixed]

ghost = read(D / 'capacity-ghost-boundary-draft/Ghost.lean.fragment')
start_marker = b'namespace NumStability.FiniteCoordinate.LineCoordinates'
end_marker = b'end NumStability.FiniteCoordinate.LineCoordinates'
assert ghost.count(start_marker) == ghost.count(end_marker) == 1
start = ghost.index(start_marker)
end = ghost.index(end_marker, start) + len(end_marker)
span = ghost[start:end]
shared = ['withGhost', 'withGhost_maps', 'withGhost_self', 'withGhost_withGhost',
          'extract_withGhost_error_le_max']
assert all(('def ' + x + ' ' in span.decode()) or ('theorem ' + x + ' ' in span.decode()) for x in shared)

field_groups = {
 'Incidence': ['left_line', 'right_line', 'left_index', 'right_index'],
 'Method': ['incidence', 'numericalFlux', 'admitted'],
 'Family': ['Cell', 'Face', 'Line', 'finiteCell', 'data', 'coordinates', 'method',
 'measure', 'measure_eq', 'states', 'states_nonempty', 'states_eq', 'physicalFlux',
 'normal', 'normal_flux_eq', 'region', 'target', 'target_interior_nonempty',
 'target_inside', 'active_inside', 'target_covered', 'bounded_cells', 'mesh',
 'mesh_actual', 'mesh_pos', 'mesh_tendsto', 'horizon', 'horizon_pos', 'boundaryRegion',
 'boundary_measurable', 'boundary_positive', 'boundary_finite', 'boundary_inside'],
 'AccuracyCertificate': ['constant', 'constant_nonneg', 'threshold', 'projection_available', 'bound'],
 'HasHighResolution': ['input_available', 'order', 'oscillation'],
 'Specification': ['quality', 'schedule', 'ordered', 'constituent', 'conservative',
 'line_local', 'accuracy', 'physical_error', 'cartesian'],
}
texts = {
 'Incidence': read(D / 'physical-capacity-line-bridge/PhysicalCapacityBridge.lean').decode(),
 'Method': read(D / 'capacity-coordinate-realization-draft/Realization.lean.fragment').decode(),
 'Family': read(D / 'physical-refinement-quality-draft/PhysicalRefinement.lean.fragment').decode(),
 'AccuracyCertificate': read(D / 'physical-refinement-quality-draft/PhysicalRefinement.lean.fragment').decode(),
 'HasHighResolution': read(D / 'physical-refinement-quality-draft/PhysicalRefinement.lean.fragment').decode(),
 'Specification': read(D / 'physical-high-resolution-sweep-draft/Sweep.lean.fragment').decode(),
}
import re
for name, fields in field_groups.items():
    text = texts[name]
    block = text[text.index('structure ' + name + ' '):]
    block = block.split('where', 1)[1]
    block = block.split('\n\n', 1)[0]
    actual = re.findall(r'^  ([A-Za-z][A-Za-z0-9_]*)\s*:', block, re.M)
    assert actual == fields, (name, actual, fields)

inputs = create('inputs.json', {
 'schema': 1, 'status': 'frozen historical-input pins for comparison plan',
 'repository_root': str(R).replace('\\','/'),
 'files': pins,
 'historical_reference_rule': 'Do not recursively validate these historical receipts against changed current canonical paths.',
 'canonical_proposal_owner_inventory': None,
 'canonical_compiled_inputs': None,
 'pending': ['final owner proposal snapshot receipt', 'root successful current topological build',
             'actual native nominal transport and joint canonical application'],
})
plan = create('transport-obligations.json', {
 'schema': 1, 'authority': 'comparison implementation plan only',
 'native_executed': False, 'source_acceptance': False,
 'faithfulness_action': 'new-audit-required',
 'structure_fields': field_groups,
 'nominal_pairs': [
  ['PhysicalCapacityBridge.Incidence','NumStability.FiniteCoordinate.PhysicalLine.Incidence'],
  ['CapacityCoordinate.Method','NumStability.CapacityCoordinate.Method'],
  ['PhysicalRefinementQuality.Family','NumStability.PhysicalRefinementQuality.Family'],
  ['PhysicalRefinementQuality.Family.AccuracyCertificate','NumStability.PhysicalRefinementQuality.Family.AccuracyCertificate'],
  ['PhysicalRefinementQuality.Family.HasHighResolution','NumStability.PhysicalRefinementQuality.Family.HasHighResolution'],
  ['PhysicalHighResolutionSweep.Specification','NumStability.PhysicalHighResolutionSweep.Specification'],
 ],
 'commuting_groups': [
  ['capacity', 'faceRule', 'lineAdvance', 'physical mesh', 'netFluxDefect', 'once-per-edge variation'],
  ['Method.numericalFlux', 'Method.admitted', 'Method.rule', 'Method.Admitted', 'Method.StableAt', 'Method.withGhost'],
  ['Family.data', 'Family.finiteCell', 'Family.method', 'Family.projected', 'Family.referenceGhost', 'Family.variation', 'Family.SmoothReference'],
  ['AccuracyCertificate.constant', 'AccuracyCertificate.threshold', 'AccuracyCertificate.projection_available', 'AccuracyCertificate.bound', 'AccuracyCertificate.perturbed_at'],
  ['stage-dependent step/run', 'constant-coordinate run specialization', 'family coordinates/method/execution', 'ValidSubsteps'],
 ],
 'shared_ghost_span': {
  'input': next(x for x in pins if x['path'].endswith('/Ghost.lean.fragment')),
  'start_byte_zero_based': start, 'end_byte_exclusive': end,
  'sha256': digest(span), 'declarations': ['NumStability.FiniteCoordinate.LineCoordinates.'+x for x in shared],
  'action': 'exclude only in new comparison assembly; retain original bytes; import canonical shared owner',
 },
 'old_source_comparison': 'excluded: materially different rejected production source target',
 'latest_source_comparison': 'map only final admitted scratch proposal to canonical replacement',
 'mechanical_guards': {'expected_pin_checks': len(checked), 'newly_hash_bound_fragments': len(unfixed),
                       'exact_structure_field_lists': len(field_groups), 'unique_shared_namespace_span': True},
})
review = pin('physical-dim-comparison-plan/REVIEW.md')
script = pin('physical-dim-comparison-plan/freeze.py')
receipt = create('receipt.json', {
 'schema': 1, 'status': 'comparison-plan-frozen; native transport pending',
 'generated_utc': datetime.now(timezone.utc).isoformat(),
 'inputs': inputs, 'obligations': plan, 'review': review, 'script': script,
 'checks': 'exact known SHA pins, observed structure fields and unique shared-FQN span passed',
 'native_run': False, 'source_acceptance': False, 'production_mutation': False,
 'historical_canonical_revalidation': False,
})
print(json.dumps(receipt, indent=2))
