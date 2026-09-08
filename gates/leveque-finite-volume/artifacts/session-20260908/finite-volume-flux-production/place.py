"""Strict new-leaf extraction of frozen generic FV mathematics; no existing owner writes."""
from pathlib import Path
import hashlib, json, re

task = Path(__file__).resolve().parent
repo = task.parents[4]
session = task.parent
family = repo / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
prefix = 'ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'

def read_frozen(directory, name, expected):
    path = session / directory / name
    data = path.read_bytes()
    assert hashlib.sha256(data).hexdigest() == expected, path
    assert b'\r' not in data
    return data.decode('utf-8')

base = read_frozen('finite-volume-flux-update-repair', 'candidate.lean',
    'f90dbaa19d16da3617dac27e982557ebe501249afb03566b9bdb6b191ae935be')
estimate = read_frozen('finite-volume-flux-error-estimate', 'estimate-fragment.lean',
    '051088db0f301ca8942ac9d28ba845ac337148a2013401dd8cf6f7552bb06b7c')
solver = read_frozen('finite-volume-flux-error-estimate', 'solver-link-fragment.lean',
    'fbfde84a787291e230c4acc3a24ce4c3d610c81e1ec13ea50667fbad19286c49')

def block(source, name):
    match = re.search(r'^(?:noncomputable )?(?:def|theorem) ' + re.escape(name) + r'\b', source, re.M)
    assert match, name
    start = match.start()
    tail = source[match.end():]
    boundary = re.search(r'^/--|^(?:noncomputable )?(?:def|theorem) |^end ', tail, re.M)
    assert boundary, name
    return source[start:match.end() + boundary.start()].rstrip() + '\n'

rename = {
    'physicalFaceAverage': 'timeAveragedPhysicalFaceFlux',
    'physicalFaceAverage_spec': 'timeAveragedPhysicalFaceFlux_isCellAverage',
    'timeStep_smul_physicalFaceAverage': 'timeStep_smul_timeAveragedPhysicalFaceFlux',
    'exactCellAverage_mass_balance': 'finiteVolumeCellAverageOn_mass_balance',
    'numericalUpdate_mass_balance': 'cellVolume_smul_riemannFiniteVolumeUpdate_fromRule',
    'numericalUpdate_weighted_error': 'riemannFiniteVolumeUpdate_weighted_error',
    'numericalUpdate_block_error': 'riemannFiniteVolumeUpdate_block_error',
    'numericalUpdate_error_bound': 'riemannFiniteVolumeUpdate_error_le',
    'numericalUpdate_block_mass_error_bound': 'riemannFiniteVolumeUpdate_block_mass_error_le',
    'average_difference_norm_le': 'norm_oneDimensionalCellAverage_sub_le',
    'selectedLinearFlux_eq_physical_trace': 'linearRectangleRiemannInterfaceFluxMethod_flux_eq_physicalTrace',
    'selectedLinearFlux_eq_solver_average': 'linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage',
    'linearRule_flux_error_le': 'linearRectangleRiemannInterfaceFlux_error_le',
    'linearRule_next_error_bound': 'linearRectangleRiemannInterfaceFlux_update_error_le',
}

def transform(body):
    body = body.replace('FVFluxUpdateDraft.', '')
    for old, new in sorted(rename.items(), key=lambda item: -len(item[0])):
        body = re.sub(r'\b' + re.escape(old) + r'\b', new, body)
    body = body.replace('numericalUpdate grid rule s t old',
        'riemannFiniteVolumeUpdate grid (t - s) old (rule s t old)')
    return body

def leaf(imports, title, explanation, chunks, variables=''):
    return ('/-\nSPDX-License-Identifier: MIT\n-/\n\n' +
        '\n'.join('import ' + name for name in imports) + '\n\n/-!\n# ' + title +
        '\n\n' + explanation + '\n-/\n\nopen MeasureTheory\nopen scoped BigOperators\n\nnamespace NumStability\n\n' +
        variables + '\n'.join(chunks) + '\nend NumStability\n')

average = leaf([prefix + 'CellAverage'], 'Norm estimates for interval cell averages',
    'A pointwise bound on the difference of two integrable fields bounds the\n' +
    'difference of their normalized averages on a positive interval.',
    ['/-- A pointwise error bound controls the difference of interval averages. -/\n' +
     transform(block(estimate, 'average_difference_norm_le'))])

physical = leaf([
    'ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle',
    prefix + 'RiemannInterface'], 'Time-averaged physical face fluxes',
    'The physical reference is a time average at an actual grid face. Rectangle\n' +
    'conservation gives the exact mass change of a cell between two times.',
    ['/-- Physical flux through the left face of cell `j`, averaged in time. -/\n' +
      transform(block(base, 'physicalFaceAverage')),
     '/-- Temporal integrability and positive duration certify the face average. -/\n' +
      transform(block(base, 'physicalFaceAverage_spec')),
     '/-- Duration times the physical face average is its time integral. -/\n' +
      transform(block(base, 'timeStep_smul_physicalFaceAverage')),
     '/-- Exact cell mass changes by the integrated left-minus-right physical flux. -/\n' +
      transform(block(base, 'exactCellAverage_mass_balance'))], 'variable {m : ℕ}\n\n')

mass = transform(block(base, 'numericalUpdate_mass_balance')).replace('theorem ', 'private theorem ', 1)
error = leaf([prefix + 'PhysicalFluxAverage', prefix + 'LocalFluxBalance', prefix + 'FluxDifference'],
    'Exact finite-volume error identities',
    'Numerical arrays are independent of exact cell averages. An arbitrary\n' +
    'time-dependent full-array flux rule gives a local weighted error identity;\n' +
    'finite contiguous blocks retain only their two exterior face errors.',
    [mass,
     '/-- Old numerical error and numerical-minus-physical face errors give the exact new error. -/\n' +
      transform(block(base, 'numericalUpdate_weighted_error')),
     '/-- Interior flux errors cancel on every finite contiguous block, including nonuniform cells. -/\n' +
      transform(block(base, 'numericalUpdate_block_error'))], 'variable {m : ℕ}\n\n')

bounds = leaf([prefix + 'FluxUpdateError'], 'Conditional finite-volume error bounds',
    'Bounds on old cell errors and face-flux errors imply next-step bounds.\n' +
    'The block estimate controls the norm of total mass error, allowing\n' +
    'cancellation; it is not a sum of absolute new cell errors.',
    [transform(block(estimate, 'norm_le_of_weighted_balance')).replace('theorem ', 'private theorem ', 1),
     '/-- Input error and the two face-flux error bounds control the new cell-average error. -/\n' +
      transform(block(estimate, 'numericalUpdate_error_bound')),
     '/-- Old cell-error bounds and the exterior flux-error bounds control total block mass error. -/\n' +
      transform(block(estimate, 'numericalUpdate_block_mass_error_bound'))])

# Solver aliases are expanded below into existing APIs. No additional solver,
# extraction, numerical rule, or numerical update definitions are introduced.
method = '(linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen)'
def solver_transform(body):
    body = transform(body)
    body = body.replace('selectedLinearSolve A hA basis speeds heigen problem',
        method + '.solve problem trivial')
    body = body.replace('selectedLinearFlux A hA basis speeds heigen problem',
        method + '.numericalFluxFromInformation\n      (' + method + '.extractInformation\n        (' + method + '.solve problem trivial))')
    body = body.replace('selectedLinearSolve A hA basis speeds heigen\n        (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j)',
        method + '.solve\n        (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j) trivial')
    body = body.replace('linearRule A hA basis speeds heigen 0 dt old j',
        'rectangleRiemannInterfaceFlux ' + method + ' old (fun _ => trivial) j')
    body = body.replace('unfold linearRule timeAveragedPhysicalFaceFlux',
        'unfold rectangleRiemannInterfaceFlux adjacentCellRectangleRiemannInformation\n    timeAveragedPhysicalFaceFlux')
    body = body.replace('(selectedLinearSolve A hA basis speeds heigen _)',
        '(' + method + '.solve _ trivial)')
    body = body.replace('numericalUpdate grid (linearRule A hA basis speeds heigen) 0 dt old i',
        'riemannFiniteVolumeUpdate grid dt old\n      (rectangleRiemannInterfaceFlux ' + method + ' old (fun _ => trivial)) i')
    body = body.replace('(linearRule A hA basis speeds heigen)',
        '(fun _ _ data => rectangleRiemannInterfaceFlux ' + method + ' data (fun _ => trivial))')
    return body

linear = leaf([prefix + 'LinearRectangleRiemannInterface', prefix + 'CellAverageEstimates',
    prefix + 'FluxUpdateErrorBounds'], 'Physical flux averages of selected linear Riemann solves',
    'The actual selected linear method yields the physical flux of its own\n' +
    'positive-time interface trace, for unequal as well as equal states.\n' +
    'Comparison with an independent global field requires a trace-error bound.',
    ['/-- The selected method output is the physical flux of its returned solution at positive times. -/\n' +
      solver_transform(block(solver, 'selectedLinearFlux_eq_physical_trace')),
     '/-- The numerical flux is exactly the physical time-average of the selected solver on ray zero. -/\n' +
      solver_transform(block(solver, 'selectedLinearFlux_eq_solver_average')),
     '/-- A local-solver/global-field trace-error bound controls the averaged numerical-flux error. -/\n' +
      solver_transform(block(solver, 'linearRule_flux_error_le')),
     '/-- Old numerical error and justified solver-trace errors imply a next-step cell-error bound. -/\n' +
      solver_transform(block(solver, 'linearRule_next_error_bound'))], 'variable {m : ℕ}\n\n')

files = {'CellAverageEstimates.lean': average, 'PhysicalFluxAverage.lean': physical,
    'FluxUpdateError.lean': error, 'FluxUpdateErrorBounds.lean': bounds,
    'LinearRiemannFluxAverage.lean': linear}
for name, body in files.items():
    assert not (family / name).exists(), name
    assert not (family / Path(name).stem).exists(), name
    assert not re.search(r'FVFlux\w*Draft|\bselectedLinearSolve\b|\bselectedLinearFlux\b|\blinearRule\b|\bnumericalUpdate\b', body), name
before = [{'path': str(p.resolve()), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()}
          for p in sorted(family.glob('*.lean'))]
for name, body in files.items():
    (family / name).write_bytes(body.encode('utf-8'))
record = {'existing_family_before': before,
    'new_files': [{'path': str((family / name).resolve()),
                   'sha256': hashlib.sha256(body.encode()).hexdigest()} for name, body in files.items()],
    'declaration_renames': rename, 'no_existing_owner_edits': True}
(task / 'placement-initial.json').write_bytes((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record['new_files'], indent=2))
