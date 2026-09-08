"""Preserve the nonaccepted acoustic parameter-domain finding and next action."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
A = S / 'audits/LEV-CH01-ACOUSTICS-RIGHT-MODE-CANONICAL-20260908/faithfulness'
decision_bytes = (A / 'decision.json').read_bytes()
assert sha(decision_bytes) == 'a6363aafd8ed62009ba884b91bcabc7d8af735da52d5894375a35344f8eecb28'
decision = json.loads(decision_bytes)
assert decision['accepted'] is False and decision['classification'] == 'undetermined'
assert decision['adjudicated'] is True
assert decision['implications']['source_implies_lean']['verdict'] == 'yes'
assert decision['implications']['lean_implies_source']['verdict'] == 'unclear'
assert json.loads((S / 'right-mode-nonaccepted-complete-exit.json').read_text(encoding='utf-8-sig'))['exit_code'] == 0
ledger = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
before = ledger.read_bytes()
ident = 'LEV-C1-ACOUSTIC-PARAMETER-DOMAIN-008'
assert ident.encode() not in before
entry = '| LEV-C1-ACOUSTIC-PARAMETER-DOMAIN-008 | LEV-CH01-ACOUSTICS-RIGHT-MODE | source-context ambiguity, not a confirmed source defect | The source specifies material names and c=sqrt(K/rho)>0 without enumerating individual sign inequalities | The positive-material target matches all equations, fields, derivatives, normalization and nonvacuity, but its exhaustive source domain is uncertified | undetermined; accepted false after independent adjudication; unclear/yes; both-negative source admissibility is unestablished and the finding is a note | decision SHA-256 a6363aafd8ed62009ba884b91bcabc7d8af735da52d5894375a35344f8eecb28; report SHA-256 6f3dd2a037e7b5cd0edf053cded8b7b1f1b14615c38afd9ed81fb3d229abdd2e | Retain the exact old audit. Search and draft a separate algebraic-domain target using the existing characteristic-combination theorem, nonzero density and positive sound-speed ratio; independently audit any new target without asserting physical admissibility of negative material values. |\n'
(S / ('source-ledger-before-right-mode-' + sha(before) + '.bin')).write_bytes(before)
ledger.write_bytes(before.rstrip(b'\r\n') + b'\n' + entry.encode())
G = R / 'gates/leveque-finite-volume/chapter-01.json'
gb = G.read_bytes()
(S / ('gate-before-right-mode-finding-' + sha(gb) + '.json')).write_bytes(gb)
gate = json.loads(gb)
row = next(r for r in gate['rows'] if r['id'] == 'LEV-CH01-ACOUSTICS-RIGHT-MODE')
assert row['status'] == 'READY'
row['next_foundation'] = 'The frozen positive-material right-mode audit is undetermined after adjudication solely on exhaustive source parameter scope. Reuse the existing generic characteristic-combination theorem to draft and native-check a separate exact algebraic-domain source target, then run fresh independent roles. Preserve the old source-context uncertainty and do not claim negative material parameters are physically admissible.'
G.write_text(json.dumps(gate, indent=2, ensure_ascii=False)+'\n', encoding='utf-8', newline='\n')
record = {'schema': 1, 'finding_id': ident, 'decision_sha256': sha(decision_bytes), 'ledger_sha256': sha(ledger.read_bytes()),
    'gate_sha256': sha(G.read_bytes()), 'status': 'READY; no closure counted'}
(S / 'right-mode-domain-finding-receipt.json').write_text(json.dumps(record, indent=2)+'\n', encoding='utf-8')
print(json.dumps(record))

