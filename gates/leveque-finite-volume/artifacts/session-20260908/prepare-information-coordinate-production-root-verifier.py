"""Derive an independent root replay without changing the frozen placement packet."""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parent
src=S/'information-coordinate-production/verify-final.py'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=src.read_text(encoding='utf-8')
new=old.replace("P=Path(__file__).resolve().parent;R=P.parents[4]","P=Path(__file__).resolve().parent/'information-coordinate-production';R=P.parents[4]")
assert new!=old
new=new.replace("assert native['exit_code']==0 and native['inputs_unchanged']","assert type(native['exit_code']) is int and native['exit_code']==0 and native['inputs_unchanged'] is True")
new=new.replace("out=P/'verification.json'","out=P.parent/'root-information-coordinate-production-verification.json'")
new=new.replace("sha(P/'verify-final.py')","sha(Path(__file__).resolve())")
p=S/'verify-information-coordinate-production-root.py'
with p.open('x',encoding='utf-8',newline='\n') as f:f.write(new)
d=dict(schema=1,source=dict(path=str(src),sha256=sha(src)),derived=dict(path=str(p),sha256=sha(p)),changes=['Fixed frozen packet path from root helper location','Fresh root output; no packet mutation','Strict integer native exit and boolean input stability','Bind actual root verifier bytes'],source_acceptance=False)
with (S/'information-coordinate-production-root-verifier-derivation.json').open('x',encoding='utf-8') as f:json.dump(d,f,indent=2);f.write('\n')
print(json.dumps(d))

