from pathlib import Path
import hashlib,json,re,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_text(encoding='utf-8'))
m=read(S/'one-step-general-production-inputs.json')
for f in m['files']:assert sha(R/f['path'])==f['sha256']
assert sha(S/'one-step-general-production-checks.lean')==m['check_file_sha256']
checks=[]
for label in ['one-step-general-production-build','one-step-general-production-declarations']:
 e=read(S/(label+'-exit.json'));assert e['exit_code']==0 and e['input_commit']==m['input_commit'];assert e['output_sha256']==sha(S/(label+'-output.txt'));checks.append(e)
text=(S/'one-step-general-production-declarations-output.txt').read_text(encoding='utf-8-sig')
for f in m['files']:
 for n in f['declarations']:
  found=re.search(re.escape("'"+n+"' depends on axioms:")+r'\s*\[([^\]]*)\]',text);assert found,n
  assert {x.strip() for x in found.group(1).split(',') if x.strip()}<={'propext','Classical.choice','Quot.sound'}
receipt=S/'one-step-general-production-verification.json';assert not receipt.exists()
receipt.write_text(json.dumps({'schema':1,'files':m['files'],'native_checks':checks,'all_two_declarations_resolve_with_allowed_axioms':True,'aggregate_sha256':sha(R/'ComputationalMathematics/Source/LeVeque/Chapter01.lean'),'source_audit':'pending; original undetermined decision retained'},indent=2)+'\n',encoding='utf-8')
paths=[R/f['path'] for f in m['files']]+[R/'ComputationalMathematics/Source/LeVeque/Chapter01.lean']
paths += [p for p in (S/'one-step-general-domain-draft').rglob('*') if p.is_file()]
paths += [S/name for name in ['one-step-general-production-inputs.json','one-step-general-production-checks.lean','one-step-general-production-build-exit.json','one-step-general-production-build-output.txt','one-step-general-production-declarations-exit.json','one-step-general-production-declarations-output.txt','one-step-general-production-verification.json','prepare-one-step-production-checks.py','verify-stage-one-step-introduction.py','one-step-intro-campaign-exit.json','one-step-intro-campaign-output.txt']]
rel=sorted({p.relative_to(R).as_posix() for p in paths})
git=lambda *a,**kw:subprocess.check_output(['git','-c','core.longpaths=true',*a],cwd=R,**kw)
assert not git('diff','--cached','--name-only').strip(),'Do not include an unrelated index'
spec=S/'one-step-intro-pathspec.bin';assert not spec.exists();spec.write_bytes(b'\0'.join(x.encode() for x in rel)+b'\0')
git('add','--pathspec-from-file='+str(spec),'--pathspec-file-nul')
for p in rel:assert git('cat-file','blob',':'+p)==(R/p).read_bytes(),p
dest=S/'one-step-intro-staged-verification.json';dest.write_text(json.dumps({'files':[{'path':p,'sha256':sha(R/p)} for p in rel],'all_git_blob_bytes_equal':True},indent=2)+'\n',encoding='utf-8')
d=dest.relative_to(R).as_posix();git('add','--',d);assert git('cat-file','blob',':'+d)==dest.read_bytes()
print(json.dumps({'verified_files':len(rel),'verification_sha256':sha(receipt),'staging_receipt_sha256':sha(dest)}))
