"""Append observed organization and blind-input handling issues to the session ledger."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
p = R / 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
before = p.read_bytes()
entries = [
 '| BF-LEV-RUN-20260908-011 | 2026-09-08 | aggregate ordering and manifest formatting | The local tier/aggregate helper used case-sensitive sorting and changed the existing JSON indentation. | Released full layout validation found one unsorted Analysis aggregate; the identical import set was sorted with str.casefold and the fresh full scan passed. A parsed-JSON identity receipt restores indent=1, and the current tier validator passes. | Applying the wrong local formatting convention creates avoidable organization debt and diff noise. | repaired; all failed evidence retained | Preserve the repository sort/format contract in future local helpers; do not edit or relax the released validator. production-aggregate-order-correction.json and production-tier-format-receipt.json record exact before/after bytes. |',
 '| BF-LEV-RUN-20260908-012 | 2026-09-08 | sealed v1 blind dependency reuse limitation | Released apply_dependency_reuse.py compact_section emits the original owner_module in the blind role, and reused meanings can retain earlier LocalDef numbers. | The coordinator recorded blind_reuse_limitation_20260908.json, SHA-256 51a4a122f4d7b55552fb8cbc4650ac6eb7a550dc5d3deb8aa8a8e703aa37ace4, in the frozen Eq1.2 orchestration; no blind reuse was applied to the current queue or frozen audits. | Blind reuse could reveal local source ownership or confuse anonymized identifiers. | avoided through the permitted fresh full blind packet path | Keep blind packets fresh and exact. Reuse only direct dependency meanings under the released checks, never their prior decisions or target effects. Preserve the sealed kit unchanged and record actual role inputs and zero tool access. |'
]
text = before.decode('utf-8')
for entry in entries:
    ident = entry.split('|')[1].strip()
    assert ident not in text, ident
(S / ('process-ledger-before-late-' + hashlib.sha256(before).hexdigest() + '.bin')).write_bytes(before)
p.write_bytes(before.rstrip(b'\r\n') + b'\n' + ('\n'.join(entries)+'\n').encode('utf-8'))
record = {'path': p.relative_to(R).as_posix(), 'before_sha256': hashlib.sha256(before).hexdigest(),
    'sha256': hashlib.sha256(p.read_bytes()).hexdigest(), 'added_ids': [e.split('|')[1].strip() for e in entries]}
(S / 'late-process-ledger-update.json').write_text(json.dumps(record, indent=2)+'\n')
print(json.dumps(record))
