"""Read-only verification of the independently reviewed Chapter 1 inventory."""
from pathlib import Path
import hashlib,json

S=Path(__file__).resolve().parent
R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=S/'chapter01-source-inventory-coverage-v2.json'
assert sha(snapshot)=='dbe8481e2d46a033fc5ee4a2cec6213b7e09ac708cf8335d3bb605e16e99447e'
reviewed=json.loads(snapshot.read_text(encoding='utf-8'))
source=R/reviewed['source_path']
assert sha(source)==reviewed['source_sha256']=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
assert reviewed['printed_pages']==[1,11] and reviewed['raw_pdf_pages']==[23,33]
for review in reviewed['reviews']:
    assert sha(R/review['path'])==review['sha256'],review['path']
gate=json.loads((R/'gates/leveque-finite-volume/chapter-01.json').read_text(encoding='utf-8'))
rows={row['id']:row for row in gate['rows']}
assert len(rows)==len(gate['rows'])==57
assert set(rows)=={row['id'] for row in reviewed['rows']}
formalizable=[];skipped=[]
for entry in reviewed['rows']:
    row=rows[entry['id']]
    for field in ['id','source_label','printed_page','pdf_page','row_kind','depends_on','source_proof']:
        assert entry[field]==row.get(field,''),(entry['id'],field)
    assert 1<=row['printed_page']<=11 and row['pdf_page']==row['printed_page']+22
    if entry['disposition'].get('formalizable') is True:
        assert row['status'] in {'READY','IN_PROGRESS','PROVED','REUSED','DISCREPANCY','HARD_BLOCKED','DEPENDENCY_BLOCKED'},row['id']
        formalizable.append(row['id'])
    else:
        for field,value in entry['disposition'].items():assert row.get(field)==value,(row['id'],field)
        assert row['status']=='SKIPPED' and not row.get('lean_declarations')
        skipped.append(row['id'])
assert len(formalizable)==41 and len(skipped)==16
assert reviewed['numbered_equations']==['1.'+str(n) for n in range(1,12)]
assert reviewed['page_without_object']['printed']==9 and reviewed['page_without_object']['raw_pdf']==31
print('Reviewed Chapter 1 source coverage passed: 57 records; 41 formalizable; 16 skipped; all attribution, source/review hashes and skip reasons match.')
