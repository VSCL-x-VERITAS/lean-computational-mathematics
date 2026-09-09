from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent;d=h.parent;g=d/'physical-refinement-cartesian-witness'
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
pins=[]
root=d/'physical-zero-quality-draft/native-01/Candidate.lean'
assert ref(root)['sha256']=='f368d77ab6d81cda6e964a8d127fb276a5ae40cb723f2957c0e5ee36917873af'
(h/'Base.lean.fragment').write_bytes(read(root));pins.append(ref(root))
assert ref(g/'receipt.json')['sha256']=='66680c0bafc83d9f224b1446058a5779e7843d2c49f16e9e3e9b4f3600663b1d'
pins.append(ref(g/'receipt.json'))
for name in ['Geometry.lean.fragment','Boundary.lean.fragment','Execution.lean.fragment','Nonconstant.lean.fragment']:
 (h/name).write_bytes(read(g/name));pins.append(ref(g/name))
bias=d/'capacity-small-bias-witness/Bias.lean.fragment'
assert ref(bias)['sha256']=='0c9cbe57ecbe5a9c3ca9e10feaf759fc423dc4aef6757555e92ba5c1faeb0a57'
text=read(bias).decode();span=text[:text.index('def method')]+'end CapacitySmallBias\n'
(h/'ConstantFlux.lean.fragment').write_text(span,encoding='utf-8',newline='\n');pins.append(ref(bias))
(h/'copied-inputs.json').write_text(json.dumps({'pins':pins,'constant_flux_span_sha256':hashlib.sha256(span.encode()).hexdigest(),'closing_namespace_added':True},indent=2)+'\n',encoding='utf-8')
runner=read(g/'run.py').decode().replace('Native canonical geometry; no evolving generic quality imported; no source acceptance.','Frozen generic physical quality and Cartesian family inhabitant; no source acceptance.')
(h/'run.py').write_text(runner,encoding='utf-8',newline='\n')
