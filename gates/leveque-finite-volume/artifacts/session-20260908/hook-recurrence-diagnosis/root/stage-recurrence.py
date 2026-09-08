"""Stage only the reviewed recurrence archive and the one appended process ledger."""
from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve();A=P.parent.parent;R=A.parents[4]
assert R.name=='lean-computational-mathematics'
sha=lambda b:hashlib.sha256(b).hexdigest()
def git(*args):
 r=subprocess.run(['git','-c','core.longpaths=true',*args],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 if r.returncode:raise RuntimeError(r.stderr.decode('utf-8',errors='replace'))
 return r.stdout
assert git('rev-parse','HEAD').strip()==b'1649167c3c92bc4fd05bd0b2720c077f2f9b3cdc'
assert not git('diff','--cached','--name-only','-z')
receipt=A/'staged-verification.json';assert not receipt.exists()
ledger=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
files=sorted(p for p in A.rglob('*') if p.is_file())+[ledger]
# No external source copy or generated Lean binary belongs in this bounded stage.
assert all(p.suffix not in {'.olean','.ilean','.rs'} for p in files)
records=[]
for p in files:
 rel=p.relative_to(R).as_posix();raw=p.read_bytes()
 expected=raw.replace(b'\r\n',b'\n') if p==ledger else raw
 records.append({'path':rel,'worktree_sha256':sha(raw),'staged_sha256':sha(expected),'bytes':len(expected),'normalization':'declared text eol=lf' if p==ledger else 'binary-preserved artifact'})
for offset in range(0,len(records),40):git('add','--',*[x['path'] for x in records[offset:offset+40]])
actual=set(git('diff','--cached','--name-only','-z','--no-renames').decode().strip('\x00').split('\x00'))
assert actual=={x['path'] for x in records},actual
for row in records:assert sha(git('show',':'+row['path']))==row['staged_sha256'],row['path']
data=(json.dumps({'kind':'exact-bounded-diagnostic-staging','files':records,'count':len(records),'scope':'Recurring Stop timeout evidence and Process068 only; source/gate/production/hook unchanged.'},indent=2)+'\n').encode()
with receipt.open('xb') as f:f.write(data)
rel=receipt.relative_to(R).as_posix();git('add','--',rel);assert git('show',':'+rel)==data
assert not git('diff','--cached','--check')
print(json.dumps({'status':'STAGED_VERIFIED','files':len(records)+1,'receipt_sha256':sha(data)}))

