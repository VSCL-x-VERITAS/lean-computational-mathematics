"""Adopt the exactly transported role guard and unchanged staged collector."""
from pathlib import Path
import hashlib
import json
import os
assert os.name != 'nt'
P = Path(__file__).resolve().parent
D = P.parent.parent
R = next(p for p in P.parents if (p / 'lean-toolchain').exists())
old = D / 'physical-dim-audit-preparation/role-size-guard'
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': digest(p)}
before = (old / 'guard.py').read_bytes()
assert digest(old / 'guard.py') == '39e28bffe47dce039e70a17450f4ce026b762e78621673ade23cd2c544dcd17a'
old_id = b'LEV-CH01-PHYSICAL-HIGH-RESOLUTION-COORDINATE-SWEEP-PRODUCTION-20260908'
new_id = b'LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908'
assert before.count(old_id) == 1 and before.replace(old_id, new_id) == (P / 'guard.py').read_bytes()
assert digest(P / 'guard.py') == '9ad00aa0324ed47d167d4f7ef44452a14a01d9a11390499e544d14f0d5bb1a41'
assert (P / 'staged.py').read_bytes() == (old / 'staged.py').read_bytes()
assert digest(P / 'staged.py') == '0e64d2d9051d2b5dbeb52ce1aa32f5eb914557c3cea113c856322695cce57e83'
receipt = json.loads((P / 'receipt.json').read_bytes())
assert receipt['actual_guard_exit'] == receipt['actual_staged_exit'] == 0
assert receipt['focused_tests_passed'] == 23 and receipt['operational_plans_created'] == 0
for item in receipt['actual_test_receipts']:
    assert digest(R / item['path']) == item['sha256']
note = P / 'ROOT-ADOPTION.md'
with note.open('x', encoding='utf-8', newline='\n') as f:
    f.write('Root adopts this exact task-bound copy after reviewing REVIEW.md and the actual 23-check receipt. The new guard is byte-for-byte the previously reviewed guard with only the exact task ID literal changed. The staged collector is byte-identical to the previously reviewed helper. The 1,048,576-byte cap, source/blind separation, actual CLI input comparison, genuine collection and adjudication handling, and complete-validation requirements remain intact.\n\nMeasure the newly prepared actual role inputs before launching any role. An oversized input requires a separately reviewed lossless transport; neither truncation nor a fabricated role receipt is allowed. Successful process completion supplies no semantic acceptance by itself.\n')
out = P / 'root-adoption-receipt.json'
with out.open('x', encoding='utf-8', newline='\n') as f:
    json.dump({'review': ref(note), 'guard': ref(P / 'guard.py'), 'staged': ref(P / 'staged.py'),
        'actual_tests': ref(P / 'receipt.json'), 'only_delta': 'exact task ID',
        'operational_plans_created': 0, 'roles_launched': 0}, f, indent=2)
    f.write('\n')
print(json.dumps(ref(out)))
