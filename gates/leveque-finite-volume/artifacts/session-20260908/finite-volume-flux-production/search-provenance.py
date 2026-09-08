"""Read-only, scoped reuse search capture and runtime/source provenance."""
from pathlib import Path
import hashlib, json, shutil, subprocess

task = Path(__file__).resolve().parent
repo = task.parents[4]
family = repo / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
mathlib = repo / '.lake/packages/mathlib'
placement = json.loads((task / 'placement-initial.json').read_bytes())
new_names = [Path(item['path']).name for item in placement['new_files']]
exclude = [arg for name in new_names for arg in ['-g', '!' + name]]
queries = [
    ('existing-api-search', ['rg', '-n',
      'physicalFaceAverage|timeAveragedFaceFlux|physicalFluxAverage|numericalUpdate_weighted_error|riemannFiniteVolumeUpdate_.*(error|mass)|cellAverage.*error|linearRiemannInterfaceFlux|norm_le_of_weighted_balance|average_difference_norm_le',
      *exclude, 'ComputationalMathematics/Analysis/PartialDifferentialEquations',
      'ComputationalMathematics/Source/LeVeque']),
    ('existing-producer-search', ['rg', '-n',
      'cellWidth_smul_oneDimensionalCellAverage|finiteVolumeCellAverageOn_spec|riemannFiniteVolumeUpdate|sum_conservativeFluxDifferenceUpdate|cellVolume_smul_finiteVolumeCellAverageUpdate|linearRectangleRiemannInterfaceFluxMethod_information',
      *[str(family / name) for name in ['CellAverage.lean', 'RiemannInterface.lean',
        'FluxDifference.lean', 'LocalFluxBalance.lean', 'LinearRectangleRiemannInterface.lean']]]),
    ('mathlib-integral-search', ['rg', '-n',
      'norm_integral_le_of_norm_le_const|theorem integral_congr_ae|theorem integral_sub',
      str(mathlib / 'Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean')]),
    ('mathlib-norm-search', ['rg', '-n',
      'norm_sub_le|norm_add_le|norm_smul|norm_sum_le',
      str(mathlib / 'Mathlib/Analysis/Normed/Group/Basic.lean'),
      str(mathlib / 'Mathlib/Analysis/Normed/Module/Basic.lean')]),
    ('canonical-residue-search', ['rg', '-n',
      'FVFlux.*Draft|sorry|admit|^axiom ', *[item['path'] for item in placement['new_files']]]),
    ('lean-version', ['lake', 'env', 'lean', '--version']),
    ('lake-version', ['lake', '--version']),
    ('mathlib-head', ['git', '-C', str(mathlib), 'rev-parse', 'HEAD']),
    ('lean-repository-head', ['git', 'rev-parse', 'HEAD']),
]
records = []
for label, argv in queries:
    argv[0] = shutil.which(argv[0])
    assert argv[0]
    path = task / (label + '-output.txt')
    assert not path.exists()
    result = subprocess.run(argv, cwd=repo, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    path.write_bytes(result.stdout)
    records.append({'label': label, 'argv': argv, 'cwd': str(repo),
                    'exit_code': result.returncode, 'output': str(path),
                    'output_sha256': hashlib.sha256(result.stdout).hexdigest()})
    if label.endswith('-search'):
        assert result.returncode in (0, 1), (label, result.stdout)
    else:
        assert result.returncode == 0, (label, result.stdout)

files = [repo / 'lean-toolchain', repo / 'lake-manifest.json',
         mathlib / 'Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean',
         mathlib / 'Mathlib/Analysis/Normed/Group/Basic.lean',
         mathlib / 'Mathlib/Analysis/Normed/Module/Basic.lean',
         repo / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Rectangle.lean']
files += [Path(item['path']) for item in placement['existing_family_before']]
result = {'captures': records, 'source_files': [
    {'path': str(path), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
    for path in files],
    'scope_note': 'Searches cover the listed current-project paths and selected pinned Mathlib files; misses are not global absence claims.',
    'initial_console_search_note': 'Path/name collision searches were performed before placement. This retained replay excludes all five new leaves. A PowerShell brace-expansion attempt failed at parsing before searches ran; replay uses argv lists.'}
(task / 'search-provenance.json').write_bytes((json.dumps(result, indent=2) + '\n').encode())
print(json.dumps(records, indent=2))
