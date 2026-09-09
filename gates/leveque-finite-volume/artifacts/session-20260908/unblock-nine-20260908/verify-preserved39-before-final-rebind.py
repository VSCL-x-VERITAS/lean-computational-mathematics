"""Verify the existing 39 accepted rows and 16 skips across two new bindings.

This read-only guard applies before the final metadata rebind. That later rebind
has its own semantic preservation guards and intentionally updates evidence refs.
"""
from pathlib import Path
import argparse
import hashlib
import json
import os
from datetime import datetime, timezone

assert os.name != 'nt', 'Use POSIX launcher'
D = Path(__file__).resolve().parent
R = next(p for p in D.parents if (p / 'lakefile.toml').exists())
snapshot = D / 'physical-final-organization-preparation/current-gate-snapshot-01.json'
gate = R / 'gates/leveque-finite-volume/chapter-01.json'
sha = lambda raw: hashlib.sha256(raw).hexdigest()
ref = lambda p: {'path': p.relative_to(R).as_posix(), 'sha256': sha(p.read_bytes())}

p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--phase', required=True, choices=['baseline', 'before-dim', 'after-dim', 'before-info', 'after-info', 'pre-batch'])
p.add_argument('--output', type=Path, required=True)
a = p.parse_args()
assert not a.output.exists(), 'Fresh receipt required'
raw = snapshot.read_bytes()
assert sha(raw) == '96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
before = json.loads(raw)
current_raw = gate.read_bytes()
current = json.loads(current_raw)
old_rows = {row['id']: row for row in before['rows']}
now_rows = {row['id']: row for row in current['rows']}
assert len(old_rows) == len(before['rows']) == 57
assert len(now_rows) == len(current['rows']) == 57 and set(old_rows) == set(now_rows)
accepted = {key: row for key, row in old_rows.items() if row['status'] in ['PROVED', 'REUSED']}
skips = {key: row for key, row in old_rows.items() if row['status'] == 'SKIPPED'}
assert len(accepted) == 39 and len(skips) == 16
assert set(old_rows) - set(accepted) - set(skips) == {'LEV-CH01-DIMENSIONAL-SPLITTING', 'LEV-CH01-RIEMANN-INTERFACE-FLUX'}
changed = sorted(key for key, row in {**accepted, **skips}.items() if now_rows[key] != row)
assert not changed, 'Previously accepted or skipped row changed before final metadata rebind: ' + repr(changed)
assert gate.read_bytes() == current_raw
record = {
    'kind': 'actual-preserved39-and16-pre-rebind-check',
    'phase': a.phase, 'recorded_at_utc': datetime.now(timezone.utc).isoformat(),
    'baseline': ref(snapshot), 'actual_gate': ref(gate), 'checker': ref(Path(__file__).resolve()),
    'accepted_rows_exactly_preserved': sorted(accepted),
    'skipped_rows_exactly_preserved': sorted(skips),
    'observed_pending_pair_status': {key: now_rows[key]['status'] for key in sorted(set(old_rows) - set(accepted) - set(skips))},
    'exit_code': 0,
    'limits': 'Full row equality before final metadata rebind only; no new audit acceptance, final source verdict or gate mutation.'}
a.output.parent.mkdir(parents=True, exist_ok=True)
with a.output.open('xb') as f:
    f.write((json.dumps(record, indent=2) + '\n').encode())
print(json.dumps({'receipt': ref(a.output.resolve()), 'preserved_accepted': 39, 'preserved_skipped': 16}))
