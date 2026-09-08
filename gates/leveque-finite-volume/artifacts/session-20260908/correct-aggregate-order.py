"""Correct the current aggregate order to the released casefold contract."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
path = R / 'ComputationalMathematics/Analysis.lean'
before = path.read_bytes()
lines = before.decode('utf-8').splitlines()
indices = [i for i, line in enumerate(lines) if line.startswith('import ')]
assert indices and indices == list(range(min(indices), max(indices) + 1))
imports = [lines[i] for i in indices]
assert len(imports) == len(set(imports))
ordered = sorted(imports, key=str.casefold)
assert imports != ordered
(S / ('analysis-before-casefold-' + hashlib.sha256(before).hexdigest() + '.bin')).write_bytes(before)
lines[min(indices):max(indices)+1] = ordered
after = ('\n'.join(lines) + '\n').encode('utf-8')
path.write_bytes(after)
record = {'path': path.relative_to(R).as_posix(), 'before_sha256': hashlib.sha256(before).hexdigest(),
    'sha256': hashlib.sha256(after).hexdigest(), 'import_count': len(imports),
    'change': 'Sort the identical import set with str.casefold, as required by unchanged check_layout.py.',
    'failed_scan': 'production-organized-layout-output.txt', 'failed_exit': 'production-organized-layout-exit.json'}
(S / 'production-aggregate-order-correction.json').write_text(json.dumps(record, indent=2)+'\n', encoding='utf-8')
print(json.dumps(record))
