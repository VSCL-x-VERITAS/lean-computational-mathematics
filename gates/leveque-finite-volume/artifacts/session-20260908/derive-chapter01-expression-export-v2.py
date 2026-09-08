"""Retain the failed export and generate a typed, complete producer-module successor."""
from pathlib import Path
import json,hashlib
S=Path(__file__).resolve().parent
src=S/'prepare-chapter01-expression-export.py';text=src.read_text(encoding='utf-8')
old="paths=set(added)"
new="paths=set(added)\nfor item in read(S/'chapter01-current-producer-inputs.json')['files']:\n paths.add(item['path'])"
assert text.count(old)==1;text=text.replace(old,new)
text=text.replace('value.rules.map fun rule =>','value.rules.map fun (rule : RecursorRule) =>')
text=text.replace("export-chapter01-declaration-expressions.lean","export-chapter01-declaration-expressions-v2.lean")
text=text.replace("chapter01-expression-export-inputs.json","chapter01-expression-export-v2-inputs.json")
dest=S/'prepare-chapter01-expression-export-v2.py';assert not dest.exists();dest.write_text(text,encoding='utf-8')
print(json.dumps({'path':str(dest),'sha256':hashlib.sha256(dest.read_bytes()).hexdigest()}))

