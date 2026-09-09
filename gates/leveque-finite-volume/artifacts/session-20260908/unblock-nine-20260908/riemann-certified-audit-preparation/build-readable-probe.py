"""Preserve the fully explicit success; retain complete types with readable instances."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
old=P/'CompleteTypesFull.lean'
assert sha(old)=='44c44e2cc8c9a42a33c42cc7bb91ff1cf7752774d0fe9a0487d840cdec55acd6'
native=json.loads((P/'full-01/receipt.json').read_bytes())
assert native['exit_code']==0 and native['inputs_unchanged']
text=old.read_text(encoding='utf-8');where=text.index('#check @')
new=text[:where]+'set_option pp.explicit false\nset_option pp.maxSteps 10000000\n'+text[where:]
out=P/'CompleteTypesReadable.lean'
with out.open('x',encoding='utf-8',newline='\n') as f:f.write(new)
config=json.loads((P/'full-probe-inputs.json').read_bytes())
config['input']=ref(out)
config['readable_derivation']={'source':ref(old),'predecessor_config':ref(P/'full-probe-inputs.json'),
 'predecessor_native':ref(P/'full-01/receipt.json'),
 'change':'Before all #check/#print commands, override inherited pp.explicit=true with false and restore pp.maxSteps=10000000. Keep #check @, pp.deepTerms, full names, all definitions and all axiom commands.'}
with (P/'full-probe-readable-inputs.json').open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(config,indent=2)+'\n')
print(json.dumps(ref(out),indent=2))
