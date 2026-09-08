"""Prepare exact type checks and the unpromoted capstone reconstruction."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3]
read=lambda p:json.loads(p.read_bytes());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
m=read(P/'placement-inputs.json')
assert sha(P/'placement-inputs.json')=='c7791025e50269abd0e74d719651f92dac725b3df5d918e7edf0664a5c4d1c72'
old=R/m['old_candidate']['path'];assert sha(old)==m['old_candidate']['sha256']
src=old.read_text(encoding='utf-8')
a=src.index('/-- Concrete normalized-volume assignment');b=src.index('/-- The existing multidimensional volume operator')
contract=src[a:b].replace('theorem cellVolumeAssignment_contract','theorem cellVolumeAssignment_contract_fromCanonical')
bridge='NumStability.VolumeAveragePlacementBridge.cellVolumeAssignment_contract_fromCanonical'
pairs=[(d['old'],d['new']) for f in m['new_files'] for d in f['declarations']]
pairs.append(('NumStability.HeterogeneousVolumeDraft.cellVolumeAssignment_contract',bridge))
header=''.join('import '+f['module']+'\n' for f in m['new_files'])+'import Lean\n\n'
composition='\nnamespace NumStability.VolumeAveragePlacementBridge\nvariable {Point E Cell : Type*} [MeasurableSpace Point]\n  [NormedAddCommGroup E] [NormedSpace ℝ E]\n\n'+contract+'end NumStability.VolumeAveragePlacementBridge\n'
checker='''\nopen Lean Elab Command Meta in
run_cmd do
  let pairs : List (String × String) := [
PAIRS]
  for (oldString, newString) in pairs do
    let oldName := oldString.toName
    let newName := newString.toName
    elabCommand (← `(command| #check $(mkIdent newName)))
    elabCommand (← `(command| #print axioms $(mkIdent newName)))
    for axiomName in (← Lean.collectAxioms newName) do
      unless [``propext, ``Classical.choice, ``Quot.sound].contains axiomName do
        throwError "Disallowed axiom {axiomName}"
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
  logInfo "CHECKED_PRODUCTION_DECLARATIONS 14"
  logInfo "CHECKED_COMPOSITION_BRIDGES 1"
'''
checker=checker.replace('PAIRS',',\n'.join('    ('+json.dumps(x)+', '+json.dumps(y)+')' for x,y in pairs))
out=P/'CheckDeclarations.lean'
with out.open('x',encoding='utf-8',newline='') as f:f.write(header+src+composition+checker)
record={'checked_source':{'path':out.relative_to(R).as_posix(),'sha256':sha(out)},
 'old_candidate':m['old_candidate'],'new_files':m['new_files'],'pairs':pairs,
 'scope':'Fourteen production declaration types and one scratch capstone reconstruction. Definitional type comparison plus separately checked source proofs; not source acceptance.'}
p=P/'comparison-inputs.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'checks_sha256':sha(out),'comparison_sha256':sha(p),'production_declarations':14,'bridges':1}))

