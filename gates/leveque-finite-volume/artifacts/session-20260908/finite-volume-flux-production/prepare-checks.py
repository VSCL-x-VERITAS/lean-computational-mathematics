"""Generate exact-type and axiom checks against immutable pre-extraction drafts."""
from pathlib import Path
import hashlib, json

task = Path(__file__).resolve().parent
session = task.parent
placement = json.loads((task / 'placement-initial.json').read_bytes())
prefix = 'ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'
sources = [
    (session / 'finite-volume-flux-update-repair/candidate.lean',
     'f90dbaa19d16da3617dac27e982557ebe501249afb03566b9bdb6b191ae935be'),
    (session / 'finite-volume-flux-error-estimate/estimate-fragment.lean',
     '051088db0f301ca8942ac9d28ba845ac337148a2013401dd8cf6f7552bb06b7c'),
    (session / 'finite-volume-flux-error-estimate/solver-link-fragment.lean',
     'fbfde84a787291e230c4acc3a24ce4c3d610c81e1ec13ea50667fbad19286c49'),
]
frozen = []
for path, expected in sources:
    content = path.read_bytes()
    assert hashlib.sha256(content).hexdigest() == expected
    frozen.append(content.decode())

pairs = []
for old, new in placement['declaration_renames'].items():
    namespace = 'FVFluxUpdateDraft' if old in [
        'physicalFaceAverage', 'physicalFaceAverage_spec', 'timeStep_smul_physicalFaceAverage',
        'exactCellAverage_mass_balance', 'numericalUpdate_mass_balance',
        'numericalUpdate_weighted_error', 'numericalUpdate_block_error'] else 'FVFluxEstimateDraft'
    pairs.append((f'NumStability.{namespace}.{old}', new))
pairs.append(('NumStability.FVFluxEstimateDraft.norm_le_of_weighted_balance',
              'norm_le_of_weighted_balance'))
pair_text = ',\n    '.join(f'("{old}", "{new}")' for old, new in pairs)
imports = '\n'.join('import ' + prefix + Path(item['path']).stem
                    for item in placement['new_files'])
check = imports + '\nimport Lean\n\n' + '\n'.join(frozen) + '''

/- Exact old-to-new statement equality after transparent expansion of removed aliases.
   Private declarations are resolved from the imported environment, never guessed. -/
open Lean Elab Command Meta in
run_cmd do
  let pairs : List (String × String) := [
    ''' + pair_text + ''']
  let env ← getEnv
  for (oldString, newSuffix) in pairs do
    let oldName := oldString.toName
    let publicName := ("NumStability." ++ newSuffix).toName
    let candidates := env.constants.toList.filter fun (n, _) =>
      n == publicName || (n.toString.startsWith "_private.ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume." &&
        n.toString.endsWith (".NumStability." ++ newSuffix))
    unless candidates.length == 1 do
      throwError "Expected exactly one canonical declaration for {newSuffix}: {candidates.map Prod.fst}"
    let newName := candidates[0]!.1
    elabCommand (← `(command| #check $(mkIdent newName)))
    elabCommand (← `(command| #print axioms $(mkIdent newName)))
    let axioms ← Lean.collectAxioms newName
    let allowed := [``propext, ``Classical.choice, ``Quot.sound]
    for axiomName in axioms do
      unless allowed.contains axiomName do
        throwError "Disallowed axiom {axiomName} in {newName}"
    liftTermElabM do
      let oldInfo ← getConstInfo oldName
      let newInfo ← getConstInfo newName
      unless oldInfo.levelParams.length == newInfo.levelParams.length do
        throwError "Universe count mismatch: {oldName} / {newName}"
      let levels := oldInfo.levelParams.map Level.param
      let newType := newInfo.type.instantiateLevelParams newInfo.levelParams levels
      unless ← withTransparency .all (isDefEq oldInfo.type newType) do
        throwError "Statement mismatch: {oldName} / {newName}"
      logInfo m!"TYPE_PRESERVED {oldName} => {newName}"
  logInfo m!"CHECKED_CANONICAL_DECLARATIONS {pairs.length}"
'''
path = task / 'declaration-contract-checks.lean'
assert not path.exists()
path.write_bytes(check.encode())
print(hashlib.sha256(path.read_bytes()).hexdigest())
