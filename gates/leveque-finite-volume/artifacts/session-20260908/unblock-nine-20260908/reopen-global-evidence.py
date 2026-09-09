"""Invalidate aggregate evidence after the nine-row state transition; preserve prior receipts."""
from pathlib import Path
import hashlib,json,os,subprocess,sys
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3];G=R/'gates/leveque-finite-volume/chapter-01.json'
assert os.name!='nt'
before=G.read_bytes();assert hashlib.sha256(before).hexdigest()=='7d4ca00d459b4d7a445b5cedce446298e9315ee6a27b043a6e32ceb15e33af71'
g=json.loads(before)
with (D/'active-gate-before-evidence-invalidation.json').open('xb') as f:f.write(before)
for name in g['verification_evidence']:g['verification_evidence'][name]={'command':'','artifact':'','artifact_sha256':'','exit_code':None,'count':0}
tmp=G.with_name('chapter-01-reopen-evidence.tmp')
with tmp.open('xb') as f:f.write((json.dumps(g,indent=2,ensure_ascii=False)+'\n').encode());f.flush();os.fsync(f.fileno())
assert G.read_bytes()==before;os.replace(tmp,G)
cmd=[sys.executable,str(R.parent/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'),'check',str(G),'--unit','1','--mode','default']
p=subprocess.run(cmd,capture_output=True)
with (D/'active-gate-validated-output.txt').open('xb') as f:f.write(p.stdout+p.stderr)
receipt={'command':cmd,'exit_code':p.returncode,'gate_sha256':hashlib.sha256(G.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(p.stdout+p.stderr).hexdigest(),'reason':'All global artifacts bind the full gate subject, so reopening rows makes previous aggregate bindings stale. Prior evidence is preserved; fresh aggregate verification remains required.'}
with (D/'active-gate-validated-receipt.json').open('xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print((p.stdout+p.stderr).decode());print(json.dumps(receipt));raise SystemExit(p.returncode)
