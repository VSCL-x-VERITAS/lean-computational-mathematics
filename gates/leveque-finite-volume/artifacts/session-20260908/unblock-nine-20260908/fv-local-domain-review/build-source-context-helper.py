"""Construct an additive helper; never rewrite the pinned parent preparer."""
from pathlib import Path
import ast, hashlib
F=Path(__file__).resolve().parent
D=F.parent
parent=D/'prepare-successor-audit-with-companions.py'
raw=parent.read_bytes()
assert hashlib.sha256(raw).hexdigest()=='a262f79466f9060695cda9dee41e65546858ab847fbdd4d0fc7d9abceffa8cad'
support=(F/'source-context-support.py').read_text(encoding='utf-8')
code=raw.decode('utf-8')
def replace_once(old,new):
 global code
 assert code.count(old)==1,(old,code.count(old))
 code=code.replace(old,new)
replace_once("spec=json.loads(Path(sys.argv[1]).read_bytes())",support+"\n\nspec=json.loads(Path(sys.argv[1]).read_bytes())")
replace_once("task['target']=spec.get('target',task['target'])", "task['target']=spec.get('target',task['target'])\ncontext_data=load_source_context(R,spec['source_context_extension'],task['source'],spec['pages'],W/'workflow-v5.0.1-local/chapter01-source-review') if spec.get('source_context_extension') else None\nif context_data is not None:task['source']['locations']=context_data['locations']")
replace_once("writej(T/'user-interpretation-packet.json',interpretation)", "writej(T/'user-interpretation-packet.json',interpretation)\nif context_data is not None:writej(T/'inherited-source-interpretation-packet.json',context_data['packet'])")
replace_once("cfg['lean']['environment_files']=list(dict.fromkeys(envfiles))", "if context_data is not None:\n envfiles.extend(reference['path'] for reference in context_data['pins'])\n envfiles.append((T/'inherited-source-interpretation-packet.json').relative_to(R).as_posix())\ncfg['lean']['environment_files']=list(dict.fromkeys(envfiles))")
replace_once("'spec_sha256':sha(Path(sys.argv[1]))", "'spec_sha256':sha(Path(sys.argv[1])),'source_context_extension':spec.get('source_context_extension'),'inherited_interpretation_sha256':sha(T/'inherited-source-interpretation-packet.json') if context_data is not None else None,'preparer_sha256':sha(Path(__file__))")
replace_once("def released(label,script,args,cwd):", "def released(label,script,args,cwd):\n if context_data is not None:\n  for reference in context_data['pins']:assert sha(R/reference['path'])==reference['sha256']")
replace_once("parent_id='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'", "if context_data is not None:\n prepared_manifest=json.loads((T/'faithfulness/manifest.json').read_bytes())\n prepared_pins={item['path']:item['sha256'] for item in prepared_manifest['lean_environment']}\n for reference in context_data['pins']:\n  assert sha(R/reference['path'])==reference['sha256']\n  assert prepared_pins[reference['path']]==reference['sha256']\nparent_id='LEV-CH01-EQ-1.10-INTERPRETED-RECTANGLE-PRODUCTION-20260908'")
replace_once(" if name=='c.py':", "  if context_data is not None:code=bind_source_context_role(code,context_data)\n if name=='c.py':")
replace_once(" assert src.is_file();create(tr/src.name,src.read_bytes())", " assert src.is_file()\n if context_data is not None:assert sha(src)==context_data['image_hashes'][page]\n create(tr/src.name,src.read_bytes())")
# Native MAX_PATH failures after successful released preparation are avoided in the additive variant.
replace_once("prefix=(tr/'r.py').read_text().split", "out=Path(chr(92)*2+'?'+chr(92)+str(out.resolve()))\ntr=out/'orchestration'\nprefix=(tr/'r.py').read_text().split")
replace_once("'blind_isolation_verified':True", "'blind_isolation_verified':True,'source_context_extension':spec.get('source_context_extension')")
ast.parse(code)
target=D/'prepare-successor-audit-with-source-context.py'
if target.exists():
 assert target.read_bytes()==code.encode('utf-8') or hashlib.sha256(target.read_bytes()).hexdigest()=='76afaf14b3d9dddc60a74c7c20bcaceedcbc22977fbb86fd860794a0550e30d1'
 target.write_text(code,encoding='utf-8',newline='\n')
else:
 with target.open('x',encoding='utf-8',newline='\n') as f:f.write(code)
print(hashlib.sha256(target.read_bytes()).hexdigest())
