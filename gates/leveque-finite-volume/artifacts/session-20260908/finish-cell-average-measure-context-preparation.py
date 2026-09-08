"""Create a hash-pinned native pipeline entry; never run semantic roles."""
from pathlib import Path
from datetime import datetime, timezone
import ast, hashlib, json
def xp(p):
    p=str(p); prefix=chr(92)*2+'?'+chr(92)
    return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))
S=xp(Path(__file__).resolve().parent); R=S.parents[3]
TASK='LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908'
T=S/'audits'/TASK; O=T/'faithfulness'
sha=lambda p:hashlib.sha256(xp(p).read_bytes()).hexdigest()
base=T/'prepared-handoff-base.json'; entry=json.loads(base.read_bytes())
assert entry['semantic_roles_invoked'] is False
assert entry['prepared_validation_exit_code']==0
assert not any((O/'agent_outputs').iterdir())
assert not (O/'orchestration/b_input.txt').exists()
assert not (O/'decision.json').exists()
parent=S/'run-root-audit-pipeline.py'
parent_code=parent.read_text(encoding='utf-8')
tail=parent_code[parent_code.index('prefix=runner.read_text()'):]
header='''"""Run the untouched cell-average native-measure successor with one fresh role at a time."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json,subprocess,sys
def extended(p):
 p=str(p); prefix=chr(92)*2+'?'+chr(92)
 return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))
S=extended(Path(__file__).resolve().parent);R=S.parents[3]
parser=argparse.ArgumentParser();parser.add_argument('task');parser.add_argument('pages');args=parser.parse_args()
assert args.task==TASK_LITERAL
taskdir=S/'audits'/args.task;out=taskdir/'faithfulness';tr=out/'orchestration'
assert not (out/'decision.json').exists()
assert not any((out/'agent_outputs').iterdir()),'This entry only starts untouched tasks.'
helper=tr/'q.py';runner=tr/'r.py';collector=tr/'c.py'
sha=lambda b:hashlib.sha256(b).hexdigest()
handoff=taskdir/'prepared-handoff-base.json'
assert sha(handoff.read_bytes())==BASE_HASH_LITERAL
entry=json.loads(handoff.read_bytes())
assert entry['task_id']==args.task and entry['pages_argument']==args.pages
assert sha((taskdir/'audit-task.json').read_bytes())==entry['task_sha256']
assert sha(Path(entry['config_path']).read_bytes())==entry['config_sha256']
assert sha((R/entry['target']['path']).read_bytes())==entry['target_source_sha256']
assert sha((taskdir/'dependency-environment-packet.json').read_bytes())==entry['native_packet_sha256']
assert sha((out/'manifest.json').read_bytes())==entry['manifest_sha256']
assert sha((taskdir/'blind-preflight.json').read_bytes())==entry['blind_preflight_sha256']
for name,h in entry['helper_hashes'].items():assert sha((tr/name).read_bytes())==h
for label in ['route','prepare','prepared-validation']:
 receipt0=json.loads((taskdir/(label+'-exit.json')).read_bytes())
 assert receipt0['exit_code']==0
 assert sha((taskdir/(label+'-output.txt')).read_bytes())==receipt0['stdout_sha256']
 assert sha((taskdir/(label+'-stderr.txt')).read_bytes())==receipt0['stderr_sha256']
'''.replace('TASK_LITERAL',repr(TASK)).replace('BASE_HASH_LITERAL',repr(sha(base)))
tail=tail.replace("assert not (tr/'b_input.txt').exists()", "assert b'dependency-environment-packet' not in message\nassert sha(message)==json.loads((taskdir/'blind-preflight.json').read_bytes())['stdin_sha256']\nassert not (tr/'b_input.txt').exists()")
code=header+tail
ast.parse(code)
run=S/'run-cell-average-measure-context-audit-pipeline.py'
assert not run.exists()
run.write_text(code,encoding='utf-8',newline='')
files=[{'path':str(p),'sha256':sha(p)} for p in sorted(T.rglob('*')) if p.is_file()]
files += [{'path':str(p),'sha256':sha(p)} for p in [S/'audit-cell-average-measure-context.config.json',S/'prepare-cell-average-measure-context.py',S/'recover-cell-average-measure-context-images.py',S/'complete-cell-average-measure-context-preparation.py',S/'finish-cell-average-measure-context-preparation.py',run]]
receipt={'recorded_at_utc':datetime.now(timezone.utc).isoformat(),'task_id':TASK,'scope':'Preparation only; no semantic model, CLI role, or subagent invoked.','workers':1,'entry_command':[r'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe','-B',str(run),TASK,'23,26,27'],'cwd':str(R),'prepared_handoff_base_sha256':sha(base),'run_entry_sha256':sha(run),'run_template_parent_path':str(parent),'run_template_parent_sha256':sha(parent),'expected_root_receipt_path':str(T/'root-pipeline-receipt.json'),'runtime_metadata':'No role runtime exists; future collector records actual UUID/model/effort only.','source_scope':'Unchanged selected original source locator; complete raw pages 23,26,27. No user interpretation.','native_supplement_scope':['direct-judge','adjudicator'],'blind_and_roundtrip_supplement_absent':True,'frozen_prior_audit_preserved':entry['old_audit_preserved'],'files_written':files,'running_sessions':[]}
p=T/'preparation-only-handoff.json';assert not p.exists();p.write_text(json.dumps(receipt,indent=2,ensure_ascii=True)+'\n',encoding='utf-8',newline='')
print(json.dumps({'status':'handoff-ready','task':TASK,'task_sha256':entry['task_sha256'],'config_sha256':entry['config_sha256'],'manifest_sha256':entry['manifest_sha256'],'native_packet_sha256':entry['native_packet_sha256'],'blind_preflight_sha256':entry['blind_preflight_sha256'],'handoff_sha256':sha(p),'run_entry_sha256':sha(run),'entry_command':receipt['entry_command']}),flush=True)
