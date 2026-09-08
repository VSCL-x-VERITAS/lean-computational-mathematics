import hashlib
import json
from pathlib import Path

D = Path(__file__).resolve().parent
W = D.parents[1]
def ref(p):
    b = p.read_bytes()
    return {'path': str(p), 'sha256': hashlib.sha256(b).hexdigest(), 'bytes': len(b)}

evidence = json.loads((D / 'host-evidence.json').read_bytes())
assert len(evidence['selected_hook_records']) == 2
assert evidence['sqlite']['matching_rows'] == []
receipt = {
    'kind': 'read-only-host-hook-diagnosis', 'new_gate_or_hook_invocations': 0,
    'collector_actual_exit_code': 0, 'host_timeout_root_cause_established': False,
    'source_choice_adoption': False, 'operational_mutations': [],
    'files': [ref(p) for p in sorted(D.iterdir()) if p.is_file() and p.name != 'final-receipt.json'],
    'additional_source_bindings': [ref(p) for p in [
        Path('C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/Lib/subprocess.py'),
        Path('C:/Users/qed_s/.codex/runtimes/formalization-msys2/usr/lib/python3.12/subprocess.py'),
        W / 'workflow-v5.0.1-local/provider-guard-evidence/hooks-list-20260908T062306827949Z.json',
    ]],
    'limits': ['No host runner source implementation was available in the inspected local executable directory; public protocol describes results, not Windows creation internals.',
               'SQLite and rollout search results are bounded observations, not global absence claims.',
               'Root owns actual host flags/environment inspection and any subsequent operational action.'],
}
target = D / 'final-receipt.json'
with target.open('x', encoding='utf-8', newline='\n') as handle:
    handle.write(json.dumps(receipt, indent=2) + '\n')
print(json.dumps({'receipt_sha256': ref(target)['sha256'], 'review_sha256': ref(D / 'REVIEW.md')['sha256'],
                  'host_evidence_sha256': ref(D / 'host-evidence.json')['sha256']}))
