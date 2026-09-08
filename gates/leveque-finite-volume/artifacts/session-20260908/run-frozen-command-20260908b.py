"""Record one actual POSIX workflow command without overwriting prior evidence."""
from pathlib import Path
import hashlib, json, subprocess, sys
S=Path(__file__).resolve().parent
R=S.parents[3]
label=sys.argv[1]
cmd=[sys.executable,*sys.argv[2:]]
out=S/(label+'-output.txt')
rec=S/(label+'-exit.json')
assert not out.exists() and not rec.exists()
run=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
out.write_bytes(run.stdout)
record={'command':cmd,'exit_code':run.returncode,'raw_output_sha256':hashlib.sha256(run.stdout).hexdigest()}
rec.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(run.stdout.decode('utf-8',errors='replace'))
print(json.dumps(record))
raise SystemExit(run.returncode)
