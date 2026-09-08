"""Bind a fresh root entry to the completed linear-Riemann context preparation."""
from pathlib import Path
import ast,hashlib,json
S=Path(__file__).resolve().parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
src=S/'run-cell-average-measure-context-audit-pipeline.py'
assert sha(src)=='efc14c0049bdec58165c53bf6d47b2d2d451edd567ed418431eeacd844cc6b6e'
task='LEV-CH01-LINEAR-RIEMANN-MEASURE-CONTEXT-PRODUCTION-20260908'
T=S/'audits'/task;handoff=T/'prepared-handoff-base.json';h=json.loads(handoff.read_bytes())
assert h['task_id']==task and h['pages_argument']=='23,25,27,28'
for label in ['route','prepare','prepared-validation']:
 r=json.loads((T/(label+'-exit.json')).read_bytes());assert r['exit_code']==0
 assert sha(T/(label+'-output.txt'))==r['stdout_sha256']
 assert sha(T/(label+'-stderr.txt'))==r['stderr_sha256']
code=src.read_text()
for old,new in [('LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908',task),('3c04b887696f682495d50f1ee05d4ae27d213b065d2dff6b8e3bc1e96c4184c7',sha(handoff)),('cell-average native-measure successor','linear-Riemann native-measure successor')]:
 assert code.count(old)==1;code=code.replace(old,new)
ast.parse(code)
dest=S/'run-linear-riemann-measure-context-audit-pipeline.py';assert not dest.exists();dest.write_text(code,encoding='utf-8',newline='\n')
record={'schema':1,'parent_sha256':sha(src),'entry_sha256':sha(dest),'handoff_sha256':sha(handoff),'task':task,'changes':['Exact task and reviewed prepared-handoff hash substitution','Descriptive docstring only'],'semantic_roles_launched':0}
p=S/'linear-riemann-measure-context-entry-derivation.json';assert not p.exists();p.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record))

