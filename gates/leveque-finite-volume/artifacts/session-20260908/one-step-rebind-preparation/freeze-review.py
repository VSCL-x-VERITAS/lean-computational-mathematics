"""Record preparation artifacts only; do not execute rebind mutations."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json
P=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for p in P.glob('*.py'):ast.parse(p.read_text(encoding='utf-8'))
positive=json.loads((P/'preflight-review-01/summary.json').read_bytes())
negative=json.loads((P/'negative-checks.json').read_bytes())
assert positive['mode']=='preflight-only' and positive['exit_code']==0
assert positive['gate_before_sha256']==positive['gate_after_sha256']
assert negative['exit_code']==0 and negative['count']==14
assert negative['gate_before_sha256']==negative['gate_after_sha256']
assert negative['driver_main_invoked'] is False and negative['mutation_entry_invoked'] is False
record={'schema':1,'reviewed_at_utc':datetime.now(timezone.utc).isoformat(),'scope':'Independent coordinator code/evidence review and read-only positive/negative preflight; no model role, subagent, gate mutation, ledger or audit edit, canonical change, Git staging or commit.','closed_rows_reviewed':positive['closed_count'],'positive_preflight_exit':0,'negative_checks':14,'negative_exit':0,'mutation_driver_executed':False,'driver_sha256':sha(P/'rebind-closed-rows.py'),'scoped_adapter_sha256':sha(P/'rebind-second-order-scoped-row.py'),'reviewed_inputs_sha256':sha(P/'reviewed-inputs.json'),'derivation_sha256':sha(P/'second-order-derivation.json'),'positive_receipt_sha256':sha(P/'preflight-review-01/summary.json'),'negative_receipt_sha256':sha(P/'negative-checks.json'),'files':[{'path':str(p),'sha256':sha(p)} for p in sorted(P.rglob('*')) if p.is_file()],'execution_requires':'Root review followed by explicit --execute; use a fresh label and serialize all gate/production writes. Native proof and audit validators retain their original requirements.'}
out=P/'review-handoff.json';assert not out.exists();out.write_text(json.dumps(record,indent=2,ensure_ascii=True)+'\n',encoding='utf-8',newline='')
print(json.dumps({'status':'reviewed-preparation-only','closed_rows':positive['closed_count'],'driver_sha256':record['driver_sha256'],'adapter_sha256':record['scoped_adapter_sha256'],'handoff_sha256':sha(out),'positive_receipt_sha256':record['positive_receipt_sha256'],'negative_receipt_sha256':record['negative_receipt_sha256']}))
