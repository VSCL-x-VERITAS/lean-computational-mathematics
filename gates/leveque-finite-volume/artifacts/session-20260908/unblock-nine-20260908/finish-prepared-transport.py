"""Finish transport preflight after preparation, using Windows extended paths."""
from pathlib import Path
import hashlib,json,os,sys
assert os.name=='nt'
D=Path(__file__).resolve().parent
S=D.parent
R=S.parents[3]
spec=json.loads(Path(sys.argv[1]).read_bytes())
tid=spec['task_id']
T=Path(chr(92)*2+'?'+chr(92)+str(S/'audits'/tid))
out=T/'faithfulness'
tr=out/'orchestration'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert not (T/'role-transport-preflight.json').exists()
assert not list((out/'agent_outputs').glob('*.json'))
for stage in ['route','prepare','prepared-validation']:
 rec=json.loads((T/(stage+'-exit.json')).read_bytes())
 assert rec['exit_code']==0
 assert rec['stdout_sha256']==sha(T/(stage+'-output.txt'))
 assert rec['stderr_sha256']==sha(T/(stage+'-stderr.txt'))
task=json.loads((T/'audit-task.json').read_bytes())
manifest=json.loads((out/'manifest.json').read_bytes())
assert manifest['task_id']==tid and manifest['target']['sha256']==sha(R/task['target']['path'])
parent=S/'audits/LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908/faithfulness/orchestration'
helpers=[{'file':n,'parent_sha256':sha(parent/n),'successor_sha256':sha(tr/n)} for n in ['r.py','c.py','q.py']]
prefix=(tr/'r.py').read_text(encoding='utf-8').split("inp=tr/(stem+'_input.txt')")[0]
assert 'subprocess.run' not in prefix
saved=sys.argv
sys.argv=['r.py',tid,'blind-translation','b','']
ns={}
try:exec(compile(prefix,'blind_isolation_preflight','exec'),ns)
finally:sys.argv=saved
packet=(out/'inputs/blind_review_packet.md').read_bytes()
message=ns['message']
assert message.endswith(packet) and message.count(packet)==1 and not ns['images']
assert tid.encode() not in message and b'LeVeque' not in message and b'user-interpretation' not in message
record={'helpers':helpers,'blind_packet_sha256':hashlib.sha256(packet).hexdigest(),
 'blind_stdin_sha256':hashlib.sha256(message).hexdigest(),'blind_isolation_verified':True,
 'roles_invoked':False,'images':[{'page':p,'sha256':sha(tr/('page-'+p.zfill(3)+'.png'))} for p in spec['pages'].split(',')],
 'config_path':(D/(tid+'.config.json')).relative_to(R).as_posix(),
 'preflight_completion':'Existing successful released preparation verified; extended Windows paths avoid the native MAX_PATH read failure. No audit input or generated role helper changed.',
 'completion_helper_sha256':sha(Path(__file__))}
with (T/'role-transport-preflight.json').open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps({'prepared':tid,'preflight_sha256':sha(T/'role-transport-preflight.json'),'roles_invoked':False}))
