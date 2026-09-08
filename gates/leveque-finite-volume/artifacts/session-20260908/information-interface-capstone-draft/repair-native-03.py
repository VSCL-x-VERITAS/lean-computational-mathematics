from pathlib import Path
from hashlib import sha256
import json
here=Path(__file__).resolve().parent
source=here/'Candidate.lean';snapshot=here/'native-02-Candidate.lean'
assert not snapshot.exists()
before=source.read_bytes();snapshot.write_bytes(before)
text=before.decode()
old='cellVolumeAverage_const volume _ (by norm_num [Real.volume_Ioc])\n        (by norm_num [Real.volume_Ioc])'
assert text.count(old)==2
for region in ['(Set.Ioc (-1 : ℝ) 0)','(Set.Ioc (0 : ℝ) 1)']:
 new=f'cellVolumeAverage_const volume {region}\n        (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_zero_iff.mpr (by norm_num))\n        (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top)'
 text=text.replace(old,new,1)
source.write_text(text,encoding='utf-8',newline='\n')
record=dict(reason='Make the cell region explicit before elaborating its volume proofs, using exact ENNReal normalization lemmas. Statements unchanged.',
 original=dict(path=str(snapshot),sha256=sha256(before).hexdigest()),
 revised=dict(path=str(source),sha256=sha256(source.read_bytes()).hexdigest()))
(here/'repair-native-03.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(record))
