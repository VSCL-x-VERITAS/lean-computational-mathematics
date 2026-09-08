"""Freeze reviewed helper and actual synthetic checks; create no candidate or epoch."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
bind=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
receipt=S/'root-batch9-asset-helper-fixtures-exit.json';raw=S/'root-batch9-asset-helper-fixtures-output.txt'
n=json.loads(receipt.read_bytes());tests=json.loads(raw.read_bytes())
assert type(n['exit_code']) is int and n['exit_code']==0
assert sha(raw)==n['raw_output_sha256']=='f7b3213917c0edb02a47fa5cd2b556910844934c5c28e5423dfe4d62ff528b7c'
assert tests['count']==len(tests['checks'])==17
assert tests['released_epoch_schema_sha256']=='15bb5ad7c90672bdeb7466f6343a6f8622e7c07b34567a16fd19c95e8b626fd3'
assert n['command'][1].endswith('/final-epoch-asset-helper-draft/test_prepare_asset_bundle.py')
files=['prepare_asset_bundle.py','mapping.schema.json','test_prepare_asset_bundle.py','REVIEW.md','freeze.py']
data={'schema':1,'status':'PASS','scope':'Reviewed additive preparation helper; synthetic fixtures only',
 'source_acceptance':False,'candidate_created':False,'epoch_created':False,'fixture_count':17,
 'actual_native_receipt':bind(receipt),'actual_output':bind(raw),'artifacts':[bind(P/x) for x in files],
 'root_review':'Root read complete helper, mapping schema, tests and scope review. Explicit concept and policy mapping remains caller-reviewed; only candidate-bound fragments are produced after actual candidate existence, with equal preview/candidate tree and exact committed evidence. No transport, collision, source acceptance or final validation is inferred.',
 'limitations':'Supports one inventoried work lane and empty inspection lanes at the anchor; all declaration policy and producer payloads must be explicitly reviewed candidate blobs. Synthetic fixtures do not validate actual Lean expressions or source judgments.'}
dest=P/'final-receipt.json'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'status':'PASS','receipt':bind(dest),'fixture_count':17,'candidate_or_epoch_created':False}))
