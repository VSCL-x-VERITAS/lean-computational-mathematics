"""One shell-wrapper control for the unchanged configured Stop hook."""
from pathlib import Path
import hashlib,json,subprocess,sys,time,os
D=Path(__file__).resolve().parent;W=D.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
config=Path('C:/Users/qed_s/.codex/hooks.json');config_sha=sha(config)
state=Path('C:/Users/qed_s/.cache/book-formalization/session-guards/48511011606d4532ef12a0e6a92d5568a625b5624c4ea45b6ec315b2174e7bdf.json')
state_sha=sha(state);assert not json.loads(state.read_bytes()).get('explicit_stop')
hook=json.loads(config.read_bytes())['hooks']['Stop'][0]['hooks'][0]
command=hook['commandWindows'];shell=os.environ.get('COMSPEC','C:/Windows/System32/cmd.exe')
# Codex command_runner.rs uses cmd /C and an outer quote around the raw command.
cmdline=subprocess.list2cmdline([shell])+' /C "'+command+'"'
payload={'session_id':'01a07fae-4a67-7770-98b0-b95c4e393705','cwd':str(W),'hook_event_name':'Stop','transcript_path':'C:/Users/qed_s/.codex/sessions/2026/09/08/rollout-2026-09-08T02-22-04-01a07fae-4a67-7770-98b0-b95c4e393705.jsonl'}
base=D/'cmd-shell';base.mkdir(exist_ok=False)
start=time.perf_counter();timed_out=False
try:
 result=subprocess.run(cmdline,cwd=W,input=json.dumps(payload).encode(),stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=30)
 out,err,code=result.stdout,result.stderr,result.returncode
except subprocess.TimeoutExpired as e:out,err,code=e.stdout or b'',e.stderr or b'',None;timed_out=True
elapsed=time.perf_counter()-start
(base/'stdout.txt').write_bytes(out);(base/'stderr.txt').write_bytes(err)
assert sha(state)==state_sha and sha(config)==config_sha
record={'mode':'cmd-shell','command_line':cmdline,'elapsed_seconds':elapsed,'outer_timed_out':timed_out,'exit_code':code,'stdout_sha256':sha(base/'stdout.txt'),'stderr_sha256':sha(base/'stderr.txt'),'state_unchanged':True,'hook_definition_unchanged':True,'limitation':'Ordinary subprocess environment and spawn; not a host lifecycle event.'}
(base/'receipt.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record));print(out.decode('utf-8',errors='replace'));print(err.decode('utf-8',errors='replace'))
raise SystemExit(code if code is not None else 124)

