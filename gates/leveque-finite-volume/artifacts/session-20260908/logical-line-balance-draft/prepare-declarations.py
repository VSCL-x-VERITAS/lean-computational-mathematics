"""Add exact declaration and allowed-axiom checks to the current scratch candidate."""
from pathlib import Path
import json, re
task = Path(__file__).resolve().parent
source = (task / 'candidate.lean').read_text(encoding='utf-8')
namespace = []
names = []
for line in source.splitlines():
    if line.startswith('namespace '): namespace.append(line.split()[1])
    elif line.startswith('end '): namespace.pop()
    else:
        match = re.match(r'(?:noncomputable )?(?:def|theorem) (\w+)', line)
        if match: names.append('.'.join(namespace + [match[1]]))
reused = ['NumStability.cellVolume_smul_finiteVolumeCellAverageUpdate',
          'NumStability.sum_conservativeFluxDifferenceUpdate',
          'NumStability.orderedOperatorSweep_two', 'Function.update_self', 'Function.update_idem']
source += '\n' + '\n'.join('#check ' + name + '\n#print axioms ' + name for name in names + reused)
source += '''

open Lean Elab Command in
run_cmd do
  let names : List Name := [''' + ', '.join('``' + name for name in names + reused) + ''']
  for name in names do
    let axioms ← Lean.collectAxioms name
    for axiomName in axioms do
      unless [``propext, ``Classical.choice, ``Quot.sound].contains axiomName do
        throwError "Disallowed axiom {axiomName} in {name}"
  logInfo m!"ALLOWED_AXIOMS_VERIFIED {names.length}"
'''
path = task / 'declarations.lean'
assert not path.exists()
path.write_bytes(source.encode())
(task / 'declaration-list.json').write_bytes((json.dumps({'new': names, 'reused': reused}, indent=2) + '\n').encode())
print(len(names), len(reused))
