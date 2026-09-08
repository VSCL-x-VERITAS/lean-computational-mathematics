from pathlib import Path
import hashlib,json,subprocess,sys,time
P=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
cmd=[sys.executable,'-B',str(P/'verify.py')];tick=time.monotonic()
run=subprocess.run(cmd,cwd=P.parents[4],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
for n,b in [('verification.stdout.json',run.stdout),('verification.stderr.txt',run.stderr)]:
 p=P/n;assert not p.exists();p.write_bytes(b)
files=[{'path':p.name,'sha256':sha(p),'bytes':p.stat().st_size} for p in sorted(P.iterdir()) if p.is_file()]
result={'command':cmd,'actual_exit_code':run.returncode,'elapsed_ms':int(1000*(time.monotonic()-tick)),
 'manifest_sha256':sha(P/'placement-manifest.json'),'files':files,
 'source_acceptance_claimed':False,'remaining_running_sessions':[]}
p=P/'final-receipt.json';assert not p.exists();p.write_bytes((json.dumps(result,indent=2)+'\n').encode())
print(json.dumps({'exit_code':run.returncode,'manifest_sha256':result['manifest_sha256'],'final_receipt_sha256':sha(p),'bound_artifacts':len(files)}))
sys.stdout.flush();sys.stdout.buffer.write(run.stdout);sys.stderr.buffer.write(run.stderr)
sys.exit(run.returncode)
