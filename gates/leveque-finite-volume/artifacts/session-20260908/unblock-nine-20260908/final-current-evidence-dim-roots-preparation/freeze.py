"""Freeze this reviewed-only derivation after its actual pure guard run."""
from pathlib import Path
from datetime import datetime, timezone
import difflib
import hashlib
import json

folder = Path(__file__).resolve().parent
D = folder.parent
R = D.parents[4]
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
ref = lambda path: {'path': path.relative_to(R).as_posix(), 'sha256': sha(path)}
read = lambda path: json.loads(path.read_bytes())
original = D / 'prepare-final-current-evidence-inputs.py'
successor = D / 'prepare-final-current-evidence-inputs-dim-roots-v2.py'
assert sha(original) == '584f7ff9a7ad2ece92d0ce0ee4bf5cb12223d198c9dbd5e75fc8bc1303b1004c'
receipt = read(folder / 'tests01/receipt.json')
assert receipt['exit_code'] == 0 and receipt['inputs_unchanged'] is True
for item in receipt['inputs']:
    assert sha(Path(item['path'])) == item['sha256']
assert sha(folder / 'tests01/stdout.txt') == receipt['stdout_sha256']
assert sha(folder / 'tests01/stderr.txt') == receipt['stderr_sha256']
result = read(folder / 'tests01/stdout.txt')
diff = ''.join(difflib.unified_diff(original.read_text(encoding='utf-8').splitlines(keepends=True),
                                  successor.read_text(encoding='utf-8').splitlines(keepends=True),
                                  fromfile=original.name, tofile=successor.name))
with (folder / 'successor.diff').open('x', encoding='utf-8', newline='\n') as stream:
    stream.write(diff)
inventory = [ref(successor), ref(original)] + [ref(path) for path in sorted(folder.rglob('*')) if path.is_file()]
record = {'format': 'reviewed-only-final-evidence-assembler-successor-1',
          'frozen_at': datetime.now(timezone.utc).isoformat(), 'status': 'ROOT_REVIEW_REQUIRED',
          'successor': ref(successor), 'original_unchanged': ref(original), 'files': inventory,
          'actual_tests': {'receipt': ref(folder / 'tests01/receipt.json'), 'exit_code': 0,
                           'passed': result['passed'], 'posix_execution': True},
          'effective_fingerprints': result['real_effective_fingerprints'],
          'helper_suite': result['real_suite'], 'operational_assembler_invoked': False,
          'actual_all41_acceptance_claim': False, 'info_authority_added': False,
          'audit_execution': False, 'gate_mutation': False, 'git_mutation': False,
          'source_mutation': False}
with (folder / 'final-receipt.json').open('x', encoding='utf-8', newline='\n') as stream:
    stream.write(json.dumps(record, indent=2) + '\n')
print(json.dumps({'receipt': ref(folder / 'final-receipt.json'), 'successor': ref(successor),
                  'passed': result['passed'], 'actual_exit': 0}))
