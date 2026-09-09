import hashlib,json,os,subprocess,time
from pathlib import Path
P=Path(__file__).resolve().parent
R=P.parents[5]
envrecord=json.loads((P/'environment.json').read_text(encoding='utf-8'))
env=os.environ.copy();env['LEAN_PATH']=envrecord['effective_LEAN_PATH']
O=P/'overlay'
native=lambda p:'\\\\?\\'+os.path.abspath(p)
lean=envrecord['lean_executable']['path']
command=[lean,'-R',native(O),'--deps',native(O/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/LocalRectangleReference.lean')]
out=P/'extended-path-probe-output.txt';err=P/'extended-path-probe-stderr.txt'
start=time.monotonic()
with open(native(out),'xb') as stdout,open(native(err),'xb') as stderr:
 result=subprocess.run(command,cwd=O,env=env,stdout=stdout,stderr=stderr)
sha=lambda p:hashlib.sha256(open(native(p),'rb').read()).hexdigest()
receipt={'command':command,'cwd':str(O),'exit_code':result.returncode,'elapsed_seconds':time.monotonic()-start,'stdout_sha256':sha(out),'stderr_sha256':sha(err)}
with open(native(P/'extended-path-probe-receipt.json'),'xb') as f:f.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps(receipt));print(open(native(out),'rb').read().decode('utf-8'));print(open(native(err),'rb').read().decode('utf-8'))
raise SystemExit(result.returncode)
