from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent;d=h.parent
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
records=[]
p=d/'physical-capacity-line-bridge/PhysicalCapacityBridge.lean'
b=read(p);assert hashlib.sha256(b).hexdigest()=='c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc'
s=b.decode();s=s[s.index('namespace PhysicalCapacityBridge'):]
(h/'Capacity.lean.fragment').write_text(s,encoding='utf-8',newline='\n')
records.append({'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'span_sha256':hashlib.sha256(s.encode()).hexdigest()})
p=d/'capacity-coordinate-realization-draft/Realization.lean.fragment'
b=read(p);s=b.decode();s=s[:s.index('noncomputable def step')]+'end CapacityCoordinate\n'
(h/'Method.lean.fragment').write_text(s,encoding='utf-8',newline='\n')
records.append({'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'span_sha256':hashlib.sha256(s.encode()).hexdigest(),'syntactic_closing_namespace_added':True})
(h/'copied-capacity-inputs.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8')
