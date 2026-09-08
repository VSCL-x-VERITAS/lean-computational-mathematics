"""Run the untouched interpreted rectangle successor with one fresh role at a time."""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,json,subprocess,sys
def extended(p):
 p=str(p); prefix=chr(92)*2+'?'+chr(92)
 return Path(p if p.startswith(prefix) else prefix+str(Path(p).resolve()))
S=extended(Path(__file__).resolve().parent);R=S.parents[3]
parser=argparse.ArgumentParser();parser.add_argument('task');parser.add_argument('pages');args=parser.parse_args()
assert args.task=='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'
taskdir=S/'audits'/args.task;out=taskdir/'faithfulness';tr=out/'orchestration'
assert not (out/'decision.json').exists()
assert not any((out/'agent_outputs').iterdir()),'This entry only starts untouched tasks.'
helper=tr/'q.py';runner=tr/'r.py';collector=tr/'c.py'
sha=lambda b:hashlib.sha256(b).hexdigest()
handoff=taskdir/'prepared-handoff-base.json'
assert sha(handoff.read_bytes())=='01a8ea24f9405f28053515a54b317c003e2e5d224d3bf1ecb3abc82e489d503e'
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
prefix=runner.read_text().split("inp=tr/(stem+'_input.txt')")[0]
assert 'subprocess.run' not in prefix
previous=sys.argv;sys.argv=[str(runner),args.task,'blind-translation','b',''];ns={'__name__':'audit_blind_preflight'}
try:exec(compile(prefix,str(runner),'exec'),ns)
finally:sys.argv=previous
packet=(out/'inputs/blind_review_packet.md').read_bytes();message=ns['message']
assert message.endswith(packet) and message.count(packet)==1 and not ns['images']
assert args.task.encode() not in message and b'LeVeque' not in message and b'user-interpretation' not in message
assert b'dependency-environment-packet' not in message
assert sha(message)==json.loads((taskdir/'blind-preflight.json').read_bytes())['stdin_sha256']
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
