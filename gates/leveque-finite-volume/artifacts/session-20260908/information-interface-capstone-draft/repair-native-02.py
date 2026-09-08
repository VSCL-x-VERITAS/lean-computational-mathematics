from pathlib import Path
from hashlib import sha256
import json
here=Path(__file__).resolve().parent
source=here/'Candidate.lean';snapshot=here/'native-01-Candidate.lean'
assert not snapshot.exists()
before=source.read_bytes();snapshot.write_bytes(before)
text=before.decode()
needle='(numericalFlux (i + 1) - numericalFlux i) := by\n  intro i'
assert text.count(needle)==1
text=text.replace(needle,'(numericalFlux (i + 1) - numericalFlux i) := by\n  dsimp only\n  intro i')
needle='(by simp [Real.volume_Ioc])'
assert text.count(needle)==2
text=text.replace(needle,'(by norm_num [Real.volume_Ioc])')
source.write_text(text,encoding='utf-8',newline='\n')
record=dict(reason='Reduce two let bindings before introducing the index; discharge the remaining explicit positive unit-length goals with norm_num. Statements unchanged.',
 original=dict(path=str(snapshot),sha256=sha256(before).hexdigest()),
 revised=dict(path=str(source),sha256=sha256(source.read_bytes()).hexdigest()))
(here/'repair-native-02.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(record))
