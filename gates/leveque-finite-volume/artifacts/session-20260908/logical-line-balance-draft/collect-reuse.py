"""Read-only prerequisite searches for the supplied-volume coordinate-line draft."""
from pathlib import Path
import hashlib, json, shutil, subprocess

task = Path(__file__).resolve().parent
repo = task.parents[4]
session = task.parent
queries = [
 ('project-line', ['rg', '-n', 'coordinate.*(update|line)|line.*(update|balance)|directional.*[Vv]olume|shared.?[Ff]ace',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations']),
 ('project-balance', ['rg', '-n', 'cellVolume_smul_finiteVolumeCellAverageUpdate|sum_finiteVolumeCellTotalBalance|sum_conservativeFluxDifferenceUpdate|orderedOperatorSweep',
  'ComputationalMathematics/Analysis/PartialDifferentialEquations']),
 ('mathlib-update', ['rg', '-n', 'update_idem|update_same|update_eq_self|update_apply',
  '.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean']),
 ('mathlib-sum', ['rg', '-n', 'sum_range_sub|sum_range_add|sum_range_succ|sum_sub_distrib',
  '.lake/packages/mathlib/Mathlib/Algebra/BigOperators/Group/Finset']),
 ('mathlib-fold', ['rg', '-n', 'foldl_cons|foldl_append', '.lake/packages/mathlib/Mathlib/Data/List']),
 ('native-version', ['lake', 'env', 'lean', '--version']),
 ('repository-head', ['git', '-c', 'core.longpaths=true', 'rev-parse', 'HEAD']),
 ('mathlib-head', ['git', '-C', '.lake/packages/mathlib', 'rev-parse', 'HEAD']),
]
records = []
for label, argv in queries:
    argv[0] = shutil.which(argv[0])
    assert argv[0]
    result = subprocess.run(argv, cwd=repo, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = task / (label + '-output.txt'), task / (label + '-stderr.txt')
    assert not out.exists() and not err.exists()
    out.write_bytes(result.stdout); err.write_bytes(result.stderr)
    records.append({'label': label, 'argv': argv, 'cwd': str(repo), 'exit_code': result.returncode,
      'stdout': {'path': str(out), 'sha256': hashlib.sha256(result.stdout).hexdigest()},
      'stderr': {'path': str(err), 'sha256': hashlib.sha256(result.stderr).hexdigest()}})
    assert result.returncode in (0, 1) and not result.stderr, (label, result.stderr)
paths = [repo / 'AGENTS.md', repo / 'lean-toolchain', repo / 'lake-manifest.json',
  session / 'dimensional-splitting-lines-draft/REVIEW.md',
  session / 'dimensional-splitting-lines-draft/TensorLines.lean.fragment',
  session / 'dimensional-splitting-lines-draft/final-evidence.json',
  session / 'finite-volume-flux-production/placement-manifest.json',
  session / 'finite-volume-flux-production/final-receipt.json']
paths += list((repo / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume').glob('*.lean'))
paths += [repo / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/OperatorSplitting.lean',
  repo / '.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean']
record = {'searches': records, 'inputs': [{'path': str(p), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],
          'scope': 'Listed current-project and pinned Mathlib paths only; no global absence claim. Native read-only searches; no released script or audit invoked.'}
(task / 'reuse-provenance.json').write_bytes((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'searches': len(records), 'inputs': len(paths)}))
