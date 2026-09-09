"""Pure fixture tests. Every receipt written here is explicitly test data, not an audit."""
from pathlib import Path
import importlib.util,json,os,sys,types
H=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('staged_fixture_subject',H/'staged.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
out=H/sys.argv[1];assert not m.exists(out);os.mkdir(m.disk(out))
checks=[]
def reject(label,fn):
 try:fn()
 except AssertionError:checks.append({'test':label,'result':'rejected'});return
 raise AssertionError('Expected rejection: '+label)
for code,required in ((0,False),(3,True)):
 m.adjudication_contract(code,{'required':required});checks.append({'test':f'actual check exit {code}','result':'accepted'})
for code,required in ((0,True),(3,False),(1,False),(0,0),(False,False)):
 reject(f'inconsistent trigger {code!r}/{required!r}',lambda c=code,r=required:m.adjudication_contract(c,{'required':r}))

# Use only this fixture subtree for all mocked operational output paths.
m.H=out;m.T=out/'fake-task';m.P=m.T/'fake-orchestration';m.O=m.T/'fake-faithfulness'
for p in (m.T,m.P,m.O):os.mkdir(m.disk(p))
m.CONFIG=out/'fake-config.json';m.write(m.CONFIG,{'fixture_only':True})
m.env=lambda:{'FIXTURE_ONLY':'1'}
m.write(m.T/'role-transport-preflight.json',{'fixture_only':True})
for bad in ('../outside','', '/absolute'):
 reject('attempt name '+repr(bad),lambda name=bad:m.new_attempt(name))

stepdir=out/'fake-step';os.mkdir(m.disk(stepdir))
original_run=m.subprocess.run
def failure(*args,**kwargs):return types.SimpleNamespace(returncode=7,stdout=b'fixture stdout\n',stderr=b'fixture failure\n')
m.subprocess.run=failure
reject('failed collector/validator exit retained',lambda:m.step(stepdir,'sample',['fixture-only']))
assert m.read(stepdir/'sample-receipt.json')['exit_code']==7
assert m.raw(stepdir/'sample-output.txt')==b'fixture stdout\n'
args=types.SimpleNamespace(name='failed-finish',check=['fixture','0'*64],collection=[])
assert m.finish(args)==7
assert not m.exists(m.T/'role-run-receipt.json')
checks.append({'test':'failed finalization leaves canonical aggregate absent','result':'accepted'})

def completed_fixture(command,**kwargs):
 destination=Path(command[6])
 for name,value in [('decision.json',{'fixture_only':True,'accepted':False,'classification':'undetermined'}),
                    ('manifest.json',{'fixture_only':True,'status':'complete'}),
                    ('report.json',{'fixture_only':True})]:m.write(m.O/name,value)
 complete={'task_id':m.TID,'exit_code':0,'q_py_invoked':False,
  'decision':m.ref(m.O/'decision.json'),'manifest':m.ref(m.O/'manifest.json'),'report':m.ref(m.O/'report.json')}
 m.write(destination/'completion.json',complete)
 return types.SimpleNamespace(returncode=0,stdout=b'fixture-only successful completion\n',stderr=b'')
m.subprocess.run=completed_fixture
args.name='successful-finish'
assert m.finish(args)==0
aggregate=m.read(m.T/'role-run-receipt.json')
assert aggregate['exit_code']==0 and not aggregate['q_py_invoked']
assert aggregate['decision_sha256']==m.ref(m.O/'decision.json')['sha256']
assert m.read(m.O/'decision.json')['accepted'] is False and not aggregate['source_acceptance_inferred']
checks.append({'test':'completion exit zero preserves nonaccepted verdict and does not claim q execution','result':'accepted'})
args.name='overwrite-forbidden'
reject('retained aggregate cannot be overwritten',lambda:m.finish(args))
m.subprocess.run=original_run
m.write(out/'tests.json',{'fixture_only':True,'checks':checks,'actual_audit_or_model_invocations':0,
 'subject':m.ref(H/'staged.py'),'guard':m.ref(H/'guard.py'),'test':m.ref(Path(__file__))})
print(json.dumps({'fixture_only':True,'checks':len(checks),'actual_audit_or_model_invocations':0},indent=2))
