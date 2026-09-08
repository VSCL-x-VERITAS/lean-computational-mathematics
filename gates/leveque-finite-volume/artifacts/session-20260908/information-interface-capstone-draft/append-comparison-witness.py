from pathlib import Path
from hashlib import sha256
import json
here=Path(__file__).resolve().parent
source=here/'Candidate.lean';snapshot=here/'native-03-Candidate.lean'
assert not snapshot.exists()
receipt=json.loads((here/'native-03.receipt.json').read_bytes())
assert receipt['exit_code']==0 and receipt['inputs_unchanged']
before=source.read_bytes();snapshot.write_bytes(before)
fragment=here/'ComparisonWitness.lean.fragment'
source.write_bytes(before+b'\n'+fragment.read_bytes())
bind=lambda p:dict(path=str(p),sha256=sha256(p.read_bytes()).hexdigest())
record=dict(successful_base=bind(snapshot),fragment=bind(fragment),extended=bind(source),
 reason='Add one literal two-face conditional-capstone application; all 13 successful base declarations remain byte-exact.')
(here/'comparison-witness-extension.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(record))
