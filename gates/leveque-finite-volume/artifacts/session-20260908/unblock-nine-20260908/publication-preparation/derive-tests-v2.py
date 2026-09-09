"""Correct only a malformed non-ASCII byte literal in the retained first synthetic test."""
from pathlib import Path
import hashlib
import json
H = Path(__file__).resolve().parent
old = H / 'test-allowlist.py'
text = old.read_text()
line = next(x for x in text.splitlines() if 'actual = m.parse_status(' in x)
replacement = "        actual = m.parse_status((' M a\\0?? space file\\0R  new\\0old\\0A  unicode-' + chr(945) + '.lean\\0').encode('utf-8'))"
assert text.count(line) == 1
new = H / 'test-allowlist-v2.py'
with new.open('xb') as f: f.write(text.replace(line, replacement).encode())
record = {'schema': 1, 'old_sha256': hashlib.sha256(old.read_bytes()).hexdigest(),
          'new_sha256': hashlib.sha256(new.read_bytes()).hexdigest(), 'before': line, 'after': replacement,
          'purpose': 'Test-only byte-literal syntax fix; checker and policy unchanged.'}
with (H / 'tests-v2-derivation.json').open('xb') as f: f.write((json.dumps(record, indent=2) + '\n').encode())
