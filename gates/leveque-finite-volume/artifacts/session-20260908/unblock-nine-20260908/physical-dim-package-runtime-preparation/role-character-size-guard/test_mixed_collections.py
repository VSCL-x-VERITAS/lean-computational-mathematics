"""Mock metadata only: run both real collection functions without subprocesses."""
from pathlib import Path
import importlib.util,json,os,sys,types
H=Path(__file__).resolve().parent
def load(name,p):
 spec=importlib.util.spec_from_file_location(name,p)
 m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
old=load('original_staged_mixed_test',H.parent/'role-size-guard/staged.py')
new=load('character_staged_mixed_test',H/'staged.py')
out=H/sys.argv[1];assert not new.exists(out);os.mkdir(new.disk(out))
checks=[]
def reject(label,fn):
 try:fn()
 except AssertionError:checks.append({'test':label,'result':'rejected'});return
 raise AssertionError('Expected rejection: '+label)
T=out/'fixture-only-task';P=T/'orchestration';O=T/'faithfulness';A=O/'agent_outputs'
for p in (T,P,O,A):os.mkdir(new.disk(p))
new.create(P/'c.py',b'# MOCK ONLY: no collector is executed\n')
for m,label in ((old,'old'),(new,'new')):
 m.H=out/label;os.mkdir(m.disk(m.H));m.T=T;m.P=P;m.O=O
 m.create(m.H/'guard.py',('MOCK METADATA FOR '+label+' GUARD\n').encode())
def mock_step(destination,label,command,allowed=(0,)):
 assert label=='collect'
 _,_,_,collector,task,stem,role,name=command
 assert task==new.TID and Path(collector).resolve()==(P/'c.py').resolve()
 before=new.read(A/'agent_runs.json') if new.exists(A/'agent_runs.json') else {'task_id':task,'runs':[]}
 run={'role':role,'agent_id':'fixture-only-'+stem,'fixture_only':True}
 new.write(A/name,{'role':role,'task_id':task,'fixture_only':True})
 new.write(P/(stem+'_runtime.json'),{'tool_calls':0,'agent_id':run['agent_id'],
  'stdin_sha256':current_plan['stdin_sha256'],'fixture_only':True})
 # The only overwrite is the fake agent-runs manifest within this fixture subtree.
 with open(new.disk(A/'agent_runs.json'),'wb') as stream:
  stream.write((json.dumps({'task_id':task,'runs':before['runs']+[run]})+'\n').encode())
 new.create(destination/'mock-stdout.txt',b'fixture collector result\n')
 new.create(destination/'mock-stderr.txt',b'')
 return {'exit_code':0,'command':['MOCK-NO-SUBPROCESS'],
  'stdout':new.ref(destination/'mock-stdout.txt'),'stderr':new.ref(destination/'mock-stderr.txt')}
old.step=new.step=mock_step
pairs=[]
for m,role,stem in ((old,'source-contract','s'),(old,'blind-translation','b'),
                    (new,'direct-judge','d'),(new,'roundtrip-judge','r')):
 d=m.H/(stem+'-plan');os.mkdir(m.disk(d))
 current_plan={'task_id':m.TID,'runner':m.ref(m.H/'guard.py'),'within_limit':True,
  'collector':m.ref(P/'c.py'),'role':role,'stem':stem,'stdin_sha256':m.g.digest(('fixture-'+stem).encode()),
  'fixture_only':True,'format':'exact-role-stdin-size-guard-1' if m is old else 'exact-role-stdin-codepoint-guard-1'}
 m.write(d/'plan.json',current_plan)
 m.write(d/'execution-receipt.json',{'plan':m.ref(d/'plan.json'),'actual_exit_code':0,
  'guard_error':None,'existing_r_unchanged':True,'actual_cli_calls':[{'stdin_sha256':current_plan['stdin_sha256']}],
  'fixture_only':True})
 assert m.collect(types.SimpleNamespace(plan=[str(d/'plan.json'),m.ref(d/'plan.json')['sha256']],name=stem+'-collect'))==0
 p=m.H/(stem+'-collect')/'receipt.json';pairs.append([str(p),m.ref(p)['sha256']])
 checks.append({'test':role+' collected through '+('original' if m is old else 'successor')+' sibling','result':'accepted'})
for m,label in ((old,'original'),(new,'successor')):
 found,pins=m.collections(pairs,m.BASE_ROLES)
 assert set(found)==m.BASE_ROLES and len(pins)==4
 checks.append({'test':label+' finalizer accepts original source/blind plus successor direct/roundtrip','result':'accepted'})
 reject(label+' rejects duplicate collection',lambda m=m:m.collections(pairs+[pairs[0]],m.BASE_ROLES))
 reject(label+' rejects missing collection',lambda m=m:m.collections(pairs[:-1],m.BASE_ROLES))
 reject(label+' rejects wrong receipt pin',lambda m=m:m.collections([[pairs[0][0],'0'*64],*pairs[1:]],m.BASE_ROLES))
assert not new.exists(T/'role-run-receipt.json')
assert not new.exists(O/'decision.json')
new.write(out/'receipt.json',{'fixture_only':True,'checks':checks,'actual_semantic_roles':0,
 'actual_collector_subprocesses':0,'operational_plans_created':False,
 'original_staged':new.ref(H.parent/'role-size-guard/staged.py'),'successor_staged':new.ref(H/'staged.py'),
 'test':new.ref(Path(__file__))})
print(json.dumps({'fixture_only':True,'checks':len(checks),'receipt':new.ref(out/'receipt.json')},indent=2))
