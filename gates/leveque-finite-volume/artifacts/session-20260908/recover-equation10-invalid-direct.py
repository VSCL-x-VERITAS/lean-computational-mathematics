"""Recover the one incomplete Eq. (1.10) run without editing any judgment.
Only an invalid direct output is archived; its runtime remains in agent_runs.
The replacement receives byte-identical permitted input in a fresh isolated role.
"""
from pathlib import Path
from datetime import datetime, timezone
import argparse, hashlib, json, os, subprocess, sys
def xp(p):
 p=str(p)
 return Path(p if p.startswith('\\\\?\\') else '\\\\?\\'+str(Path(p).resolve()))
S=xp(Path(__file__).resolve().parent);R=S.parents[3]
T='LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908'
D=S/'audits'/T;O=D/'faithfulness';TR=O/'orchestration'
p=argparse.ArgumentParser();p.add_argument('--execute',action='store_true');a=p.parse_args()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
Q=S/'audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/q.py'
H=S/'audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration'
RR=H/'r.py';CC=H/'c.py'
for f,h in [(Q,'807f6b502ceb72aab0e4c72801813c45339d4ef817c5c9e9187d73248fac63b7'),(RR,'b642e41886970764c08c2d50bf181f47ce1eab5706a18a15ce2a905137e110f6'),(CC,'351ac0fe3d6f169562f7975e7979cac2754bf3c38c4f51af78c781e94cf0ded8')]:assert sha(f)==h
assert not (O/'decision.json').exists()
old=D/'root-pipeline-receipt.json'
assert sha(old)=='bb5fdf2b74d7f74a7a341c41231c6e8adf757b445c9fbf6f99db1129fb7b69d3'
assert read(old)['exit_code']==1
for f,k in [('root-pipeline-output.txt','stdout_sha256'),('root-pipeline-stderr.txt','stderr_sha256')]:assert sha(D/f)==read(old)[k]
bad=O/'agent_outputs/direct_judge.json'
assert sha(bad)=='26353a3d122942972a24d37672f6e8f988a371ada0dade1562511e84a58fc6d3'
assert read(bad)['dependency_coverage'][79]['id']=='D080'
assert sha(TR/'r_final.json')=='3f508d2a8845b1f3e6f5f943f55533703c336a7db6a1a8f49b9fcf123607f743'
assert not (TR/'d_retry1_input.txt').exists()
prefix=RR.read_text().split("inp=tr/(stem+'_input.txt')")[0]
assert 'subprocess.run' not in prefix
argv=sys.argv;sys.argv=[str(RR),T,'direct-judge','d_retry1','23,25,26,27'];ns={'__name__':'identical_direct_preflight'}
try:exec(compile(prefix,str(RR),'exec'),ns)
finally:sys.argv=argv
assert ns['message']==(TR/'d_input.txt').read_bytes()
assert hashlib.sha256(ns['message']).hexdigest()=='2dc519c75c2d5d1f441fd2decd2d5b0e1d092f4956246b2cd48704168abfd830'
wrapper=r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py'
env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG='/c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/audit.config.json')
def released(script,*args):
 return [sys.executable,'-B',wrapper,'.faithfulness-audit/scripts/'+script,T,*args]
subprocess.run(released('validate_audit.py','--phase','prepared'),cwd=R,env=env,check=True)
if not a.execute:
 print(json.dumps({'status':'recovery_preflight_pass','task':T,'identical_direct_stdin_sha256':hashlib.sha256(ns['message']).hexdigest(),'invalid_output_preserved':True,'model_roles_launched':0}));raise SystemExit(0)
receipt=D/'root-recovery-receipt.json';stdout=D/'root-recovery-output.txt';stderr=D/'root-recovery-stderr.txt'
assert not any(x.exists() for x in [receipt,stdout,stderr])
archive=TR/'failed-direct_judge-26353a3d12294297.json';assert not archive.exists()
runs=O/'agent_outputs/agent_runs.json';runs_archive=TR/'agent_runs-before-direct-recovery.json';assert not runs_archive.exists()
controlled={str(f.relative_to(D)):sha(f) for f in [D/'audit-task.json',O/'manifest.json',O/'agent_outputs/source_contract.json',O/'agent_outputs/blind_translation.json',*list((O/'inputs').iterdir())] if f.is_file()}
record={'schema':1,'task':T,'started_at_utc':datetime.now(timezone.utc).isoformat(),'workers':1,'original_failure_receipt_sha256':sha(old),'invalid_direct_output_sha256':sha(bad),'identical_direct_stdin_sha256':hashlib.sha256(ns['message']).hexdigest(),'controlled_before':controlled,'steps':[]}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
rc=1
try:
 with stdout.open('wb') as of,stderr.open('wb') as ef:
  def run(cmd,expected=0):
   of.write((json.dumps({'command':cmd,'expected_exit':expected})+'\n').encode());of.flush()
   r=subprocess.run(cmd,cwd=R,env=env,stdout=of,stderr=ef)
   record['steps'].append({'command':cmd,'actual_exit_code':r.returncode,'expected_exit':expected})
   assert r.returncode==expected,(cmd,r.returncode,expected)
  run(released('validate_agent_output.py','source-contract'))
  run(released('validate_agent_output.py','blind-translation'))
  run(released('validate_agent_output.py','direct-judge'),2)
  run([sys.executable,'-B',str(CC),T,'r','roundtrip-judge','roundtrip_judge.json'])
  runs_archive.write_bytes(runs.read_bytes());assert sha(runs_archive)==sha(runs)
  # Both explicit absolute paths are within this task; rename one invalid output, never recurse.
  assert str(bad.resolve()).startswith(str(D.resolve())+os.sep)
  assert str(archive.resolve()).startswith(str(D.resolve())+os.sep)
  bad.rename(archive)
  assert sha(archive)==record['invalid_direct_output_sha256'] and not bad.exists()
  run([sys.executable,'-B',str(RR),T,'direct-judge','d_retry1','23,25,26,27'])
  assert sha(TR/'d_retry1_input.txt')==record['identical_direct_stdin_sha256']
  assert read(TR/'d_retry1_transport.json')['exit_code']==0
  run([sys.executable,'-B',str(CC),T,'d_retry1','direct-judge','direct_judge.json'])
  # This same pinned coordinator validates existing roles and performs only triggered adjudication.
  run([sys.executable,'-B',str(Q),T,'23,25,26,27','1'])
  assert all(sha(D/k)==v for k,v in controlled.items() if k!='faithfulness/manifest.json')
  assert sha(old)==record['original_failure_receipt_sha256']
  rc=0
except BaseException as error:
 record['error']=repr(error)
 raise
finally:
 record.update(completed_at_utc=datetime.now(timezone.utc).isoformat(),exit_code=rc,stdout_sha256=sha(stdout),stderr_sha256=sha(stderr))
 if (O/'decision.json').exists():record['decision_sha256']=sha(O/'decision.json')
 receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'task':T,'recovery_exit_code':rc,'receipt_sha256':sha(receipt),'decision_sha256':record.get('decision_sha256')}),flush=True)

