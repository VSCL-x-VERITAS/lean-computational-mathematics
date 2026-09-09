"""Reuse prior native runner, parser/filter verification and committed verifier."""
from pathlib import Path
import ast,hashlib,json,re
F=Path(__file__).resolve().parent;B=F.parent/'dim-high-resolution-fingerprints'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
new_input=sha(F/'inputs.json')
assert new_input=='3ece7faec1eba9fbe7cdc7446929b7149d73e7c054fd759c6e051bc104f30741'
old_input='16c62ddcc697c243fbc90dce0f12a0254529d6a977bc181bd52eee8d40e55e70'
records=[]
for name in ('run-native.py','head.py','run-freeze.py','freeze.py','check-origin-presence.py','verify-at-commit.py'):
    raw=(B/name).read_text(encoding='utf-8');text=raw
    if name in ('run-native.py','freeze.py'):
        assert old_input in text;text=text.replace(old_input,new_input)
    if name=='freeze.py':
        for a,b in [('1126','1419'),('151','167'),('150','7'),('16','4')]:text=re.sub(r'\b'+a+r'\b',b,text)
        text=text.replace('combined_owner_files=167','combined_owner_files=171')
        text=text.replace('sixteen-owner','four-owner').replace('five retained prior','six retained prior')
    if name=='check-origin-presence.py':
        text=text.replace('sixteen','four');text=re.sub(r'\b16\b','4',text)
    if name=='verify-at-commit.py':text=text.replace('source_owner_count=167','source_owner_count=171')
    ast.parse(text);compile(text,str(F/name),'exec')
    with (F/name).open('x',encoding='utf-8',newline='\n') as out:out.write(text)
    records.append({'file':name,'base_sha256':sha(B/name),'derived_sha256':sha(F/name),
                    'allowed_change':'Input pin, exact new/prior census and counting prose only.'})
with (F/'runner-derivation.json').open('x',encoding='utf-8') as out:json.dump(records,out,indent=2);out.write('\n')
print(json.dumps(records,indent=2))
