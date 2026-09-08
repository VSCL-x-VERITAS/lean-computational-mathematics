"""Add omitted stable attribution/skip fields without changing prior source evidence."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda b:hashlib.sha256(b).hexdigest()
old=S/'chapter01-source-inventory-coverage.json'
assert sha(old.read_bytes())=='4e57afefc9ed96d651da7671f6726107d24bc35e07507a53a619be59af6dcd3c'
v=json.loads(old.read_text());g=json.loads((R/'gates/leveque-finite-volume/chapter-01.json').read_text())
current={r['id']:r for r in g['rows']};assert len(current)==57
for item in v['rows']:
    r=current[item['id']]
    for k in ['id','source_label','printed_page','pdf_page','row_kind','depends_on']:assert item[k]==r[k]
    item['source_proof']=r.get('source_proof','')
    if r['status']=='SKIPPED':
        item['disposition']={k:r[k] for k in ['status','reason_code','reason']}
        assert not r.get('lean_declarations')
v['prior_snapshot_sha256']=sha(old.read_bytes())
v['addendum']='Preserve the original reviewed inventory and counts; make every source_proof attribution and exact skip reason_code explicit. No row, source claim, skip decision, proof or audit outcome changes.'
assert sum(r['disposition'].get('formalizable',False) for r in v['rows'])==41
assert sum(r['disposition'].get('status')=='SKIPPED' for r in v['rows'])==16
dest=S/'chapter01-source-inventory-coverage-v2.json';assert not dest.exists()
dest.write_text(json.dumps(v,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
print(json.dumps({'records':57,'formalizable':41,'skipped':16,'snapshot_sha256':sha(dest.read_bytes())}))
