"""Test/freeze only. No real transport plan or role is invoked."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,subprocess,sys,time
F=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=str(p.resolve()),sha256=sha(p))
def write(p,v):
    with p.open('x',encoding='utf-8') as out:json.dump(v,out,indent=2);out.write('\n')
now=lambda:datetime.now(timezone.utc).isoformat()
command=[sys.executable,'-X','utf8','-B',str(F/'test_v4.py')]
started=now();clock=time.monotonic()
with (F/'tests-output.txt').open('xb') as out,(F/'tests-stderr.txt').open('xb') as err:
    result=subprocess.run(command,stdout=out,stderr=err)
receipt={'command':command,'started_at_utc':started,'completed_at_utc':now(),
    'elapsed_seconds':time.monotonic()-clock,'exit_code':result.returncode,
    'stdout':ref(F/'tests-output.txt'),'stderr':ref(F/'tests-stderr.txt')}
write(F/'tests-exit.json',receipt)
assert result.returncode==0
manifest={'format':'retry-lineage-adjudicator-transport-preparation-1','created_at_utc':now(),
          'files':[ref(p) for p in F.iterdir() if p.is_file()],
          'base':ref(F.parent/'adjudicator-transport-recovery-v3/recovery-v3.py')}
write(F/'manifest.json',manifest)
final={'format':'retry-lineage-adjudicator-transport-preparation-receipt-1','completed_at_utc':now(),
    'manifest':ref(F/'manifest.json'),'helper':ref(F/'recovery-v4.py'),'review':ref(F/'REVIEW.md'),
    'tests':ref(F/'tests-exit.json'),'synthetic_guard_tests':15,'unchanged_function_asts':20,
    'real_continuation_failure_observed_by_this_preparation':False,
    'real_transport_plan_prepared':False,'operational_invocation':False}
write(F/'receipt.json',final)
print(json.dumps({'receipt':ref(F/'receipt.json'),**final},indent=2))
