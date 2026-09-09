from pathlib import Path
import hashlib,json,ast
F=Path(__file__).resolve().parent;O=F.parent/'riemann-routine-fingerprints';items=[]
for old,new in [('check-origin-presence-v2.py','check-origin-presence.py'),('verify-at-commit.py','verify-at-commit.py')]:
    text=(O/old).read_text();reps=[('four new source owners','sixteen new source owners'),("'owner_count':4","'owner_count':16"),('all_four_owners_absent_from_head_and_anchor','all_sixteen_owners_absent_from_head_and_anchor'),('source_owner_count=151','source_owner_count=167')]
    applied=[]
    for a,b in reps:
        if a in text:text=text.replace(a,b);applied.append((a,b))
    ast.parse(text);compile(text,str(F/new),'exec');(F/new).write_text(text,encoding='utf-8',newline='\n')
    items.append({'source':str(O/old),'source_sha256':hashlib.sha256((O/old).read_bytes()).hexdigest(),'derived':str(F/new),'derived_sha256':hashlib.sha256((F/new).read_bytes()).hexdigest(),'replacements':applied})
(F/'origin-helper-derivation.json').write_text(json.dumps(items,indent=2)+'\n',encoding='utf-8',newline='\n')
