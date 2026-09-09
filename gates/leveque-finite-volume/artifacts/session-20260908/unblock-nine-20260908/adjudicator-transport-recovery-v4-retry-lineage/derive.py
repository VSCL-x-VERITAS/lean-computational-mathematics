"""Derive one narrow V3 successor; preserve all unchanged transport primitives."""
from pathlib import Path
import ast,hashlib,json
F=Path(__file__).resolve().parent
base=F.parent/'adjudicator-transport-recovery-v3/recovery-v3.py'
expected='a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887'
assert hashlib.sha256(base.read_bytes()).hexdigest()==expected
source=base.read_bytes().decode().replace('\r\n','\n')
original=source
guards=(F/'lineage-guards.fragment').read_text(encoding='utf-8')
def replace(old,new,count=1):
    global source
    assert source.count(old)==count,(old,source.count(old))
    source=source.replace(old,new)
replace('\ndef prepare(spec_path,failed_stem,new_stem,destination):',
        '\n'+guards+'\ndef prepare(spec_path,failed_stem,new_stem,destination):')
replace("    spec=read(spec_path);tid=spec['task_id']\n",
        "    spec=read(spec_path);tid=spec['task_id']\n    assert tid==RETRY_TASK and failed_stem=='a' and new_stem=='a2'\n")
replace("    assert len(runs['runs'])==4 and len({x['agent_id'] for x in runs['runs']})==4\n",
        "    lineage=retry_lineage(tid,runs)\n")
replace("    dedup={str(p.resolve()):ref(p) for p in static}\n",
        "    static += [verify(pin) for pin in lineage['pins']]\n    dedup={str(p.resolve()):ref(p) for p in static}\n")
replace("'lossless-adjudicator-recovery-plan-1'","'lossless-adjudicator-retry-lineage-plan-1'",2)
replace("        'role_protocol_changed':False,'roles_invoked':False}\n",
        "        'role_protocol_changed':False,'roles_invoked':False,'retry_lineage':lineage}\n")
replace("    original=read(verify(plan['original_transport']))\n",
        "    assert retry_lineage(tid,read(O/'agent_outputs/agent_runs.json'))==plan['retry_lineage']\n    original=read(verify(plan['original_transport']))\n")
replace("'lossless-adjudicator-recovery-execution-1'","'lossless-adjudicator-retry-lineage-execution-1'")
replace("        'original_attempt_retained':True,'exit_code':2,'guard_error':None}\n",
        "        'original_attempt_retained':True,'exit_code':2,'guard_error':None,\n        'actual_continuation_failure_receipt':plan['retry_lineage']['actual_continuation_failure_receipt'],\n        'retry_lineage':plan['retry_lineage']}\n")
old={n.name:ast.dump(n,include_attributes=False) for n in ast.parse(original).body if isinstance(n,(ast.FunctionDef,ast.AsyncFunctionDef))}
new={n.name:ast.dump(n,include_attributes=False) for n in ast.parse(source).body if isinstance(n,(ast.FunctionDef,ast.AsyncFunctionDef))}
unchanged=[name for name in old if name not in ('prepare','execute')]
assert all(new[name]==old[name] for name in unchanged)
assert set(new)-set(old)=={'retry_history','continuation_contract','retry_lineage'}
with (F/'recovery-v4.py').open('x',encoding='utf-8',newline='\n') as out:out.write(source)
receipt={'base':{'path':str(base.resolve()),'sha256':expected},
    'derived':{'path':str((F/'recovery-v4.py').resolve()),'sha256':hashlib.sha256((F/'recovery-v4.py').read_bytes()).hexdigest()},
    'unchanged_function_asts':unchanged,'changed_existing_functions':['prepare','execute'],
    'added_functions':sorted(set(new)-set(old)),'operational_invocation':False}
with (F/'derivation.json').open('x',encoding='utf-8') as out:json.dump(receipt,out,indent=2);out.write('\n')
print(json.dumps(receipt,indent=2))
