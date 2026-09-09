"""Freeze one binding request from genuine completed equivalent audit evidence."""
from pathlib import Path
import hashlib,importlib.util,json,os,sys
assert os.name!='nt'
D=Path(__file__).resolve().parent
S=D.parent
R=S.parents[3]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
specification=json.loads(Path(sys.argv[1]).read_bytes())
taskid=specification['task_id']
T=S/'audits'/taskid
task=json.loads((T/'audit-task.json').read_bytes())
decision=json.loads((T/'faithfulness/decision.json').read_bytes())
assert decision['accepted'] is True and decision['classification']=='faithful-equivalent'
assert all(decision['implications'][d]['verdict']=='yes' for d in ['lean_implies_source','source_implies_lean'])
checker_path=R.parent/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
assert sha(checker_path)=='3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104'
spec=importlib.util.spec_from_file_location('checker',checker_path)
checker=importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)
context=checker.current_context(R/'gates/leveque-finite-volume/chapter-01.json',1)
request={'schema':1,'row':specification['row_id'],'status':'PROVED',
 'task':ref(T/'audit-task.json'),'manifest':ref(T/'faithfulness/manifest.json'),
 'decision':ref(T/'faithfulness/decision.json'),
 'interpretation_packet':ref(T/'user-interpretation-packet.json'),
 'current_bindings':context['bindings'],
 'native':{'receipt_kind':'argv','check':ref(D/'CompleteDeclarations.lean'),
 'output':ref(S/'unblock-nine-complete-declarations-output.txt'),
 'receipt':ref(S/'unblock-nine-complete-declarations-exit.json'),
 'proof_manifest':ref(D/'complete-declaration-manifest.json'),
 'declarations':[task['target']['declaration']]}}
destination=Path(sys.argv[2]).resolve()
assert destination.is_relative_to(D.resolve())
with destination.open('xb') as f:f.write((json.dumps(request,indent=2)+'\n').encode())
print(json.dumps(ref(destination)))
