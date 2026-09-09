"""Run synthetic checks, then prepare one genuine failed DIM attempt; never execute a role."""
from pathlib import Path
from datetime import datetime,timezone
import subprocess,sys,hashlib,json,time
D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
def now():return datetime.now(timezone.utc).isoformat()
def ref(p):return {'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
def run(name,args):
    command=[sys.executable,'-X','utf8','-B',*map(str,args)]
    stdout=D/(name+'-output.txt');stderr=D/(name+'-stderr.txt')
    started=now();clock=time.monotonic()
    with stdout.open('xb') as out,stderr.open('xb') as err:
        proc=subprocess.run(command,cwd=R,stdout=out,stderr=err)
    receipt={'command':command,'started_at_utc':started,'completed_at_utc':now(),
        'elapsed_seconds':time.monotonic()-clock,'exit_code':proc.returncode,
        'stdout':ref(stdout),'stderr':ref(stderr),'roles_invoked':False}
    with (D/(name+'-exit.json')).open('x',encoding='utf-8') as out:
        json.dump(receipt,out,indent=2);out.write('\n')
    print(json.dumps(receipt,indent=2),flush=True)
    assert proc.returncode==0
run('tests',[D/'test_recovery_v3.py'])
run('dim-prepare',[D/'recovery-v3.py','prepare',
    D.parent/'dimensional-method-audit-preparation/audit-spec.json',
    '--failed-stem','a','--new-stem','a2','--destination',D/'dim-a2'])
