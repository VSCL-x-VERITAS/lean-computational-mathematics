"""Insert imports locally while preserving the existing aggregate import order."""
from pathlib import Path
import hashlib
import json
F = Path(__file__).resolve().parent
old = F / 'place-v2.py'
assert hashlib.sha256(old.read_bytes()).hexdigest() == '6f6fde77dde89854f8befde43cc5b90bbe38e989d9611ab9fc407955547d1700'
text = old.read_text(encoding='utf-8')
changes = [
    ("    assert not set(imports) & set(new_imports) and imports == sorted(imports)\n", "    assert not set(imports) & set(new_imports)\n    merged_imports = imports.copy()\n    for addition in sorted(new_imports):\n        predecessors = [line for line in merged_imports if line < addition]\n        position = merged_imports.index(max(predecessors)) + 1 if predecessors else 0\n        merged_imports.insert(position, addition)\n    assert [line for line in merged_imports if line not in new_imports] == imports\n"),
    ("'\\n'.join(sorted(imports + new_imports))", "'\\n'.join(merged_imports)")]
for before, after in changes:
    assert text.count(before) == 1
    text = text.replace(before, after)
new = F / 'place-v3.py'
compile(text, new.name, 'exec')
with new.open('xb') as stream:
    stream.write(text.encode())
record = {'parent': {'path': old.name, 'sha256': hashlib.sha256(old.read_bytes()).hexdigest()},
          'output': {'path': new.name, 'sha256': hashlib.sha256(new.read_bytes()).hexdigest()},
          'exact_replacements': [{'before': a, 'after': b} for a, b in changes],
          'prior_attempt': 'Version 2 staged the four verified leaves, then stopped before source/tiers writes because the existing Analysis aggregate is not globally sorted. Version 3 inserts only the new imports beside their alphabetic predecessors and verifies every old import remains in its original order.'}
with (F / 'placement-v3-derivation.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
