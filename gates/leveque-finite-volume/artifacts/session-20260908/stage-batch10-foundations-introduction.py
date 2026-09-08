"""Stage only reviewed nine-leaf production and frozen placement evidence."""
from pathlib import Path
import argparse,hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--review-sha256',required=True);p.add_argument('--imports-sha256',required=True);a=p.parse_args()
assert os.name!='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
assert sha(S/'root-batch10-production-placement-verification.json')==a.review_sha256
assert sha(S/'batch10-analysis-imports.json')==a.imports_sha256
review=read(S/'root-batch10-production-placement-verification.json')
assert review['status']=='PASS' and review['source_acceptance'] is False
m=read(S/'batch10-analysis-imports.json')
assert m['all_new_files']==review['files'] and len(m['all_new_files'])==9
for f in m['all_new_files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/m['path'])==m['after_sha256']
labels=['batch10-foundations-full-build','root-batch10-campaign-before-exposure']
for label in labels:
 e=read(S/(label+'-exit.json'));assert type(e['exit_code']) is int and e['exit_code']==0
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
paths=[R/f['path'] for f in m['all_new_files']]+[R/m['path']]
folders=['information-method-production','riemann-information-only-method-draft',
 'information-coordinate-sweep-draft','information-coordinate-production',
 'returned-field-coordinate-sweep-draft']
for name in folders:
 for q in (S/name).rglob('*'):
  if q.is_file():
   assert not q.is_symlink()
   assert '__pycache__' not in q.parts and q.suffix!='.pyc',q
   paths.append(q)
names=['root-batch10-production-placement-verification.json',
 'root-information-method-production-verification.json','verify-information-method-production-root.py',
 'information-method-root-verifier-derivation.json','prepare-information-method-root-verifier.py',
 'root-information-only-draft-verification.json','verify-information-only-draft-v2.py',
 'information-only-verifier-v2-derivation.json','prepare-information-only-verifier-v2.py',
 'root-information-only-verifier-01-replay.txt','root-information-only-verifier-01-replay-exit.json',
 'root-returned-field-coordinate-sweep-verification.json','verify-returned-field-coordinate-sweep-root.py',
 'returned-field-coordinate-root-verifier-derivation.json',
 'root-information-coordinate-sweep-verification.json','verify-information-coordinate-sweep-root.py',
 'information-coordinate-root-verifier-derivation.json',
 'root-information-coordinate-production-verification.json','verify-information-coordinate-production-root.py',
 'information-coordinate-production-root-verifier-derivation.json',
 'expose-batch10-foundations.py','batch10-analysis-imports.json','stage-batch10-foundations-introduction.py']
for label in labels:names += [label+'-exit.json',label+'-output.txt']
paths += [S/n for n in names];paths += list(S.glob('batch10-analysis-before-*.bin'))
for q in paths:assert q.is_file() and not q.is_symlink(),q
rel=sorted({q.relative_to(R).as_posix() for q in paths})
git=lambda *a,**kw:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,**kw)
assert git('rev-parse','HEAD').decode().strip()=='d7e81f23acf1daa1b16b8d8b402036411912fa6b'
assert not git('diff','--cached','--name-only').strip()
spec=S/'batch10-foundations-intro-pathspec.bin'
with spec.open('xb') as f:f.write(b'\0'.join(q.encode() for q in rel)+b'\0')
git('add','--pathspec-from-file='+str(spec),'--pathspec-file-nul')
blobs=git('cat-file','--batch',input=('\n'.join(':'+q for q in rel)+'\n').encode());offset=0
for q in rel:
 end=blobs.index(b'\n',offset);oid,kind,size=blobs[offset:end].decode().split();assert kind=='blob'
 start=end+1;finish=start+int(size);assert blobs[finish:finish+1]==b'\n'
 assert blobs[start:finish]==(R/q).read_bytes(),q;offset=finish+1
assert offset==len(blobs)
out=S/'batch10-foundations-intro-staged-verification.json'
data=dict(schema=1,files=[dict(path=q,sha256=sha(R/q)) for q in rel],all_git_blob_bytes_equal=True,
 method='Exact POSIX traversal and Git cat-file --batch comparison',
 scope='Nine reusable leaves, nine sorted Analysis imports and reviewed frozen placement evidence. No source interpretation, gate acceptance or remote write.')
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
q=out.relative_to(R).as_posix();git('add','--',q);assert git('cat-file','blob',':'+q)==out.read_bytes()
print(json.dumps(dict(verified_files=len(rel),receipt_sha256=sha(out))))

