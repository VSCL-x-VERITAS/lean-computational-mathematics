"""Run one untouched default-config audit with one fresh role at a time."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json,subprocess,sys
def extended(p):
 p=str(p)
 return Path(p if p.startswith('\\\\?\\') else '\\\\?\\'+str(Path(p).resolve()))
S=extended(Path(__file__).resolve().parent);R=S.parents[3]
parser=argparse.ArgumentParser();parser.add_argument('task');parser.add_argument('pages');args=parser.parse_args()
taskdir=S/'audits'/args.task;out=taskdir/'faithfulness';tr=out/'orchestration'
assert not (out/'decision.json').exists()
assert not any((out/'agent_outputs').iterdir()),'This entry only starts untouched tasks.'
helper=S/'audits/LEV-CH01-EQ-1.6-ACOUSTICS-MATRIX-CANONICAL-20260908/faithfulness/orchestration/q.py'
runner=S/'audits/LEV-CH01-EQ-1.2-ADVECTION-CANONICAL-20260908/faithfulness/orchestration/r.py'
collector=runner.with_name('c.py');sha=lambda b:hashlib.sha256(b).hexdigest()
assert sha(helper.read_bytes())=='807f6b502ceb72aab0e4c72801813c45339d4ef817c5c9e9187d73248fac63b7'
assert sha(runner.read_bytes())=='b642e41886970764c08c2d50bf181f47ce1eab5706a18a15ce2a905137e110f6'
assert sha(collector.read_bytes())=='351ac0fe3d6f169562f7975e7979cac2754bf3c38c4f51af78c781e94cf0ded8'
handoff=S/'audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/coordinator-handoff-20260908.json'
assert sha(handoff.read_bytes())=='0506bd8f4846d9725c1141b9cc390bf35aa93e67982336c7dca9ded647f71e1f'
entry=next(x for x in json.loads(handoff.read_bytes())['pending'] if x['task_id']==args.task)
assert entry['pages_argument']==args.pages
assert sha((taskdir/'audit-task.json').read_bytes())==entry['task_sha256']
assert sha((S/'audit.config.json').read_bytes())==entry['config_sha256']
assert sha((R/entry['target']['path']).read_bytes())==entry['target_source_sha256']
prefix=runner.read_text().split("inp=tr/(stem+'_input.txt')")[0]
assert 'subprocess.run' not in prefix
previous=sys.argv;sys.argv=[str(runner),args.task,'blind-translation','b',''];ns={'__name__':'audit_blind_preflight'}
try:exec(compile(prefix,str(runner),'exec'),ns)
finally:sys.argv=previous
packet=(out/'inputs/blind_review_packet.md').read_bytes();message=ns['message']
assert message.endswith(packet) and message.count(packet)==1 and not ns['images']
assert args.task.encode() not in message and b'LeVeque' not in message and b'user-interpretation' not in message
assert not (tr/'b_input.txt').exists()
receipt=taskdir/'root-pipeline-receipt.json';stdout=taskdir/'root-pipeline-output.txt';stderr=taskdir/'root-pipeline-stderr.txt'
assert not any(p.exists() for p in [receipt,stdout,stderr])
command=[sys.executable,'-B',str(helper),args.task,args.pages,'1']
record={'schema':1,'command':command,'started_at_utc':datetime.now(timezone.utc).isoformat(),'workers':1,'handoff_sha256':sha(handoff.read_bytes()),'task_sha256':entry['task_sha256'],'blind_preflight':{'stdin_sha256':sha(message),'packet_sha256':sha(packet),'images':0,'packet_exact_and_single':True},'helper_sha256':sha(helper.read_bytes())}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'status':'starting','task':args.task,'blind_preflight':record['blind_preflight']}),flush=True)
with stdout.open('wb') as of,stderr.open('wb') as ef:result=subprocess.run(command,cwd=R,stdout=of,stderr=ef)
record.update({'completed_at_utc':datetime.now(timezone.utc).isoformat(),'exit_code':result.returncode,'stdout_sha256':sha(stdout.read_bytes()),'stderr_sha256':sha(stderr.read_bytes())})
if (tr/'b_input.txt').exists():
 record['actual_blind_stdin_sha256']=sha((tr/'b_input.txt').read_bytes())
 assert record['actual_blind_stdin_sha256']==record['blind_preflight']['stdin_sha256']
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
if result.returncode:sys.stdout.buffer.write(stdout.read_bytes()+stderr.read_bytes())
else:
 decision=json.loads((out/'decision.json').read_bytes())
 print(json.dumps({'status':'frozen','task':args.task,'exit_code':0,'accepted':decision['accepted'],'classification':decision['classification'],'hashes':{name:sha((out/name).read_bytes()) for name in ['manifest.json','decision.json','report.md']}}),flush=True)
raise SystemExit(result.returncode)
