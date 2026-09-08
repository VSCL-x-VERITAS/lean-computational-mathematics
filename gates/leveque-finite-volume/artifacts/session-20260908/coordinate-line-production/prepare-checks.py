"""Generate old-to-new type and executed-definition comparisons from frozen input."""
from pathlib import Path
import hashlib, json

task = Path(__file__).resolve().parent
repo = task.parents[4]
placement = json.loads((task / 'placement-initial.json').read_bytes())
source = Path(placement['source']['path']).read_bytes()
assert hashlib.sha256(source).hexdigest() == placement['source']['sha256']
imports = '\n'.join('import ' + str(Path(r['path']).relative_to(repo).with_suffix('')).replace('\\', '.').replace('/', '.')
                    for r in placement['new_files'])
pairs = ',\n    '.join('("' + item['draft'] + '", "' + item['canonical'] + '")'
                        for item in placement['declaration_map'])
text = imports + '\nimport Lean\n\n' + source.decode() + '''

/- Compare all frozen statements and all six executed definitions in Lean. -/
open Lean Elab Command Meta in
run_cmd do
  let pairs : List (String × String) := [
    ''' + pairs + ''']
  for (oldString, newString) in pairs do
    let oldName := oldString.toName
    let newName := newString.toName
    elabCommand (← `(command| #check $(mkIdent newName)))
    elabCommand (← `(command| #print axioms $(mkIdent newName)))
    let axioms ← Lean.collectAxioms newName
    for axiomName in axioms do
      unless [``propext, ``Classical.choice, ``Quot.sound].contains axiomName do
        throwError "Disallowed axiom {axiomName} in {newName}"
    liftTermElabM do
      let oldInfo ← getConstInfo oldName
      let newInfo ← getConstInfo newName
      unless oldInfo.levelParams.length == newInfo.levelParams.length do
        throwError "Universe arity changed: {oldName} / {newName}"
      let levels := oldInfo.levelParams.map Level.param
      let newType := newInfo.type.instantiateLevelParams newInfo.levelParams levels
      unless ← withTransparency .all (isDefEq oldInfo.type newType) do
        throwError "Statement changed: {oldName} / {newName}"
      logInfo m!"TYPE_PRESERVED {oldName} => {newName}"
      match oldInfo, newInfo with
      | .defnInfo oldDef, .defnInfo newDef =>
        let newValue := newDef.value.instantiateLevelParams newDef.levelParams levels
        unless ← withTransparency .all (isDefEq oldDef.value newValue) do
          throwError "Executed definition changed: {oldName} / {newName}"
        logInfo m!"VALUE_PRESERVED {oldName} => {newName}"
      | _, _ => pure ()
  logInfo m!"CANONICAL_AXIOMS_AND_TYPES_VERIFIED {pairs.length}"
'''
path = task / 'declaration-contract-checks.lean'
assert not path.exists()
path.write_bytes(text.encode())
print(hashlib.sha256(path.read_bytes()).hexdigest())
