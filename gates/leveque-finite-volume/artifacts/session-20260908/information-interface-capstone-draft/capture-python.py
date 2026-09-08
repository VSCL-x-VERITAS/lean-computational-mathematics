from pathlib import Path
from hashlib import sha256
import json, subprocess, sys
here=Path(__file__).resolve().parent
label,script=sys.argv[1:3]
source=here/script
out=here/(label+'.output.txt');receipt=here/(label+'.receipt.json')
assert not out.exists() and not receipt.exists()
command=[sys.executable,'-B',str(source)]+sys.argv[3:]
run=subprocess.run(command,cwd=here.parents[4],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
out.write_bytes(run.stdout)
record=dict(command=command,cwd=str(here.parents[4]),exit_code=run.returncode,
 source=dict(path=str(source),sha256=sha256(source.read_bytes()).hexdigest()),
 output=dict(path=str(out),sha256=sha256(run.stdout).hexdigest()))
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
sys.stdout.buffer.write(run.stdout)
sys.exit(run.returncode)
