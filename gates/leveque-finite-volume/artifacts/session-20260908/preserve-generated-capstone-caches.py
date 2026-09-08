"""Preserve exact audit bytes while removing two generated caches from Git tracking."""
from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
git=lambda *a,**kw:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,**kw)
assert git('rev-parse','HEAD').decode().strip()=='24b3a281d19aac39ee745a4168a877bd82f78208'
assert not git('diff','--cached','--name-only').strip()
P=S/'generated-capstone-cache-preservation';P.mkdir(exist_ok=False)
records=[]
for name in ['capstones-final-03.olean','measure-final-02.olean']:
 p=S/'prospective-density-material-riemann-capstones-draft'/name
 rel=p.relative_to(R).as_posix();data=p.read_bytes()
 assert git('cat-file','blob','HEAD:'+rel)==data
 snapshot=P/(name+'.snapshot.bin')
 with snapshot.open('xb') as f:f.write(data)
 assert snapshot.read_bytes()==data
 records.append(dict(original_path=rel,original_sha256=sha(p),snapshot_path=snapshot.relative_to(R).as_posix(),snapshot_sha256=sha(snapshot),bytes=len(data),historical_commit='d7e81f23acf1daa1b16b8d8b402036411912fa6b',historical_git_blob=git('rev-parse','HEAD:'+rel).decode().strip()))
git('rm','--cached','--',*[x['original_path'] for x in records])
assert set(git('diff','--cached','--name-only').decode().splitlines())=={x['original_path'] for x in records}
for x in records:
 assert sha(R/x['original_path'])==x['original_sha256']
 assert sha(R/x['snapshot_path'])==x['snapshot_sha256']
 assert not git('ls-files','--',x['original_path']).strip()
 ignored=subprocess.run(['git','-c','core.longpaths=true','check-ignore','--quiet','--',x['original_path']],cwd=R)
 assert ignored.returncode==0
value=dict(schema=1,status='EXACT_GENERATED_CACHE_BYTES_PRESERVED',files=records,only_git_index_deletions=True,original_files_retained_on_disk=True,frozen_manifests_unchanged=True,source_changes=False,reason='Actual layout check rejects tracked generated .olean files. Exact compiled evidence is retained as inert binary snapshots; original generated paths remain available and ignored locally.',replay='For a clean audit-evidence replay, restore only a missing original generated path from its hash-matching snapshot using exclusive creation, verify the original SHA, and then run the unchanged evidence verifier. Do not overwrite existing files or modify old manifests. This is evidence-cache restoration, not a proof or source acceptance.')
out=P/'preservation.json'
with out.open('x',encoding='utf-8') as f:json.dump(value,f,indent=2);f.write('\n')
print(json.dumps(dict(status=value['status'],receipt_sha256=sha(out),files=records)))

