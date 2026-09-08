"""Run an explicit bounded list of untouched default audits sequentially.

Each child keeps its own immutable actual-exit receipt. The queue has one child
and therefore at most one fresh semantic role at a time. No gate is written.
"""
from pathlib import Path
import argparse,hashlib,json,subprocess,sys
S=Path(__file__).resolve().parent;R=S.parents[3]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('tasks',nargs='+');a=p.parse_args()
assert 1<=len(a.tasks)<=6 and len(set(a.tasks))==len(a.tasks)
helper=S/'run-root-audit-pipeline.py';sha=lambda b:hashlib.sha256(b).hexdigest()
handoff=Path(chr(92)*2+'?'+chr(92)+str(S/'audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/coordinator-handoff-20260908.json'))
assert sha(handoff.read_bytes())=='0506bd8f4846d9725c1141b9cc390bf35aa93e67982336c7dca9ded647f71e1f'
entries={x['task_id']:x for x in json.loads(handoff.read_bytes())['pending']}
for task in a.tasks:assert task in entries
for task in a.tasks:
 print(json.dumps({'queue_boundary':'starting_task','task':task}),flush=True)
 result=subprocess.run([sys.executable,'-B',str(helper),task,entries[task]['pages_argument']],cwd=R)
 print(json.dumps({'queue_boundary':'child_completed','task':task,'actual_exit_code':result.returncode}),flush=True)
 if result.returncode:raise SystemExit(result.returncode)
print(json.dumps({'queue_boundary':'all_children_completed','tasks':a.tasks,'actual_exit_code':0}),flush=True)

