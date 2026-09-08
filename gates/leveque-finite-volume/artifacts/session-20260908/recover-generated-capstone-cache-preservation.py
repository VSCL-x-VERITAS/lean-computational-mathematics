"""Finish exact cache preservation after the original ignored-path assumption failed."""
from pathlib import Path
import hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'generated-capstone-cache-preservation'
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
git=lambda *a,**kw:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,**kw)
names=['capstones-final-03.olean','measure-final-02.olean']
paths=[(S/'prospective-density-material-riemann-capstones-draft'/n).relative_to(R).as_posix() for n in names]
assert set(git('diff','--cached','--name-only').decode().splitlines())==set(paths)
assert set(git('diff','--cached','--name-only','--diff-filter=D').decode().splitlines())==set(paths)
gitdir=Path(git('rev-parse','--absolute-git-dir').decode().strip()).resolve()
exclude=Path(git('rev-parse','--git-path','info/exclude').decode().strip())
if not exclude.is_absolute():exclude=R/exclude
exclude=exclude.resolve();assert exclude.is_relative_to(gitdir) and not exclude.is_symlink()
before=exclude.read_bytes() if exclude.exists() else b''
backup=P/'git-info-exclude-before.bin'
with backup.open('xb') as f:f.write(before)
lines=before.decode('utf-8').splitlines()
added=['/'+p for p in paths if '/'+p not in lines]
after=before+(b'\n' if before and not before.endswith(b'\n') else b'')+''.join(x+'\n' for x in added).encode()
assert not exclude.exists() or exclude.read_bytes()==before
exclude.parent.mkdir(exist_ok=True)
exclude.write_bytes(after)
records=[]
for name,rel in zip(names,paths,strict=True):
 p=R/rel;snap=P/(name+'.snapshot.bin');data=p.read_bytes()
 assert snap.read_bytes()==data==git('cat-file','blob','HEAD:'+rel)
 assert not git('ls-files','--',rel).strip()
 assert subprocess.run(['git','-c','core.longpaths=true','check-ignore','--quiet','--',rel],cwd=R).returncode==0
 receipt=S/'prospective-density-material-riemann-capstones-draft'/(name[:-6]+'.receipt.json')
 assert receipt.is_file()
 records.append(dict(original_path=rel,original_sha256=sha(p),snapshot_path=snap.relative_to(R).as_posix(),snapshot_sha256=sha(snap),bytes=len(data),native_receipt=dict(path=receipt.relative_to(R).as_posix(),sha256=sha(receipt)),historical_commit='d7e81f23acf1daa1b16b8d8b402036411912fa6b',historical_git_blob=git('rev-parse','HEAD:'+rel).decode().strip()))
manifest=S/'prospective-density-material-riemann-capstones-draft/evidence-manifest.json'
v=dict(schema=1,status='EXACT_GENERATED_CACHE_BYTES_PRESERVED',files=records,original_files_retained_on_disk=True,only_git_index_deletions=paths,original_manifest=dict(path=manifest.relative_to(R).as_posix(),sha256=sha(manifest)),local_exclusion=dict(path=str(exclude),before_sha256=hashlib.sha256(before).hexdigest(),after_sha256=sha(exclude),backup_path=backup.relative_to(R).as_posix(),added_exact_patterns=added),frozen_manifests_unchanged=True,source_changes=False,replay='Establish the same two exact local exclusions in a fresh checkout, restore only missing original generated files from the corresponding snapshots with exclusive creation and SHA/size checks, then run the unchanged old verifier. Local info/exclude is not transported by Git. Existing absolute-path provenance relocation remains a separate limitation; this record does not assert a portable full replay.',prior_failure='preserve-generated-capstone-caches.py actual exit 1 after index removal and byte snapshots because it incorrectly assumed old paths were already ignored. No original source/cache byte or frozen receipt was changed.')
out=P/'preservation.json'
with out.open('x',encoding='utf-8') as f:json.dump(v,f,indent=2);f.write('\n')
print(json.dumps(dict(status=v['status'],sha256=sha(out),files=records)))

