"""Immutable native checks for the small-bias capacity ingredients."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;D=P.parent
def raw(p):
    with open('\\\\?\\'+str(p),'rb') as f:return f.read()
def put(p,b):
    with open('\\\\?\\'+str(p),'xb') as f:f.write(b)
old=D/'capacity-net-reference-error-draft/run_native.py'
assert hashlib.sha256(raw(old)).hexdigest()=='341eb0bd783e590a872461de8ed1f25a73452b44624ed2392fcfc572bd3984c9'
names=['CapacitySmallBias.'+s for s in ['constantFlux_hyperbolic','method','lineAdvance_eq','admitted_withGhost','stable','advance_withGhost_uniform','positive_available','reference_norm_error','cartesian_scaling','boundaryCount','variation_add_le','variation_add_le_two']]
put(P/'declarations.json',(json.dumps(names,indent=2)+'\n').encode())
put(P/'Checks.lean.fragment',('\n'.join('#check '+name+'\n#print axioms '+name for name in names)+'\n').encode())
source=raw(old).decode().replace("P=D/'capacity-net-reference-error-draft'","P=D/'capacity-small-bias-witness'")
source=source.replace("bridge=D/'physical-capacity-line-bridge/PhysicalCapacityBridge.lean'", "bridge=D/'capacity-zero-flux-witness/native-01/Candidate.lean'")
source=source.replace('c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc','76a0ad0c917b836cfc4de35da405dc103a696a19354846a9f4d9d6cbd2055d74')
source=source.replace('NetError.lean.fragment','Bias.lean.fragment')
before="source= b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError\\n'+raw(bridge)+b'\\n'+raw(P/'Bias.lean.fragment')"
after="source=raw(bridge)+b'\\n'+raw(P/'Bias.lean.fragment')+b'\\n'+raw(P/'Checks.lean.fragment')"
assert source.count(before)==1
source=source.replace(before,after).replace('pins=[bridge_ref,fragment_ref,candidate_ref,',"pins=[bridge_ref,fragment_ref,candidate_ref,ref(P/'Checks.lean.fragment'),")
compile(source,'run_native.py','exec');put(P/'run_native.py',source.encode())
put(P/'runner-derivation.json',(json.dumps({'parent':str(old),'parent_sha256':hashlib.sha256(raw(old)).hexdigest(),
 'output_sha256':hashlib.sha256(source.encode()).hexdigest(),'base_sha256':'76a0ad0c917b836cfc4de35da405dc103a696a19354846a9f4d9d6cbd2055d74',
 'new_declarations':len(names),'production_compilation':False},indent=2)+'\n').encode())
