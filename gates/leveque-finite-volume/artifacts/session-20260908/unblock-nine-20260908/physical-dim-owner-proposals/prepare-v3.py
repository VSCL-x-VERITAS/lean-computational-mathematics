"""Create proposal-only canonical owner snapshots from exact reviewed source spans."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,difflib
R=Path(r'C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
D=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908'
P=D/'physical-dim-owner-proposals'/'attempt-03'
P.mkdir(exist_ok=False)
FV='ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/'
CV='ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/'
SRC='ComputationalMathematics/Source/LeVeque/Chapter01/'
def native(p):return '\\\\?\\'+str(p)
def raw(p):
 with open(native(p),'rb') as f:return f.read()
def file_ref(p):
 b=raw(p);return {'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def put(p,b):
 os.makedirs(native(p.parent),exist_ok=True)
 if not isinstance(b,bytes):b=(json.dumps(b,indent=2,ensure_ascii=False)+'\n').encode()
 with open(native(p),'xb') as f:f.write(b)
 return file_ref(p)
inputs={};spans=[];outputs=[];token_events=[];rewrites=[]
def source(path):
 p=R/path if path.startswith('ComputationalMathematics/') else D/path
 inputs[str(p)]=file_ref(p)
 return raw(p).decode('utf-8').replace('\r\n','\n')
def span(path,start=None,end=None):
 text=source(path)
 a=text.index(start) if start else 0
 assert not start or text.count(start)==1,(path,start)
 b=text.index(end,a) if end else len(text)
 assert b>a,(path,start,end)
 seg=text[a:b]
 record={'source':inputs[str(R/path if path.startswith('ComputationalMathematics/') else D/path)],
  'start_anchor':start,'end_anchor_exclusive':end,'start_line':text[:a].count('\n')+1,
  'end_line':text[:b].count('\n')+1,'normalized_span_sha256':hashlib.sha256(seg.encode()).hexdigest(),
  'normalization':'CRLF to LF only before line/span selection'}
 spans.append(record)
 return seg
def strip_checks(s):return re.sub(r'(?m)^#(?:check|print axioms).*\n?','',s).strip()+'\n'
token_map=[
 ('CapacitySmallBias.constantFlux_hyperbolic','NumStability.constantFlux_isHyperbolicOn'),
 ('CapacityZeroFlux.faceFlux_zero','NumStability.FiniteCoordinate.faceFlux_eq_zero'),
 ('CapacityZeroFlux.cellMean_eq','NumStability.FiniteCoordinate.cellMean_eq_of_faceFlux_zero'),
 ('CapacityZeroFlux.onceEdgeVariation','NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation'),
 ('PhysicalCapacityBridge','NumStability.FiniteCoordinate.PhysicalLine'),
 ('CapacityNetReferenceError','NumStability.FiniteCoordinate'),
 ('CapacityPhysicalMesh','NumStability.FiniteVolumeCellPartition'),
 ('CapacityBoundarySweep','NumStability.CapacityCoordinate.Sweep'),
 ('CapacityCoordinate','NumStability.CapacityCoordinate'),
 ('PhysicalRefinementQuality','NumStability.PhysicalRefinementQuality'),
 ('PhysicalHighResolutionSweep','NumStability.PhysicalHighResolutionSweep'),
 ('RefiningCartesianWitness','NumStability.RefiningCartesianGrid'),
 ('ZeroPhysicalRefinementWitness','NumStability.ZeroFluxCartesianRefinement')]
def transform(s):
 # One simultaneous pass; replacement text is never processed a second time.
 pattern=re.compile(r'(?<![\w.])(?:'+ '|'.join(re.escape(a) for a,b in token_map)+r')(?![\w])')
 repl=dict(token_map)
 counts={}
 def sub(m):
  counts[m[0]]=counts.get(m[0],0)+1
  return repl[m[0]]
 s=pattern.sub(sub,s)
 token_events.append(counts)
 return strip_checks(s)
def header(imports,doc):
 ordered=sorted(set(imports),key=str.casefold)
 return '/-\nSPDX-License-Identifier: MIT\n-/\n\n'+'\n'.join('import '+i for i in ordered)+'\n\n/-!\n'+doc+'\n-/\n\n'
def fvim(name):return (FV+name).replace('/','.')
def cvim(name):return (CV+name).replace('/','.')
def write_owner(path,body,imports,doc,role='reusable',changed=False):
 p=R/path
 if not changed:assert not os.path.exists(native(p)) and not os.path.exists(native(p.with_suffix(''))),path
 content=header(imports,doc)+transform(body)
 out=P/'proposed'/path
 put(out,content.encode())
 record={'target_path':path,'module':path[:-5].replace('/','.'),
  'role':role,'change':'changed' if changed else 'new','proposed':file_ref(out),
  'imports':re.findall(r'(?m)^import\s+(\S+)',content),'lines':len(content.splitlines())}
 if changed:
  record['current']=file_ref(p)
  diff=''.join(difflib.unified_diff(source(path).splitlines(True),content.splitlines(True),fromfile=path,tofile='proposal/'+path))
  record['diff']=put(P/'diffs'/(Path(path).stem+'.diff'),diff.encode())
 outputs.append(record)
 return content

coord_path=FV+'CoordinateLineMethod.lean'
estimate_path=FV+'CoordinateLineMethodEstimates.lean'
oldcoords=span(coord_path,'/-- Actual line coordinates','/-- The same physical law')
olderror=span(estimate_path,'theorem LineCoordinates.extract_error_le','theorem LineRealization.coordinate_stability')
ghost_path='capacity-ghost-boundary-draft/Ghost.lean.fragment'
ghostcoords=span(ghost_path,'namespace NumStability.FiniteCoordinate.LineCoordinates','end NumStability.FiniteCoordinate.LineCoordinates')
coordbase='namespace NumStability.FiniteCoordinate\nvariable {D Cell Face Line : Type*} {m : ℕ}\nlocal notation "State" => Fin m → ℝ\n\n'
write_owner(FV+'FiniteLineCoordinates.lean',coordbase+oldcoords+olderror+'end NumStability.FiniteCoordinate\n\n'+ghostcoords+'end NumStability.FiniteCoordinate.LineCoordinates\n',
 ['Mathlib.Analysis.Normed.Group.Constructions'],
 '# Finite coordinate lookup and supplied boundary data\n\nCanonical finite-cell and face indices, sound lookup, line extraction and its norm bounds.\nGhost replacement changes supplied values only. It introduces no physical cell, mesh,\nmeasure, numerical method, or high-resolution premise.')

bridge='physical-capacity-line-bridge/PhysicalCapacityBridge.lean'
cap=span(bridge,'namespace PhysicalCapacityBridge','theorem weighted_mass_balance')
capghost=span(ghost_path,'theorem capacity_withGhost','end CapacityGhost')
write_owner(FV+'PhysicalLineCapacity.lean',cap+capghost+'end PhysicalCapacityBridge\n',
 [fvim('FiniteLineCoordinates'),fvim('FinitePhysicalUpdate'),'Mathlib.Tactic.NormNum'],
 '# Conservative line updates with measured physical capacities\n\nActual cells use their supplied positive physical volume. Shared-face numerical outputs\nare already integrated fluxes. Incidence proves equality with the same physical update.\nThe missing-lookup capacity is a positive totalization value only, never a physical\ncell size or mesh diameter. No common face area or integrated hyperbolicity is assumed.')

net='capacity-net-reference-error-draft/NetError.lean.fragment'
netbody=span(net,'namespace CapacityNetReferenceError','theorem capacity_line_error_balance')
# The comment immediately before the omitted theorem belongs to that theorem.
cut=netbody.rfind('/--')
if cut>netbody.rfind('theorem advance_error_le_net'):netbody=netbody[:cut]
zerobody=span('capacity-zero-flux-witness/Zero.lean.fragment','namespace CapacityZeroFlux\nopen MeasureTheory','def method')
zerobody=zerobody.replace('namespace CapacityZeroFlux','namespace NumStability.FiniteCoordinate',1)
zerobody=zerobody.replace('theorem faceFlux_zero','theorem faceFlux_eq_zero',1).replace('theorem cellMean_eq','theorem cellMean_eq_of_faceFlux_zero',1)
write_owner(FV+'FinitePhysicalFluxError.lean',netbody+'end CapacityNetReferenceError\n\n'+zerobody+'end NumStability.FiniteCoordinate\n',
 [fvim('FinitePhysicalReferenceError')],
 '# Physical reference flux defects and zero-flux invariance\n\nThe signed net face-flux defect retains cancellation before a norm estimate.\nAll original measured-reference integrability, state and subinterval hypotheses remain.\nThe zero-flux consequences concern actual physical flux histories and measured cell\nmeans; they do not infer pointwise stationarity or continuum PDE equivalence.')

real='capacity-coordinate-realization-draft/Realization.lean.fragment'
mesh=span(real,'namespace CapacityPhysicalMesh')
write_owner(FV+'PhysicalCellMesh.lean',mesh,
 [fvim('CellVolumeAverage'),'Mathlib.Topology.MetricSpace.Bounded','Mathlib.Data.Finset.Lattice.Fold'],
 '# Mesh size from actual cell diameters\n\nA finite maximum of metric diameters, independent of measures and capacities.\nBounds on distances require bounded actual cells. Positive volume alone supplies\nneither boundedness nor positive metric diameter.')

core=span(real,'namespace CapacityCoordinate','noncomputable def step')
remove=span(real,'theorem Method.projection_cell','/-- A cell observes only')
assert remove in core;core=core.replace(remove,'')
methodghost=span(ghost_path,'namespace CapacityCoordinate.Method')
drop=span(ghost_path,'theorem projection_withGhost','/-- Cross-boundary-data stability')
assert drop in methodghost;methodghost=methodghost.replace(drop,'')
write_owner(FV+'CapacityCoordinateMethod.lean',core+'end CapacityCoordinate\n\n'+methodghost,
 [fvim('PhysicalLineCapacity')],
 '# Supplied capacity methods and conditional stability\n\nNumerical flux and admission depend on the actual supplied time step.\nConstruction and execution require no pairwise stability property. The separate\nStableAt estimate compares two admitted inputs at the same step. Boundary replacement\npreserves flux and admission functions, with actual-cell and ghost errors kept explicit.')

sweep=span('capacity-boundary-sweep-draft/Sweep.lean.fragment')
laws=span('capacity-boundary-sweep-draft/StageLaws.lean.fragment',None,'/-- The previous fixed-coordinate API')
write_owner(FV+'CapacityCoordinateSweep.lean',sweep+'\n'+laws+'end CapacityBoundarySweep\n',
 [fvim('CapacityCoordinateMethod'),fvim('FinitePhysicalFluxError'),'ComputationalMathematics.Analysis.Normed.Group.SequentialError'],
 '# Ordered capacity sweeps with stage-dependent boundary data\n\nOne execution producer accepts the actual coordinate/method pair at each stage.\nMass balance retains exterior transfer, and locality concerns each current stage.\nPhysical error propagation separately assumes actual/reference admission, positive\ndurations, conditional stability, net flux defect and reference splitting defect.\nThe constant-coordinate case is a specialization of this producer.')

variation=span('capacity-zero-flux-witness/Zero.lean.fragment','/-- The same once-per-left-edge sum','variable [MeasurableSpace Point]')
vb=span('capacity-small-bias-witness/Bias.lean.fragment','/-- Actual boundary-edge count','end CapacitySmallBias')
vprefix='namespace NumStability.FiniteCoordinate.LineCoordinates\nopen NumStability NumStability.FiniteCoordinate\nopen scoped BigOperators\nvariable {D Cell Face Line : Type*} {m : ℕ}\nlocal notation "State" => Fin m → ℝ\n\n'
write_owner(FV+'CoordinateLineVariation.lean',vprefix+variation+vb+'end NumStability.FiniteCoordinate.LineCoordinates\n',
 [fvim('FiniteLineCoordinates'),'Mathlib.Algebra.BigOperators.Ring.Finset',
  'Mathlib.Algebra.Order.BigOperators.Group.Finset','Mathlib.Tactic.Linarith','Mathlib.Tactic.NormNum'],
 '# Variation over actual coordinate edges\n\nEach internal edge is counted once and each missing-neighbor exterior edge is retained.\nA common cell shift cancels at internal edges; fixed-ghost boundary variation is bounded\nby the actual boundary-edge count. Two-edge bounds explicitly require that count bound.')

quality=span('physical-refinement-quality-draft/PhysicalRefinement.lean.fragment')
oldvar=span('physical-refinement-quality-draft/PhysicalRefinement.lean.fragment',
 'noncomputable def variation','/-- Core quality')
split=oldvar.index(' := by')
newvar=oldvar[:split]+''' := by
  letI := family.finiteCell n
  exact NumStability.FiniteCoordinate.LineCoordinates.onceEdgeVariation
    (family.coordinates n) d line ghost current

'''
assert quality.count(oldvar)==1;quality=quality.replace(oldvar,newvar)
rewrites.append({'kind':'transparent-shared-variation-specialization','source':'PhysicalRefinementQuality.Family.variation',
 'original_normalized_span_sha256':hashlib.sha256(oldvar.encode()).hexdigest(),
 'replacement':newvar,'meaning':'Same finite-cell instance, coordinates, ghost values and once-edge sum; root will verify by rfl.'})
zeroquality=span('physical-zero-quality-draft/ZeroQuality.lean.fragment')
write_owner(FV+'PhysicalRefinementQuality.lean',quality+'\n'+zeroquality,
 [fvim('CapacityCoordinateMethod'),fvim('PhysicalCellMesh'),fvim('FinitePhysicalFluxError'),
  fvim('CoordinateLineVariation'),'Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries'],
 '# High-resolution quality for refining physical meshes\n\nA fixed physical measure, state domain and tensor flux are bound to each actual\nrefining mesh and supplied normal flux. References obey supplied measured directional\nbalances; tensor/normal data alone do not establish a continuum PDE equivalence.\nGenuine C-infinity uses the inner ENat infinity explicitly. One reference certificate\nhas a fixed constant and threshold before every later level and admitted time step.\nPositive input-step availability and quantitative oscillation control form core quality;\npairwise stability is a separate assumption of the perturbation theorem.\nBoundary projections are normalized means on actual supplied regions. The zero-flux\nquality theorem covers the full reference class, without selecting a profile predicate.')

sweepspec=span('physical-high-resolution-sweep-draft/Sweep.lean.fragment')
admitted=span('physical-admitted-high-resolution-sweep/Admitted.lean.fragment')
write_owner(FV+'PhysicalHighResolutionSweep.lean',sweepspec+'\n'+admitted,
 [fvim('PhysicalRefinementQuality'),fvim('CapacityCoordinateSweep'),fvim('FiniteCartesianReference')],
 '# High-resolution coordinate execution on supplied physical meshes\n\nThe selected level executes its actual capacity methods in the supplied order.\nValid substeps record positive within-horizon durations and admission of the actual\nintermediate arrays. Bare algebraic execution stays available independently.\nConservation retains boundary transfer. Stability and physical reference-error estimates\nare explicit conditional observations, not restrictions on core quality. Cartesian\nidentifications concern the same data; supplied directional balances are not asserted\nto be equivalent to an unsplit continuum PDE or a universal geometric construction.')

geom=span('physical-refinement-cartesian-witness/Geometry.lean.fragment')
firstboundary=span('physical-refinement-cartesian-witness/Boundary.lean.fragment',None,'/-- Only finite active')
write_owner(FV+'Examples/RefiningCartesianGeometry.lean',geom+'\n'+firstboundary+'end RefiningCartesianWitness\n',
 [fvim('FiniteCartesianGeometry'),fvim('PhysicalCellMesh'),fvim('Examples/HighResolutionAdvectionLine')],
 '# A growing finite Cartesian geometry\n\nConcrete two-dimensional boxes have h = 1/(n+2), measured volumes h^2 and a fixed\nnonempty target. Actual bounded-cell metric diameters tend to zero. Fixed directional\nflux and coordinate normals can be supplied on the same geometry. These are explicit\nexample choices, not a construction for every logical or curvilinear grid. Existing\ninterval-grid bounds are reused; capacities are never substituted for diameters.')

restboundary=span('physical-refinement-cartesian-witness/Boundary.lean.fragment','/-- Only finite active','end RefiningCartesianWitness')
coord=span('physical-refinement-cartesian-witness/Execution.lean.fragment','noncomputable def coord','theorem incidence')
exampleprefix='namespace RefiningCartesianWitness\nopen NumStability MeasureTheory Set\nopen NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian\nopen scoped BigOperators\n\n'
write_owner(FV+'Examples/RefiningCartesianBoundary.lean',exampleprefix+restboundary+coord+'end RefiningCartesianWitness\n',
 [fvim('Examples/RefiningCartesianGeometry'),fvim('FiniteLineCoordinates')],
 '# Boundary regions and lookup on the refining Cartesian example\n\nThe finite lookup preserves actual cell positions and coordinate lines. Every supplied\nboundary region is a genuine bounded positive finite-measure Cartesian cell. Clamping\nonly totalizes unread positions; the adjacent-query theorem identifies every physical\nneighbor without clamping. No boundary condition is inferred from the lookup.')

zerofamily=span('physical-zero-refinement-witness/Family.lean.fragment')
write_owner(FV+'Examples/ZeroFluxCartesianRefinement.lean',zerofamily,
 [fvim('Examples/RefiningCartesianBoundary'),fvim('PhysicalRefinementQuality'),cvim('Hyperbolicity')],
 '# A complete zero-flux physical refinement example\n\nThe growing measured Cartesian family, actual boundary regions and zero-flux capacity\nmethod instantiate the full quality contract. A fixed spatially nonconstant stationary\nC-infinity field belongs to its genuine reference class at every level. Stability is\nproved separately. This example does not assert solver availability for arbitrary laws.')

# The final source target comes only from the successful admitted successor.
admitreceipt=json.loads(source('physical-admitted-high-resolution-sweep/receipt.json'))
assert admitreceipt['actual_exit_code']==0
src=span('physical-admitted-high-resolution-sweep/SourceTarget.lean.fragment')
assert hashlib.sha256(source('physical-admitted-high-resolution-sweep/SourceTarget.lean.fragment').encode()).hexdigest()==admitreceipt['source_target']['sha256']
write_owner(SRC+'CoordinateHighResolutionMethods.lean',src,
 [fvim('PhysicalHighResolutionSweep')],
 '# Chapter 1 coordinate splitting on a physical logical grid\n\nThis correspondence uses the recorded physical logical-grid and separately adopted\nhigh-resolution interpretations. It executes supplied capacity methods through positive,\nadmitted coordinate substeps on the selected measured mesh. Core quality retains\nuniform smooth order and quantitative oscillation control; stability is required only\ninside the conditional error analysis. The underlying assumptions are supplied measured\ndirectional balances, with no continuum-equivalence inference from tensor/normal data.\nThe earlier common-area source contract is preserved in its frozen historical audit;\nthis replacement requires its own source-faithfulness decision.',
 role='source',changed=True)

def changed_exact(path,content,changes):
 old=source(path)
 content=content.replace('\r\n','\n')
 out=P/'proposed'/path;put(out,content.encode())
 record={'target_path':path,'module':path[:-5].replace('/','.'),'role':'reusable','change':'changed',
  'current':file_ref(R/path),'proposed':file_ref(out),'imports':re.findall(r'(?m)^import\s+(\S+)',content),
  'lines':len(content.splitlines()),'changes':changes}
 diff=''.join(difflib.unified_diff(old.splitlines(True),content.splitlines(True),fromfile=path,tofile='proposal/'+path))
 record['diff']=put(P/'diffs'/(Path(path).stem+'.diff'),diff.encode())
 outputs.append(record)
def update_imports(text,extra):
 lines=text.splitlines(True)
 imports=re.findall(r'(?m)^import\s+(\S+)',text)
 at=next(i for i,l in enumerate(lines) if l.startswith('import '))
 lines=[l for l in lines if not l.startswith('import ')]
 block=''.join('import '+s+'\n' for s in sorted(set(imports+extra),key=str.casefold))
 lines.insert(at,block)
 return ''.join(lines)
cm=source(coord_path)
assert cm.count(oldcoords)==1
cm=cm.replace(oldcoords,'')
cm=update_imports(cm,[fvim('FiniteLineCoordinates')])
cm=cm.replace('Actual finite-cell line coordinates, supplied ghost values, physical law linkage and equality with the selected line operator.',
 'The retained common-area line realization and its selected interval operator.\nFinite-cell lookup and supplied ghost values are imported from FiniteLineCoordinates.')
changed_exact(coord_path,cm,[
 'Move four LineCoordinates declarations with exact existing names/types/proof bodies.',
 'Add direct FiniteLineCoordinates import and describe retained common-area scope; all realization code unchanged.'])
ce=source(estimate_path)
assert ce.count(olderror)==1
ce=ce.replace(olderror,'')
changed_exact(estimate_path,ce,['Move only LineCoordinates.extract_error_le unchanged; prior imports expose it through CoordinateLineMethod.'])

hyper_path=CV+'Hyperbolicity.lean'
hyper=source(hyper_path)
constant=span('capacity-small-bias-witness/Bias.lean.fragment','/-- A constant flux','def method')
constant=constant.replace('theorem constantFlux_hyperbolic (constant : State) (states : Set State)',
 'theorem constantFlux_isHyperbolicOn {m : ℕ}\n    (constant : Fin m → ℝ) (states : Set (Fin m → ℝ))')
constant=constant.replace('(fun _ : State => constant)','(fun _ : Fin m → ℝ => constant)')
assert 'State' not in constant
assert hyper.count('end NumStability')==1
hyper=hyper.replace('end NumStability',constant+'\nend NumStability')
hyper=update_imports(hyper,['Mathlib.Analysis.Calculus.FDeriv.Const','Mathlib.LinearAlgebra.StdBasis'])
changed_exact(hyper_path,hyper,['Add exact checked constant-flux derivative/eigenbasis proof under NumStability.constantFlux_isHyperbolicOn.',
 'Add direct upstream imports for the actual derivative and standard basis; all existing declarations unchanged.'])

def declaration_inventory(text):
 stack=[];result=[]
 for n,line in enumerate(text.splitlines(),1):
  m=re.match(r'^namespace\s+(\S+)\s*$',line)
  if m:stack.append(m[1]);continue
  m=re.match(r'^end(?:\s+(\S+))?\s*$',line)
  if m:
   assert stack,('unmatched end',n,line)
   assert m[1] is None or m[1]==stack[-1],('mismatched end',n,line,stack)
   stack.pop();continue
  m=re.match(r'^(?:(?:noncomputable|private|protected)\s+)*(def|abbrev|structure|theorem|lemma|instance)\s+([^\s(:{]+)',line)
  if m:
   prefix='.'.join(stack)
   name=m[2] if m[2].startswith('NumStability.') else prefix+'.'+m[2]
   result.append({'name':name,'kind':m[1],'line':n})
 assert not stack,stack
 return result
seen={}
for record in outputs:
 p=P/'proposed'/record['target_path'];text=raw(p).decode()
 assert '\r' not in text and text.endswith('\n')
 assert not re.search(r'(?m)^#(?:check|print|eval)|\bsorry\b|\badmit\b',text)
 assert '/-!' in text
 exports=declaration_inventory(text);record['exports']=exports;record['declarations']=[x['name'] for x in exports]
 for x in exports:
  assert x['name'].startswith('NumStability.'),x
  assert x['name'] not in seen,(x,seen.get(x['name']))
  seen[x['name']]=record['target_path']
 for module in record['imports']:
  q=module.replace('.','/')+'.lean'
  candidates=[P/'proposed'/q,R/q,R/'.lake/packages/mathlib'/q]
  assert any(os.path.isfile(native(t)) for t in candidates),('missing import source',module)
 assert record['imports']==sorted(set(record['imports']),key=str.casefold)
# Existing moved names are present exactly once at their single new owner.
existing_names=['NumStability.FiniteCoordinate.LineCoordinates',
 'NumStability.FiniteCoordinate.LineCoordinates.extract',
 'NumStability.FiniteCoordinate.LineCoordinates.extract_cell',
 'NumStability.FiniteCoordinate.LineCoordinates.extract_local',
 'NumStability.FiniteCoordinate.LineCoordinates.extract_error_le']
assert all(seen[x]==FV+'FiniteLineCoordinates.lean' for x in existing_names)
assert len(outputs)==16
assert sum(x['change']=='new' for x in outputs)==12
for p,item in inputs.items():assert file_ref(Path(p))['sha256']==item['sha256'],p
approved=D/'physical-dim-promotion-review/mapping.json'
assert file_ref(approved)['sha256']=='37d6e19cca93d27e70267ed2702ea11a6e53af907256f8c418b7299cf0b20a4b'
put(P/'mapping.json',{'schema':1,'status':'proposal snapshots; not native checked or promoted',
 'approved_plan':file_ref(approved),'input_files':list(inputs.values()),'original_spans':spans,
 'namespace_token_substitutions':token_map,'substitution_counts_per_owner':token_events,
 'transparent_rewrites':rewrites,'files':outputs,'preserved_moved_names':existing_names,
 'fixed_coordinate_run':'Omitted from production; retain frozen rfl specialization in comparison artifacts.',
 'omitted_aliases':'The approved map lists all omissions; no omitted declaration is referenced by a proposal.',
 'final_admitted_receipt':file_ref(D/'physical-admitted-high-resolution-sweep/receipt.json'),
 'five_owner_regularity_group':'Excluded from this proposal; exact-copy placement remains root-owned.',
 'native_checks':'Not run by this author; root will check production placement and nominal comparison maps.',
 'source_acceptance':False,'production_mutation':False})
put(P/'imports-and-exports.json',{'files':[{'path':x['target_path'],'imports':x['imports'],
 'declarations':x['declarations'],'lines':x['lines']} for x in outputs]})
print(json.dumps({'mapping':file_ref(P/'mapping.json'),'owners':len(outputs),
 'new':sum(x['change']=='new' for x in outputs),'authored_declarations':sum(len(x['exports']) for x in outputs)},indent=2))
