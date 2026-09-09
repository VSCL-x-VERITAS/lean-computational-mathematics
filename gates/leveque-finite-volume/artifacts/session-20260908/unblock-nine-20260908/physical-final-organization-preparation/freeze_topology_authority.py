"""Preserve actual topology authority locally; publish only portable provenance."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os
assert os.name == 'posix'
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
source=R/'.formalization/library-topology.json'
raw=source.read_bytes();h=hashlib.sha256(raw).hexdigest()
assert h=='1459fc684433d30e50e5e623e87a7a1772fcb2801ac65b9df4c94dbecbc70709'
top=json.loads(raw)
campaign=next(c for c in top['campaigns'] if c['id']=='leveque-finite-volume-main-2026q3')
assert campaign['owner']=='project-owner'
assert top['shared_anchor']=='9e2225705fed906b1120d55105d607baabef57c9'
folder=R/'.formalization/topology-history'
folder.mkdir(exist_ok=True)
destination=folder/('physical-organization-authority-'+h+'.json')
if destination.exists():assert destination.read_bytes()==raw
else:
    with destination.open('xb') as f:f.write(raw)
assert source.read_bytes()==destination.read_bytes()
receipt={
 'format':'historical-organization-topology-authority-1',
 'source_path':source.relative_to(R).as_posix(),
 'snapshot_path':destination.relative_to(R).as_posix(),'sha256':h,
 'captured_at_utc':datetime.now(timezone.utc).isoformat(),
 'campaign':campaign['id'],'owner':campaign['owner'],'anchor':top['shared_anchor'],
 'source_tree_sha256':'0ce5a7e967129ddd5ff747d255f06fcb38c7620c2cf15802be05ab3fbbb40eda',
 'meaning':'Exact actual current authority bytes preserved locally for this historical organization measurement. Later request and candidate epoch must independently bind their actual topology and lane heads.',
 'full_snapshot_publication':False,'operational_topology_unchanged':True,
 'source_acceptance_added':False}
p=P/'topology-authority-snapshot-01.json'
with p.open('xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps({'portable_receipt':p.relative_to(R).as_posix(),
 'receipt_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'snapshot_sha256':h}))

