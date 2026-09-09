"""Capture a focused native Lean type/axiom run; no source or operational mutations."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,subprocess,sys,time
I=Path(__file__).resolve().parent;D=I.parent;R=I.parents[5]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((I/'native-inputs.json').read_bytes());pins=manifest['files']+[manifest['probe']]
for item in pins:assert sha(R/item['path'])==item['sha256']
def identity():
 p=subprocess.run([sys.executable,'-B',str(R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'),
  str(D/'final-fingerprints/capture-posix-head.py')],cwd=R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 assert p.returncode==0,p.stderr
 return json.loads(p.stdout)
before=identity();argv=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',manifest['probe']['path']]
output=I/'native-types-output.txt';receipt=I/'native-types-receipt.json'
assert not output.exists() and not receipt.exists()
start=time.monotonic();started=datetime.now(timezone.utc).isoformat()
with output.open('xb') as f:p=subprocess.run(argv,cwd=R,stdout=f,stderr=subprocess.STDOUT)
elapsed=time.monotonic()-start;after=identity()
unchanged=all(sha(R/item['path'])==item['sha256'] for item in pins)
record={'schema':1,'argv':argv,'command':'lake env lean '+manifest['probe']['path'],'exit_code':p.returncode,
 'started_at_utc':started,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'elapsed_ms':round(elapsed*1000),
 'input_commit':before['head'],'input_tree':before['tree'],'identity_after':after,'inputs':pins,'inputs_unchanged':unchanged,
 'output_sha256':sha(output),'manifest_sha256':sha(I/'native-inputs.json'),'script_sha256':sha(Path(__file__)),
 'native_git_invoked':False}
with receipt.open('x',encoding='utf-8',newline='\n') as f:json.dump(record,f,indent=2);f.write('\n')
print(json.dumps(record));assert unchanged
raise SystemExit(p.returncode)
