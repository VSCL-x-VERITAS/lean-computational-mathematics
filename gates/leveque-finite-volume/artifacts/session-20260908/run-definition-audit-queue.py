"""Run the two prepared definition audits sequentially, one fresh role at a time."""
from pathlib import Path
import hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
entries=[
 ('run-definition-rectangle-audit-pipeline.py','7fb5e4334fc194afdb097fb6204e27d1036910371d01215bc2c006d4b2bc1d4e','LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908','23,25,26,27'),
 ('run-definition-problem-data-audit-pipeline.py','5c7921de3578390e1c35f1784d87b4603eaa4e5bd10316719b21d223bfe168ca','LEV-CH01-RIEMANN-HYPERBOLIC-PROBLEM-DATA-PRODUCTION-20260908','23,25,26,27,28')]
for entry,expected,task,pages in entries:
 assert hashlib.sha256((S/entry).read_bytes()).hexdigest()==expected
 command=[sys.executable,'-B',str(S/entry),task,pages]
 print(json.dumps({'queue_task':task,'command':command,'one_role_at_a_time':True}),flush=True)
 result=subprocess.run(command,cwd=R)
 if result.returncode:raise SystemExit(result.returncode)
print(json.dumps({'definition_queue_complete':True,'tasks':[r[2] for r in entries]}),flush=True)
