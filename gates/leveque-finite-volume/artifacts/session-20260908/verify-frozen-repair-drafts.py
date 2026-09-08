"""Independently rehash three complete scratch handoffs before checkpointing."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def actual(raw):
 raw=raw.replace('\\','/')
 if raw.startswith('//?/'):raw=raw[4:]
 if re.match(r'^[A-Za-z]:/',raw):raw='/'+raw[0].lower()+raw[2:]
 p=Path(raw)
 if not p.is_absolute():p=R/p
 p=p.resolve();assert p.is_relative_to(R.resolve()),raw
 return p
records=[]
for folder,name,expected,key in [
 ('material-interface-general-draft','final-receipt-v3.json','55cee04c7f94957eed4ad7f2993b2448ca7072665011af5e0ece6d5ee147c858','artifacts'),
 ('finite-volume-flux-update-repair','final-receipt.json','b80b7940589121c479769a24e96fdf380fe8182bd4b9dda04d6aa65b7aa0550a','artifacts'),
 ('nonconservation-integral-source-draft','final-evidence.json','f954d8cbd82bce321580311982847c68a646fb3e227559f1fcd893efcb36e2e3','files')]:
 p=S/folder/name;assert sha(p)==expected
 data=json.loads(p.read_bytes());files=data[key]
 for f in files:
  q=actual(f['path']);assert sha(q)==f['sha256'],str(q)
  if 'bytes' in f:assert q.stat().st_size==f['bytes'],str(q)
 records.append({'receipt':p.relative_to(R).as_posix(),'receipt_sha256':sha(p),'verified_bound_artifact_count':len(files)})
dest=S/'root-batch5-frozen-drafts-verification.json';assert not dest.exists()
dest.write_text(json.dumps({'schema':1,'records':records,'verification':'Independent exact byte hashes and file sizes, with native Windows paths normalized only for locating the same files. Original receipt bytes unchanged. No fresh native replay or source acceptance is asserted.'},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'records':records,'sha256':sha(dest)}))
