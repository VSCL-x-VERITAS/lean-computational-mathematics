"""Capture only named local derivation/guard scripts through the unchanged POSIX launcher."""
import hashlib,json,os,subprocess,sys,time
from pathlib import Path
P=Path(__file__).resolve().parent;H=P.parent;R=H.parents[5];W=R.parent
def n(p):return '\\\\?\\'+str(p)
def raw(p):
    with open(n(p),'rb') as f:return f.read()
def ref(p):return {'path':str(p),'sha256':hashlib.sha256(raw(p)).hexdigest()}
label=sys.argv[1]
allowed={'derive-01':'derive-dim-inherited-context-helpers.py','guards-01':'test-dim-inherited-context-helpers.py'}
assert label in allowed
script=H/allowed[label]; launcher=W/'workflow-v5.0.1-local/run_workflow_posix.py'
inputs=[ref(script),ref(launcher),ref(Path(__file__))]
command=[sys.executable,'-X','utf8','-B',str(launcher),str(script)]
start=time.monotonic()
with open(n(P/(label+'-stdout.txt')),'xb') as out,open(n(P/(label+'-stderr.txt')),'xb') as err:
    proc=subprocess.run(command,cwd=R,stdout=out,stderr=err)
receipt={'command':command,'cwd':str(R),'actual_exit':proc.returncode,'elapsed_seconds':time.monotonic()-start,
 'stdout':ref(P/(label+'-stdout.txt')),'stderr':ref(P/(label+'-stderr.txt')),'inputs':inputs,
 'operational_validation':False,'gate_mutation':False}
for item in inputs:assert ref(Path(item['path']))==item
with open(n(P/(label+'-receipt.json')),'xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt,indent=2))
if proc.returncode:print(raw(P/(label+'-stderr.txt')).decode('utf-8',errors='replace')[-5000:])
raise SystemExit(proc.returncode)
