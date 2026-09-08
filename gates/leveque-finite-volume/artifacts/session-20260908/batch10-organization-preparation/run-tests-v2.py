from pathlib import Path
from hashlib import sha256
import json,subprocess,sys
here=Path(__file__).resolve().parent
label=sys.argv[1];out=here/(label+'.output.txt');receipt=here/(label+'.receipt.json')
assert not out.exists() and not receipt.exists()
command=[sys.executable,'-B',str(here/'test-v2.py')]
run=subprocess.run(command,cwd=here.parents[4],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
out.write_bytes(run.stdout)
record=dict(command=command,cwd=str(here.parents[4]),exit_code=run.returncode,
 output=dict(path=str(out),sha256=sha256(run.stdout).hexdigest()),
 inputs=[dict(path=str(here/name),sha256=sha256((here/name).read_bytes()).hexdigest()) for name in ['test-v2.py','prepare-v2.py','run-tests-v2.py']],
 scope='Synthetic/helper validation only; operational derived scripts were not executed.')
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
sys.stdout.buffer.write(run.stdout);sys.exit(run.returncode)
