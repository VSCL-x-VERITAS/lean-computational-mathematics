"""Reuse the successful frozen ghost-packet verifier with exact local substitutions."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;D=P.parent
def raw(p):
    with open('\\\\?\\'+str(p),'rb') as f:return f.read()
def put(p,b):
    with open('\\\\?\\'+str(p),'xb') as f:f.write(b)
manifest=D/'capacity-ghost-boundary-draft/manifest.json'
assert hashlib.sha256(raw(manifest)).hexdigest()=='9df2f4822fb29e66b9a67f84cb2befb86d6cc5bd984309d2f7cd46c781cea138'
old=D/'capacity-ghost-boundary-draft/freeze.py'
pin=next(x for x in json.loads(raw(manifest))['files'] if x['path'].endswith('/capacity-ghost-boundary-draft/freeze.py'))
assert hashlib.sha256(raw(old)).hexdigest()==pin['sha256']
source=raw(old).decode()
source=source.replace('len(reports)==43','len(reports)==58').replace("})==43","})==58")
source=source.replace('len(names)==11','len(names)==15').replace("'new_declarations':11,'axiom_reports':43", "'new_declarations':15,'axiom_reports':58")
source=source.replace("base=D/'capacity-coordinate-realization-draft/native-02/Candidate.lean'", "base=D/'capacity-ghost-boundary-draft/native-01/Candidate.lean'")
source=source.replace('d6f0ace4271bba46cba7ee5464f5ff6d86289d1c81f4f894daca2695c69fbcc2','f0e3bf9abd1a997f46df663b657a142749213572bbb2ecd16bb71b94e55af2c2')
source=source.replace("'withGhost|ghost.*error|extract.*error_le'", "'zero.*flux|zero.*Method|cellMean.*const|ReferenceOn.*zero|zero.*ReferenceOn|windowVariation'")
compile(source,'freeze.py','exec');put(P/'freeze.py',source.encode())
put(P/'freeze-derivation.json',(json.dumps({'parent':pin,'output_sha256':hashlib.sha256(source.encode()).hexdigest(),
 'changes':'58 total reports / 15 new names; exact ghost base; scoped zero-producer search. All guards retained.'},indent=2)+'\n').encode())
