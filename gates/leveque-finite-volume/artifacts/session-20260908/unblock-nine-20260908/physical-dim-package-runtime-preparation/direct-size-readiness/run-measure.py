"""Capture the actual local measurement exit and outputs; never run semantic roles."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,subprocess,sys
H=Path(__file__).resolve().parent
def disk(p):return '\\\\?\\'+str(p.resolve()) if os.name=='nt' else str(p)
def raw(p):
 with open(disk(p),'rb') as f:return f.read()
def ref(p):
 b=raw(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def create(p,b):
 with open(disk(p),'xb') as f:f.write(b)
out=H/sys.argv[1];assert not os.path.exists(disk(out));os.mkdir(disk(out))
command=[sys.executable,'-X','utf8','-B',disk(H/'measure.py')]
start=datetime.now(timezone.utc).isoformat()
result=subprocess.run(command,cwd=H,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
create(out/'stdout.json',result.stdout);create(out/'stderr.txt',result.stderr)
record={'format':'native-readonly-measurement-exit-1','command':command,'cwd':str(H),
 'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'exit_code':result.returncode,
 'stdout':ref(out/'stdout.json'),'stderr':ref(out/'stderr.txt'),'script':ref(H/'measure.py'),'runner':ref(Path(__file__)),
 'operational_plan_created':False,'semantic_roles_invoked':False}
create(out/'receipt.json',(json.dumps(record,indent=2)+'\n').encode())
print(json.dumps({'receipt':ref(out/'receipt.json'),'exit_code':result.returncode},indent=2))
raise SystemExit(result.returncode)
