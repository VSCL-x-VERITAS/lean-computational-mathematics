from pathlib import Path
from hashlib import sha256
import json
here=Path(__file__).resolve().parent
candidate=here/'Candidate.lean';fragment=here/'ComparisonWitness.lean.fragment'
for p in [candidate,fragment]:
 q=here/('native-04-'+p.name);assert not q.exists();q.write_bytes(p.read_bytes())
text=fragment.read_text(encoding='utf-8')
for idx,state in [('-1','0'),('0','1')]:
 point='0' if idx=='-1' else '1'
 number='1' if idx=='-1' else '2'
 old=f'    change ‖law.physicalFlux (old ({idx})) - law.physicalFlux (StationaryRiemannField.reference 0 1 {point} τ)‖ ≤ 0\n' if idx=='-1' else f'    change ‖law.physicalFlux (old 0) - law.physicalFlux (StationaryRiemannField.reference 0 1 {point} τ)‖ ≤ 0\n'
 old+=f'    rw [show old ({idx}) = {state} from normalized_pair.{number}, href]\n    simp' if idx=='-1' else f'    rw [show old 0 = {state} from normalized_pair.{number}, href]\n    simp'
 assert text.count(old)==1,old
 new=f'    simp [localTrace, method, RiemannInformationFluxMethod.selectedResult,\n      LeftStateInformationFlux.method, LeftStateInformationFlux.localTrace,\n      adjacentCellRiemannProblem, unitGrid, show old ({idx}) = {state} from normalized_pair.{number}, href]'
 text=text.replace(old,new)
fragment.write_text(text,encoding='utf-8',newline='\n')
candidate.write_bytes((here/'native-03-Candidate.lean').read_bytes()+b'\n'+fragment.read_bytes())
bind=lambda p:dict(path=str(p),sha256=sha256(p.read_bytes()).hexdigest())
record=dict(reason='Use explicit projection and integer/real simplification for the two concrete face traces instead of assuming those casts are definitionally equal. No statement change.',
 original_candidate=bind(here/'native-04-Candidate.lean'),original_fragment=bind(here/'native-04-ComparisonWitness.lean.fragment'),
 revised_candidate=bind(candidate),revised_fragment=bind(fragment))
(here/'repair-native-05.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(record))
