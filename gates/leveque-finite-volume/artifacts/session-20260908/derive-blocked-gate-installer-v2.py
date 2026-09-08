from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=S/'install-reviewed-blocked-gate.py'
assert sha(old)=='7a58407aa57755f95d4905708c8185e0f61bc90dee9535c86dca89f1e39ad0b6'
body=old.read_text(encoding='utf-8')
a=" complete=b.validate_proposed(proposed,context,checker,reader)\n"
assert body.count(a)==1
body=body.replace(a,a+" organization=proposed['verification_loops']['organization_completeness']\n cross_gate_before=checker.cross_gate_state(b.ROOT,organization)\n b.require(not cross_gate_before[1],'cross-gate organization mismatch')\n")
a=" b.require(checker.current_context(b.GATE,1)==context,'context changed before installation')\n"
assert body.count(a)==1
body=body.replace(a,a+" b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed before installation')\n")
a="  b.require(checker.current_context(b.GATE,1)==context and b.GATE.read_bytes()==original,'context/gate changed at write boundary')\n"
assert body.count(a)==1
body=body.replace(a,a+"  b.require(checker.cross_gate_state(b.ROOT,organization)==cross_gate_before,'cross-gate set/counters changed at write boundary')\n")
out=S/'install-reviewed-blocked-gate-v2.py'
with out.open('x',encoding='utf-8',newline='') as f:f.write(body)
d=S/'blocked-gate-installer-v2-derivation.json'
with d.open('x',encoding='utf-8',newline='') as f:json.dump(dict(prior=dict(path=str(old),sha256=sha(old)),derived=dict(path=str(out),sha256=sha(out)),reason='Independent review found current_context/known-file hashes do not cover newly added cross-gate files. Add exact set/counter rescans at initial validation and both write boundaries; retain all original guards and no terminal claim. Installer still requires exclusive root ownership among cooperating gate writers.'),f,indent=2)
print(json.dumps(dict(installer_sha256=sha(out),derivation_sha256=sha(d))))

