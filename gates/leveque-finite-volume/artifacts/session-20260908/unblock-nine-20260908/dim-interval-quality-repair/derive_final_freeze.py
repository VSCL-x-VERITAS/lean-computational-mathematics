from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent
old=h/'freeze.py';new=h/'freeze_final.py'
s=old.read_text(encoding='utf-8')
needle="h.parent/'dim-interval-quality-repair/SCOPE-LIMIT.md'"
assert s.count(needle)==1 and not new.exists()
new.write_text(s.replace(needle,"h.parent/'dim-shared-accuracy-certificate/SCOPE-LIMIT.md'"),encoding='utf-8')
(h/'finalizer-derivation.json').write_text(json.dumps({'review_before_execution':True,
 'draft_finalizer':{'path':str(old),'sha256':hashlib.sha256(old.read_bytes()).hexdigest()},
 'executed_successor':{'path':str(new),'sha256':hashlib.sha256(new.read_bytes()).hexdigest()},
 'change':'Correct prior packet path in the scope-limit provenance reference; no native input or result changes.'},indent=2)+'\n',encoding='utf-8')
