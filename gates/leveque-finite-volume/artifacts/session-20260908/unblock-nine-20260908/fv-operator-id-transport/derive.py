"""Derive a single assertion-only compatibility variant. Invoke no audit role."""
from pathlib import Path
import hashlib,json,os
D=Path(__file__).resolve().parent
S=D.parent.parent
R=S.parents[3]
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),
             'native-long-path-io','exec'),globals())
tid='LEV-CH01-FV-LOCAL-FLUX-UPDATE-OPERATOR-QUALIFIED-20260908'
P=S/'audits'/tid/'faithfulness/orchestration'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
original=(P/'q.py').read_bytes()
assert sha(P/'q.py')=='105eaf5835daa11270fa8c3d5b651479097a8923d061754785e1a5ff9ef90368'
old=b"assert task.startswith('LEV-CH01-') and task.endswith(('-CANONICAL-20260908','-PRODUCTION-20260908'))"
new=('assert task=='+repr(tid)).encode()
assert original.count(old)==1 and original.count(new)==1
successor=original.replace(old,new,1)
assert successor.replace(new,old,1)!=original # the first exact guard is the untouched original
assert successor.count(new)==2
compile(successor,'q-operator-id.py','exec')
assert successor==original[:original.index(old)]+new+original[original.index(old)+len(old):]
assert eval(new.removeprefix(b'assert '),{'task':tid})
assert not eval(old.removeprefix(b'assert '),{'task':tid})
assert not eval(new.removeprefix(b'assert '),{'task':tid+'-OTHER'})
with (D/'q-operator-id.py').open('xb') as h:h.write(successor)
compile((D/'run.py').read_bytes(),'run.py','exec')
receipt={'format':'exact-task-orchestration-name-compatibility-1','task_id':tid,
    'parent':ref(P/'q.py'),'successor':ref(D/'q-operator-id.py'),'launcher':ref(D/'run.py'),
    'exact_removed_line':old.decode(),'exact_added_line':new.decode(),
    'byte_delta_only':True,'original_exact_task_guard_retained':True,
    'role_protocol_and_calls_unchanged':True,'source_or_audit_inputs_changed':False,
    'syntax_checks':True,'guard_tests':3,'roles_invoked':False}
with (D/'derivation.json').open('xb') as h:h.write((json.dumps(receipt,indent=2)+'\n').encode())
print(json.dumps({'derivation':ref(D/'derivation.json'),'launcher':ref(D/'run.py'),
    'successor':ref(D/'q-operator-id.py')},indent=2))
