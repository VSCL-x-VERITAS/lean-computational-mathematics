from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent;d=h.parent;z=d/'physical-zero-refinement-witness';s=d/'physical-high-resolution-sweep-draft'
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
source=s/'native-03/Candidate.lean'
assert ref(source)['sha256']=='73daca68c54303af3d73dd4916b2792b33b44c0b258e8c136ae95cc82525304e'
oldtarget=read(s/'SourceTarget.lean.fragment').decode()
full=read(source).decode();assert full.count(oldtarget)==1
base=full.replace(oldtarget,'',1)
assert 'theorem leveque01_coordinateHighResolutionMethods_sourceContract' not in base
(h/'Base.lean.fragment').write_text(base,encoding='utf-8',newline='\n')
pins=[ref(source),ref(s/'SourceTarget.lean.fragment')]
assert ref(z/'receipt.json')['sha256']=='5511d3fed5c9f656080fea03040b0a3eb95b5a20d502c103b08d098722b7139d'
pins.append(ref(z/'receipt.json'))
for name in ['ConstantFlux.lean.fragment','Geometry.lean.fragment','Boundary.lean.fragment','Execution.lean.fragment','Nonconstant.lean.fragment','Family.lean.fragment']:
 (h/name).write_bytes(read(z/name));pins.append(ref(z/name))
q=d/'physical-zero-quality-draft/ZeroQuality.lean.fragment'
qs=read(q).decode();assert qs in read(d/'physical-zero-quality-draft/native-01/Candidate.lean').decode()
(h/'ZeroQuality.lean.fragment').write_bytes(read(q));pins.append(ref(q))
(h/'base-provenance.json').write_text(json.dumps({'pins':pins,'derivation':'Removed exact prior SourceTarget span from the frozen sweep input; generic sweep and all other definitions unchanged. A separately pinned final ValidSubsteps wrapper remains required before assembly/native use.','base_sha256':hashlib.sha256(base.encode()).hexdigest(),'old_source_wrapper_retained_in_original':True},indent=2)+'\n',encoding='utf-8')
runner=read(z/'run.py').decode().replace('Frozen generic physical quality and Cartesian family inhabitant; no source acceptance.','Joint application of explicitly pinned proposed source primary; no source acceptance.')
(h/'run.py').write_text(runner,encoding='utf-8',newline='\n')
