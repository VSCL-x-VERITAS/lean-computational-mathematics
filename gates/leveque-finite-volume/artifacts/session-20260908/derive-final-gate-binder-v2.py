"""Derive the final evidence binder for the reviewed v2 audit verifier."""
from pathlib import Path
import ast,hashlib,json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
source=S/'bind-final-gate-evidence.py';validator=S/'validate-closed-row-audits-v2.py'
assert sha(validator)=='6beb4fd9fdb5ac2e7d8c66702f9232be797559151ad618d13c19a006b3fea20e'
old=source.read_text(encoding='utf-8-sig')
needle="(S/'validate-closed-row-audits.py').relative_to(R)"
assert old.count(needle)==1
new=old.replace(needle,"(S/'validate-closed-row-audits-v2.py').relative_to(R)")
ast.parse(new)
dest=S/'bind-final-gate-evidence-v2.py'
with dest.open('x',encoding='utf-8',newline='\n') as f:f.write(new)
record={'schema':1,'parent':{'path':source.name,'sha256':sha(source)},'derived':{'path':dest.name,'sha256':sha(dest)},'audit_validator':{'path':validator.name,'sha256':sha(validator)},'changes':['Expected audit command now names the reviewed v2 validator, which preserves ordinary released checks and dispatches the three exact stronger cases to their pinned adapters.'],'preserved':'Every receipt, row, context, axiom, command, output, and released evidence_defects check is unchanged. No gate was written and the binder has not been executed.'}
p=S/'final-gate-binder-v2-derivation.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'derivation_sha256':sha(p)}))

