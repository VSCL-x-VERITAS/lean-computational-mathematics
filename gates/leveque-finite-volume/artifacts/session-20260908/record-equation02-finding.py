"""Retain the rejected canonical model audit and its next concrete foundation."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda data: hashlib.sha256(data).hexdigest()
p = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
before = p.read_bytes()
ident = 'LEV-C1-ADVECTION-MODEL-006'
assert ident.encode() not in before
entry = '| LEV-C1-ADVECTION-MODEL-006 | LEV-CH01-EQ-1.2-ADVECTION | independent omitted-claim finding | The selected scalar paragraph and equation (1.2) assert transport-model satisfaction and real-scalar hyperbolicity | Existing singleton-vector/scalar predicate equivalence is correct but supplies neither assertion | not-faithful-weaker after adjudication; accepted false; Lean implies source no, source implies Lean yes | decision SHA-256 6072faa49270450621c181e13cb3f19aa6eb589c1b5ae950a28c203bd799b2b9; report SHA-256 1463ca982b5f1037d0f4f0cda9af44ef78f8e4f76ca9d8b98d3f1fcc3e88da33 | Preserve the selected claim and rejected audit. Extend the producer with scalar hyperbolicity and an explicit uniform-transport premise implying actual classical or rectangle solutions, with their regularity domains explicit. Audit a new stronger successor. |\n'
(S / ('ledger-before-equation02-' + sha(before) + '.bin')).write_bytes(before)
p.write_bytes(before.rstrip(b'\r\n') + b'\n' + entry.encode('utf-8'))
G = R / 'gates/leveque-finite-volume/chapter-01.json'
gb = G.read_bytes()
(S / ('gate-before-equation02-' + sha(gb) + '.json')).write_bytes(gb)
g = json.loads(gb)
row = next(r for r in g['rows'] if r['id'] == 'LEV-CH01-EQ-1.2-ADVECTION')
assert row['status'] == 'READY'
row['next_foundation'] = 'The frozen canonical predicate-equivalence audit is not-faithful-weaker. Retain that result and extend the source target with scalar hyperbolicity and actual solution satisfaction from an explicit uniform-transport model, with classical/integral regularity domains, then run a fresh stronger-successor audit.'
assert all(v == 0 for v in g['verification_loops']['organization_completeness'].values())
G.write_text(json.dumps(g, indent=2, ensure_ascii=False)+'\n', encoding='utf-8', newline='\n')
print(json.dumps({'ledger_id': ident, 'status': 'READY', 'organization_counters_verified_zero': True}))
