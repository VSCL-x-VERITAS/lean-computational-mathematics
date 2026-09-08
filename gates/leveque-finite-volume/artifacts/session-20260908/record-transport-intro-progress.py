"""Record checked new owners and measured tier debt without claiming source closure."""
from pathlib import Path
import hashlib, json
S = Path(__file__).resolve().parent
R = S.parents[3]
sha = lambda b: hashlib.sha256(b).hexdigest()
for prefix in ['transport-intro-focused-build', 'transport-intro-placeholders']:
    record = json.loads((S / (prefix + '-exit.json')).read_text(encoding='utf-8-sig'))
    assert record['exit_code'] == 0, prefix
layout = (S / 'transport-intro-layout-output.txt').read_text(encoding='utf-8-sig')
for line in ['Lean modules: 5919', 'unclassified modules: 5', 'mixed modules: 0',
             'modules missing module docs: 0', 'legacy naming exceptions: 0',
             'declaration-bearing umbrellas: 0', 'unsorted aggregate imports: 0']:
    assert line in layout, line
assert 'unreachable' not in layout and 'missing direct' not in layout
assert json.loads((S / 'transport-intro-layout-exit.json').read_text(encoding='utf-8-sig'))['exit_code'] == 1
assert json.loads((S / 'transport-intro-tiers-exit.json').read_text(encoding='utf-8-sig'))['exit_code'] == 1
assert '24 axiom report(s)' in (S / 'transport-intro-placeholders-output.txt').read_text(encoding='utf-8-sig')
assert len(json.loads((S / 'transport-intro-rebinding-receipt.json').read_text())) == 4
proof = json.loads((S / 'transport-intro-proof-verification.json').read_text())
assert len(proof['files']) == 8
for f in proof['files']:
    assert sha((R / f['path']).read_bytes()) == f['sha256'], f['path']
ledger = R / 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md'
lb = ledger.read_bytes()
ident = 'LEV-C1-ONE-WAY-ACOUSTIC-MODEL-007'
assert ident.encode() not in lb
entry = '| LEV-C1-ONE-WAY-ACOUSTIC-MODEL-007 | LEV-CH01-EQ-1.4-ONE-WAY-WAVE | independent omitted acoustic connection | The selected one-way-wave passage identifies an acoustic pressure/particle-velocity combination and acoustic sound speed | Old positive-speed scalar/profile model retains correct PDE, direction and nonvacuity but omits that given-system relationship | not-faithful-weaker; accepted false; no/yes; both judges agree and no adjudication required | decision SHA-256 77601b25183ffff2ec98185b1cafe3103e0968a94e151d7ef78d00a7f88fbaee; report SHA-256 7f1020fa672f40b3f6c180de1bf9dd6cf6ac83db2ab5994aaaea5e4668cb326e | Worker is drafting a thin stronger source target reusing the actual acoustic right-mode theorem, explicit w=p+rho*c*u and c=sqrt(K/rho), while retaining the old scalar/direction/profile contract. Preserve the rejected audit; independently audit the successor. |\n'
(S / ('ledger-before-transport-intro-' + sha(lb) + '.bin')).write_bytes(lb)
ledger.write_bytes(lb.rstrip(b'\r\n')+b'\n'+entry.encode('utf-8'))
G = R / 'gates/leveque-finite-volume/chapter-01.json'
before = G.read_bytes()
(S / ('gate-before-transport-intro-' + sha(before) + '.json')).write_bytes(before)
g = json.loads(before)
g['verification_loops']['organization_completeness'] = {
    'unclassified_modules': 5, 'duplicate_wrappers': 0, 'placeholder_findings': 0, 'canonical_placement_pending': 0}
byid = {r['id']: r for r in g['rows']}
for row, task in [
    ('LEV-CH01-EQ-1.2-ADVECTION', 'LEV-CH01-EQ-1.2-UNIFORM-TRANSPORT-PRODUCTION-20260908'),
    ('LEV-CH01-EQ-1.3-ADVECTED-PROFILE', 'LEV-CH01-EQ-1.3-TRANSPORT-INTEGRAL-PRODUCTION-20260908'),
    ('LEV-CH01-RIEMANN-INTERFACE-FLUX', 'LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908')]:
    assert byid[row]['status'] == 'READY'
    byid[row]['next_foundation'] = 'The stronger canonical producer is placed, built and declaration/axiom checked. Complete exact preparation and independent roles for ' + task + ', retaining previous rejected/undetermined outcomes. Bind only after an accepted complete decision.'
byid['LEV-CH01-EQ-1.4-ONE-WAY-WAVE']['next_foundation'] = 'The frozen old model audit is not-faithful-weaker. Complete the stronger given-acoustic-system wrapper draft with explicit pressure/velocity invariant and acoustic speed, then validate and independently audit it without discarding the old scalar contract or rejected audit.'
for name in g['verification_evidence']:
    g['verification_evidence'][name] = {'command': '', 'artifact': '', 'artifact_sha256': '', 'exit_code': None, 'count': 0}
G.write_text(json.dumps(g, indent=2, ensure_ascii=False)+'\n', encoding='utf-8', newline='\n')
print(json.dumps({'placed_modules': 8, 'checked_declarations': 24,
    'organization': g['verification_loops']['organization_completeness'],
    'remaining_rows': sum(r['status'] in ['READY', 'IN_PROGRESS'] for r in g['rows']),
    'next_organization_action': 'Introduce eight exact tier records citing the actual forthcoming source-addition commit.'}))
