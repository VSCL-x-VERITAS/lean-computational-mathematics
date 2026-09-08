"""Recognize Lean's displayed universe applications on named axioms."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;p=S/'verify-batch8-normalized-volume-draft.py'
src=p.read_text(encoding='utf-8')
old="[x.strip() for x in axioms.split(',') if x.strip()]"
new="[re.sub(r'\\.\\{[^}]*\\}$','',x.strip()) for x in axioms.split(',') if x.strip()]"
assert src.count(old)==1
src=src.replace(old,new)
q=S/'verify-batch8-normalized-volume-draft-v3.py'
with q.open('x',encoding='utf-8',newline='') as f:f.write(src)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
d=S/'batch8-normalized-volume-verifier-v3-derivation.json'
with d.open('x',encoding='utf-8',newline='') as f:
 json.dump({'parent':p.name,'parent_sha256':sha(p),'child':q.name,'child_sha256':sha(q),
 'failed_second_attempt_sha256':sha(S/'verify-batch8-normalized-volume-draft-v2.py'),
 'correction':'Direct inspection of final-checks-output.txt shows Classical.choice.{u} and Quot.sound.{u}. The defect was unparsed universe display, not order. V2 did not fix it and is retained as failed. This child strips only the trailing Lean universe application from each axiom name and preserves original exact ordered-list equality, allowlist and all receipt/source guards.',
 'evidence_output_sha256':sha(S/'heterogeneous-volume-average-draft/final-checks-output.txt')},f,indent=2);f.write('\n')
print(json.dumps({'child_sha256':sha(q),'derivation_sha256':sha(d)}))

