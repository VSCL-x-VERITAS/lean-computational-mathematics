"""Preserve the first verifier and handle Lean's explicit empty-axiom output."""
from pathlib import Path
import ast,hashlib,json
S=Path(__file__).resolve().parent;p=S/'verify-logical-line-draft.py'
source=p.read_text(encoding='utf-8')
a=" found=re.findall(re.escape(\"'\"+name+\"' depends on axioms:\")+r'\\s*\\[([^\\]]*)\\]',out);assert len(found)==1\n actual={x.strip() for x in found[0].split(',') if x.strip()}"
b=" found=re.findall(re.escape(\"'\"+name+\"' depends on axioms:\")+r'\\s*\\[([^\\]]*)\\]',out)\n empty=out.count(\"'\"+name+\"' does not depend on any axioms\")\n assert (len(found),empty) in [(1,0),(0,1)]\n actual={x.strip() for x in found[0].split(',') if x.strip()} if found else set()"
assert source.count(a)==1
new=source.replace(a,b);ast.parse(new)
dest=S/'verify-logical-line-draft-v2.py'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(new)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
record={'parent':{'path':p.name,'sha256':sha(p)},'derived':{'path':dest.name,'sha256':sha(dest)},'reason':'First root read-only verifier exited 1 because it accepted only depends-on-axioms brackets. The unchanged native output explicitly reports no axioms for orderedOperatorSweep_two and Function.update_self. The v2 verifier requires exactly one of these two exact output forms and compares the resulting set to the frozen manifest. No Lean source, frozen output, or declared axiom set is changed.'}
with (S/'logical-line-verifier-v2-derivation.json').open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
