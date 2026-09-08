"""Compare Windows process creation context without changing the hook command."""
from pathlib import Path
import hashlib,json,subprocess,sys,time,argparse
D=Path(__file__).resolve().parent;W=D.parents[1];R=W/'lean-computational-mathematics'
p=argparse.ArgumentParser();p.add_argument('mode',choices=['no-window','detached']);a=p.parse_args()
flag={'no-window':subprocess.CREATE_NO_WINDOW,'detached':subprocess.DETACHED_PROCESS}[a.mode]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
state=Path('C:/Users/qed_s/.cache/book-formalization/session-guards/48511011606d4532ef12a0e6a92d5568a625b5624c4ea45b6ec315b2174e7bdf.json')
info=json.loads(state.read_bytes());state_sha=sha(state);assert not info.get('explicit_stop')
config=Path('C:/Users/qed_s/.codex/hooks.json');config_sha=sha(config)
hook=json.loads(config.read_bytes())['hooks']['Stop'][0]['hooks'][0]
argv=[sys.executable,'-B','C:/Users/qed_s/.codex/runtimes/formalization-hook-bridge.py','/c/Users/qed_s/.codex/skills/book-formalization/scripts/formalization_session_guard.py']
assert ' '.join(argv).replace('\\','/')==hook['commandWindows']
payload={'session_id':'01a07fae-4a67-7770-98b0-b95c4e393705','cwd':str(W),'hook_event_name':'Stop','transcript_path':'C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-01a07fae-4a67-7770-98b0-b95c4e393705.jsonl'}
base=D/a.mode;assert not base.exists();base.mkdir()
start=time.perf_counter();timeout=False
try:
 run=subprocess.run(argv,cwd=W,input=json.dumps(payload).encode(),stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=30,creationflags=flag)
 out,err,code=run.stdout,run.stderr,run.returncode
except subprocess.TimeoutExpired as e:out,err,code=e.stdout or b'',e.stderr or b'',None;timeout=True
elapsed=time.perf_counter()-start
(base/'stdout.txt').write_bytes(out);(base/'stderr.txt').write_bytes(err)
assert sha(state)==state_sha and sha(config)==config_sha
record={'mode':a.mode,'windows_creationflags':flag,'command':argv,'elapsed_seconds':elapsed,'outer_timed_out':timeout,'exit_code':code,'stdout_sha256':sha(base/'stdout.txt'),'stderr_sha256':sha(base/'stderr.txt'),'state_unchanged':True,'hook_definition_unchanged':True,'purpose':'Diagnostic creation-context variation, not a host lifecycle event or hook replacement.'}
(base/'receipt.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record));print(out.decode('utf-8',errors='replace'));print(err.decode('utf-8',errors='replace'))
raise SystemExit(code if code is not None else 124)
