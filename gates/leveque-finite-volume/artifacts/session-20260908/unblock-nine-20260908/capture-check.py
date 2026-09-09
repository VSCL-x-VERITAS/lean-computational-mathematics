"""Capture real POSIX checker or native Lake results with byte-preserving logs."""
from pathlib import Path
import argparse, hashlib, json, os, shutil, subprocess, sys, time
p=argparse.ArgumentParser()
p.add_argument('mode',choices=['python','lake'])
p.add_argument('label')
p.add_argument('arguments',nargs=argparse.REMAINDER)
a=p.parse_args()
D=Path(__file__).resolve().parent
S=D.parent
R=S.parents[3]
W=R.parent
assert a.label.replace('-','').isalnum() and a.arguments
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
out=S/(a.label+'-output.txt')
receipt=S/(a.label+'-exit.json')
assert not out.exists() and not receipt.exists()
if a.mode=='python':
 assert os.name!='nt'
 command=[sys.executable,*a.arguments]
 actual=command
 head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip()
else:
 assert os.name=='nt'
 lake=shutil.which('lake')
 assert lake
 command='lake '+' '.join(a.arguments)
 actual=[lake,*a.arguments]
 head=subprocess.check_output([sys.executable,'-B',str(W/'workflow-v5.0.1-local/run_workflow_posix.py'),
  str(W/'workflow-v5.0.1-local/posix_git.py'),'-C',str(R),'rev-parse','HEAD'],cwd=R,text=True).strip()
start=time.monotonic()
with out.open('xb') as f:
 result=subprocess.run(actual,cwd=R,stdout=f,stderr=subprocess.STDOUT)
record={'command':command,'exit_code':result.returncode,'input_commit':head,
 'elapsed_ms':int((time.monotonic()-start)*1000),'output_sha256':sha(out),
 'capture_script_sha256':sha(Path(__file__))}
if a.mode=='lake':
 record.update(argv=['lake',*a.arguments],native_lake=lake)
with receipt.open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(record))
if result.returncode:print(out.read_text(encoding='utf-8',errors='replace'))
raise SystemExit(result.returncode)
