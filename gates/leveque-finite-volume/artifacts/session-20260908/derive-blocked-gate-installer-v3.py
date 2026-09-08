from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=S/'install-reviewed-blocked-gate-v2.py'
assert sha(old)=='1126be629bc417e249f4696bcf41b5d7aff8c3f402af3f835a4db23e02634cd6'
body=old.read_text(encoding='utf-8')
oldblock=""" complete=b.validate_proposed(proposed,context,checker,reader)
 organization=proposed['verification_loops']['organization_completeness']
 cross_gate_before=checker.cross_gate_state(b.ROOT,organization)
 b.require(not cross_gate_before[1],'cross-gate organization mismatch')
"""
newblock=""" organization=proposed['verification_loops']['organization_completeness']
 cross_gate_before=checker.cross_gate_state(b.ROOT,organization)
 b.require(not cross_gate_before[1],'cross-gate organization mismatch')
 complete=b.validate_proposed(proposed,context,checker,reader)
 b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed during validation')
"""
assert body.count(oldblock)==1
body=body.replace(oldblock,newblock)
out=S/'install-reviewed-blocked-gate-v3.py'
with out.open('x',encoding='utf-8',newline='') as f:f.write(body)
d=S/'blocked-gate-installer-v3-derivation.json'
with d.open('x',encoding='utf-8',newline='') as f:json.dump(dict(prior=dict(path=str(old),sha256=sha(old)),derived=dict(path=str(out),sha256=sha(out)),reason='Close the same set-freshness window: snapshot before released proposed validation and require exact equality immediately afterward; retain both write-boundary rescans and all prior guards.'),f,indent=2)
print(json.dumps(dict(installer_sha256=sha(out),derivation_sha256=sha(d))))

