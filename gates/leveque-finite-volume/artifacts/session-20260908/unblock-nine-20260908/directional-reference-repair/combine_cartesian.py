from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent
names=['Finite.lean','Lift.lean','FiniteCartesian.fragment']
texts=[(P/n).read_text(encoding='utf-8') for n in names]
imports=sorted(set(l for t in texts for l in t.splitlines() if l.startswith('import ')))
body='\n'.join('\n'.join(l for l in t.splitlines() if not l.startswith('import ')) for t in texts)
(P/'FiniteCartesian.lean').write_text('\n'.join(imports)+'\n'+body+'\n',encoding='utf-8',newline='\n')
print(json.dumps({n:hashlib.sha256((P/n).read_bytes()).hexdigest() for n in names+['FiniteCartesian.lean']},indent=2))
