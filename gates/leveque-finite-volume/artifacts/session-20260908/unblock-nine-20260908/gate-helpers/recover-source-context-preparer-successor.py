"""Complete the exact interrupted helper derivation with extended-path I/O."""
from pathlib import Path
import ast
import hashlib
import json
import os
H0 = Path(__file__).resolve().parent
H = Path('\\\\?\\'+str(H0.resolve())) if os.name == 'nt' else H0.resolve()
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
tree = ast.parse((H/'add-source-context-preparer-successor.py').read_text())
changes = ast.literal_eval(next(n.value for n in tree.body if isinstance(n, ast.Assign)
    and any(isinstance(t, ast.Name) and t.id == 'changes' for t in n.targets)))
expected = {'qualified_row_support_v3.py': '59ad410e2d83f8318aa29588a22f0f9be57a608d39d7e0351cef3a6f8c68b8c3',
            'source-context-validation.fragment.py': 'ace962f4229d33f4c3d37a28b47574dd425b428b256dcfc25e47e2b093a6b96f'}
snapshot = H/'source-context-initial-helper-snapshots'
assert snapshot.is_dir()
records = []
for name, original_sha in expected.items():
    path = H/name; saved = snapshot/(name+'.snapshot')
    raw = saved.read_bytes() if saved.exists() else path.read_bytes()
    assert hashlib.sha256(raw).hexdigest() == original_sha
    text = raw.decode()
    for before, after in changes:
        assert text.count(before) == 1
        text = text.replace(before, after)
    compile(text, name, 'exec')
    current = path.read_bytes()
    assert current in (raw, text.encode()), 'Unexpected concurrent helper edit'
    if not saved.exists():
        with saved.open('xb') as handle: handle.write(raw)
    path.write_bytes(text.encode())
    records.append({'path': name, 'initial_snapshot': saved.relative_to(H).as_posix(),
                    'before_sha256': original_sha, 'after_sha256': sha(path),
                    'already_changed_before_recovery': current == text.encode()})
with (H/'source-context-preparer-successor-derivation.json').open('xb') as handle:
    handle.write((json.dumps({'schema': 1, 'files': records, 'exact_replacements': [{'before': a, 'after': b} for a,b in changes],
       'operational_invocations': 0, 'initial_attempt_observed_exit': 1,
       'initial_failure': 'Native MAX_PATH while creating the second historical snapshot; first helper had already been derived.',
       'recovery': 'Verify both original snapshots and exact deterministic outputs; finish only those owned helper writes.'}, indent=2)+'\n').encode())
print(json.dumps(records, indent=2))
