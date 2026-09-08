"""Read compact, evidence-bound progress for explicit audit tasks; never mutate."""
from pathlib import Path
import argparse,hashlib,json
S=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('tasks',nargs='+');a=p.parse_args()
for ident in a.tasks:
 d=S/'audits'/ident
 def read(path):return json.loads(path.read_bytes())
 receipt=d/'root-pipeline-receipt.json';out={'task':ident,'state':'prepared'}
 if receipt.exists():
  r=read(receipt);out['state']='running';out['started']=r.get('started_at_utc')
  if 'exit_code' in r:
   out['state']='completed' if r['exit_code']==0 else 'failed';out['actual_exit_code']=r['exit_code']
   for name,key in [('root-pipeline-output.txt','stdout_sha256'),('root-pipeline-stderr.txt','stderr_sha256')]:assert hashlib.sha256((d/name).read_bytes()).hexdigest()==r[key]
  else:
   progress=d/'root-pipeline-output.txt'
   if progress.exists():
    for line in reversed(progress.read_text(encoding='utf-8',errors='replace').splitlines()):
     try:event=json.loads(line)
     except json.JSONDecodeError:continue
     if event.get('status')=='launching':out['role']=event['role'];out['stdin_sha256']=event['stdin_sha256'];break
     if event.get('boundary')=='role_validated':out['last_validated_role']=event['role'];break
 if out['state']=='completed':
  decision=d/'faithfulness/decision.json';j=read(decision);out.update(accepted=j['accepted'],classification=j['classification'],decision_sha256=hashlib.sha256(decision.read_bytes()).hexdigest())
 print(json.dumps(out,ensure_ascii=True))
