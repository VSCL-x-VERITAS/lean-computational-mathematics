"""Stage explicit frozen audit tasks and successful root evidence, checking blob bytes."""
from pathlib import Path
import argparse,hashlib,json,os,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--label',required=True)
p.add_argument('--task',action='append',required=True,help='TASK_ID=reviewed_decision_sha256')
p.add_argument('--verified-check',action='append',default=[])
p.add_argument('--file',action='append',default=[],help='Exact repository-relative extra file')
a=p.parse_args();assert os.name!='nt' and a.label.replace('-','').isalnum()
read=lambda p:json.loads(p.read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
files={'gates/leveque-finite-volume/chapter-01.json',
 'ledgers/leveque-finite-volume/book-issues/leveque-finite-volume/chapters/chapter-01/issues.md',
 'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'}
def select(path):
 path=path.resolve();assert path.is_relative_to(R) and path.is_file() and not path.is_symlink(),path
 files.add(path.relative_to(R).as_posix())
for name in ['run-root-audit-pipeline.py','validate-closed-row-audits.py','close-reviewed-default-row.py','stage-reviewed-audit-batch.py']:
 select(S/name)
for name in ['coordinator-handoff-20260908.md','coordinator-handoff-20260908.json']:
 select(S/'audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908'/name)
tasks=[]
for spec in a.task:
 ident,expected=spec.split('=',1);taskdir=S/'audits'/ident
 assert sha(taskdir/'faithfulness/decision.json')==expected
 receipt=read(taskdir/'root-pipeline-receipt.json');assert receipt['exit_code']==0
 assert receipt['stdout_sha256']==sha(taskdir/'root-pipeline-output.txt')
 assert receipt['stderr_sha256']==sha(taskdir/'root-pipeline-stderr.txt')
 for path in taskdir.rglob('*'):
  if path.is_file():select(path)
 tasks.append({'task':ident,'decision_sha256':expected})
for label in a.verified_check:
 assert label.replace('-','').isalnum()
 receipt=read(S/(label+'-exit.json'));assert type(receipt['exit_code']) is int and receipt['exit_code']==0
 expected=receipt.get('raw_output_sha256',receipt.get('output_sha256'))
 assert expected==sha(S/(label+'-output.txt'))
 select(S/(label+'-exit.json'));select(S/(label+'-output.txt'))
for extra in a.file:select(R/extra)
gate=read(R/'gates/leveque-finite-volume/chapter-01.json')
for row in gate['rows']:
 if row['status'] in ['PROVED','REUSED','DISCREPANCY']:
  for path in (R/row['faithfulness_task']).parent.joinpath('gate-bindings').rglob('*'):
   if path.is_file():select(path)
selection=S/(a.label+'-selection.json');receipt_path=S/(a.label+'-staged-verification.json');spec_path=S/(a.label+'-pathspec.bin')
assert not any(p.exists() for p in [selection,receipt_path,spec_path])
files.add(selection.relative_to(R).as_posix());paths=sorted(files)
selection.write_text(json.dumps({'schema':1,'files':paths,'reviewed_tasks':tasks,'excluded':'All other active or unselected audit tasks.'},indent=2)+'\n',encoding='utf-8')
spec_path.write_bytes(b'\0'.join(p.encode() for p in paths)+b'\0')
git=lambda *args,**kw:subprocess.check_output(['git','-c','core.longpaths=true',*args],cwd=R,**kw)
git('add','--pathspec-from-file='+str(spec_path),'--pathspec-file-nul')
index={}
for item in git('ls-files','--stage','-z').split(b'\0'):
 if item:
  header,path=item.split(b'\t',1);mode,oid,stage=header.split();assert stage==b'0';index[path.decode()]=oid.decode()
queries=[index[path] for path in paths]
batch=git('cat-file','--batch',input=('\n'.join(queries)+'\n').encode());offset=0;records=[]
for path,oid in zip(paths,queries,strict=True):
 end=batch.index(b'\n',offset);actual,kind,size=batch[offset:end].decode().split();assert actual==oid and kind=='blob'
 start=end+1;finish=start+int(size);assert batch[finish:finish+1]==b'\n'
 data=(R/path).read_bytes();assert batch[start:finish]==data,path
 records.append({'path':path,'sha256':hashlib.sha256(data).hexdigest()});offset=finish+1
assert offset==len(batch)
receipt_path.write_text(json.dumps({'schema':1,'verified_files':len(records),'files':records,'git_blob_bytes_equal_worktree':True,'method':'Complete POSIX traversal and actual git cat-file --batch blob comparison.'},indent=2)+'\n',encoding='utf-8')
rel=receipt_path.relative_to(R).as_posix();git('add','--',rel);assert git('show',':'+rel)==receipt_path.read_bytes()
print(json.dumps({'verified_files':len(records),'receipt':rel,'receipt_sha256':sha(receipt_path),'gate_sha256':sha(R/'gates/leveque-finite-volume/chapter-01.json')}))
