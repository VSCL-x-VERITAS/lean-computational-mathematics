"""Capture the actual read-only proposal verification via the prepared POSIX runtime."""
from pathlib import Path
import hashlib,json,subprocess,sys
H=Path(__file__).resolve().parent
R=H.parents[4]
W=R.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
command=[sys.executable,'-B',str(W/'workflow-v5.0.1-local/run_workflow_posix.py'),str(H/'check.py')]
assert not (H/'check-01.output.txt').exists() and not (H/'check-01.exit.json').exists()
inputs=[{'path':str(p),'sha256':sha(p)} for p in [H/'check.py',Path(__file__).resolve(),W/'workflow-v5.0.1-local/run_workflow_posix.py']]
with (H/'check-01.output.txt').open('xb') as stream:
 run=subprocess.run(command,cwd=R,stdout=stream,stderr=subprocess.STDOUT)
receipt={'schema':1,'command':command,'cwd':str(R),'exit_code':run.returncode,'inputs':inputs,
 'output':{'path':str(H/'check-01.output.txt'),'sha256':sha(H/'check-01.output.txt')},
 'scope':'Actual read-only mechanical review. Existing receipts consumed; no prepare/install/native build/new audit/Git mutation.'}
with (H/'check-01.exit.json').open('xb') as out:out.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt));raise SystemExit(run.returncode)
