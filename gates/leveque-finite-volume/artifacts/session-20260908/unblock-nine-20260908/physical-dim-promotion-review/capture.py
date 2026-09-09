"""Read-only source capture for a proposal-only physical DIM owner map."""
from pathlib import Path
import hashlib,json,os,re,subprocess,datetime
R=Path(r'C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
W=R.parent;D=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908'
P=D/'physical-dim-promotion-review'
P.mkdir(exist_ok=False)
def raw(p):
 with open('\\\\?\\'+str(p),'rb') as f:return f.read()
def ref(p):
 b=raw(p)
 return {'path':p.relative_to(R).as_posix() if p.is_relative_to(R) else str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def put(name,obj):
 b=obj if isinstance(obj,bytes) else (json.dumps(obj,indent=2)+'\n').encode()
 with open('\\\\?\\'+str(P/name),'xb') as f:f.write(b)
fv=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
relative=[
 'physical-capacity-line-bridge/PhysicalCapacityBridge.lean','physical-capacity-line-bridge/manifest.json',
 'capacity-net-reference-error-draft/NetError.lean.fragment','capacity-net-reference-error-draft/receipt.json',
 'capacity-coordinate-realization-draft/Realization.lean.fragment','capacity-coordinate-realization-draft/receipt.json',
 'capacity-ghost-boundary-draft/Ghost.lean.fragment','capacity-ghost-boundary-draft/receipt.json',
 'capacity-boundary-sweep-draft/Sweep.lean.fragment','capacity-boundary-sweep-draft/StageLaws.lean.fragment','capacity-boundary-sweep-draft/receipt.json',
 'physical-refinement-quality-draft/PhysicalRefinement.lean.fragment','physical-refinement-quality-draft/native-02/receipt.json',
 'physical-high-resolution-sweep-draft/Sweep.lean.fragment','physical-high-resolution-sweep-draft/SourceTarget.lean.fragment',
 'physical-zero-quality-draft/ZeroQuality.lean.fragment',
 'capacity-zero-flux-witness/Zero.lean.fragment','capacity-zero-flux-witness/receipt.json',
 'capacity-small-bias-witness/Bias.lean.fragment','capacity-small-bias-witness/receipt.json',
 'physical-refinement-cartesian-witness/Geometry.lean.fragment','physical-refinement-cartesian-witness/Boundary.lean.fragment',
 'physical-refinement-cartesian-witness/Execution.lean.fragment','physical-refinement-cartesian-witness/Nonconstant.lean.fragment',
 'physical-refinement-cartesian-witness/ReferenceConnection.lean.fragment','physical-refinement-cartesian-witness/receipt.json',
 'physical-zero-refinement-witness/Family.lean.fragment','physical-zero-refinement-witness/receipt.json',
 'dim-blind-evidence-repair/five-owner-proposal.json','dim-five-owner-overlay/receipt.json',
 'dim-inherited-hyperbolicity-context/source-context-v3.json',
 'final-organization-manual-review/ROOT-ADOPTION.md','final-organization-manual-review/REVIEW.md',
 'final-organization-current-input-preparation/scope-and-ratchet-blueprint.json']
owners=['CoordinateLineMethod','CoordinateLineMethodEstimates','FinitePhysicalGeometry','FinitePhysicalUpdate',
 'FinitePhysicalReferenceError','CellVolumeAverage','PhysicalCoordinateGeometry','CoordinateLineBalance',
 'CoordinateLineSweep','RefiningLineMethod','HighResolutionCoordinateSweep','FiniteCartesianGeometry',
 'FiniteCartesianReference','Examples/HighResolutionAdvectionLine','Examples/CFLUnitShift']
paths=[D/x for x in relative]+[fv/(x+'.lean') for x in owners]+[
 R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/Hyperbolicity.lean',
 R/'ComputationalMathematics/Source/LeVeque/Chapter01/CoordinateHighResolutionMethods.lean',
 R/'AGENTS.md',R/'docs/architecture/NAMING.md',R/'docs/architecture/TIERS.md',
 R/'docs/architecture/layout-exceptions.json']
module=W/'formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module'
paths += [module/'instructions.md',module/'references/source-faithfulness.md',module/'unit-index.json',
 module/'book-profile.json']
records=[]
declpat=re.compile(r'(?m)^(?:(?:noncomputable|private|protected)\s+)*(def|abbrev|structure|theorem|lemma|instance)\s+([^\s(:{]+)')
for i,p in enumerate(paths):
 b=raw(p);item=ref(p);text=b.decode('utf-8')
 item['lines']=len(text.splitlines())
 item['imports']=re.findall(r'(?m)^(?:public\s+)?import\s+(\S+)',text)
 item['declarations']=[{'kind':m[1],'local_name':m[2],'line':text[:m.start()].count('\n')+1} for m in declpat.finditer(text)]
 if p.name.endswith('.fragment'):
  name=f'view-{i:02}-{p.name}.snapshot';put(name,b);item['view_snapshot']=ref(P/name)
 records.append(item)
proposed=['FiniteLineCoordinates','PhysicalLineCapacity','FinitePhysicalFluxError','PhysicalCellMesh',
 'CapacityCoordinateMethod','CapacityCoordinateSweep','CoordinateLineVariation','PhysicalRefinementQuality',
 'PhysicalHighResolutionSweep','Examples/RefiningCartesianGeometry','Examples/RefiningCartesianBoundary',
 'Examples/ZeroFluxCartesianRefinement']
collision=[]
for x in proposed:
 p=fv/(x+'.lean')
 collision.append({'proposed_path':p.relative_to(R).as_posix(),'file_exists':p.exists(),
   'same_named_directory_exists':p.with_suffix('').is_dir(),
   'declaration_parent_collision':False})
 assert not p.exists() and not p.with_suffix('').exists(),str(p)
cmd=['rg','-n','CapacityCoordinate|CapacityPhysicalMesh|PhysicalRefinementQuality|PhysicalCapacityBridge|netFluxDefect|onceEdgeVariation|constantFlux_isHyperbolicOn',
 'ComputationalMathematics','-g','*.lean']
proc=subprocess.run(cmd,cwd=R,capture_output=True);assert proc.returncode in (0,1)
put('reuse-search-stdout.txt',proc.stdout);put('reuse-search-stderr.txt',proc.stderr)
put('reuse-search.json',{'command':cmd,'cwd':str(R),'actual_exit':proc.returncode,
 'stdout':ref(P/'reuse-search-stdout.txt'),'stderr':ref(P/'reuse-search-stderr.txt'),
 'scope':'Current canonical project text only; no mathematical global absence claim.'})
for item,p in zip(records,paths):assert ref(p)['sha256']==item['sha256'],str(p)
put('inputs.json',{'schema':1,'status':'read-only proposal snapshot','observed_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'inputs':records,'proposed_names':collision,'source_acceptance':False,'native_rebuild_run':False,
 'notes':['Mutable final-sweep fragments are copied as views; future production must bind its final native-success snapshot.',
 'This is a bounded organization review under parent-authorized session output scope, not a sealed code-review workflow or final layout measurement.']})
print(json.dumps({'inputs':ref(P/'inputs.json'),'proposed_new_paths':len(proposed),'observed_inputs':len(records)},indent=2))
