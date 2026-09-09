"""Preserve the failed name-heuristic attempt; enumerate this exact observed audit scope."""
from pathlib import Path
import hashlib
import json

H = Path(__file__).resolve().parent
old = H / 'prepare-policy.py'
text = old.read_text()
before = "assert all('INTERPRETED' in p for p in audit_prefixes)"
names = [
    'COORDINATE-DIRECTIONAL-METHODS-INTERPRETED', 'COORDINATE-SPLITTING-INTERPRETED',
    'EIGENVALUES-INTERPRETED-PROPAGATION', 'FINITE-VOLUME-FLUX-UPDATE-INTERPRETED',
    'FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED', 'LEFT-MODE-INTERPRETED-DOMAINS',
    'LOCAL-RIEMANN-INFORMATION-INTERFACE-INTERPRETED', 'MATERIAL-AVERAGING-INTERPRETED',
    'MATERIAL-AVG-OPERATORS', 'MATERIAL-INTERFACE-INTERPRETED', 'MATERIAL-INTERFACE-TOPOLOGY-INTERPRETED',
    'RIEMANN-DEFINITION-INTERPRETED', 'RIEMANN-INFORMATION-INTERFACE-INTERPRETED',
    'RIEMANN-MODEL-REFINED', 'SOURCE-SLICES-REFINED', 'SOURCE-TERMS-INTERPRETED']
after = "assert audit_prefixes == sorted(SESSION + 'audits/LEV-CH01-' + name + '-PRODUCTION-20260908/' for name in " + repr(names) + ")"
assert text.count(before) == 1
new = H / 'prepare-policy-v2.py'
with new.open('xb') as f: f.write(text.replace(before, after).encode())
receipt = {'schema': 1, 'old_sha256': hashlib.sha256(old.read_bytes()).hexdigest(),
           'new_sha256': hashlib.sha256(new.read_bytes()).hexdigest(),
           'before': before, 'after': after, 'reason': 'Three actual current-goal audit names use operators/refined naming.'}
with (H / 'policy-v2-derivation.json').open('xb') as f: f.write((json.dumps(receipt, indent=2) + '\n').encode())
