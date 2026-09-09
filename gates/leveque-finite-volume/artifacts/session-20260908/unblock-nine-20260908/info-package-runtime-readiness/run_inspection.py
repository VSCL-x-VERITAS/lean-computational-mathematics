from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,subprocess,sys
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
out=P/'inspection-01';out.mkdir()
command=[sys.executable,'-X','utf8','-B',str(R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'),str(P/'inspect.py')]
started=datetime.now(timezone.utc).isoformat()
with (out/'stdout.txt').open('wb') as stdout,(out/'stderr.txt').open('wb') as stderr:
    result=subprocess.run(command,cwd=R,stdout=stdout,stderr=stderr)
receipt={'command':command,'started_at':started,'finished_at':datetime.now(timezone.utc).isoformat(),
         'actual_exit_code':result.returncode,'stdout_sha256':hashlib.sha256((out/'stdout.txt').read_bytes()).hexdigest(),
         'stderr_sha256':hashlib.sha256((out/'stderr.txt').read_bytes()).hexdigest(),'read_only':True}
(out/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt))
raise SystemExit(result.returncode)
