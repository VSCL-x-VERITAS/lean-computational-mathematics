"""Native task-local source/search and exact declaration capture."""
from pathlib import Path
import hashlib, json, os, re, shutil, subprocess

assert os.name == 'nt'
task = Path(__file__).resolve().parent
repo, session = task.parents[4], task.parent
workspace = repo.parent

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
runs.append(capture('project-flux-error-search', 'rg', ['-n', 'weighted.*[Ee]rror|[Ee]rror.*flux|flux.*[Ee]rror|sum.*[Ff]lux|telescop|cellAverage|finiteVolumeUpdate', 'ComputationalMathematics/Analysis/PartialDifferentialEquations', 'ComputationalMathematics/Source/LeVeque/Chapter01', '-g', '*.lean']))
runs.append(capture('project-temporal-reference-search', 'rg', ['-n', 'average.*balance|balance.*average|timeAveraged|timeAverage.*[Ff]lux|physical.*[Ee]dge', 'ComputationalMathematics', '-g', '*.lean']))
runs.append(capture('project-grid-search', 'rg', ['-n', 'OneDimensionalFiniteVolumeGrid|cellLeft :=|cellRight :=', 'ComputationalMathematics', '-g', '*.lean']))
runs.append(capture('mathlib-telescoping-search', 'rg', ['-n', 'sum_range_sub|sum_Ico_sub|sum_Icc_sub', '.lake/packages/mathlib/Mathlib/Algebra/BigOperators', '-g', '*.lean']))
runs.append(capture('mathlib-integral-search', 'rg', ['-n', 'theorem integral_id|theorem integral_sub|theorem integral_smul_const|theorem integral_const', '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean', '.lake/packages/mathlib/Mathlib/Analysis/SpecialFunctions/Integrals/Basic.lean']))
runs.append(capture('native-version', 'lake', ['env', 'lean', '--version']))
runs.append(capture('candidate-dependencies', 'lake', ['env', 'lean', '--deps', str(task / 'candidate.lean')]))
runs.append(capture('witness-dependencies', 'lake', ['env', 'lean', '--deps', str(task / 'witness-check.lean')]))

audit = session / 'audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908'
source = entry(session / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf')
assert source['sha256'] == 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
assert entry(audit / 'faithfulness/decision.json')['sha256'] == '8660b099909f6f75de955b1ef62d176191887521f1e1c261f6dc645743074375'
views = []
for raw, printed in [(26, 4), (27, 5), (31, 9), (32, 10)]:
    view = entry(workspace / f'workflow-v5.0.1-local/chapter01-source-review/page-{raw:03d}.png')
    view.update(raw_pdf_page_one_based=raw, printed_page=printed, actually_viewed=True)
    views.append(view)
inputs = ['AGENTS.md', 'lean-toolchain', 'lake-manifest.json',
    'ComputationalMathematics/Source/LeVeque/Chapter01/FiniteVolumeFluxUpdate.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/LinearAdvection.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/CellAverage.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannInterface.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/LocalFluxBalance.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/FluxDifference.lean',
    '.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Module.lean',
    '.lake/packages/mathlib/Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean',
    '.lake/packages/mathlib/Mathlib/Analysis/SpecialFunctions/Integrals/Basic.lean']
write_new('input-provenance.json', {
    'source': source, 'views': views, 'inputs': [entry(repo / p) for p in inputs],
    'frozen_audit_files': [entry(p) for p in sorted(audit.rglob('*')) if p.is_file()],
    'commands': runs, 'candidate_at_dependency_check': entry(task / 'candidate.lean'),
    'mathlib_revision': 'e8ea1afc32790ce1d4e1a4e45cc412ba9388716b',
    'source_audit_verdict': None,
    'note': 'Scoped search replay after interactive searches before implementation; no exhaustive absence claim.'})

candidate = (task / 'candidate.lean').read_bytes()
source_fragment = (task / 'source-wrapper-fragment.lean').read_bytes()
witness_fragment = (task / 'witness-fragment.lean').read_bytes()
witness_import = b'import Mathlib.Analysis.SpecialFunctions.Integrals.Basic\n'
assert (task / 'source-wrapper-check.lean').read_bytes() == candidate + b'\n' + source_fragment
assert (task / 'witness-check.lean').read_bytes() == witness_import + candidate + b'\n' + witness_fragment

def declared(data, namespace):
    return [namespace + name for name in re.findall(r'^(?:noncomputable )?(?:def|theorem) ([\w.]+)', data.decode('utf-8'), re.M)]
names = declared(candidate, 'NumStability.FVFluxUpdateDraft.') + declared(source_fragment, 'NumStability.FVFluxUpdateDraft.') + declared(witness_fragment, 'NumStability.FVFluxUpdateDraft.Witness.')
assert len(names) == 19
dependencies = ['NumStability.IsRectangleConservationLawSolution', 'NumStability.oneDimensionalCellAverage',
    'NumStability.oneDimensionalCellAverage_isCellAverage', 'NumStability.cellWidth_smul_oneDimensionalCellAverage',
    'NumStability.OneDimensionalFiniteVolumeGrid.cellVolume_pos', 'NumStability.finiteVolumeCellAverageOn_spec',
    'NumStability.riemannFiniteVolumeUpdate', 'NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate',
    'NumStability.sum_conservativeFluxDifferenceUpdate', 'NumStability.travelingWave_isRectangleConservationLawSolution',
    'intervalIntegral.integral_sub', 'intervalIntegral.integral_smul_const', 'integral_id']
checks = task / 'declaration-checks.lean'
assert not checks.exists()
body = witness_import + candidate + b'\n' + source_fragment + b'\n' + witness_fragment
body += ('\n' + '\n'.join(f'#check {n}\n#print axioms {n}' for n in names + dependencies) + '\n').encode('utf-8')
checks.write_bytes(body)
write_new('declaration-list.json', {'new': names, 'existing': dependencies})
print('Captured immutable input/search evidence; prepared 32 exact declaration and axiom checks.')
