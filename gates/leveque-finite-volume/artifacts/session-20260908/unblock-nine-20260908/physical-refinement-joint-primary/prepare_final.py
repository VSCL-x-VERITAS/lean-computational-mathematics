from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent;d=h.parent;p=d/'physical-admitted-high-resolution-sweep'
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
candidate=p/'native-01/Candidate.lean'
assert ref(candidate)['sha256']=='eb6aa5a41ea1abd167458966052144d6d4f5ee076d442c39f578681c9b3881bc'
assert ref(p/'receipt.json')['sha256']=='4a85f2ba726e00008c29783f55b3d87005754cf813b77f340948309d78caf153'
expected={'Admitted.lean.fragment':'03c64cec39d5524374b65ff9d5a6d01afdf360abfbb6b685763aa5a70bf384e1','SourceTarget.lean.fragment':'bd33a9b4db94efe7f5021a7e9d682528e239560298ec09413b58bd0282e0646c'}
pins=json.loads(read(h/'base-provenance.json'))['pins']+[ref(candidate),ref(p/'receipt.json')]
zero_input=d/'physical-zero-quality-draft/native-01/Candidate.lean'
assert ref(zero_input)['sha256']=='f368d77ab6d81cda6e964a8d127fb276a5ae40cb723f2957c0e5ee36917873af'
text=read(zero_input).decode();start=text.index('namespace CapacityZeroFlux')
end=text.index('end CapacityZeroFlux',start)+len('end CapacityZeroFlux')
(h/'ZeroReference.lean.fragment').write_text(text[start:end]+'\n',encoding='utf-8',newline='\n')
pins.append(ref(zero_input))
for name,sha in expected.items():
 assert ref(p/name)['sha256']==sha
 assert read(candidate).count(read(p/name))==1,name
 (h/name).write_bytes(read(p/name));pins.append(ref(p/name))
header='''import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

'''
parts=['Base.lean.fragment','Admitted.lean.fragment','SourceTarget.lean.fragment','ZeroReference.lean.fragment','ZeroQuality.lean.fragment','ConstantFlux.lean.fragment','Geometry.lean.fragment','Boundary.lean.fragment','Execution.lean.fragment','Nonconstant.lean.fragment','Family.lean.fragment','Application.lean.fragment','Checks.lean.fragment']
assembled=header+'\n'.join(read(h/name).decode() for name in parts)
assert 'import ComputationalMathematics.Source.' not in assembled
assert assembled.count('theorem leveque01_coordinateHighResolutionMethods_sourceContract')==1
(h/'Candidate.lean').write_text(assembled,encoding='utf-8',newline='\n')
(h/'copied-inputs.json').write_text(json.dumps({'pins':pins,'parts':[ref(h/name) for name in parts],'canonical_source_import_excluded':True,'proposed_source_declaration_count':1,'parent_receipt':ref(p/'receipt.json')},indent=2)+'\n',encoding='utf-8')
