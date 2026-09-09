from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,subprocess,sys
P=Path(__file__).resolve().parent
disk=lambda p:'\\\\?\\'+str(p.resolve())
read=lambda p:Path(disk(p)).read_bytes()
sha=lambda p:hashlib.sha256(read(p)).hexdigest()
tag=sys.argv[1];assert tag=='staged-tests-01'
out=P/(tag+'-run');assert not Path(disk(out)).exists();os.mkdir(disk(out))
cmd=[sys.executable,'-X','utf8','-B',str(P/'test_staged.py'),tag]
start=datetime.now(timezone.utc).isoformat()
result=subprocess.run(cmd,cwd=P,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
Path(disk(out/'output.txt')).write_bytes(result.stdout);Path(disk(out/'stderr.txt')).write_bytes(result.stderr)
receipt={'command':cmd,'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'actual_exit_code':result.returncode,'output_sha256':sha(out/'output.txt'),'stderr_sha256':sha(out/'stderr.txt'),
 'subject_sha256':sha(P/'staged.py'),'test_sha256':sha(P/'test_staged.py'),'fixture_only':True,
 'actual_audit_or_model_invocations':0}
Path(disk(out/'receipt.json')).write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(result.stdout.decode());print(result.stderr.decode())
print(json.dumps({'receipt_sha256':sha(out/'receipt.json'),'actual_exit_code':result.returncode},indent=2))
raise SystemExit(result.returncode)
