"""Task-local native provenance and declaration capture; scratch writes only."""
from pathlib import Path
import hashlib, json, os, re, shutil, subprocess

assert os.name == 'nt'
task = Path(__file__).resolve().parent
repo, session = task.parents[4], task.parent
workspace = repo.parent
prior = session / 'finite-volume-flux-update-repair'

def entry(path):
    path = Path(path).resolve()
    data = path.read_bytes()
    return {'path': str(path), 'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data)}

def write_new(name, obj):
    path = task / name
    assert not path.exists()
    path.write_bytes((json.dumps(obj, indent=2) + '\n').encode('utf-8'))

def capture(label, executable, arguments):
    output, errors = task / (label + '.stdout.txt'), task / (label + '.stderr.txt')
    assert not output.exists() and not errors.exists()
    argv = [shutil.which(executable), *arguments]
    assert argv[0]
    with output.open('wb') as out, errors.open('wb') as err:
        process = subprocess.run(argv, cwd=repo, stdout=out, stderr=err)
    assert process.returncode in (0, 1), (label, process.returncode)
    return {'argv': argv, 'cwd': str(repo), 'exit_code': process.returncode,
            'stdout': entry(output), 'stderr': entry(errors)}

runs = []
runs.append(capture('project-estimate-search', 'rg', ['-n', 'norm.*[Ff]lux|[Ff]lux.*norm|norm.*numericalUpdate|physicalFaceAverage|oneDimensionalCellAverage.*norm|norm.*oneDimensionalCellAverage', 'ComputationalMathematics', '-g', '*.lean']))
runs.append(capture('project-solver-link-search', 'rg', ['-n', 'linearRectangleRiemannInterfaceFluxMethod_information|rayZero|numericalFluxFromInformation|selectedLinearRiemannRayZeroValue', 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume', '-g', '*.lean']))
runs.append(capture('mathlib-average-bound-search', 'rg', ['-n', 'norm_integral_le_of_norm_le_const|integral_congr_ae|integral_sub', '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean']))
runs.append(capture('mathlib-norm-search', 'rg', ['-n', 'norm_add_le|norm_sub_le|norm_sum_le|norm_smul', '.lake/packages/mathlib/Mathlib/Analysis/Normed/Group/Basic.lean', '.lake/packages/mathlib/Mathlib/Analysis/Normed/Module/Basic.lean']))
runs.append(capture('mathlib-positive-multiplication-search', 'rg', ['-n', 'theorem mul_le_mul_iff_right₀|theorem mul_le_mul_iff_left₀', '.lake/packages/mathlib/Mathlib/Algebra/Order/GroupWithZero/Unbundled/Defs.lean']))
runs.append(capture('native-version', 'lake', ['env', 'lean', '--version']))
runs.append(capture('combined-dependencies', 'lake', ['env', 'lean', '--deps', str(task / 'combined-check.lean')]))

audit = session / 'audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908'
assert entry(audit / 'faithfulness/decision.json')['sha256'] == '44dfd5c682eb5fdcd9fabd7b747df0ccbabc280d31482e26861c714a7b56c1a4'
source = entry(session / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf')
assert source['sha256'] == 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
assert entry(prior / 'candidate.lean')['sha256'] == 'f90dbaa19d16da3617dac27e982557ebe501249afb03566b9bdb6b191ae935be'
assert entry(prior / 'final-receipt.json')['sha256'] == 'b80b7940589121c479769a24e96fdf380fe8182bd4b9dda04d6aa65b7aa0550a'
views = []
for raw, printed in [(26, 4), (27, 5), (32, 10)]:
    view = entry(workspace / f'workflow-v5.0.1-local/chapter01-source-review/page-{raw:03d}.png')
    view.update(raw_pdf_page_one_based=raw, printed_page=printed,
                actually_viewed_earlier_in_this_conversation=True)
    views.append(view)
inputs = ['AGENTS.md', 'lean-toolchain', 'lake-manifest.json',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInterface.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalFluxBalance.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FluxDifference.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RectangleRiemannInterface.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRectangleRiemannInterface.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LinearRiemannSolution.lean',
    '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean',
    '.lake/packages/mathlib/Mathlib/Analysis/Normed/Group/Basic.lean',
    '.lake/packages/mathlib/Mathlib/Analysis/Normed/Module/Basic.lean',
    '.lake/packages/mathlib/Mathlib/Algebra/Order/GroupWithZero/Unbundled/Defs.lean']
write_new('input-provenance.json', {
    'source': source, 'views': views, 'inputs': [entry(repo / p) for p in inputs],
    'frozen_audit_files': [entry(p) for p in sorted(audit.rglob('*')) if p.is_file()],
    'frozen_prior_files': [entry(p) for p in sorted(prior.iterdir()) if p.is_file()],
    'commands': runs, 'checked_combination': entry(task / 'combined-check.lean'),
    'mathlib_revision': 'e8ea1afc32790ce1d4e1a4e45cc412ba9388716b',
    'source_audit_verdict': None,
    'note': 'Scoped search replay after interactive search; initial broad error search was truncated and replaced by focused searches. No exhaustive absence claim.'})

base = (task / 'frozen-base.lean').read_bytes()
estimate = (task / 'estimate-fragment.lean').read_bytes()
solver = (task / 'solver-link-fragment.lean').read_bytes()
header = b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface\n'
assert base == (prior / 'candidate.lean').read_bytes()
assert (task / 'combined-check.lean').read_bytes() == header + base + b'\n' + estimate + b'\n' + solver

def declared(data, namespace):
    return [namespace + n for n in re.findall(r'^(?:noncomputable )?(?:def|theorem) ([\w.]+)', data.decode(), re.M)]
new = declared(estimate, 'NumStability.FVFluxEstimateDraft.') + declared(solver, 'NumStability.FVFluxEstimateDraft.')
base_names = declared(base, 'NumStability.FVFluxUpdateDraft.')
assert len(new) == 12 and len(base_names) == 9
dependencies = ['NumStability.linearRectangleRiemannInterfaceFluxMethod_information',
    'NumStability.linearRiemannSolution_rayZero', 'NumStability.certifiedLinearRectangleRiemannSolution',
    'NumStability.linearRectangleRiemannInterfaceFluxMethod', 'NumStability.rectangleRiemannInterfaceFlux',
    'NumStability.linearRectangleRiemannInterfaceFluxMethod_exists_total',
    'intervalIntegral.norm_integral_le_of_norm_le_const', 'intervalIntegral.integral_congr_ae',
    'intervalIntegral.integral_sub', 'intervalIntegral.integral_const',
    'norm_add_le', 'norm_sub_le', 'norm_smul', 'norm_sum_le']
checks = task / 'declaration-checks.lean'
assert not checks.exists()
checks.write_bytes((task / 'combined-check.lean').read_bytes() +
    ('\n' + '\n'.join(f'#check {n}\n#print axioms {n}' for n in new + base_names + dependencies) + '\n').encode())
write_new('declaration-list.json', {'new': new, 'frozen_base': base_names, 'existing': dependencies})
print('Captured inputs and prepared 35 declaration/axiom checks: 12 new, 9 frozen-base, 14 integrated producers.')
