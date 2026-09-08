"""Replay the configured Windows Stop command against the existing unchanged session state."""
from pathlib import Path
import hashlib,json,subprocess,sys,time
from datetime import datetime,timezone
D=Path(__file__).resolve().parent;W=D.parents[1];R=W/'lean-computational-mathematics'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def host(v):return Path('C:/'+v[3:]) if v.startswith('/c/') else Path(v)
state_info=json.loads((D/'existing-guard-state.json').read_bytes())
state=host(state_info['state_path'])
assert sha(state)==state_info['state_sha256']
config=Path('C:/Users/qed_s/.codex/hooks.json');before=sha(config)
hook=json.loads(config.read_bytes())['hooks']['Stop'][0]['hooks'][0]
argv=[sys.executable,'-B','C:/Users/qed_s/.codex/runtimes/formalization-hook-bridge.py','/c/Users/qed_s/.codex/skills/book-formalization/scripts/formalization_session_guard.py']
assert ' '.join(argv).replace('\\','/')==hook['commandWindows']
assert hook['timeout']==30
gate=host(state_info['gate']);gate_before=sha(gate)
assert gate_before=='e264dd1cea8cdc57b0389876aad410092df72c1ad48ca1fb73d14049374659c0'
payload={'session_id':state_info['session_id'],'cwd':str(W),'hook_event_name':'Stop','transcript_path':'C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-01a07fae-4a67-7770-98b0-b95c4e393705.jsonl'}
raw=(json.dumps(payload)+'\n').encode()
with (D/'stop-replay-payload.json').open('xb') as f:f.write(raw)
started=datetime.now(timezone.utc).isoformat();clock=time.perf_counter()
timed_out=False
try:
 run=subprocess.run(argv,cwd=W,input=raw,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=hook['timeout'])
 stdout,stderr,exit_code=run.stdout,run.stderr,run.returncode
except subprocess.TimeoutExpired as e:
 stdout,stderr,exit_code=e.stdout or b'',e.stderr or b'',None;timed_out=True
elapsed=time.perf_counter()-clock
for name,content in [('stop-replay-output.txt',stdout),('stop-replay-stderr.txt',stderr)]:
 with (D/name).open('xb') as f:f.write(content)
assert sha(state)==state_info['state_sha256'] and sha(config)==before and sha(gate)==gate_before
record={'kind':'actual-configured-Windows-Stop-command-replay','session_id':state_info['session_id'],'started_at_utc':started,'elapsed_seconds':elapsed,'command':argv,'cwd':str(W),'outer_timeout_seconds':hook['timeout'],'unchanged_inner_checker_timeout_seconds':20,'timed_out':timed_out,'exit_code':exit_code,'stdout_sha256':sha(D/'stop-replay-output.txt'),'stderr_sha256':sha(D/'stop-replay-stderr.txt'),'state_sha256':sha(state),'hook_config_sha256':before,'gate_sha256':gate_before,'guard_sha256':sha(Path('C:/Users/qed_s/.codex/skills/book-formalization/scripts/formalization_session_guard.py')),'payload_sha256':sha(D/'stop-replay-payload.json'),'operational_writes':[],'limitation':'Direct actual command replay; not a new host lifecycle Stop event or a hook trust change.'}
with (D/'stop-replay-exit.json').open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(record));print(stdout.decode('utf-8',errors='replace'));print(stderr.decode('utf-8',errors='replace'))
raise SystemExit(exit_code if exit_code is not None else 124)
