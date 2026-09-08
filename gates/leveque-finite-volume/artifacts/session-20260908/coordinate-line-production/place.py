"""Extract three new coordinate-line leaves from the exact reviewed frozen draft."""
from pathlib import Path
import hashlib, json, re, shutil, subprocess

task = Path(__file__).resolve().parent
repo = task.parents[4]
session = task.parent
family = repo / 'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
prefix = 'ComputationalMathematics.Analysis.PartialDifferentialEquations.'
source = session / 'logical-line-balance-draft/candidate.lean'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(source) == '527aa742c248431fb1b73c93d1efc8f602e160c9a83d2d9c880bd17768e1150f'
approval = session / 'root-batch8-logical-line-verification.json'
assert sha(approval) == '72138928eae1c038a6f86a81ce4ef8c71acf6b911c7cbcc685f54d369dd27579'
text = source.read_text(encoding='utf-8')
before_paths = [p.relative_to(repo).as_posix() for p in family.rglob('*.lean')]
queries = [
 ('current-names', ['rg', '-n', 'namespace NumStability.CoordinateLineBalance|coordinateLine.*Balance|def normalFaceFlux|def netOutwardFlux', 'ComputationalMathematics', '-g', '*.lean']),
 ('current-producers', ['rg', '-n', 'cellVolume_smul_finiteVolumeCellAverageUpdate|sum_conservativeFluxDifferenceUpdate|orderedOperatorSweep_two', str(family / 'LocalFluxBalance.lean'), str(family / 'FluxDifference.lean'), str(family.parent / 'OperatorSplitting.lean')]),
 ('mathlib-update', ['rg', '-n', 'theorem update_self|theorem update_idem', '.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean'])]
searches = []
for label, argv in queries:
    argv[0] = shutil.which(argv[0])
    result = subprocess.run(argv, cwd=repo, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = task / (label + '-output.txt'), task / (label + '-stderr.txt')
    assert not stdout.exists() and not stderr.exists()
    stdout.write_bytes(result.stdout); stderr.write_bytes(result.stderr)
    assert result.returncode in (0, 1) and not result.stderr
    searches.append({'argv': argv, 'exit_code': result.returncode,
      'stdout': {'path': str(stdout), 'sha256': sha(stdout)},
      'stderr': {'path': str(stderr), 'sha256': sha(stderr)}})

begin = text.index('/-- The rule reads')
sweep_begin = text.index('/-- Execute the conservative directional operators')
witness_begin = text.index('namespace Witness\n')
basic = text[begin:sweep_begin].rstrip()
sweep = text[sweep_begin:witness_begin].rstrip()
witness = text[witness_begin + len('namespace Witness\n'):text.index('\nend Witness')].strip()
sweep = sweep.replace('theorem sweep_cons',
  '/-- The remaining stages receive the state produced by the first directional update. -/\ntheorem sweep_cons', 1)
witness = witness.replace('def nonuniformVolume',
  '/-- A supplied scalar cell volume that is one at index zero and two elsewhere. -/\ndef nonuniformVolume', 1)
witness = witness.replace('def interiorFlux',
  '/-- A single nonzero interior face flux, used to test weighted cancellation. -/\ndef interiorFlux', 1)
witness = witness.replace('theorem nonuniformVolume_pos',
  '/-- Both supplied volume values are strictly positive. -/\ntheorem nonuniformVolume_pos', 1)

def leaf(imports, title, description, body, namespace, variables):
    return '/-\nSPDX-License-Identifier: MIT\n-/\n\n' + '\n'.join('import ' + x for x in imports) + \
      '\n\n/-!\n# ' + title + '\n\n' + description + '\n-/\n\nopen scoped BigOperators\n\nnamespace ' + namespace + '\n\n' + \
      variables + body + '\n\nend ' + namespace + '\n'

ns = 'NumStability.CoordinateLineBalance'
variables = 'variable {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]\n\n'
files = {
 'CoordinateLineBalance.lean': leaf([prefix + 'FiniteVolume.LocalFluxBalance', prefix + 'FiniteVolume.FluxDifference'],
  'Conservative coordinate lines with supplied cell volumes',
  'Cells have indices `D → ℤ`. A shared face is indexed by its direction and\n' +
  'right cell; its supplied numerical normal flux includes the face-area factor.\n' +
  'The actual update reads one coordinate line and conserves volume-weighted\n' +
  'mass, with the two exterior face terms retained on each finite line.\n\n' +
  'Volumes are supplied positive data in the balance theorems. This algebra\n' +
  'does not derive a physical chart, measure, normal, area, or constitutive flux\n' +
  'from the indices, and does not assert accuracy or constant-state preservation.', basic, ns, variables),
 'CoordinateLineSweep.lean': leaf([prefix + 'FiniteVolume.CoordinateLineBalance', prefix + 'OperatorSplitting'],
  'Successive conservative coordinate-line updates',
  'The existing ordered operator sweep executes the supplied direction-duration\n' +
  'list. Each normal-flux rule reads its actual intermediate numerical state.\n' +
  'The two-stage mass identity retains both directional transfers; it does not\n' +
  'assert commutation, a high-resolution property, or a physical geometry.', sweep, ns, variables),
 'Examples/CoordinateLineBalance.lean': leaf([prefix + 'FiniteVolume.CoordinateLineBalance'],
  'Unequal-volume coordinate-line conservation example',
  'Two cells with supplied volumes one and two exchange a nonzero interior flux.\n' +
  'Their averages change by different amounts while their weighted mass sum\n' +
  'is preserved. The example tests conservative algebra, without asserting a\n' +
  'physical normal-flux model or a Riemann-solver certificate.', witness, ns + '.Witness', '')}
for relative, body in files.items():
    path = family / relative
    assert not path.exists() and not path.with_suffix('').exists(), path
    assert 'LogicalLineBalanceDraft' not in body and '/-!+#' not in body
assert not (family / 'Examples.lean').exists()
for relative, body in files.items():
    path = family / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(body.encode())
newfiles = [{'path': str(family / relative), 'sha256': sha(family / relative)} for relative in files]
decls = json.loads((session / 'logical-line-balance-draft/declaration-list.json').read_bytes())['new']
deps = [family / 'LocalFluxBalance.lean', family / 'FluxDifference.lean', family.parent / 'OperatorSplitting.lean',
        repo / '.lake/packages/mathlib/Mathlib/Logic/Function/Basic.lean', repo / 'lean-toolchain', repo / 'lake-manifest.json']
record = {'source': {'path': str(source), 'sha256': sha(source)},
  'root_approval': {'path': str(approval), 'sha256': sha(approval)},
  'searches': searches, 'new_files': newfiles, 'prior_family_path_inventory': before_paths,
  'unchanged_dependencies': [{'path': str(p), 'sha256': sha(p)} for p in deps],
  'declaration_map': [{'draft': n, 'canonical': n.replace('LogicalLineBalanceDraft', 'CoordinateLineBalance')}
    for n in decls], 'semantic_changes': [],
  'editorial_changes': ['Correct malformed scratch module-doc header in new copies only.',
    'Add scope-specific module docs and missing sweep/witness docstrings.',
    'Split balance, sweep and witness ownership; preserve generic declaration namespace below NumStability.'],
  'scope': 'New generic leaves only; no source interpretation, gate, aggregate, tier or prior artifact edits.'}
(task / 'placement-initial.json').write_bytes((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(newfiles, indent=2))
