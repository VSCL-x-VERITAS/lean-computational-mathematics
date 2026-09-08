"""Capture this read-only byte/reference review's actual exit."""
from pathlib import Path
import hashlib,json,subprocess,sys
H=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
command=[sys.executable,'-B',str(H/'check.py')]
assert not (H/'check-01.output.txt').exists()
inputs=[{'path':str(p),'sha256':sha(p)} for p in [H/'check.py',Path(__file__).resolve()]]
run=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
(H/'check-01.output.txt').write_bytes(run.stdout)
receipt={'command':command,'exit_code':run.returncode,'inputs':inputs,'output':{'path':str(H/'check-01.output.txt'),'sha256':sha(H/'check-01.output.txt')},
 'scope':'Read-only bytes and rg searches only; no Git, layout, Lean, rebind or restore operation.'}
with (H/'check-01.exit.json').open('xb') as out:out.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt));raise SystemExit(run.returncode)
