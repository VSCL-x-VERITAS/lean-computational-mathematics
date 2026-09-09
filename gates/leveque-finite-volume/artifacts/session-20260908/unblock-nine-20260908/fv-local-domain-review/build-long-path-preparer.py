"""Derive an additive I/O-only transport fix with exact partial recovery guards."""
from pathlib import Path
from datetime import datetime,timezone
import ast,hashlib,json,os
F=Path(__file__).resolve().parent;D=F.parent;R=F.parents[5];S=D.parent
parent=D/'prepare-successor-audit-with-source-context.py'
assert hashlib.sha256(parent.read_bytes()).hexdigest()=='f0f27bc5757411a7363fcc70a18c78b2d5bf8011920f9e7c9ee2ebc2013f4ce2'
shim=(F/'native-long-path-io.py').read_text()
support=(F/'partial-prepare-recovery-support.py').read_text()
code=parent.read_text()
def replace_once(old,new):
 global code
 assert code.count(old)==1,(old,code.count(old))
 code=code.replace(old,new)
replace_once("D=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3];W=R.parent",shim+"\nD=Path(__file__).resolve().parent;S=D.parent;R=S.parents[3];W=R.parent")
replace_once("def create(p,data):\n p.parent.mkdir", "recovery_pins={};recovery_started=False\ndef create(p,data):\n global recovery_started\n if recovery_pins and p.parent==T and p.name in recovery_pins:\n  assert hashlib.sha256(data).hexdigest()==recovery_pins[p.name]\n  assert p.read_bytes()==data\n  return\n if recovery_pins and not recovery_started:\n  verify_partial_recovery(T,recovery_pins,True);recovery_started=True\n p.parent.mkdir")
replace_once("spec=json.loads(Path(sys.argv[1]).read_bytes())",support+"\nassert len(sys.argv) in (2,6)\nif len(sys.argv)==6:assert sys.argv[2]=='--recover-partial' and sys.argv[4]=='--recovery-sha256'\nspec=json.loads(Path(sys.argv[1]).read_bytes())")
replace_once("assert not T.exists(),T", "if len(sys.argv)==6:\n recovery_pins=load_partial_recovery(R,T,Path(sys.argv[1]),Path(sys.argv[3]),sys.argv[5])\n assert not (D/(taskid+'.config.json')).exists(),'Unexpected successor configuration.'\nelse:assert not T.exists(),T")
replace_once("T.mkdir();writej(T/'audit-task.json',task)","if not recovery_pins:T.mkdir()\nwritej(T/'audit-task.json',task)")
replace_once("def released(label,script,args,cwd):", "def released(label,script,args,cwd):\n if recovery_pins:verify_partial_recovery(T,recovery_pins)")
replace_once("'preparer_sha256':sha(Path(__file__))", "'preparer_sha256':sha(Path(__file__)),'partial_recovery_manifest':{'path':Path(sys.argv[3]).resolve().relative_to(R).as_posix(),'sha256':sys.argv[5]} if recovery_pins else None")
replace_once(" ast.parse(code);create(tr/name,code.encode())", " code=code.replace('from pathlib import Path','from pathlib import Path\\nimport os\\n'+"+repr(shim)+")\n ast.parse(code);create(tr/name,code.encode())")
replace_once("print(json.dumps({'prepared':taskid", "if recovery_pins:verify_partial_recovery(T,recovery_pins)\nprint(json.dumps({'prepared':taskid")
ast.parse(code)
target=D/'prepare-successor-audit-with-source-context-long-paths.py'
with target.open('x',encoding='utf-8',newline='\n') as f:f.write(code)
# Read the operational directory only. Never create or alter anything there.
exec(compile(shim,str(F/'native-long-path-io.py'),'exec'),globals())
spec_path=D/'finite-volume-local-flux-update-audit-spec.json';spec=json.loads(spec_path.read_bytes())
T=S/'audits'/spec['task_id']
assert {p.name for p in T.iterdir()}=={'audit-task.json','user-interpretation-packet.json'}
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
manifest={'format':'two-file-unsealed-audit-preparation-recovery-1','task_path':T.relative_to(R).as_posix(),
 'spec':ref(spec_path),'preparer_parent':ref(parent),'existing_files':[ref(T/name) for name in ('audit-task.json','user-interpretation-packet.json')],
 'failure_stage':'before-released-route'}
mp=F/'fv-partial-preparation-recovery.json'
with mp.open('x',encoding='utf-8',newline='\n') as f:json.dump(manifest,f,indent=2);f.write('\n')
print(json.dumps({'helper':ref(target),'recovery':ref(mp),'existing_files':manifest['existing_files']}))
