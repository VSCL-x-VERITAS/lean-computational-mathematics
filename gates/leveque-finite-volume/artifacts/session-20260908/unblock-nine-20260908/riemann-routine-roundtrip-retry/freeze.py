"""Freeze this completed preparation; does not execute the proposed handoff."""
from pathlib import Path
import importlib.util,json
F=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('retry_recover',F/'recover.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
plan=m.read(F/'handoff-plan/plan.json')
for pin in plan['static_inputs']:m.verify(pin)
for live,key in [(m.O/'manifest.json','manifest_before'),
                 (m.O/'agent_outputs/agent_runs.json','agent_runs_before'),
                 (m.O/'agent_outputs/roundtrip_judge.json','invalid_canonical_before')]:
    assert live.read_bytes()==m.verify(plan[key]).read_bytes()
assert m.read(F/'guard-tests-exit.json')['exit_code']==0
assert m.read(F/'handoff-preparation-exit.json')['exit_code']==0
assert not (F/'handoff-plan/execution-started.json').exists()
packet={'format':'malformed-roundtrip-retry-preparation-manifest-1','task_id':m.TASK,
        'created_at_utc':m.now(),'files':[m.ref(p) for p in m.files(F)],
        'static_input_count':len(plan['static_inputs']),
        'skill':m.ref(m.R/'.faithfulness-audit/skill/formalization-faithfulness-audit/SKILL.md')}
m.write(F/'manifest.json',packet)
receipt={'format':'malformed-roundtrip-retry-preparation-receipt-1','task_id':m.TASK,
    'completed_at_utc':m.now(),'manifest':m.ref(F/'manifest.json'),'review':m.ref(F/'REVIEW.md'),
    'helper':m.ref(F/'recover.py'),'plan':m.ref(F/'handoff-plan/plan.json'),
    'fresh_retry_receipt':m.ref(F/'fresh-retry-receipt.json'),
    'guard_tests':m.ref(F/'guard-tests-exit.json'),'guard_tests_count':15,
    'preparation':m.ref(F/'handoff-preparation-exit.json'),
    'original_wrapper_exit_code':1,'fresh_native_exit_code':0,'fresh_released_role_validation_exit_code':0,
    'canonical_collection_performed':False,'operational_execution_performed':False}
m.write(F/'receipt.json',receipt)
print(json.dumps({'receipt':m.ref(F/'receipt.json'),**receipt},indent=2))
