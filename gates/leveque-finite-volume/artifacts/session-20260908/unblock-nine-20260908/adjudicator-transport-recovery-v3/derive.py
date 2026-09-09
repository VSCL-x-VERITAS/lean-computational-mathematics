"""Derive additive V3; preserve the exact V2 operational functions."""
from pathlib import Path
import hashlib,json,ast
D=Path(__file__).resolve().parent
old=D.parent/'adjudicator-transport-recovery/recovery-v2.py'
raw=old.read_bytes()
assert hashlib.sha256(raw).hexdigest()=='d87472b4fb24835f349083729906a335afc8d5fde39297ebc5387ca46920bcf1'
text=raw.decode();start=text.index('def deduplicate(');end=text.index('def manifest_transition(')
replacement=(D/'transport-functions.py.inc').read_text(encoding='utf-8')
new=text[:start]+replacement+'\n'+text[end:]
new=new.replace('import argparse\n','import argparse\nimport difflib\n',1)
old_ast=ast.parse(text);new_ast=ast.parse(new)
old_functions={x.name:ast.dump(x) for x in old_ast.body if isinstance(x,ast.FunctionDef)}
new_functions={x.name:ast.dump(x) for x in new_ast.body if isinstance(x,ast.FunctionDef)}
for name,body in old_functions.items():
    if name!='deduplicate':assert new_functions[name]==body,name
dest=D/'recovery-v3.py'
with dest.open('xb') as out:out.write(new.encode())
receipt={'original':{'path':str(old),'sha256':hashlib.sha256(raw).hexdigest()},
    'new':{'path':str(dest),'sha256':hashlib.sha256(new.encode()).hexdigest()},
    'unchanged_functions':[n for n in old_functions if n!='deduplicate'],
    'only_changes':'Import difflib and replace deduplicate with exact transport helpers; all operational functions AST-identical.',
    'roles_invoked':False}
with (D/'derivation.json').open('x',encoding='utf-8') as out:json.dump(receipt,out,indent=2);out.write('\n')
print(json.dumps(receipt,indent=2))
