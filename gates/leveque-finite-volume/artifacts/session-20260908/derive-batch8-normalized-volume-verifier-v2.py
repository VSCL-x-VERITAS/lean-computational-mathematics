"""Preserve the first verifier and compare axiom sets independently of display order."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent;p=S/'verify-batch8-normalized-volume-draft.py'
old=p.read_text(encoding='utf-8')
a="actual[name]==f['axioms'][name]"
assert old.count(a)==1
new=old.replace(a,"set(actual[name])==set(f['axioms'][name]) and len(actual[name])==len(f['axioms'][name])")
q=S/'verify-batch8-normalized-volume-draft-v2.py'
with q.open('x',encoding='utf-8',newline='') as f:f.write(new)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
d=S/'batch8-normalized-volume-verifier-derivation.json'
with d.open('x',encoding='utf-8',newline='') as f:
 json.dump({'parent':p.name,'parent_sha256':sha(p),'child':q.name,'child_sha256':sha(q),
 'reason':'The native axiom list and metadata list have different order. Axioms are a set; equality is now set equality plus equal cardinality. Exact allowed-set, declaration, input, command, output and native-exit checks are unchanged. No source or frozen receipt changed.'},f,indent=2);f.write('\n')
print(json.dumps({'child_sha256':sha(q),'derivation_sha256':sha(d)}))

