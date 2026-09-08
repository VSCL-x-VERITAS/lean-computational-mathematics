"""Stage exact verified FV introduction bytes; no audit, gate, or ledger changes."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3];D=S/'finite-volume-flux-production'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(S/'root-batch7-fv-placement-verification.json')=='a987b8fada4261daa4d69848b99af317f6b489639d36c0a9ce1107a82dc042ce'
m=json.loads((S/'fv-foundations-analysis-imports.json').read_bytes())
for f in m['files']:assert sha(R/f['path'])==f['sha256']
assert sha(R/m['path'])==m['after_sha256']
for label in ['fv-foundations-full-build','fv-foundations-intro-campaign']:
 e=json.loads((S/(label+'-exit.json')).read_bytes());assert e['exit_code']==0
 assert e.get('raw_output_sha256',e.get('output_sha256'))==sha(S/(label+'-output.txt'))
paths=[R/f['path'] for f in m['files']]+[R/m['path']]
paths += [p for p in D.rglob('*') if p.is_file()]
names=['expose-fv-foundations.py','fv-foundations-analysis-imports.json','fv-foundations-organization-review.md','verify-fv-foundations-placement.py','root-batch7-fv-placement-verification.json','stage-fv-foundations-introduction.py']
for label in ['fv-foundations-full-build','fv-foundations-intro-campaign']:
 names.extend([label+'-exit.json',label+'-output.txt'])
paths += [S/n for n in names]
paths += list(S.glob('fv-foundations-analysis-before-*.bin'))
rel=sorted({p.relative_to(R).as_posix() for p in paths})
git=lambda *a:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R)
assert not git('diff','--cached','--name-only').strip()
spec=S/'fv-foundations-intro-pathspec.bin'
with spec.open('xb') as f:f.write(b'\0'.join(p.encode() for p in rel)+b'\0')
git('add','--pathspec-from-file='+str(spec),'--pathspec-file-nul')
for p in rel:assert git('cat-file','blob',':'+p)==(R/p).read_bytes(),p
out=S/'fv-foundations-intro-staged-verification.json'
record={'schema':1,'files':[{'path':p,'sha256':sha(R/p)} for p in rel],'all_git_blob_bytes_equal':True,'method':'Exact selected paths via POSIX traversal and actual Git cat-file blob comparison','scope':'Five reviewed reusable leaves, Analysis imports, and their frozen placement/check artifacts. No gate, ledger, audit, topology or candidate acceptance.'}
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
p=out.relative_to(R).as_posix();git('add','--',p);assert git('cat-file','blob',':'+p)==out.read_bytes()
print(json.dumps({'verified_files':len(rel),'staging_receipt_sha256':sha(out)}))

