"""Verify actual adapter exits and the exact recorded stronger row evidence."""
from pathlib import Path
import importlib.util,json
S=Path(__file__).resolve().parent;R=S.parents[3]
spec=importlib.util.spec_from_file_location('production_stronger',S/'bind-audited-stronger-production-rows.py');mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
progress=mod.read(S/'stronger-production-closure/progress.json')
assert progress['mode']=='execute' and progress['adapter_sha256']==mod.sha(S/'bind-audited-stronger-production-rows.py')
gate=mod.read(R/'gates/leveque-finite-volume/chapter-01.json')
assert {x['row'] for x in progress['steps']}=={p['row'] for p in mod.pins()['rows']}
for step in progress['steps']:
 assert type(step['exit_code']) is int and step['exit_code']==0
 for key in ('stdout','stderr'):mod.bound_file(R,step[key])
 row=next(r for r in gate['rows'] if r['id']==step['row']);assert row['status']=='PROVED'
 taskpath=R/row['faithfulness_task'];task=mod.read(taskpath);out=R/task['audit_output']
 mod.validate_strengthening_evidence(R,taskpath,task,mod.read(out/'manifest.json'),mod.read(out/'decision.json'),mod.bound_file(R,row['strengthening_evidence']),row)
print(json.dumps({'rows':len(progress['steps']),'actual_child_exits':[x['exit_code'] for x in progress['steps']],'progress_sha256':mod.sha(S/'stronger-production-closure/progress.json'),'gate_sha256':mod.sha(R/'gates/leveque-finite-volume/chapter-01.json')}))
