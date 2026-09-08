"""Independently verify the completed Eq. (1.10) audit after a Windows path guard failure."""
from pathlib import Path
import hashlib,json,os,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
T='LEV-CH01-EQ-1.10-INTEGRAL-CONSERVATION-PRODUCTION-20260908';D=S/'audits'/T;O=D/'faithfulness'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
recovery=D/'root-recovery-receipt.json'
assert sha(recovery)=='fb0c614d385c08a2e4f6dd45fadc15dd7c9a89cd199846a4b6963ca67bfec4e1'
r=read(recovery);assert r['exit_code']==1 and r['error']=='AssertionError()'
assert all(s['actual_exit_code']==s['expected_exit'] for s in r['steps'])
assert r['steps'][-1]['actual_exit_code']==0 and r['steps'][-1]['command'][-1]=='1'
assert sha(D/'root-recovery-output.txt')==r['stdout_sha256']
assert sha(D/'root-recovery-stderr.txt')==r['stderr_sha256']
differences=[]
for recorded_path,oldhash in r['controlled_before'].items():
 normalized=recorded_path.replace('\\','/')
 newhash=sha(D/normalized)
 if newhash!=oldhash:differences.append({'recorded_path':recorded_path,'normalized_path':normalized,'old_sha256':oldhash,'new_sha256':newhash})
assert len(differences)==1 and differences[0]['normalized_path']=='faithfulness/manifest.json'
assert differences[0]['recorded_path']!=differences[0]['normalized_path']
assert sha(O/'manifest.json')=='ef3c6ce50c0a202acce5a2daa6b54b26f03c6c907227a0b962f86518dd29ab5d'
assert sha(O/'decision.json')=='be89b5bf7e066c64e3b24292d96d997d879ddb5c5342de79936263cf9ce9a052'
assert sha(D/'root-pipeline-receipt.json')==r['original_failure_receipt_sha256']
assert sha(O/'orchestration/failed-direct_judge-26353a3d12294297.json')==r['invalid_direct_output_sha256']
assert sha(O/'orchestration/d_final.json')==r['invalid_direct_output_sha256']
assert sha(O/'orchestration/d_retry1_input.txt')==sha(O/'orchestration/d_input.txt')==r['identical_direct_stdin_sha256']
prior=read(O/'orchestration/agent_runs-before-direct-recovery.json')['runs'];current=read(O/'agent_outputs/agent_runs.json')['runs']
assert current[:len(prior)]==prior and len(current)==len(prior)+2
assert current[-2]['role']=='direct-judge' and current[-1]['role']=='adjudicator'
assert len({x['agent_id'] for x in current})==len(current)
env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG=str(S/'audit.config.json'))
cmd=[sys.executable,str(R/'.faithfulness-audit/scripts/validate_audit.py'),T,'--phase','complete']
v=subprocess.run(cmd,cwd=R,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
assert v.returncode==0,(v.returncode,v.stdout,v.stderr)
p=D/'root-recovery-verification.json';assert not p.exists()
result={'schema':1,'task':T,'original_pipeline_exit':1,'recovery_driver_exit':1,'all_recorded_child_exits_match_expected':True,'cause':'The recovery postcondition compared Windows backslash paths against a forward-slash exclusion. The only changed controlled file is the expected completed manifest; every task/source/dependency input remained byte-identical.','controlled_differences':differences,'complete_validation':{'command':cmd,'exit_code':v.returncode,'stdout_sha256':hashlib.sha256(v.stdout).hexdigest(),'stderr_sha256':hashlib.sha256(v.stderr).hexdigest()},'manifest_sha256':sha(O/'manifest.json'),'decision_sha256':sha(O/'decision.json'),'report_sha256':sha(O/'report.md'),'original_receipts_and_invalid_judgment_preserved':True,'all_actual_agent_provenance_preserved':True,'new_audit_roles_invoked':0,'accepted':read(O/'decision.json')['accepted']}
p.write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'verification':p.relative_to(R).as_posix(),'sha256':sha(p),'complete_validator_exit':v.returncode,'accepted':result['accepted'],'classification':read(O/'decision.json')['classification']}))

