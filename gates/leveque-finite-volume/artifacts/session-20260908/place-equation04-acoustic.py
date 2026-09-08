"""Place the reviewed thin acoustic wrapper and connect its source aggregate."""
from pathlib import Path
import hashlib, json, subprocess
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
draft = S / 'equation04-acoustic-model/Equation04AcousticModel.lean'
assert sha(draft.read_bytes()) == '05fe4d2f1cda9c311340c41e85830bc7a3873d99efc5d4261c5d754f58546843'
receipt = S / 'equation04-acoustic-model/final-verification.json'
assert sha(receipt.read_bytes()) == 'e593468c786170042743a7c65d131adc21750ef873ba6f0dba5f6db1e15f469e'
head = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'rev-parse', 'HEAD'], cwd=R, text=True).strip()
assert head == '46038487a021089cf26b3327ab5ee5610dfa4a76'
target = R / 'ComputationalMathematics/Source/LeVeque/Chapter01/Equation04AcousticModel.lean'
assert not target.exists()
target.write_bytes(draft.read_bytes())
module = target.relative_to(R).as_posix()[:-5].replace('/', '.')
aggregate = R / 'ComputationalMathematics/Source/LeVeque/Chapter01.lean'
before = aggregate.read_bytes()
lines = before.decode('utf-8').splitlines()
indices = [i for i, line in enumerate(lines) if line.startswith('import ')]
assert indices == list(range(min(indices), max(indices)+1))
imports = {lines[i] for i in indices}
assert 'import '+module not in imports
lines[min(indices):max(indices)+1] = sorted(imports | {'import '+module}, key=str.casefold)
aggregate.write_text('\n'.join(lines)+'\n', encoding='utf-8', newline='\n')
declaration = 'NumStability.leveque01_equation04_acousticOneWayModel'
check = S / 'equation04-acoustic-production-checks.lean'
check.write_text('import '+module+'\n\n#check '+declaration+'\n#print axioms '+declaration+'\n', encoding='utf-8', newline='\n')
record = {'schema': 1, 'files': [{'path': target.relative_to(R).as_posix(),
    'sha256': sha(target.read_bytes()), 'declarations': [declaration]}],
    'check_file_sha256': sha(check.read_bytes()), 'draft_receipt_sha256': sha(receipt.read_bytes()),
    'aggregate': {'path': aggregate.relative_to(R).as_posix(), 'before_sha256': sha(before), 'sha256': sha(aggregate.read_bytes())},
    'organization': 'Covered by the existing reviewed source prefix; exact own introduction metadata may follow its real addition commit.',
    'canonical_validation': 'pending'}
(S / 'equation04-acoustic-production-inputs.json').write_text(json.dumps(record, indent=2)+'\n')
paths = [target.relative_to(R).as_posix(), aggregate.relative_to(R).as_posix()]
subprocess.run(['git', '-c', 'core.longpaths=true', 'add', '--', *paths], cwd=R, check=True)
for path in paths:
    assert subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', ':'+path], cwd=R) == (R/path).read_bytes()
print(json.dumps({'placed': target.relative_to(R).as_posix(), 'declaration': declaration, 'exact_staged_bytes': True}))
