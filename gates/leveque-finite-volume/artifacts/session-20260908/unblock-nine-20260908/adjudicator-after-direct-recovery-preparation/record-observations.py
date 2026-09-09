from pathlib import Path
import hashlib,json,os
D=Path(__file__).resolve().parent;R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
T=R/'gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908';P=T/'faithfulness/orchestration'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':str(p),'sha256':sha(p)}
def read(p):return json.loads(p.read_bytes())
execution=D.parent/'direct-transport-recovery-v1/dim-d2-01/execution-receipt.json';ex=read(execution)
native=next(x for x in ex['steps'] if x['name']=='native-direct')
assert native['exit_code']==ex['exit_code']==0 and ex['audit_completed'] is False
stderr=(P/'d2_stderr.txt').read_text();assert '2026-09-08T20:40:04.071927Z' in stderr
assert sha(P/'d2_stderr.txt')==native['stderr']['sha256']
runtime=read(P/'d2_runtime.json')
assert runtime['agent_id']==ex['new_direct_agent_id'] and runtime['tool_calls']==0
continuation=D.parent/'dim-original-adjudication-continuation-01/receipt.json';cont=read(continuation)
assert cont['exit_code']==1 and cont['original_four_roles_unchanged'] and cont['original_wrapper_unchanged']
a=read(P/'a_transport.json');events=[json.loads(x) for x in (P/'a_events.jsonl').read_bytes().splitlines()]
assert a['exit_code']==1 and [x['type'] for x in events]==['thread.started'] and not (P/'a_final.json').exists()
assert len((P/'a_input.txt').read_bytes())==a['stdin_bytes'] and sha(P/'a_input.txt')==a['stdin_sha256']
assert (P/'a_input.txt').read_bytes()==(D/'prospective-input.txt').read_bytes()
notes={'format':'completed-delay-and-distinct-adjudicator-capacity-observations-1',
 'direct_recovery':ref(execution),'native_direct_exit_code':0,'native_elapsed_seconds':native['elapsed_seconds'],
 'native_started_at_utc':native['started_at_utc'],'native_completed_at_utc':native['completed_at_utc'],
 'direct_stderr':ref(P/'d2_stderr.txt'),'stderr_warning_timestamp':'2026-09-08T20:40:04.071927Z',
 'direct_runtime':ref(P/'d2_runtime.json'),'turn_context_timestamp':runtime['turn_context']['timestamp'],
 'final_timestamp':runtime['final_timestamp'],'runtime_tool_calls':runtime['tool_calls'],
 'root_reported_live_observation':{'around':'20:44 UTC','events_and_stderr_file_lengths':0,
   'provenance':'Root task message; this worker did not independently collect the live process/filesystem snapshot.'},
 'conclusion':'Completed stderr records native activity shortly after launch. The earlier reported zero-length files do not establish startup had not begun. The direct role eventually completed successfully without intervention. No causal Windows I/O or process-creation failure has been demonstrated.',
 'process_intervention_performed':False,'role_restarted':False,
 'separate_actual_adjudicator_failure':{'continuation':ref(continuation),'transport':ref(P/'a_transport.json'),
   'events':ref(P/'a_events.jsonl'),'stderr':ref(P/'a_stderr.txt'),'input':ref(P/'a_input.txt'),
   'native_exit_code':1,'event_types':[x['type'] for x in events],
   'input_characters':len((P/'a_input.txt').read_text()),'input_limit_characters':1048576,
   'has_final':False,'prospective_input_matches_actual_bytes':True},
 'operational_files_modified':False,'new_roles_invoked':False}
with (D/'observations.json').open('xb') as f:f.write((json.dumps(notes,indent=2)+'\n').encode())
print(json.dumps({'observations':ref(D/'observations.json'),'turn_context_timestamp':notes['turn_context_timestamp'],'final_timestamp':notes['final_timestamp']},indent=2))
