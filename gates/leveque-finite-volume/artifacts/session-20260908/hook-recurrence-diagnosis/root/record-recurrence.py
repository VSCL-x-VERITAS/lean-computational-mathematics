"""Record the observed recurring process issue without changing guard or gate."""
from pathlib import Path
import hashlib,json
D=Path(__file__).resolve().parent;W=D.parents[1];R=W/'lean-computational-mathematics'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
modes=W/'workflow-v5.0.1-local/chapter01-hook-process-mode-tests'
results=[]
for name in ['no-window','detached','cmd-shell','contained-cmd-trace']:
 p=modes/name/'receipt.json';v=json.loads(p.read_bytes());assert v['exit_code']==0 and not v['outer_timed_out'];results.append({'mode':name,'receipt_path':str(p),'receipt_sha256':sha(p),'elapsed_seconds':v['elapsed_seconds']})
trace=modes/'contained-cmd-trace/git-trace.jsonl';starts={};ends={}
for line in trace.read_text(encoding='utf-8').splitlines():
 v=json.loads(line)
 if v.get('event')=='start':starts[v['sid']]=v
 if v.get('event')=='exit':ends[v['sid']]=v
assert set(starts)==set(ends) and all(v['code']==0 for v in ends.values())
git=[{'argv':starts[s]['argv'],'start_time':starts[s]['time'],'exit_time':ends[s]['time'],'seconds':ends[s]['t_abs'],'exit_code':ends[s]['code']} for s in starts]
config=Path('C:/Users/qed_s/.codex/hooks.json');assert sha(config)=='f18c55231c66f29563ab1ea120ec152594349e74ee011400a60c7a4b5d6e715c'
gate=R/'gates/leveque-finite-volume/chapter-01.json';assert sha(gate)=='e264dd1cea8cdc57b0389876aad410092df72c1ad48ca1fb73d14049374659c0'
record={'kind':'second-actual-stop-timeout-diagnosis','host_timeout_root_cause_established':False,'actual_host_failures':2,'successful_diagnostic_replicas':results,'trace_sha256':sha(trace),'traced_git_commands':git,'configuration_sha256':sha(config),'gate_sha256':sha(gate),'diagnostic_limit':'All replicas use tool-created environment/pipes. They are not actual host Stop events and do not resolve the recurring host failure. Only the shell/job factors were replicated; timing variation alone is inconclusive.','next_discriminating_observation':'A separately launched passive process observer across the actual host Stop event; no hook, timeout, validator or trust change.'}
with (D/'recurrence-evidence.json').open('xb') as f:f.write((json.dumps(record,indent=2)+'\n').encode())
ledger=R/'ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908/issues.md'
raw=ledger.read_bytes();assert b'LEV-SKILL-STOP-HOST-RECURRENCE-068' not in raw
with (D/'process-issues-before.bin').open('xb') as f:f.write(raw)
row='| LEV-SKILL-STOP-HOST-RECURRENCE-068 | codex-start-1-v5-0-1-20260908 | second actual Stop-hook closure attempt | The next actual host Stop again exceeded the unchanged guard inner 20-second closure budget, although both prior direct replays passed | Preserve both actual hook records; inspect matching-version runner, effective local hook list, and bounded process-context controls | open host-runtime diagnosis; root cause unproved | No-window 7.457s, detached 8.516s, cmd-shell 16.335s and suspended contained-job cmd 9.794s all actual exit 0; recurrence-evidence.json binds exact receipts and Git trace | Direct passing replicas do not resolve the actual host failure. Passive external process observation is the next discriminating step. No timeout, hook, trust state, guard, runtime, validator, gate or mathematical contract changed; source choices remain unanswered. |'
newline=b'\r\n' if b'\r\n' in raw else b'\n'
with ledger.open('ab') as f:f.write((b'' if raw.endswith(b'\n') else newline)+row.encode()+newline)
with (D/'ledger-update.json').open('xb') as f:f.write((json.dumps({'path':str(ledger),'before_sha256':hashlib.sha256(raw).hexdigest(),'after_sha256':sha(ledger),'appended_id':'LEV-SKILL-STOP-HOST-RECURRENCE-068','book_ledger_changed':False},indent=2)+'\n').encode())
print(json.dumps({'status':'RECURRENCE_RECORDED','root_cause_established':False,'diagnostic_modes':results,'traced_git_commands':len(git),'evidence_sha256':sha(D/'recurrence-evidence.json'),'ledger_sha256':sha(ledger)}))

