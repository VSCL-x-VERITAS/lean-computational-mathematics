"""Generate additive comparison sources; never invokes Lean or changes production."""
from pathlib import Path
import hashlib, json, re, sys
from datetime import datetime, timezone

HERE = Path(__file__).resolve().parent
D = HERE.parent
R = D.parents[4]
TAG = sys.argv[1]
assert re.fullmatch(r'generated-[0-9]+', TAG), TAG
OUT = HERE / TAG

def lp(p): return Path('\\\\?\\' + str(p.resolve()))
def rb(p): return lp(p).read_bytes()
def sha(b): return hashlib.sha256(b).hexdigest()
def pin(p, expected=None):
    b = rb(p)
    h = sha(b)
    if expected is not None: assert h == expected, (str(p),h,expected)
    return {'path':str(p.relative_to(R)).replace('\\','/'), 'sha256':h,'bytes':len(b)}
def write(name, data):
    p = OUT / name
    assert not lp(p).exists(), str(p)
    if isinstance(data, str): data=data.encode()
    lp(p).write_bytes(data)
    return pin(p)
def js(name,obj): return write(name,json.dumps(obj,ensure_ascii=False,indent=2)+'\n')

assert not lp(OUT).exists(), str(OUT)
lp(OUT).mkdir(parents=True)
original = D/'physical-admitted-high-resolution-sweep/native-01/Candidate.lean'
parent_pin = pin(original,'eb6aa5a41ea1abd167458966052144d6d4f5ee076d442c39f578681c9b3881bc')
proposal_pin = pin(D/'physical-dim-owner-proposals/receipt.json','ee1f8facbc4bf0358a148b407871729261e7e6b46059d2ceea0bd85b98e81592')
mapping_pin = pin(D/'physical-dim-owner-proposals/attempt-06/mapping.json','6b8d51bf7ab2bf4fd585a92ff76c3845488f3119c87fbc8df820a6db978cf498')
files_pin = pin(D/'physical-dim-owner-proposals/proposed-files.json','b626ffffdc17c9e097999482d850475f7b6a5c4ee9e91c376b8d85b14ee7043c')
b = rb(original)
excluded = []
start_marker=b'namespace NumStability.FiniteCoordinate.LineCoordinates'
end_marker=b'end NumStability.FiniteCoordinate.LineCoordinates'
assert b.count(start_marker)==b.count(end_marker)==1
start=b.index(start_marker); end=b.index(end_marker,start)+len(end_marker)
excluded.append({'reason':'shared canonical LineCoordinates ghost namespace; imported once',
 'start_byte_zero_based':start,'end_byte_exclusive':end,'sha256':sha(b[start:end])})
text=(b[:start]+b'\n/- Exact shared ghost namespace excluded; use canonical FiniteLineCoordinates. -/\n'+b[end:]).decode()
imports=[]; checks=[]; kept=[]
for line in text.splitlines(keepends=True):
    if line.startswith('import '): imports.append(line.rstrip())
    elif line.startswith('#check ') or line.startswith('#print axioms '): checks.append(line.rstrip())
    else: kept.append(line)
text=''.join(kept)
source_name='leveque01_coordinateHighResolutionMethods_sourceContract'
assert len(re.findall(r'\btheorem '+source_name+r'\b',text))==1
text=text.replace('theorem '+source_name+'\n', 'theorem comparison_draft_'+source_name+'\n')
roots=['PhysicalCapacityBridge','CapacityNetReferenceError','CapacityCoordinate',
       'CapacityPhysicalMesh','CapacityGhost','PhysicalRefinementQuality',
       'CapacityBoundarySweep','PhysicalHighResolutionSweep']
qualifications=[]; final_lines=[]
for line in text.splitlines(keepends=True):
    if re.match(r'^\s*(namespace|end)\s',line):
        final_lines.append(line); continue
    original_line=line
    for root in roots:
        line=re.sub(r'(?<![\w.])'+root+r'(?=\b)', '_root_.'+root, line)
    if line!=original_line:
        qualifications.append({'before':original_line.rstrip('\r\n'),'after':line.rstrip('\r\n')})
    final_lines.append(line)
historical=''.join(final_lines)
header='\n'.join([
 'import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods',
 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates',
 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates',
 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep',
 'import Mathlib.Topology.MetricSpace.Bounded',
 'import Mathlib.Data.Finset.Lattice.Fold',
 'set_option maxRecDepth 4096',
 'set_option maxHeartbeats 1600000',
 '',
 '/- Artifact-only comparison. Historical nominal structures and proof producers are',
 'retained under root-qualified scratch namespaces; shared canonical names are imported.',
 'The locally renamed scratch source theorem is the latest admitted proposal, not',
 'the old rejected production target. No source acceptance is inferred. -/',
 '',
])
fragment=rb(HERE/'Comparisons.lean.fragment').decode()
decls=re.findall(r'^(?:noncomputable )?(?:def|theorem)\s+([A-Za-z0-9_]+)',fragment,re.M)
assert len(decls)==len(set(decls))
comparison_checks='\n'.join('#check PhysicalDIMTransport.'+n+'\n#print axioms PhysicalDIMTransport.'+n for n in decls)+'\n'
hist_ref=write('Historical.lean.fragment',historical)
cmp_ref=write('Comparisons.lean.fragment',fragment)
candidate=write('Candidate.lean',header+'\n'+historical+'\n'+fragment+'\n'+comparison_checks)

joint_path=D/'physical-refinement-joint-primary/Application.lean.fragment'
joint_pin=pin(joint_path)
joint=rb(joint_path).decode()
joint_map={
 'PhysicalRefinementJointPrimary':'PhysicalDIMCanonicalJoint',
 'ZeroPhysicalRefinementWitness':'NumStability.ZeroFluxCartesianRefinement',
 'RefiningCartesianWitness':'NumStability.RefiningCartesianGrid',
 'PhysicalHighResolutionSweep':'NumStability.PhysicalHighResolutionSweep',
 'CapacityCoordinate':'NumStability.CapacityCoordinate',
 'PhysicalCapacityBridge':'NumStability.FiniteCoordinate.PhysicalLine',
}
counts={}
for old,new in joint_map.items():
    pattern=r'(?<![\w.])'+old+r'\b'
    joint,count=re.subn(pattern,new,joint)
    assert count>0,(old,count)
    counts[old]={'replacement':new,'count':count}
jdecls=re.findall(r'^(?:noncomputable )?(?:def|theorem)\s+([A-Za-z0-9_]+)',joint,re.M)
assert len(jdecls)==14 and len(set(jdecls))==14
jheader='\n'.join([
 'import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods',
 'import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.ZeroFluxCartesianRefinement',
 'set_option maxRecDepth 4096', 'set_option maxHeartbeats 1600000', '',
 '/- Canonical-import-only adaptation of the exact frozen 14-declaration joint application. -/', '',
])
jchecks='\n'.join('#check PhysicalDIMCanonicalJoint.'+n+'\n#print axioms PhysicalDIMCanonicalJoint.'+n for n in jdecls)+'\n'
joint_ref=write('Joint.lean',jheader+joint+'\n'+jchecks)
provenance=js('source-provenance.json',{
 'schema':1,'parent':parent_pin,'proposal_receipt':proposal_pin,'proposal_mapping':mapping_pin,
 'proposal_files':files_pin,'excluded_original_byte_spans':excluded,
 'removed_import_lines':imports,'removed_historical_check_lines':checks,
 'scratch_source_binder_rename':{'old':source_name,'new':'comparison_draft_'+source_name,'count':1},
 'qualification_lines':qualifications,
 'joint_original':joint_pin,'joint_namespace_substitutions':counts,
 'current_canonical_pins':None,
 'historical_metadata_policy':'Pinned as historical evidence; never recursively revalidated against newly changed canonical paths.',
})
inventory=js('declarations.json',{
 'comparison':[{'name':'PhysicalDIMTransport.'+n} for n in decls],
 'canonical_joint':[{'name':'PhysicalDIMCanonicalJoint.'+n} for n in jdecls],
 'method':'Exact authored names parsed from single explicit comparison namespace; no generated/private names inferred.'
})
receipt=js('preparation-receipt.json',{
 'schema':1,'status':'source generated; native verification NOT run',
 'utc':datetime.now(timezone.utc).isoformat(),
 'generator':pin(HERE/'assemble.py'),'comparison_fragment':pin(HERE/'Comparisons.lean.fragment'),
 'historical_fragment':hist_ref,'generated_comparison_fragment':cmp_ref,
 'candidate':candidate,'joint':joint_ref,'provenance':provenance,'inventory':inventory,
 'comparison_authored_count':len(decls),'joint_authored_count':len(jdecls),
 'canonical_build_receipt':None,'native_executed':False,'source_acceptance':False,
 'production_written':False,
})
print(json.dumps(receipt,indent=2))
