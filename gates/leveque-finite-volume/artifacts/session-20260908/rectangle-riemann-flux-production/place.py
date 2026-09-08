"""Place only the three independently reviewed generic rectangle-interface estimates."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3];D=S/'rectangle-riemann-flux-error-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(D/'Candidate.lean')=='cb128325e7a2a54cf655ab425e58d6ecbf725968ac0bae274554855589c14b9d'
assert sha(D/'manifest.json')=='94e4c859423b7c9eb2d19aba815f69e8ce72642a1447c2bcf2bf80b895906ffd'
source=(D/'Candidate.lean').read_text(encoding='utf-8')
body=source[source.index('open MeasureTheory'):]
body='\n'.join(line for line in body.splitlines() if not line.startswith(('#check','#print')))+'\n'
body=body.replace('NumStability.RectangleFluxErrorDraft','NumStability')
pairs=[('interface_error_le','rectangleRiemannInterfaceFlux_error_le'),('update_error_le','rectangleRiemannInterfaceFlux_update_error_le'),('block_mass_error_le','rectangleRiemannInterfaceFlux_block_mass_error_le')]
for old,new in pairs:body=re.sub(r'\b'+old+r'\b',new,body)
docs=['Numerical-to-local and local-to-global trace bounds control the selected interface flux error.','For the fixed admissible old array, the two face estimates control the next cell-average error.','Only exterior face errors survive in the bound on total block mass error; cancellation is allowed.']
for (_,name),doc in zip(pairs,docs,strict=True):
 needle='theorem '+name;assert body.count(needle)==1
 body=body.replace(needle,'/-- '+doc+' -/\n'+needle)
header='''/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface

/-!
# Conditional errors of selected rectangle Riemann methods

For each admitted ordered adjacent-cell problem, compare the actual selected
numerical flux with the physical trace of its returned local solution, then
compare that trace with an independent global rectangle-conservative field.
Both pointwise error bounds on `(0, dt]` are explicit hypotheses. Constant-state
consistency alone does not imply either bound for unequal data.

Solver admissibility is required only for the fixed old array. The generic
law and method supply no general nonlinear existence, entropy, convergence,
accuracy order, stability or CFL result. The block estimate controls the norm
of total weighted mass error, allowing cancellation between cells.
-/

'''
dest=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RectangleRiemannFluxError.lean'
with dest.open('x',encoding='utf-8',newline='\n') as f:f.write(header+body)
check='import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannFluxError\n'+source
check+='''
open Lean Elab Command Meta in
run_cmd do
  let pairs : List (String × String) := [
'''+',\n'.join('    ("NumStability.RectangleFluxErrorDraft.'+a+'", "NumStability.'+b+'")' for a,b in pairs)+''']
  for (oldString, newString) in pairs do
    let oldName := oldString.toName
    let newName := newString.toName
    elabCommand (← `(command| #check $(mkIdent newName)))
    elabCommand (← `(command| #print axioms $(mkIdent newName)))
    let axioms ← Lean.collectAxioms newName
    for ax in axioms do
      unless [``propext, ``Classical.choice, ``Quot.sound].contains ax do
        throwError "Disallowed axiom {ax}"
    liftTermElabM do
      let oldInfo ← getConstInfo oldName
      let newInfo ← getConstInfo newName
      unless oldInfo.levelParams.length == newInfo.levelParams.length do
        throwError "Universe count mismatch"
      let levels := oldInfo.levelParams.map Level.param
      let newType := newInfo.type.instantiateLevelParams newInfo.levelParams levels
      unless ← withTransparency .all (isDefEq oldInfo.type newType) do
        throwError "Type mismatch {oldName} / {newName}"
      logInfo m!"TYPE_PRESERVED {oldName} => {newName}"
  logInfo "CHECKED_CANONICAL_DECLARATIONS 3"
'''
checkpath=P/'declaration-contract-checks.lean'
with checkpath.open('x',encoding='utf-8',newline='\n') as f:f.write(check)
record={'schema':1,'source':{'path':str(D/'Candidate.lean'),'sha256':sha(D/'Candidate.lean')},'production':{'path':dest.relative_to(R).as_posix(),'sha256':sha(dest)},'comparison':{'path':checkpath.relative_to(R).as_posix(),'sha256':sha(checkpath)},'pairs':pairs,'independent_review':'shock_foundation read-only review: 19 bindings verified, actual v2 success/3 allowed-axiom outputs inspected, no mathematical correction required; source acceptance excluded.','changes':'Namespace/name relocation, per-theorem/module documentation and removal of scratch checks. Mathematical bodies and premises preserved; no aggregate/tier/gate/old-source edit.'}
with (P/'placement-inputs.json').open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
