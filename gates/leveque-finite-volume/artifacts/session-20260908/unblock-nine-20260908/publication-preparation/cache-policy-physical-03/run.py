from pathlib import Path
import hashlib,json,subprocess,sys,time
P=Path(__file__).resolve().parent;D=P.parent.parent;R=D.parents[4];W=R.parent
command=[sys.executable,'-X','utf8','-B',str(W/'workflow-v5.0.1-local/run_workflow_posix.py'),str(P/'derive.py')]
start=time.monotonic()
with (P/'stdout.txt').open('xb') as out,(P/'stderr.txt').open('xb') as err:
 result=subprocess.run(command,cwd=R,stdout=out,stderr=err)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt={'argv':command,'exit_code':result.returncode,'elapsed_ms':round((time.monotonic()-start)*1000),
 'stdout_sha256':sha(P/'stdout.txt'),'stderr_sha256':sha(P/'stderr.txt'),'runner_sha256':sha(Path(__file__))}
with (P/'exit.json').open('xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt))
print((P/('stdout.txt' if result.returncode==0 else 'stderr.txt')).read_text(encoding='utf-8'))
sys.exit(result.returncode)
