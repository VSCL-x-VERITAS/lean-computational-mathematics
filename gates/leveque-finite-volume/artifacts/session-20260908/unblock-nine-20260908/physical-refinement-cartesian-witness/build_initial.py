from pathlib import Path
import hashlib,json
h=Path(__file__).resolve().parent
d=h.parent
def read(p):return Path('\\\\?\\'+str(p.resolve())).read_bytes()
old=d/'dim-two-direction-joint-witness/Candidate.lean'
assert hashlib.sha256(read(old)).hexdigest()=='48d57797ff3c2074dabb6f72417f4eba54c8131b588dc59cf47d67d9ecc1a6fe'
mesh=d/'capacity-coordinate-realization-draft/Realization.lean.fragment'
text=read(mesh).decode()
meshbody=text[text.index('namespace CapacityPhysicalMesh'):]
(h/'Mesh.lean.fragment').write_text(meshbody,encoding='utf-8',newline='\n')
(h/'copied-inputs.json').write_text(json.dumps({'exact_mesh_span':{'path':str(mesh),'sha256':hashlib.sha256(read(mesh)).hexdigest(),'copied_span_sha256':hashlib.sha256(meshbody.encode()).hexdigest()},'adapted_geometry_pattern':{'path':str(old),'sha256':hashlib.sha256(read(old)).hexdigest()}},indent=2)+'\n',encoding='utf-8')
