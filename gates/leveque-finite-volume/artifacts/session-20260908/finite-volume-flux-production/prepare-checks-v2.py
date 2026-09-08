"""Preserve v1's overly strict dt-minus-zero check and add a kernel-checked bridge."""
from pathlib import Path
import hashlib

task = Path(__file__).resolve().parent
source = (task / 'declaration-contract-checks.lean').read_text(encoding='utf-8')
old = '''      unless ← withTransparency .all (isDefEq oldInfo.type newType) do
        throwError "Statement mismatch: {oldName} / {newName}"
      logInfo m!"TYPE_PRESERVED {oldName} => {newName}"'''
new = '''      if newSuffix == "linearRectangleRiemannInterfaceFlux_update_error_le" then
        logInfo m!"TYPE_BRIDGE_BELOW {oldName} => {newName}: sub_zero normalization"
      else
        unless ← withTransparency .all (isDefEq oldInfo.type newType) do
          throwError "Statement mismatch: {oldName} / {newName}"
        logInfo m!"TYPE_PRESERVED {oldName} => {newName}"'''
assert source.count(old) == 1
source = source.replace(old, new)
frozen_path = task.parent / 'finite-volume-flux-error-estimate/solver-link-fragment.lean'
frozen = frozen_path.read_bytes()
assert hashlib.sha256(frozen).hexdigest() == 'fbfde84a787291e230c4acc3a24ce4c3d610c81e1ec13ea50667fbad19286c49'
original = frozen.decode()
statement = original[original.index('theorem linearRule_next_error_bound'):]
statement = statement[:statement.index(' := by')]
statement = statement.replace('theorem linearRule_next_error_bound',
                              'theorem linearRule_next_error_bound_statement_preserved', 1)
source += '\nnamespace NumStability.FVFluxEstimateDraft\nvariable {m : ℕ}\n\n' + statement + ''' := by
  simpa only [FVFluxUpdateDraft.numericalUpdate, sub_zero] using
    linearRectangleRiemannInterfaceFlux_update_error_le grid A hA basis speeds heigen
      hq old hdt i faceBound hold htrace

end NumStability.FVFluxEstimateDraft

#print axioms NumStability.FVFluxEstimateDraft.linearRule_next_error_bound_statement_preserved
'''
path = task / 'declaration-contract-checks-v2.lean'
assert not path.exists()
path.write_bytes(source.encode())
print(hashlib.sha256(path.read_bytes()).hexdigest())
