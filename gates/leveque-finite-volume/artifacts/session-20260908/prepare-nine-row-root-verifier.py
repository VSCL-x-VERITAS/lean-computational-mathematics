from pathlib import Path
import json,hashlib
S=Path(__file__).resolve().parent;P=S/'nine-row-local-route-review-batch10'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(P/'manifest.json')=='270b25158f597e519dfba22957ec89c7afa94941e7035a06b2e2c20a173fb804'
assert sha(P/'local-route-review.json')=='a1f573c281e28f67b42bc22cf01a3209a659eea74c8cf92a86efe401d23ad2cd'
original=(P/'verify_evidence_v3.py').read_text(encoding='utf-8')
assert original.count('HERE=Path(__file__).resolve().parent')==1
body=original.replace('HERE=Path(__file__).resolve().parent',"HERE=Path(__file__).resolve().parent/'nine-row-local-route-review-batch10'")
body=body.replace("out=HERE/'evidence-verification-v3.json'","out=SESSION/'root-nine-row-evidence-verification.json'")
body=body.replace("out.write_text(json.dumps(report,indent=2)","assert not report['mismatches'] and not concurrent\nout.write_text(json.dumps(report,indent=2)")
target=S/'verify-nine-row-evidence-root.py'
with target.open('x',encoding='utf-8',newline='') as f:f.write(body)
d=S/'nine-row-root-verifier-derivation.json'
with d.open('x',encoding='utf-8',newline='') as f:json.dump(dict(source=dict(path=str(P/'verify_evidence_v3.py'),sha256=sha(P/'verify_evidence_v3.py')),derived=dict(path=str(target),sha256=sha(target)),manifest_sha256=sha(P/'manifest.json'),review_sha256=sha(P/'local-route-review.json'),changes='Fix frozen input directory, use new root output, explicitly reject any mismatch/concurrent change. All original byte checks retained. No Lean or source-faithfulness verdict.'),f,indent=2)
print(json.dumps(dict(derived_sha256=sha(target))))

