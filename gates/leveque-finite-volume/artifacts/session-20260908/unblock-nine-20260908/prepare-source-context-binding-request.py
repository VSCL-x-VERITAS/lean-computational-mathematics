"""Freeze a qualified replacement-row request only after its genuine audit accepts both implications."""
from pathlib import Path
import hashlib,importlib.util,json,os,sys
assert os.name!='nt'
D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
specification=json.loads(Path(sys.argv[1]).read_bytes())
T=S/'audits'/specification['task_id']
task=json.loads((T/'audit-task.json').read_bytes())
decision=json.loads((T/'faithfulness/decision.json').read_bytes())
run=json.loads((T/'role-run-receipt.json').read_bytes())
assert run['exit_code']==0 and run['decision_sha256']==sha(T/'faithfulness/decision.json')
assert decision['accepted'] is True and decision['classification']=='faithful-equivalent'
assert all(decision['implications'][key]['verdict']=='yes' for key in ['lean_implies_source','source_implies_lean'])
assert task['target']==specification['target']
native_manifest=D/'local-complete-declaration-manifest.json'
manifest=json.loads(native_manifest.read_bytes())
assert manifest['rows'][specification['row_id']]==task['target']
assert all(sha(R/f['path'])==f['sha256'] for f in manifest['files'])
checker_path=R.parent/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/scripts/gate.py'
assert sha(checker_path)=='3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104'
sp=importlib.util.spec_from_file_location('replacement_checker',checker_path);checker=importlib.util.module_from_spec(sp);sp.loader.exec_module(checker)
context=checker.current_context(R/'gates/leveque-finite-volume/chapter-01.json',1)
request={'schema':1,'row':specification['row_id'],'status':'PROVED',
 'task':ref(T/'audit-task.json'),'manifest':ref(T/'faithfulness/manifest.json'),'decision':ref(T/'faithfulness/decision.json'),
 'interpretation_packet':ref(T/'user-interpretation-packet.json'),'current_bindings':context['bindings'],
 'source_context_extension':specification['source_context_extension'],
 'inherited_source_interpretation_packet':ref(T/'inherited-source-interpretation-packet.json'),
 'source_context_lineage':ref(T/'preparation-lineage.json'),
 'native':{'receipt_kind':'argv','check':ref(D/'LocalCompleteDeclarations.lean'),
 'output':ref(S/'unblock-nine-local-complete-declarations-02-output.txt'),
 'receipt':ref(S/'unblock-nine-local-complete-declarations-02-exit.json'),
 'proof_manifest':ref(native_manifest),'declarations':[task['target']['declaration']]}}
assert ref(R/request['source_context_extension']['path'])==request['source_context_extension']
destination=Path(sys.argv[2]).resolve();assert destination.is_relative_to(D.resolve())
with destination.open('xb') as f:f.write((json.dumps(request,indent=2)+'\n').encode())
print(json.dumps(ref(destination)))
