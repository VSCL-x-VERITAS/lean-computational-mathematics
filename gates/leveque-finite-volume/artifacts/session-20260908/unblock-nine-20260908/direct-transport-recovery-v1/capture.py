"""Capture actual prepare/test subprocess outcomes, never a role execution."""
from pathlib import Path
from datetime import datetime,timezone
import os,sys,json,hashlib,subprocess,time
D=Path(__file__).resolve().parent;R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
def ref(p):return {'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
def now():return datetime.now(timezone.utc).isoformat()
mode=sys.argv[1];assert mode in ('tests','prepare','route')
if mode=='tests':command=[sys.executable,'-X','utf8','-B',str(D/'test_guards.py'),str(D/'tests-final-01')]
elif mode=='prepare':command=[sys.executable,'-X','utf8','-B',str(D/'recovery.py'),'prepare','--destination',str(D/'dim-d2-01')]
else:command=[sys.executable,'-X','utf8','-B',str(R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'),'/c/Users/qed_s/.codex/skills/formalization-faithfulness-audit/scripts/route_audit.py','/c/'+(R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/audit-task.json').as_posix()[3:]]
out=D/(mode+'-output.txt');err=D/(mode+'-stderr.txt');started=now();clock=time.monotonic()
with out.open('xb') as stdout,err.open('xb') as stderr:result=subprocess.run(command,cwd=R,stdout=stdout,stderr=stderr)
receipt={'command':command,'started_at_utc':started,'completed_at_utc':now(),'elapsed_seconds':time.monotonic()-clock,'exit_code':result.returncode,'stdout':ref(out),'stderr':ref(err),'roles_invoked':False}
with (D/(mode+'-exit.json')).open('xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt,indent=2));raise SystemExit(result.returncode)
