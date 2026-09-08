"""Native, task-local, read-only input/search capture and declaration-check preparation."""
from pathlib import Path
import hashlib, json, os, re, shutil, subprocess

assert os.name == 'nt'
task = Path(__file__).resolve().parent
repo = task.parents[4]
session = task.parent
workspace = repo.parent

def entry(path):
    path = Path(path).resolve()
    data = path.read_bytes()
    return {'path': str(path), 'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data)}

def write_new(name, obj):
    path = task / name
    assert not path.exists(), name
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
runs.append(capture('project-search', 'rg', ['-n', 'MaterialInterface|materialInterface|RiemannData|JumpAt|JumpDiscontinu', 'ComputationalMathematics', '-g', '*.lean']))
runs.append(capture('mathlib-jump-search', 'rg', ['-n', 'JumpAt|JumpDiscontinu|jump_discontinu|jump.*tendsto|tendsto.*jump', '.lake/packages/mathlib/Mathlib/Topology', '.lake/packages/mathlib/Mathlib/Analysis', '-g', '*.lean']))
runs.append(capture('mathlib-trace-search', 'rg', ['-n', 'tendsto_nhds_unique|Tendsto.prodMk_nhds|Tendsto.fst_nhds|Tendsto.snd_nhds|Tendsto.congr\x27|not_continuousAt_of_tendsto', '.lake/packages/mathlib/Mathlib/Topology/Separation/Hausdorff.lean', '.lake/packages/mathlib/Mathlib/Topology/Constructions/SumProd.lean', '.lake/packages/mathlib/Mathlib/Order/Filter/Tendsto.lean', '.lake/packages/mathlib/Mathlib/Topology/Continuous.lean']))
runs.append(capture('native-version', 'lake', ['env', 'lean', '--version']))
runs.append(capture('candidate-dependencies', 'lake', ['env', 'lean', '--deps', str(task / 'candidate.lean')]))

audit = session / 'audits/LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908'
source = entry(session / 'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf')
assert source['sha256'] == 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
decision = entry(audit / 'faithfulness/decision.json')
assert decision['sha256'] == 'd39e5f7d682275ebe7333695c0249c6e4ccffd7b81e0bc4bfa3c4930659e1216'
views = []
for raw, printed in [(29, 7), (30, 8), (27, 5)]:
    view = entry(workspace / f'workflow-v5.0.1-local/chapter01-source-review/page-{raw:03d}.png')
    view.update(raw_pdf_page_one_based=raw, printed_page=printed, actually_viewed=True)
    views.append(view)
inputs = [
    'AGENTS.md', 'lean-toolchain', 'lake-manifest.json',
    'ComputationalMathematics/Source/LeVeque/Chapter01/MaterialInterfaceRiemannData.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/InitialValue/Riemann.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannDataRegularity.lean',
    'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Examples/HuberShock/Jump.lean',
    '.lake/packages/mathlib/Mathlib/Topology/Separation/Hausdorff.lean',
    '.lake/packages/mathlib/Mathlib/Topology/Constructions/SumProd.lean',
    '.lake/packages/mathlib/Mathlib/Order/Filter/Tendsto.lean',
    '.lake/packages/mathlib/Mathlib/Topology/Continuous.lean',
]
module = workspace / 'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module'
policy = [entry(module / name) for name in ['book-profile.json', 'instructions.md', 'references/source-faithfulness.md']]
write_new('input-provenance.json', {
    'source': source, 'views': views, 'inputs': [entry(repo / p) for p in inputs],
    'policies': policy, 'frozen_audit_files': [entry(p) for p in sorted(audit.rglob('*')) if p.is_file()],
    'commands': runs, 'candidate_at_dependency_check': entry(task / 'candidate.lean'),
    'mathlib_revision': 'e8ea1afc32790ce1d4e1a4e45cc412ba9388716b',
    'source_audit_verdict': None,
    'note': 'Scoped search replay after interactive searches before implementation; no semantic absence claim.'})

candidate = (task / 'candidate.lean').read_text(encoding='utf-8')
assert '\r' not in candidate
names = ['NumStability.MaterialInterfaceDraft.' + name for name in re.findall(r'^(?:noncomputable )?(?:def|theorem) ([\w.]+)', candidate, re.M)]
assert len(names) == 14
dependencies = ['NumStability.IsRiemannData.tendsto_left', 'NumStability.IsRiemannData.tendsto_right',
                'NumStability.IsRiemannData.not_continuousAt_zero', 'NumStability.riemannData_isRiemannData',
                'NumStability.riemannData_zero', 'Filter.Tendsto.prodMk_nhds', 'Filter.Tendsto.fst_nhds',
                'Filter.Tendsto.snd_nhds', 'Filter.Tendsto.congr\x27', 'tendsto_nhds_unique']
checks = task / 'declaration-checks.lean'
assert not checks.exists()
checks.write_bytes((candidate + '\n' + '\n'.join(f'#check {n}\n#print axioms {n}' for n in names + dependencies) + '\n').encode('utf-8'))
write_new('declaration-list.json', {'new': names, 'existing': dependencies})
print('Captured immutable inputs/searches and prepared 24 exact declaration/axiom checks.')
