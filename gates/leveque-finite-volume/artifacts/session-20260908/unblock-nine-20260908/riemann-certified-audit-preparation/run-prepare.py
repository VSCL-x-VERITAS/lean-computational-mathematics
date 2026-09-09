"""Capture the local spec-only validation, never released preparation or roles."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess,sys,time
P=Path(__file__).resolve().parent
assert len(sys.argv)==3 and re.fullmatch('full-[0-9]+',sys.argv[1]) and re.fullmatch('spec-[0-9]+',sys.argv[2])
label=sys.argv[2];helper=P/'prepare-spec.py'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
before=sha(helper)
snapshot=P/(label+'-prepare-spec.py');snapshot.write_bytes(helper.read_bytes())
argv=[sys.executable,'-X','utf8','-B',str(helper),*sys.argv[1:]]
started=datetime.now(timezone.utc).isoformat();timer=time.monotonic()
out=P/(label+'-output.txt')
with out.open('xb') as stream:result=subprocess.run(argv,stdout=stream,stderr=subprocess.STDOUT,cwd=P)
assert sha(helper)==before
receipt={'schema':1,'command':argv,'exit_code':result.returncode,'elapsed_ms':int((time.monotonic()-timer)*1000),
 'started_at_utc':started,'finished_at_utc':datetime.now(timezone.utc).isoformat(),
 'helper_sha256':before,'helper_snapshot':snapshot.name,'output_sha256':sha(out),
 'released_preparer_invoked':False,'model_roles_invoked':False,'git_invocations':0}
with (P/(label+'-exit.json')).open('x',encoding='utf-8',newline='\n') as stream:stream.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt,indent=2))
if result.returncode:print(out.read_text())
raise SystemExit(result.returncode)
