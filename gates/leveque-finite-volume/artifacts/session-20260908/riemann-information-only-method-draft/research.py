from pathlib import Path
from hashlib import sha256
import json
import subprocess

HERE = Path(__file__).resolve().parent
SESSION = HERE.parent
REPO = SESSION.parents[3]
assert not (HERE / 'reuse.json').exists()
commands = [
    ['rg', '-n', 'structure.*FluxMethod|Result : .*Type|constants_in_domain|localTrace|norm_sub_oneDimensionalCellAverage_le_of_trace',
     'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'],
    ['rg', '-n', 'RiemannSolver|numericalFlux|Riemann.*FluxMethod', '.lake/packages/mathlib/Mathlib'],
    ['rg', '-n', 'norm_sub_le_norm_sub_add_norm_sub|intervalIntegrable_congr|integral_congr_ae',
     '.lake/packages/mathlib/Mathlib/Analysis/Normed/Group/Basic.lean',
     '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean'],
]
searches = []
for index, command in enumerate(commands, 1):
    run = subprocess.run(command, cwd=REPO, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output = HERE / f'search-{index:02}.txt'
    output.write_bytes(run.stdout)
    searches.append(dict(command=command, cwd=str(REPO), exit_code=run.returncode,
                         output=str(output), sha256=sha256(run.stdout).hexdigest()))
files = [SESSION / 'returned-field-interface-capstone-draft/REVIEW.md',
         SESSION / 'returned-field-interface-capstone-draft/manifest.json',
         SESSION / 'returned-field-interface-capstone-draft/preparation.json',
         SESSION / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf',
         REPO / 'lean-toolchain', REPO / 'lake-manifest.json',
         REPO / '.lake/packages/mathlib/Mathlib/Analysis/Normed/Group/Basic.lean',
         REPO / '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean']
data = dict(searches=searches, inputs=[dict(path=str(p), sha256=sha256(p.read_bytes()).hexdigest()) for p in files],
            selected=['Keep the existing law, ordered Riemann input and finite-volume update types.',
                      'Forget only RiemannFieldFluxMethod.field/initial/trace_integrable; preserve execution fields.',
                      'Use norm_sub_oneDimensionalCellAverage_le_of_trace directly for an optional selected-result trace.',
                      'Use riemannFiniteVolumeUpdate_error_le without a new norm/integral proof.',
                      'Reuse StationaryRiemannField unit-speed law and reference for substantive nonvacuity.'],
            rejections=['Old full-field APIs impose extra representation obligations and all-real trace integrability.',
                        'A preliminary read of FluxErrorEstimates.lean found no such file; corrected to existing FluxUpdateErrorBounds.lean.',
                        'A preliminary search of Mathlib/Analysis/PartialDifferentialEquations found no such directory; the recorded Mathlib term search below is the relevant scoped evidence.',
                        'No mathematical claim of global absence follows from a failed path lookup or a scoped term miss.',
                        'Constant consistency alone is not a physical solution or accuracy certificate.'],
            scope='Scratch unselected alternative. No adoption of pending representation/accuracy questions or source verdict.')
(HERE / 'reuse.json').write_text(json.dumps(data, indent=2)+'\n', encoding='utf-8', newline='\n')
print(json.dumps(dict(path=str(HERE / 'reuse.json'), sha256=sha256((HERE / 'reuse.json').read_bytes()).hexdigest())))
