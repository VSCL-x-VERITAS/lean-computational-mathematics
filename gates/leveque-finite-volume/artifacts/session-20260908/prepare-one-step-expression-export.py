"""Export only the two additive one-step declarations using the pinned serializer."""
from pathlib import Path
import hashlib,json,subprocess
S=Path(__file__).resolve().parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_text(encoding='utf-8'))
old=read(S/'chapter01-expression-export-v2-inputs.json');src=R/old['exporter_path'];assert sha(src)==old['exporter_sha256']
for f in old['files']:assert sha(R/f['path'])==f['sha256']
m=read(S/'one-step-general-production-inputs.json');paths=[f['path'] for f in m['files']]
for f in m['files']:assert sha(R/f['path'])==f['sha256']
text=src.read_text();start=text.index('private def selectedModules : Array String := #[\n');end=text.index('\n]\n\nrun_cmd do',start)
modules=sorted(p[:-5].replace('/','.') for p in paths)
text=text[:start]+'private def selectedModules : Array String := #[\n'+',\n'.join('  '+json.dumps(x) for x in modules)+text[end:]
text=text.replace('.lake/chapter01-declaration-expressions.jsonl','.lake/chapter01-one-step-expressions.jsonl')
p=S/'export-one-step-declaration-expressions.lean';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')
record={'schema':1,'files':m['files'],'selected_modules':modules,'exporter_path':p.relative_to(R).as_posix(),'exporter_sha256':sha(p),'normalization':old['normalization'],'prior_exporter_sha256':sha(src),'prior_fingerprints_sha256':sha(S/'chapter01-declaration-expression-fingerprints-v3.json'),'input_commit':subprocess.check_output(['git','-c','core.longpaths=true','rev-parse','HEAD'],cwd=R,text=True).strip()}
out=S/'one-step-expression-export-inputs.json';assert not out.exists();out.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8');print(json.dumps({'input_manifest_sha256':sha(out),'exporter_sha256':sha(p)}))
