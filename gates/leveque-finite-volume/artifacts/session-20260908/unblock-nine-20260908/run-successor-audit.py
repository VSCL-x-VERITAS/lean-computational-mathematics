"""Run an already prepared isolated-role audit and retain its actual process receipt."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,subprocess,sys
assert os.name=='nt'
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3]
spec=json.loads(Path(sys.argv[1]).read_bytes());tid=spec['task_id'];T=S/'audits'/tid
out=T/'faithfulness';prep=T/'role-transport-preflight.json'
assert json.loads(prep.read_bytes())['blind_isolation_verified'] and not (out/'decision.json').exists()
command=[sys.executable,'-X','utf8','-B',str(out/'orchestration/q.py'),tid,spec['pages'],'2']
start=datetime.now(timezone.utc).isoformat()
print(json.dumps({'launching':tid,'command':command,'started_at_utc':start}),flush=True)
with (T/'role-run-output.txt').open('xb') as stdout,(T/'role-run-stderr.txt').open('xb') as stderr:
 p=subprocess.run(command,cwd=R,stdout=stdout,stderr=stderr)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
rec={'command':command,'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'exit_code':p.returncode,'stdout_sha256':sha(T/'role-run-output.txt'),'stderr_sha256':sha(T/'role-run-stderr.txt'),'prepared_transport_sha256':sha(prep)}
if (out/'decision.json').is_file():
 decision=json.loads((out/'decision.json').read_bytes());rec['decision_sha256']=sha(out/'decision.json');rec['classification']=decision['classification'];rec['accepted']=decision['accepted']
with (T/'role-run-receipt.json').open('xb') as f:f.write((json.dumps(rec,indent=2)+'\n').encode())
print(json.dumps(rec),flush=True)
if p.returncode:print((T/'role-run-stderr.txt').read_text(errors='replace'))
raise SystemExit(p.returncode)
