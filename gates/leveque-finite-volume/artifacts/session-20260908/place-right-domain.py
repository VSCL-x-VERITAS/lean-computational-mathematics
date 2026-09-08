"""Place the reviewed positive-ratio right-mode wrapper and connect its aggregate."""
from pathlib import Path
import hashlib, json, subprocess
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
draft = S / 'acoustics-algebraic-domain/AcousticsRightModeAlgebraic.lean'
assert sha(draft.read_bytes()) == '143afa75803d27917e2a1226f56b221bf367899e141e705cf3d3d0b742b06ba9'
receipt = S / 'acoustics-algebraic-domain/final-verification.json'
assert sha(receipt.read_bytes()) == '5b3b37888342d95f0ab13dfa13aba4d2dabe38511b83345153c74eb596804f5e'
head = subprocess.check_output(['git', '-c', 'core.longpaths=true', 'rev-parse', 'HEAD'], cwd=R, text=True).strip()
assert head == 'b05cc4a1a2125ddaef745bc394fe2138dea236d9'
target = R / 'ComputationalMathematics/Source/LeVeque/Chapter01/AcousticsRightModeAlgebraic.lean'
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
declaration = 'NumStability.leveque01_acousticsRightMode_of_pos_ratio'
check = S / 'right-domain-production-checks.lean'
check.write_text('import '+module+'\n\n#check '+declaration+'\n#print axioms '+declaration+'\n', encoding='utf-8', newline='\n')
record = {'schema': 1, 'files': [{'path': target.relative_to(R).as_posix(),
    'sha256': sha(target.read_bytes()), 'declarations': [declaration]}],
    'check_file_sha256': sha(check.read_bytes()), 'draft_receipt_sha256': sha(receipt.read_bytes()),
    'aggregate': {'path': aggregate.relative_to(R).as_posix(), 'before_sha256': sha(before), 'sha256': sha(aggregate.read_bytes())},
    'organization': 'Covered by the existing reviewed source prefix; exact own introduction metadata may follow its real addition commit.',
    'canonical_validation': 'pending'}
(S / 'right-domain-production-inputs.json').write_text(json.dumps(record, indent=2)+'\n')
paths = [target.relative_to(R).as_posix(), aggregate.relative_to(R).as_posix()]
subprocess.run(['git', '-c', 'core.longpaths=true', 'add', '--', *paths], cwd=R, check=True)
for path in paths:
    assert subprocess.check_output(['git', '-c', 'core.longpaths=true', 'show', ':'+path], cwd=R) == (R/path).read_bytes()
print(json.dumps({'placed': target.relative_to(R).as_posix(), 'declaration': declaration, 'exact_staged_bytes': True}))
