"""Stage the cache diagnosis using the same Git runtime as the guard."""
from pathlib import Path
import hashlib,json,os,subprocess
P=Path(__file__).resolve();A=P.parent.parent;R=A.parents[4]
assert os.name!='nt' and R.name=='lean-computational-mathematics'
sha=lambda b:hashlib.sha256(b).hexdigest()
def git(*args):
 r=subprocess.run(['/usr/bin/git',*args],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert r.returncode==0,(args,r.returncode,r.stdout.decode(errors='replace'),r.stderr.decode(errors='replace'));return r.stdout
assert git('rev-parse','HEAD').strip()==b'b19095e6289f197b25651e57d49b4b6ebce22be8'
assert not git('diff','--cached','--name-only','-z')
ledger=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
files=sorted(p for p in A.rglob('*') if p.is_file())+[ledger]
assert all(p.suffix not in {'.olean','.ilean','.rs','.c','.cc','.h'} for p in files)
records=[]
for p in files:
 raw=p.read_bytes();expected=raw.replace(b'\r\n',b'\n') if p==ledger else raw
 records.append({'path':p.relative_to(R).as_posix(),'worktree_sha256':sha(raw),'staged_sha256':sha(expected)})
for off in range(0,len(records),30):git('add','--',*[v['path'] for v in records[off:off+30]])
assert set(git('diff','--cached','--name-only','-z','--no-renames').decode().strip('\x00').split('\x00'))=={v['path'] for v in records}
for v in records:assert sha(git('show',':'+v['path']))==v['staged_sha256'],v['path']
git('diff','--cached','--check','--','.',':(exclude)'+A.relative_to(R).as_posix()+'/**')
git('-c','core.whitespace=blank-at-eol,space-before-tab,cr-at-eol,-blank-at-eof','diff','--cached','--check')
out=A/'staged-verification.json'
data=(json.dumps({'kind':'posix-git-exact-cache-diagnosis-staging','files':records,'count':len(records),'git_runtime':'/usr/bin/git','configuration_mutated':False,'outside_archive_default_hygiene_exit':0,'frozen_archive_framing_hygiene_exit':0},indent=2)+'\n').encode()
with out.open('xb') as f:f.write(data)
git('add','--',out.relative_to(R).as_posix());assert git('show',':'+out.relative_to(R).as_posix())==data
print(json.dumps({'status':'POSIX_STAGE_VERIFIED','files':len(records)+1,'receipt_sha256':sha(data)}))
