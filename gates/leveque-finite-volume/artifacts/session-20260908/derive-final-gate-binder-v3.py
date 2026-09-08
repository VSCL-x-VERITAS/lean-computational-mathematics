"""Prepare the final-only binder with pinned v3 validation and complete inventory."""
from pathlib import Path
import ast, hashlib, json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
source=S/'bind-final-gate-evidence-v2.py'
validator=S/'validate-closed-row-audits-v3.py'
assert sha(source)=='ef4d4905688b306cf8a55e622f4c84d48148edf68fbd683bc5596153ba6fdada'
assert sha(validator)=='546d85ce56481fede6b4cfb4d07aa7da76ce8f7fa5fdb6d2e62db7c08434911e'
old=source.read_text(encoding='utf-8-sig')
needle="python_command('audits',(S/'validate-closed-row-audits-v2.py').relative_to(R),['--validate'])"
assert old.count(needle)==1
replacement="assert sha(S/'validate-closed-row-audits-v3.py')=='546d85ce56481fede6b4cfb4d07aa7da76ce8f7fa5fdb6d2e62db7c08434911e'\npython_command('audits',(S/'validate-closed-row-audits-v3.py').relative_to(R),['--validate','--require-all-closed'])"
new=old.replace(needle,replacement)
ast.parse(new)
dest=S/'bind-final-gate-evidence-v3.py'
with dest.open('x',encoding='utf-8',newline='\n') as f:f.write(new)
record={'schema':1,'parent':{'path':source.name,'sha256':sha(source)},'derived':{'path':dest.name,'sha256':sha(dest)},'audit_validator':{'path':validator.name,'sha256':sha(validator)},'changes':['Require the exact v3 validator SHA at binder runtime.','Require the exact audit argument tail --validate --require-all-closed.','Preserve all prior receipt, row, context, axiom, output and released evidence_defects checks.'],'scope':'Prepared only; no binder execution, gate write, source acceptance or final epoch. Root reviewed the single call-site and independent shock_foundation read-only review confirmed v3 output compatibility.'}
p=S/'final-gate-binder-v3-derivation.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({**record,'derivation_sha256':sha(p)}))
