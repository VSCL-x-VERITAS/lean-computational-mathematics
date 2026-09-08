"""Record a real read-only recomputation; write receipts only in this scratch directory."""
from pathlib import Path
import hashlib,json,subprocess,sys,time
P=Path(__file__).resolve().parent
def xp(p):return Path(chr(92)*2+'?'+chr(92)+str(Path(p).resolve()))
def sha(b):return hashlib.sha256(b).hexdigest()
cmd=[sys.executable,'-B',str(P/'freeze-transport.py'),'--check']
started=time.monotonic()
run=subprocess.run(cmd,cwd=P.parents[4],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
elapsed=time.monotonic()-started
for name,data in [('verification.stdout.json',run.stdout),('verification.stderr.txt',run.stderr)]:
 dest=xp(P/name);assert not dest.exists(),str(dest);dest.write_bytes(data)
files=[]
for p in sorted(P.iterdir()):
 if p.is_file() and p.name!='verification-receipt.json':files.append({'path':p.name,'sha256':sha(xp(p).read_bytes()),'bytes':p.stat().st_size})
receipt={'command':cmd,'cwd':str(P.parents[4]),'actual_exit_code':run.returncode,
 'elapsed_seconds':elapsed,'stdout_sha256':sha(run.stdout),'stderr_sha256':sha(run.stderr),
 'files':files,'candidate_epoch_or_gate_action_performed':False,
 'scope':'Only read-only Git/blob and existing evidence checks were executed. All receipt writes are in this scratch directory.'}
dest=xp(P/'verification-receipt.json');assert not dest.exists()
dest.write_bytes((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps({'actual_exit_code':run.returncode,'receipt_sha256':sha(dest.read_bytes()),'stdout_sha256':sha(run.stdout),'files':len(files)}))
sys.exit(run.returncode)
