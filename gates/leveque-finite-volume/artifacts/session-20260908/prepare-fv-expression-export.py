"""Reuse the structural serializer for the five new FV module owners."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
oldpath=S/'chapter01-current-expression-fingerprints-3239.json'
assert sha(oldpath)=='6ca24e74145d412e69237d0059c018cf12a1843f0d0609d0087638a51b5e233d'
old=read(oldpath)
for f in old['files']:assert sha(R/f['path'])==f['sha256']
parent=S/'export-definition-declaration-expressions.lean'
assert sha(parent)==read(S/'definition-expression-export-inputs.json')['exporter_sha256']
m=read(S/'fv-foundations-analysis-imports.json')
assert sha(S/'root-batch7-fv-placement-verification.json')=='a987b8fada4261daa4d69848b99af317f6b489639d36c0a9ce1107a82dc042ce'
for f in m['files']:assert sha(R/f['path'])==f['sha256']
modules=sorted(f['path'][:-5].replace('/','.') for f in m['files'])
assert len(modules)==5 and not set(modules)&set(old['selected_modules'])
code=parent.read_text(encoding='utf-8');start=code.index('private def selectedModules : Array String := #[\n');end=code.index('\n]\n\nrun_cmd do',start)
code=code[:start]+'private def selectedModules : Array String := #[\n'+',\n'.join('  '+json.dumps(x) for x in modules)+code[end:]
assert code.count('.lake/chapter01-definition-expressions.jsonl')==1
code=code.replace('.lake/chapter01-definition-expressions.jsonl','.lake/chapter01-fv-expressions.jsonl')
p=S/'export-fv-declaration-expressions.lean'
with p.open('x',encoding='utf-8',newline='\n') as f:f.write(code)
record={'schema':1,'files':m['files'],'selected_modules':modules,'exporter_path':p.relative_to(R).as_posix(),'exporter_sha256':sha(p),'normalization':old['normalization'],'prior_exporter_sha256':sha(parent),'prior_fingerprints_sha256':sha(oldpath),'input_commit':subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip(),'entry_point_additions':m}
out=S/'fv-expression-export-inputs.json'
with out.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'manifest_sha256':sha(out),'exporter_sha256':sha(p),'modules':modules}))

