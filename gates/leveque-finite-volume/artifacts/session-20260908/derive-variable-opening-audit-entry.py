"""Derive a single-task native audit entry with unchanged fresh-role orchestration."""
from pathlib import Path
import ast,hashlib,json
S=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
parent=S/'run-definition-problem-data-audit-pipeline.py'
assert sha(parent)=='5c7921de3578390e1c35f1784d87b4603eaa4e5bd10316719b21d223bfe168ca'
code=parent.read_text(encoding='utf-8')
for old,new in [
 ('LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908','LEV-CH01-VARIABLE-COEFFICIENT-OPENING-CLAIM-PRODUCTION-20260908'),
 ('problem-data-lineage.json','opening-claim-lineage.json'),
 ('66a036c55b32bbca09db98dc36cacacb38fc0876393c4d5fc2511f2d193b7cc9','2692c5970ed6cff30db1c628a748e9fead70a8c7c116eef37e5b766b2a27f150'),
 ('riemann-problem-data-audit-route','variable-opening-audit-route'),
 ('riemann-problem-data-audit-prepare','variable-opening-audit-prepare')]:
 assert code.count(old)==1,old;code=code.replace(old,new)
ast.parse(code);dest=S/'run-variable-opening-audit-pipeline.py'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(code)
p=S/'variable-opening-audit-entry-derivation.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps({'schema':1,'parent':parent.name,'parent_sha256':sha(parent),'entry':dest.name,'entry_sha256':sha(dest),'changes':'Only task ID, exact source-selection lineage, and successful route/prepare labels. Unchanged tool-free fresh role orchestration, blind masking, worker count 1 and actual native receipts.'},indent=2)+'\n')
print(json.dumps({'entry_sha256':sha(dest),'derivation_sha256':sha(p)}))
