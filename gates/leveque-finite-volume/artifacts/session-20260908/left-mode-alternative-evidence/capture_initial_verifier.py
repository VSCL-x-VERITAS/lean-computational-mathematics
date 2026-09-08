"""Reproduce and retain the initial verifier's comment false-positive, with actual exit."""
from pathlib import Path
import hashlib,json,subprocess,sys
D=Path(__file__).resolve().parent
script=D/'freeze-initial.py'
out=D/'freeze-initial-reproduced.txt'
receipt=D/'freeze-initial-reproduced.json'
assert not out.exists() and not receipt.exists()
argv=[sys.executable,str(script)]
with out.open('wb') as f:run=subprocess.run(argv,stdout=f,stderr=subprocess.STDOUT)
receipt.write_text(json.dumps({'argv':argv,'exit_code':run.returncode,
 'script_sha256':hashlib.sha256(script.read_bytes()).hexdigest(),
 'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),
 'scope':'Reproduction of initial freeze verifier failure; Lean final check had already exited zero.'},indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'actual_reproduced_exit':run.returncode,'output':str(out)}))
assert run.returncode==1
