"""Capture actual local verification/prepare results. No role execution command."""
import subprocess,sys,time
import recovery as r
def main():
 name=sys.argv[1];assert name in {'tests-01','prepare-01'}
 E=r.D/name;E.mkdir()
 before={str(p):r.sha(p) for p in r.P.iterdir() if p.is_file()}
 before.update({str(p):r.sha(p) for p in [r.O/'manifest.json',r.O/'agent_outputs/agent_runs.json']})
 command=[sys.executable,'-X','utf8','-B',str(r.D/('tests.py' if name=='tests-01' else 'recovery.py'))]
 if name=='prepare-01':command+=['prepare','--destination',str(r.D/'dim-a2-01')]
 start=r.now();tick=time.monotonic()
 with (E/'output.txt').open('xb') as out,(E/'stderr.txt').open('xb') as err:
  result=subprocess.run(command,cwd=r.R,stdout=out,stderr=err)
 unchanged=all(r.sha(r.Path(p))==h for p,h in before.items())
 new={str(p) for p in r.P.iterdir() if p.is_file()}-set(before)
 receipt={'format':'actual-local-preparation-1','command':command,'started_at_utc':start,
  'completed_at_utc':r.now(),'elapsed_seconds':time.monotonic()-tick,'exit_code':result.returncode,
  'stdout':r.ref(E/'output.txt'),'stderr':r.ref(E/'stderr.txt'),
  'operational_before_pins':before,'operational_originals_unchanged':unchanged,
  'operational_new_files':sorted(new),'roles_invoked':False}
 r.write(E/'receipt.json',receipt)
 print(r.json.dumps({'receipt':r.ref(E/'receipt.json'),'exit_code':result.returncode,
  'operational_originals_unchanged':unchanged,'operational_new_files':sorted(new)},indent=2))
 assert unchanged and not new
 return result.returncode
if __name__=='__main__':raise SystemExit(main())
