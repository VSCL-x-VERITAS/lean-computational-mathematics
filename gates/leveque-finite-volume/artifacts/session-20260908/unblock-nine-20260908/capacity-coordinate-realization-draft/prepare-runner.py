"""Derive local immutable native attempt capture from the checked net-error capture."""
from pathlib import Path
import hashlib,json,os
P=Path(__file__).resolve().parent;D=P.parent
def n(p):return '\\\\?\\'+str(p)
def raw(p):
    with open(n(p),'rb') as f:return f.read()
def put(p,b):
    with open(n(p),'xb') as f:f.write(b)
old=D/'capacity-net-reference-error-draft/run_native.py'
assert hashlib.sha256(raw(old)).hexdigest()=='341eb0bd783e590a872461de8ed1f25a73452b44624ed2392fcfc572bd3984c9'
names=['CapacityCoordinate.'+s for s in ['Method','Method.rule','Method.Admitted','Method.StableAt',
 'Method.advance_eq','Method.coordinate_stability','Method.projection_cell','Method.coordinate_local',
 'step','run','run_succ','run_ordered','run_physical_error']]
names+=['CapacityPhysicalMesh.'+s for s in ['mesh','diameter_le_mesh','mesh_nonneg','mesh_le_iff',
 'mesh_attained','dist_le_mesh','mesh_pos_of_separated']]
checks='\n'.join('#check '+name+'\n#print axioms '+name for name in names)+'\n'
put(P/'Checks.lean.fragment',checks.encode())
put(P/'declarations.json',(json.dumps(names,indent=2)+'\n').encode())
source=raw(old).decode().replace("P=D/'capacity-net-reference-error-draft'","P=D/'capacity-coordinate-realization-draft'")
source=source.replace("bridge=D/'physical-capacity-line-bridge/PhysicalCapacityBridge.lean'", "bridge=D/'capacity-net-reference-error-draft/native-03/Candidate.lean'")
source=source.replace('c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc','f0991e78e85488c00d4a30a9ad4d3a8cc7f2bcc2a2f033319784b57ee5a5955b')
source=source.replace('NetError.lean.fragment','Realization.lean.fragment')
before="source= b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError\\n'+raw(bridge)+b'\\n'+raw(P/'Realization.lean.fragment')"
after="source= b'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates\\nimport Mathlib.Topology.MetricSpace.Bounded\\nimport Mathlib.Data.Finset.Lattice.Fold\\n'+raw(bridge)+b'\\n'+raw(P/'Realization.lean.fragment')+b'\\n'+raw(P/'Checks.lean.fragment')"
assert source.count(before)==1
source=source.replace(before,after)
source=source.replace('pins=[bridge_ref,fragment_ref,candidate_ref,',"pins=[bridge_ref,fragment_ref,candidate_ref,ref(P/'Checks.lean.fragment'),")
compile(source,'run_native.py','exec')
put(P/'run_native.py',source.encode())
put(P/'runner-derivation.json',(json.dumps({'parent':str(old),'parent_sha256':hashlib.sha256(raw(old)).hexdigest(),
 'output_sha256':hashlib.sha256(source.encode()).hexdigest(),'frozen_input':'f0991e78e85488c00d4a30a9ad4d3a8cc7f2bcc2a2f033319784b57ee5a5955b',
 'new_declarations':len(names),'production_compilation':False},indent=2)+'\n').encode())
