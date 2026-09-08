"""Root read-only recomputation of the completed baseline transport draft."""
from pathlib import Path
import hashlib,json,subprocess,sys,time
S=Path(__file__).resolve().parent;R=S.parents[3];D=S/'baseline-equation03-transport-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
helper=D/'freeze-transport.py'
assert sha(helper)=='09889cefd5404a5adcc5ca73298cee7eae61d880769997c60212acc816b04816'
receipt=json.loads((D/'verification-receipt.json').read_bytes())
assert receipt['actual_exit_code']==0
for f in receipt['files']:
 p=D/f['path'];assert sha(p)==f['sha256'] and p.stat().st_size==f['bytes']
assert receipt['stdout_sha256']==sha(D/'verification.stdout.json')
assert receipt['stderr_sha256']==sha(D/'verification.stderr.txt')
out=S/'root-equation03-transport-check-output.json';err=S/'root-equation03-transport-check-stderr.txt'
command=[sys.executable,'-B',str(helper),'--check']
start=time.monotonic()
with out.open('xb') as of,err.open('xb') as ef:
 result=subprocess.run(command,cwd=R,stdout=of,stderr=ef)
record={'schema':1,'command':command,'actual_exit_code':result.returncode,'elapsed_ms':int((time.monotonic()-start)*1000),'helper_sha256':sha(helper),'original_verification_receipt_sha256':sha(D/'verification-receipt.json'),'stdout_sha256':sha(out),'stderr_sha256':sha(err),'candidate_or_epoch_acceptance':False}
path=S/'root-equation03-transport-check-exit.json'
with path.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
if result.returncode:
 sys.stdout.buffer.write(out.read_bytes()+err.read_bytes())
 raise SystemExit(result.returncode)
assert not err.read_bytes()
data=json.loads(out.read_bytes())
assert data['retained_declarations']==3 and data['bound_manifest_entries']==113 and data['fresh_role_records']==5
assert data['candidate_or_epoch_acceptance'] is False
print(json.dumps({**record,'root_verification_sha256':sha(path),'retained_declarations':3,'manifest_binding_occurrences':113}))

