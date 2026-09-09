from pathlib import Path
import hashlib,json,subprocess,sys,time
P=Path(__file__).resolve().parent
x=json.loads((P/'run-inputs.json').read_bytes());R=Path(x['root']);W=R.parent
command=[sys.executable,'-X','utf8','-B',str(W/'workflow-v5.0.1-local/run_workflow_posix.py'),str(P/'assess.py'),
 '--root',str(R),'--config',str(R/x['config']['path']),'--config-sha256',x['config']['sha256'],
 '--gate-sha256',x['gate']['sha256'],'--output',x['output']]
start=time.monotonic()
with (P/'analysis-stdout.txt').open('xb') as out,(P/'analysis-stderr.txt').open('xb') as err:
 result=subprocess.run(command,cwd=R,stdout=out,stderr=err)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt={'argv':command,'exit_code':result.returncode,'elapsed_ms':round((time.monotonic()-start)*1000),
 'stdout_sha256':sha(P/'analysis-stdout.txt'),'stderr_sha256':sha(P/'analysis-stderr.txt'),
 'runner_sha256':sha(Path(__file__))}
with (P/'analysis-exit.json').open('xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt))
if result.returncode:print((P/'analysis-stderr.txt').read_text(encoding='utf-8'))
sys.exit(result.returncode)
