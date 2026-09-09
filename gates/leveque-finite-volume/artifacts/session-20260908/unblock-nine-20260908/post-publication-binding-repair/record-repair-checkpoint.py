"""Record actual binding-repair evidence and append the process issue ledger."""
from pathlib import Path
from datetime import datetime, timezone
import collections
import hashlib
import json
import os

assert os.name == 'posix'
P = Path(__file__).resolve().parent
D, S = P.parent, P.parent.parent
R = next(p for p in P.parents if (p / 'lakefile.toml').is_file())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
read = lambda p: json.loads(p.read_bytes())
checks = {}
for label in ('layout', 'tiers', 'compatibility', 'placeholders', 'organization-preflight',
              'full-build', 'declarations', 'gate'):
    receipt = S / ('post-publication-binding-repair-' + label + '-exit.json')
    output = S / ('post-publication-binding-repair-' + label + '-output.txt')
    data = read(receipt)
    assert type(data['exit_code']) is int and data['exit_code'] == 0, label
    assert data['output_sha256'] == sha(output)
    assert data['input_commit'] == 'b8ccf0d8bd610b599b13708e8c8518771bcf71ab'
    assert data['capture_script_sha256'] == sha(D / 'capture-check.py')
    checks[label] = {'receipt': ref(receipt), 'output': ref(output)}
rebind_path = D / 'accepted-row-rebind-runs/post-publication-current39/receipt.json'
rebind = read(rebind_path)
assert rebind['closed_rows_rebound'] == 39 and rebind['status'] == 'PASS'
assert rebind['mode'] == 'APPLIED_GLOBAL_CHECKS_OPEN'
blocker_path = P / 'riemann-blocker-01/receipt.json'
blocker = read(blocker_path)
gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
assert blocker['after_gate_sha256'] == sha(gate_path)
gate = read(gate_path)
counts = collections.Counter(row['status'] for row in gate['rows'])
assert counts == {'PROVED':22, 'REUSED':17, 'IN_PROGRESS':1, 'HARD_BLOCKED':1, 'SKIPPED':16}
ledger = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
prior = ledger.read_bytes()
assert hashlib.sha256(prior).hexdigest() == '283519a2be34129f07110508f8d19eaa709421ad0c8a7424404c8095a9fb7e1c'
diagnostic_root = R.parent / 'workflow-v5.0.1-local/chapter01-main-publication-b8ccf0d8bd610b599b13708e8c8518771bcf71ab'
dest = P / 'verified-checkpoint'
dest.mkdir(exist_ok=False)
diagnostics = []
for relative in ('closure-timeout-02/RESOLUTION.md', 'metadata-refresh-01/receipt.json',
                 'closure-post-refresh-01/receipt.json', 'closure-post-refresh-01/output.txt'):
    source = diagnostic_root / relative
    target = dest / ('timeout-' + relative.replace('/', '-'))
    target.write_bytes(source.read_bytes())
    diagnostics.append(ref(target))
timeout_receipt = read(diagnostic_root / 'closure-post-refresh-01/receipt.json')
assert timeout_receipt['actual_returncode'] == 1 and not timeout_receipt['interrupted']
assert timeout_receipt['elapsed_seconds'] < 20
record = {
    'kind':'actual-post-publication-binding-repair-checkpoint',
    'recorded_at_utc':datetime.now(timezone.utc).isoformat(),
    'gate':ref(gate_path), 'status_counts':dict(counts),
    'formalized_objects':39, 'remaining_objects':2, 'formalization_denominator':41,
    'formalization_percentage':95.12, 'skipped':16, 'deferred':0,
    'checks':checks, 'accepted_row_rebind':ref(rebind_path), 'user_choice_blocker':ref(blocker_path),
    'timeout_diagnosis':diagnostics,
    'source_relocation':ref(P / 'source-relocation/receipt.json'),
    'organization_relocation':ref(P / 'organization-relocation/receipt.json'),
    'resolution':'POSIX Git index metadata refresh removed the closure-check stall without changing tracked blobs. A later constant-flux theorem was extracted with its name, statement and proof preserved, restoring the old audited Hyperbolicity source exactly. Fresh native builds and declaration checks passed. The unchanged reviewed consumer rebound all 39 accepted rows and retained their semantic judgments.',
    'limits':'The gate remains ACTIVE. Riemann-interface interpretation remains unresolved by explicit user choice. Dimensional splitting still needs a current independent audit; its old prepared task is historical because the relocation changed a dependency import. Native compilation of 41 declarations is not acceptance of 41 source obligations. Global closure evidence remains open. Existing unrelated library warnings are retained. This is a checkpoint, not campaign integration.',
    'released_validators_or_hooks_changed':False, 'new_semantic_judgment':False
}
result_path = dest / 'result.json'
result_path.write_text(json.dumps(record, indent=2)+'\n')
entry = '| LEV-SKILL-PUBLICATION-BINDING-REPAIR-103 | codex-start-1-v5-0-1-20260908 | Closure timeout and current evidence bindings | Mixed native/POSIX index metadata stalled the unchanged checker; published dependency additions made old bindings stale | Refresh index metadata without changing blobs, preserve the audited owner source by extracting the later theorem, and execute native verification plus the unchanged 39-row rebinder | Timeout and stale accepted-row bindings RESOLVED; chapter ACTIVE | ' + ref(result_path)['path'] + ' SHA256 ' + sha(result_path) + ' | No validator or hook weakened; user-retained source ambiguity and unfinished DIM audit remain visible. |\n'
assert b'LEV-SKILL-PUBLICATION-BINDING-REPAIR-103' not in prior and prior.endswith(b'\n')
assert ledger.read_bytes() == prior
with ledger.open('ab') as stream:
    stream.write(entry.encode())
assert ledger.read_bytes() == prior + entry.encode()
receipt = {'result':ref(result_path), 'ledger_before_sha256':hashlib.sha256(prior).hexdigest(),
           'ledger_after':ref(ledger), 'gate_unchanged':ref(gate_path)}
(dest / 'receipt.json').write_text(json.dumps(receipt, indent=2)+'\n')
print(json.dumps(receipt, indent=2))
