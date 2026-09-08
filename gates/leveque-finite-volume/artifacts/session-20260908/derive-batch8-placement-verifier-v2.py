"""Preserve the first root verifier and interpret family-local receipt paths explicitly."""
from pathlib import Path
import ast,hashlib,json
S=Path(__file__).resolve().parent;old=S/'verify-batch8-foundation-placements.py'
code=old.read_text(encoding='utf-8')
replacements=[('def walk(obj):','def walk(obj,base=R):'),("p=R/obj['path'];assert sha(p)==obj['sha256'],str(p)","p=Path(obj['path']);p=p if p.is_absolute() else (R/p if (R/p).exists() else base/p)\n   assert p.resolve().is_relative_to(R.resolve()) and sha(p)==obj['sha256'],str(p)"),('for v in obj.values():walk(v)','for v in obj.values():walk(v,base)'),('for v in obj:walk(v)','for v in obj:walk(v,base)'),('walk(read(S/name))','walk(read(S/name),(S/name).parent)')]
for a,b in replacements:
 assert code.count(a)==1,a
 code=code.replace(a,b)
ast.parse(code);dest=S/'verify-batch8-foundation-placements-v2.py'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(code)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
record={'parent':{'path':old.name,'sha256':sha(old)},'derived':{'path':dest.name,'sha256':sha(dest)},'reason':'The first read-only run failed on build01-exit.json because a frozen family receipt uses directory-relative paths. The v2 reader retains exact content hashes, propagates that receipt directory and verifies confinement to the repository. It changes no evidence or Lean source.'}
with (S/'batch8-placement-verifier-v2-derivation.json').open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(record))
