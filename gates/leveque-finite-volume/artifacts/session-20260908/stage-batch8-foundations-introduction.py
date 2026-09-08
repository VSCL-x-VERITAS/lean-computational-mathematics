"""Stage the exact ten-leaf introduction and frozen evidence before organization classification."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
assert sha(S/'root-batch8-placement-verification.json')=='cfa34484713dd89a97e0ab3bcaf67d5819b7dd003ea1447e924c97c4da7b1d39'
assert sha(S/'batch8-analysis-imports.json')=='39a6c1de25e23159d205d1947380461511f46ebeecccf50209e8863814f01027'
m=read(S/'batch8-analysis-imports.json')
for f in m['all_new_files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/m['path'])==m['after_sha256']
labels=['batch8-foundations-full-build-after-exposure','batch8-foundations-intro-campaign','rectangle-riemann-flux-draft-v1','rectangle-riemann-flux-draft-v2','rectangle-riemann-flux-production-build','rectangle-riemann-flux-production-declarations']
for label in labels:
 e=read(S/(label+'-exit.json'));assert type(e['exit_code']) is int and e['exit_code']==0
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
paths=[R/f['path'] for f in m['all_new_files']]+[R/m['path']]
for name in ['jump-balance-production','coordinate-line-production','logical-line-balance-draft','rectangle-riemann-flux-error-draft','rectangle-riemann-flux-production']:
 paths += [p for p in (S/name).rglob('*') if p.is_file()]
names=['root-batch8-placement-verification.json','verify-batch8-foundation-placements.py','verify-batch8-foundation-placements-v2.py','derive-batch8-placement-verifier-v2.py','batch8-placement-verifier-v2-derivation.json','root-batch8-logical-line-verification.json','verify-logical-line-draft.py','verify-logical-line-draft-v2.py','derive-logical-line-verifier-v2.py','logical-line-verifier-v2-derivation.json','expose-batch8-foundations.py','batch8-analysis-imports.json','batch8-foundations-organization-review.md','stage-batch8-foundations-introduction.py']
for label in labels:names += [label+'-exit.json',label+'-output.txt']
paths += [S/n for n in names];paths += list(S.glob('batch8-analysis-before-*.bin'))
rel=sorted({p.relative_to(R).as_posix() for p in paths})
git=lambda *a,**kw:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,**kw)
assert not git('diff','--cached','--name-only').strip()
spec=S/'batch8-foundations-intro-pathspec.bin'
with spec.open('xb') as f:f.write(b'\0'.join(p.encode() for p in rel)+b'\0')
git('add','--pathspec-from-file='+str(spec),'--pathspec-file-nul')
query=('\n'.join(':'+p for p in rel)+'\n').encode()
blobs=git('cat-file','--batch',input=query);offset=0
for p in rel:
 end=blobs.index(b'\n',offset);oid,kind,size=blobs[offset:end].decode().split();assert kind=='blob'
 start=end+1;finish=start+int(size);assert blobs[finish:finish+1]==b'\n'
 assert blobs[start:finish]==(R/p).read_bytes(),p;offset=finish+1
assert offset==len(blobs)
out=S/'batch8-foundations-intro-staged-verification.json'
record={'schema':1,'files':[{'path':p,'sha256':sha(R/p)} for p in rel],'all_git_blob_bytes_equal':True,'method':'Exact POSIX traversal and Git cat-file --batch byte comparison','scope':'Ten reviewed generic leaves, nine Analysis imports and frozen evidence. Source interpretations remain pending; no gate, audit, ledger, candidate or integration acceptance.'}
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
path=out.relative_to(R).as_posix();git('add','--',path);assert git('cat-file','blob',':'+path)==out.read_bytes()
print(json.dumps({'verified_files':len(rel),'receipt_sha256':sha(out)}))
