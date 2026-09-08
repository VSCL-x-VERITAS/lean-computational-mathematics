"""Capture actual static/rejection tests through the existing POSIX launcher."""
from pathlib import Path
import hashlib,json,subprocess,sys
H=Path(__file__).resolve().parent
R=H.parents[4]
W=R.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
command=[sys.executable,'-B',str(W/'workflow-v5.0.1-local/run_workflow_posix.py'),str(H/'check.py')]
assert not (H/'checks-01.output.txt').exists() and not (H/'checks-01.exit.json').exists()
inputs=[{'path':str(p),'sha256':sha(p)} for p in [H/'check.py',H/'construct_request.py',Path(__file__).resolve(),W/'workflow-v5.0.1-local/run_workflow_posix.py']]
run=subprocess.run(command,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
(H/'checks-01.output.txt').write_bytes(run.stdout)
receipt={'schema':1,'command':command,'cwd':str(R),'exit_code':run.returncode,'inputs':inputs,
 'output':{'path':str(H/'checks-01.output.txt'),'sha256':sha(H/'checks-01.output.txt')},
 'scope':'Actual process exit for static/rejection-only tests; no operational constructor use.'}
(H/'checks-01.exit.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps(receipt))
raise SystemExit(run.returncode)
