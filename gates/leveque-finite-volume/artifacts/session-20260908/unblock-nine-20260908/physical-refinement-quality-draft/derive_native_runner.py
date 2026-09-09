"""Derive the reviewed append-only native capture for the physical quality draft."""
from pathlib import Path
import hashlib, json, difflib
D = Path(__file__).resolve().parent.parent
P = Path(__file__).resolve().parent
parent = D / 'capacity-coordinate-realization-draft/run_native.py'
before = parent.read_text(encoding='utf-8')
text = before
changes = [
    ("P=D/'capacity-coordinate-realization-draft'", "P=D/'physical-refinement-quality-draft'"),
    ("bridge=D/'capacity-net-reference-error-draft/native-03/Candidate.lean'", "bridge=D/'capacity-ghost-boundary-draft/native-01/Candidate.lean'"),
    ("f0991e78e85488c00d4a30a9ad4d3a8cc7f2bcc2a2f033319784b57ee5a5955b", "f0e3bf9abd1a997f46df663b657a142749213572bbb2ecd16bb71b94e55af2c2"),
]
for old, new in changes:
    assert text.count(old) == 1
    text = text.replace(old, new)
assert text.count('Realization.lean.fragment') == 4
text = text.replace('Realization.lean.fragment', 'PhysicalRefinement.lean.fragment')
compile(text, 'run_native.py', 'exec')
for path, raw in [
    (P / 'run_native.py', text.encode()),
    (P / 'native-runner.diff', ''.join(difflib.unified_diff(before.splitlines(True), text.splitlines(True), str(parent), 'run_native.py')).encode()),
]:
    with path.open('xb') as stream: stream.write(raw)
record = {'parent': {'path': str(parent), 'sha256': hashlib.sha256(parent.read_bytes()).hexdigest()},
          'derived_sha256': hashlib.sha256(text.encode()).hexdigest(),
          'changes': changes, 'source_basename_replacements': 4}
with (P / 'runner-derivation.json').open('xb') as stream:
    stream.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps(record))
