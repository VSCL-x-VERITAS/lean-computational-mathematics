"""Capture actual POSIX parser/archive execution; no Git or source changes."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,subprocess,sys,time
F=Path(__file__).resolve().parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
launcher=R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
argv=[sys.executable,'-X','utf8','-B',str(launcher),str(F/'freeze-v2.py')]
out=F/'freeze-v2-output.txt';err=F/'freeze-v2-stderr.txt'
start=datetime.now(timezone.utc).isoformat();timer=time.monotonic()
with out.open('xb') as stdout,err.open('xb') as stderr:
 result=subprocess.run(argv,cwd=R,stdout=stdout,stderr=stderr)
receipt={'command':argv,'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'elapsed_seconds':time.monotonic()-timer,'exit_code':result.returncode,
 'stdout_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),
 'stderr_sha256':hashlib.sha256(err.read_bytes()).hexdigest()}
with (F/'freeze-v2-exit.json').open('x',encoding='utf-8') as f:json.dump(receipt,f,indent=2);f.write('\n')
print(json.dumps(receipt,indent=2));print(out.read_text(encoding='utf-8'));print(err.read_text(encoding='utf-8'))
raise SystemExit(result.returncode)
