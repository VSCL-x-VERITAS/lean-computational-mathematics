"""Stage exact reviewed production and frozen placement evidence for an introduction commit."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
assert sha(S/'root-batch9-production-placement-verification.json')=='7972c821babf7148e14e7b4c3a8e2ad28fb04a072f795c224163dff7f393cddd'
assert sha(S/'batch9-analysis-imports.json')=='69c97096c18863aa3a4465a87ed2cdb4f8ae1c2d335a1254babfc17469074b74'
m=read(S/'batch9-analysis-imports.json')
for f in m['all_new_files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/m['path'])==m['after_sha256']
labels=['batch9-foundations-full-build','root-batch9-campaign-before-exposure',
 'cell-volume-average-production-build','cell-volume-average-production-declarations']
for label in labels:
 e=read(S/(label+'-exit.json'));assert type(e['exit_code']) is int and e['exit_code']==0
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
paths=[R/f['path'] for f in m['all_new_files']]+[R/m['path']]
for name in ['cell-volume-average-production','returned-field-production','returned-riemann-field-draft']:
 paths += [p for p in (S/name).rglob('*') if p.is_file()]
names=['root-batch9-production-placement-verification.json','verify-batch9-production-placements.py',
 'root-batch9-returned-field-verification.json','verify-batch9-returned-field-draft.py',
 'expose-batch9-foundations.py','batch9-analysis-imports.json','batch9-foundations-organization-review.md',
 'stage-batch9-foundations-introduction.py','place-cell-volume-average-laws.py']
for label in labels:names += [label+'-exit.json',label+'-output.txt']
paths += [S/n for n in names];paths += list(S.glob('batch9-analysis-before-*.bin'))
rel=sorted({p.relative_to(R).as_posix() for p in paths})
git=lambda *a,**kw:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,**kw)
assert not git('diff','--cached','--name-only').strip()
spec=S/'batch9-foundations-intro-pathspec.bin'
with spec.open('xb') as f:f.write(b'\0'.join(p.encode() for p in rel)+b'\0')
git('add','--pathspec-from-file='+str(spec),'--pathspec-file-nul')
blobs=git('cat-file','--batch',input=('\n'.join(':'+p for p in rel)+'\n').encode());offset=0
for p in rel:
 end=blobs.index(b'\n',offset);oid,kind,size=blobs[offset:end].decode().split();assert kind=='blob'
 start=end+1;finish=start+int(size);assert blobs[finish:finish+1]==b'\n'
 assert blobs[start:finish]==(R/p).read_bytes(),p;offset=finish+1
assert offset==len(blobs)
out=S/'batch9-foundations-intro-staged-verification.json'
data={'schema':1,'files':[{'path':p,'sha256':sha(R/p)} for p in rel],
 'all_git_blob_bytes_equal':True,'method':'Exact POSIX traversal and Git cat-file --batch byte comparison',
 'scope':'Six generic leaves, six Analysis imports and reviewed frozen evidence. No source interpretation or gate acceptance.'}
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
path=out.relative_to(R).as_posix();git('add','--',path);assert git('cat-file','blob',':'+path)==out.read_bytes()
print(json.dumps({'verified_files':len(rel),'receipt_sha256':sha(out)}))
