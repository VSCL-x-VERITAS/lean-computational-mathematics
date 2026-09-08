"""Prepare the existing structural serializer for the four new module owners."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_bytes())
oldpath=S/'chapter01-current-expression-fingerprints-7707.json'
assert sha(oldpath)=='374319bfa993ce386f53a52b0fced7c222158a9f1e21086f9ec26b8cea498682'
old=read(oldpath)
for f in old['files']:assert sha(R/f['path'])==f['sha256']
parent=S/'export-one-step-declaration-expressions.lean'
assert sha(S/'one-step-expression-export-inputs.json')=='4c3443929b4850c9d1d7777cf6b3df3c6f6a8f2ad6c6b504927e8814f89554b8'
assert sha(parent)==read(S/'one-step-expression-export-inputs.json')['exporter_sha256']
m=read(S/'definition-repairs-production-inputs.json')
assert sha(S/'definition-repairs-production-verification.json')=='53b710615834dfb6522713c9c3b7489b56eeb55d8138497e1b130cb0314a86d5'
for f in m['files']:assert sha(R/f['path'])==f['sha256']
modules=sorted(f['path'][:-5].replace('/','.') for f in m['files'])
assert len(modules)==4 and not set(modules)&set(old['selected_modules'])
code=parent.read_text(encoding='utf-8');start=code.index('private def selectedModules : Array String := #[\n');end=code.index('\n]\n\nrun_cmd do',start)
code=code[:start]+'private def selectedModules : Array String := #[\n'+',\n'.join('  '+json.dumps(x) for x in modules)+code[end:]
assert code.count('.lake/chapter01-one-step-expressions.jsonl')==1
code=code.replace('.lake/chapter01-one-step-expressions.jsonl','.lake/chapter01-definition-expressions.jsonl')
p=S/'export-definition-declaration-expressions.lean';assert not p.exists();p.write_text(code,encoding='utf-8',newline='\n')
out=S/'definition-expression-export-inputs.json';assert not out.exists()
record={'schema':1,'files':m['files'],'selected_modules':modules,'exporter_path':p.relative_to(R).as_posix(),'exporter_sha256':sha(p),
 'normalization':old['normalization'],'prior_exporter_sha256':sha(parent),'prior_fingerprints_sha256':sha(oldpath),
 'input_commit':subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip(),
 'entry_point_correction':read(S/'definition-analysis-import-correction.json')}
out.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest_sha256':sha(out),'exporter_sha256':sha(p),'modules':modules}))
