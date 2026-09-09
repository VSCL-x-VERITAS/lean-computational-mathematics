"""Freeze exact current gate bytes for row census, without asserting acceptance."""
from pathlib import Path
import hashlib, json
from datetime import datetime, timezone
P = Path(__file__).resolve().parent
R = next(p for p in P.parents if (p/'lean-toolchain').is_file())
source = R/'gates/leveque-finite-volume/chapter-01.json'
raw = source.read_bytes()
digest = hashlib.sha256(raw).hexdigest()
assert digest == '96b4f9054479ab03de116275dad733859113d3aabe57392c8b260bbcb35f208b'
gate = json.loads(raw)
assert sum(x['status'] in ('PROVED','REUSED') for x in gate['rows']) == 39
destination = P/'current-gate-snapshot-01.json'
with destination.open('xb') as f: f.write(raw)
assert source.read_bytes() == destination.read_bytes()
receipt = {'format':'exact-current-gate-census-snapshot-1',
 'source_path':source.relative_to(R).as_posix(), 'source_sha256':digest,
 'snapshot_path':destination.relative_to(R).as_posix(), 'snapshot_sha256':digest,
 'captured_at_utc':datetime.now(timezone.utc).isoformat(),
 'closed_rows':39, 'purpose':'Immutable actual row census and prospective target alignment for independent organization measurement.',
 'source_acceptance_added':False, 'operational_gate_unchanged':True}
p=P/'current-gate-snapshot-01-receipt.json'
with p.open('xb') as f: f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps({'snapshot_sha256':digest,'receipt_sha256':hashlib.sha256(p.read_bytes()).hexdigest()}))

