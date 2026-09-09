"""Immutable native checks for the zero physical-flux ingredients."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;D=P.parent
def raw(p):
    with open('\\\\?\\'+str(p),'rb') as f:return f.read()
def put(p,b):
    with open('\\\\?\\'+str(p),'xb') as f:f.write(b)
old=D/'capacity-net-reference-error-draft/run_native.py'
assert hashlib.sha256(raw(old)).hexdigest()=='341eb0bd783e590a872461de8ed1f25a73452b44624ed2392fcfc572bd3984c9'
names=['CapacityZeroFlux.'+s for s in ['faceFlux_zero','cellMean_eq','method','lineAdvance_eq','advance_eq',
 'advance_withGhost_eq','admitted','admitted_withGhost','stable','stable_withGhost','positive_available',
 'exact_reference','norm_error_zero','onceEdgeVariation','variation_eq']]
put(P/'declarations.json',(json.dumps(names,indent=2)+'\n').encode())
put(P/'Checks.lean.fragment',('\n'.join('#check '+name+'\n#print axioms '+name for name in names)+'\n').encode())
source=raw(old).decode().replace("P=D/'capacity-net-reference-error-draft'","P=D/'capacity-zero-flux-witness'")
source=source.replace("bridge=D/'physical-capacity-line-bridge/PhysicalCapacityBridge.lean'", "bridge=D/'capacity-ghost-boundary-draft/native-01/Candidate.lean'")
source=source.replace('c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc','f0e3bf9abd1a997f46df663b657a142749213572bbb2ecd16bb71b94e55af2c2')
source=source.replace('NetError.lean.fragment','Zero.lean.fragment')
before="source= b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError\\n'+raw(bridge)+b'\\n'+raw(P/'Zero.lean.fragment')"
after="source=raw(bridge)+b'\\n'+raw(P/'Zero.lean.fragment')+b'\\n'+raw(P/'Checks.lean.fragment')"
assert source.count(before)==1
source=source.replace(before,after).replace('pins=[bridge_ref,fragment_ref,candidate_ref,',"pins=[bridge_ref,fragment_ref,candidate_ref,ref(P/'Checks.lean.fragment'),")
compile(source,'run_native.py','exec');put(P/'run_native.py',source.encode())
put(P/'runner-derivation.json',(json.dumps({'parent':str(old),'parent_sha256':hashlib.sha256(raw(old)).hexdigest(),
 'output_sha256':hashlib.sha256(source.encode()).hexdigest(),'base_sha256':'f0e3bf9abd1a997f46df663b657a142749213572bbb2ecd16bb71b94e55af2c2',
 'new_declarations':len(names),'production_compilation':False},indent=2)+'\n').encode())
