"""Create a one-task native capture entry using the frozen sentence-scope lineage."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
src=S/'run-root-audit-pipeline.py';text=src.read_text(encoding='utf-8')
def change(old,new):
 global text
 assert text.count(old)==1,old[:100]
 text=text.replace(old,new,1)
old="""handoff=S/'audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/coordinator-handoff-20260908.json'
assert sha(handoff.read_bytes())=='0506bd8f4846d9725c1141b9cc390bf35aa93e67982336c7dca9ded647f71e1f'
entry=next(x for x in json.loads(handoff.read_bytes())['pending'] if x['task_id']==args.task)"""
new="""assert args.task=='LEV-CH01-ADVECTION-LINEAR-FLUX-CONSERVED-CLAIM-CANONICAL-20260908'
handoff=taskdir/'sentence-scope-lineage.json'
assert sha(handoff.read_bytes())=='74fe68c6ce9e15dbc2f8f07fd801905b4b259bf05aa14f553b71608e5203a5be'
entry=json.loads(handoff.read_bytes())
assert entry['task_id']==args.task
for label in ['advection-sentence-route','advection-sentence-prepare']:
 receipt0=json.loads((S/(label+'-exit.json')).read_bytes())
 assert receipt0['exit_code']==0
 assert sha((S/(label+'-output.txt')).read_bytes())==receipt0['raw_output_sha256']"""
change(old,new)
dest=S/'run-advection-sentence-audit-pipeline.py';assert not dest.exists()
dest.write_text(text,encoding='utf-8')
print(json.dumps({'path':str(dest),'sha256':hashlib.sha256(dest.read_bytes()).hexdigest()}))

