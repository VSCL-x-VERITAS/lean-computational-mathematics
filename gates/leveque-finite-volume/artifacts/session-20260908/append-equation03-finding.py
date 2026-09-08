"""Append the independent nonacceptance finding without altering its audit."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
path = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
before = path.read_bytes()
ident = 'LEV-C1-ADVECTED-PROFILE-005'
assert ident.encode() not in before
entry = '| LEV-C1-ADVECTED-PROFILE-005 | LEV-CH01-EQ-1.3-ADVECTED-PROFILE | independent solution-domain finding | Equation (1.3) says any profile; the canonical GLOBAL target guarantees classical PDE solvability only for differentiable profiles | Frozen GLOBAL audit is undetermined after 22-trigger adjudication; accepted false; source implies Lean yes, Lean implies source unclear | OPEN and actionable; no closure or source discrepancy certified | decision SHA-256 b23abeb6383d5b4aee51da3ab92bcf113798a63ebed6f17390027cd67681b530; report SHA-256 1ce9fd7e4a837f63409d7a22034c2dca60e3d531763fbb66bb20f85c849c4268; equation03-transport draft and reuse review | Add actual characteristic and rectangle conclusions, retain explicit classical and integral regularity domains, and independently audit the changed target with the same chapter\'s Section 1.1.2 context. Do not rerun the unchanged target seeking a favorable judgment. |\n'
(S / ('ledger-before-equation03-' + hashlib.sha256(before).hexdigest() + '.bin')).write_bytes(before)
after = before.rstrip(b'\r\n') + b'\n' + entry.encode('utf-8')
path.write_bytes(after)
record = {'path': path.relative_to(R).as_posix(), 'id': ident,
    'before_sha256': hashlib.sha256(before).hexdigest(), 'sha256': hashlib.sha256(after).hexdigest()}
(S / 'equation03-finding-ledger-update.json').write_text(json.dumps(record, indent=2)+'\n')
print(json.dumps(record))
