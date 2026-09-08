"""Exercise rejection paths in memory; never invoke a mutation entry point."""
from pathlib import Path
from datetime import datetime,timezone
import copy,hashlib,importlib.util,json,subprocess,sys
P=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('reviewed_rebind_driver',P/'rebind-closed-rows.py')
d=importlib.util.module_from_spec(spec);spec.loader.exec_module(d)
before=d.G.read_bytes();gate=json.loads(before);inputs=d.read(P/'reviewed-inputs.json')
checker_path=d.R.parent/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
checker=d.import_module('negative_gate_checks',checker_path)
stronger=d.import_module('negative_stronger_checks',d.bound(inputs['adapters']['bind-audited-stronger-reused-row.py']))
contracts={r['id']:d.source_contract(r) for r in gate['rows'] if r['status'] in d.CLOSED}
records=[]
def rejected(label,fn):
 try:fn()
 except (ValueError,KeyError) as error:
  records.append({'check':label,'rejected':True,'reason':str(error)});return
 raise AssertionError('Negative case unexpectedly accepted: '+label)
def change_row(rowid,key,value):
 changed=copy.deepcopy(gate);next(r for r in changed['rows'] if r['id']==rowid)[key]=value
 d.assert_preserved(gate,changed,contracts)
for key,value in [('status','REUSED'),('classification','faithful-stronger'),('faithfulness_task','wrong-task.json'),('lean_declarations',['Wrong.declaration']),('contract_hash','0'*64)]:
 rejected('preserve interpreted transport '+key,lambda k=key,v=value:change_row('LEV-CH01-EQ-1.2-ADVECTION',k,v))
rejected('preserve scoped classification note',lambda:change_row(d.SECOND,'adjudicated_scope_note',{'classification_only':False}))
rejected('preserve strengthening evidence',lambda:change_row(d.SMOOTH,'strengthening_evidence',{'path':'wrong','sha256':'0'*64}))
rejected('preserve nonvacuity evidence',lambda:change_row(d.SMOOTH,'nonvacuity_witness','Dropped'))
def unknown_interpretation():
 row=copy.deepcopy(next(r for r in gate['rows'] if r['id'] in d.TRANSPORT));task=d.read(d.R/row['faithfulness_task']);out=d.R/task['audit_output'];row['id']='LEV-CH01-UNKNOWN-INTERPRETED'
 d.select_adapter(row,d.read(out/'decision.json'),contracts['LEV-CH01-EQ-1.2-ADVECTION'],d.read(out/'agent_outputs/source_contract.json'))
rejected('no generic fallback for unknown interpretation',unknown_interpretation)
def generic_scope_loss():
 row=next(r for r in gate['rows'] if r['id']=='LEV-CH01-ADVECTION-LINEAR-FLUX');task=d.read(d.R/row['faithfulness_task']);out=d.R/task['audit_output'];contract=copy.deepcopy(contracts[row['id']]);contract['statement']='Broadened source claim'
 d.select_adapter(row,d.read(out/'decision.json'),contract,d.read(out/'agent_outputs/source_contract.json'))
rejected('no generic source-scope rewrite',generic_scope_loss)
def unknown_stronger():
 row=copy.deepcopy(next(r for r in gate['rows'] if r['id']==d.SMOOTH));row['id']='LEV-CH01-UNKNOWN-STRONGER'
 d.select_adapter(row,{},contracts[d.SMOOTH],{})
rejected('stronger support restricted to pinned smooth task',unknown_stronger)
rejected('adapter byte change rejected',lambda:d.bound({**inputs['adapters']['rebind-reused-row.py'],'sha256':'0'*64}))
def false_native_exit():
 task=d.read(d.R/next(r for r in gate['rows'] if r['id']==d.SECOND)['faithfulness_task'])
 original_read=d.read;target=d.bound(inputs['proof_catalog'][0]['resolution_exit'])
 def bad_read(p):
  value=original_read(p)
  return {**value,'exit_code':True} if Path(p)==target else value
 try:
  d.read=bad_read;d.proof_evidence(task,inputs['proof_catalog'],stronger)
 finally:d.read=original_read
rejected('boolean native success rejected',false_native_exit)
cmd=[sys.executable,'-B',str(P/'rebind-second-order-scoped-row.py'),'--gate-checker',str(checker_path),'--gate',str(d.G),'--task','unused','--row',d.SECOND,'--resolution-log','unused','--resolution-exit','unused','--resolution-manifest','unused','--check-file','unused']
result=subprocess.run(cmd,cwd=d.R,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
assert result.returncode==2 and b'--rebind' in result.stderr
for name,data in [('missing-rebind-stdout.txt',result.stdout),('missing-rebind-stderr.txt',result.stderr)]:
 path=P/name;assert not path.exists();path.write_bytes(data)
records.append({'check':'scoped adapter requires explicit --rebind before any evidence or mutation','command':cmd,'exit_code':result.returncode,'stdout_sha256':hashlib.sha256(result.stdout).hexdigest(),'stderr_sha256':hashlib.sha256(result.stderr).hexdigest(),'rejected':True})
assert d.G.read_bytes()==before
receipt={'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'checks':records,'count':len(records),'exit_code':0,'driver_main_invoked':False,'mutation_entry_invoked':False,'gate_before_sha256':hashlib.sha256(before).hexdigest(),'gate_after_sha256':d.sha(d.G),'driver_sha256':d.sha(P/'rebind-closed-rows.py'),'second_order_sha256':d.sha(P/'rebind-second-order-scoped-row.py')}
d.immutable_json(P/'negative-checks.json',receipt)
print(json.dumps({'count':len(records),'exit_code':0,'receipt_sha256':d.sha(P/'negative-checks.json'),'gate_unchanged':True}))
