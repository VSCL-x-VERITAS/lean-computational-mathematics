from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;D=P.parent;R=P.parents[5];S=D/'directional-reference-repair'
inputs={}
def read(p):
    inputs[p.relative_to(R).as_posix()]=hashlib.sha256(p.read_bytes()).hexdigest()
    return p.read_text(encoding='utf-8')
def clean(t):return '\n'.join(l for l in t.splitlines() if not l.startswith(('import ','#check ','#print axioms ')))+'\n'
def imports(t):return [l[7:] for l in t.splitlines() if l.startswith('import ')]
renames=[
 ('NumStability.DirectionalQualityRepair.RectangleReferenceOn','NumStability.LocalConservationLaw.RectangleReferenceOn'),
 ('NumStability.DirectionalQualityRepair.SmoothReferenceOn','NumStability.LocalConservationLaw.SmoothReferenceOn'),
 ('DimLocalCharacteristicWitness.RectangleReferenceOn','NumStability.LocalConservationLaw.RectangleReferenceOn'),
 ('DimLocalCharacteristicWitness.SmoothReferenceOn','NumStability.LocalConservationLaw.SmoothReferenceOn'),
 ('DirectionalGeometryRepair.cartesian_facePoint_measurable','FiniteCartesian.facePoint_measurable'),
 ('NumStability.FiniteDirectionalRepair','NumStability.FiniteCoordinate'),('FiniteDirectionalRepair','FiniteCoordinate'),
 ('NumStability.DirectionalQualityRepair','NumStability.DirectionalLine'),('DirectionalQualityRepair','DirectionalLine'),
 ('NumStability.DirectionalPropagationRepair','NumStability.SequentialError'),('DirectionalPropagationRepair','SequentialError'),
 ('NumStability.CartesianProjectionRepair','NumStability.CartesianGrid'),('CartesianProjectionRepair','CartesianGrid'),
 ('NumStability.FiniteCartesianRepair','NumStability.FiniteCartesian'),('FiniteCartesianRepair','FiniteCartesian'),
 ('NumStability.FiniteCartesianDraft','NumStability.FiniteCartesian'),('FiniteCartesianDraft','FiniteCartesian'),
 ('NumStability.DirectionalCompleteRepair','NumStability.HighResolutionCoordinateSweep'),
 ('DimLocalCharacteristicWitness','NumStability.LocalLinearAdvection'),
 ('CFL1RefinementWitness','NumStability.CFLUnitShift'),('CFL1QualityFamilyWitness','NumStability.HighResolutionAdvectionLine')]
def rename(t):
    for a,b in renames:t=t.replace(a,b)
    return t
FV='ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.'
CL='ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.'
files=[]
def put(mod,deps,body,description):
    path=R/(mod.replace('.','/')+'.lean');assert not path.exists(),path
    text='/-\nSPDX-License-Identifier: MIT\n-/\n\n'+'\n'.join('import '+d for d in sorted(set(deps)))+'\n\n/-!\n'+description+'\n-/\n\n'+rename(body).strip()+'\n'
    path.parent.mkdir(parents=True,exist_ok=True);path.write_text(text,encoding='utf-8',newline='\n')
    ns=[];decl=[]
    for i,line in enumerate(text.splitlines(),1):
        n=re.match(r'^namespace\s+(\S+)',line)
        if n:ns.append(n.group(1));continue
        if re.match(r'^end\b',line):
            if ns:ns.pop()
            continue
        d=re.match(r'^(?:@\[[^]]+\]\s*)?(?:noncomputable\s+)?(?:def|theorem|structure)\s+([^\s(:]+)',line)
        if d:decl.append('.'.join(ns+[d.group(1)]))
    files.append({'path':path.relative_to(R).as_posix(),'module':mod,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'declarations':decl,'lines':len(text.splitlines())})
ctx='''open MeasureTheory
open scoped BigOperators
namespace NumStability.FiniteDirectionalRepair
variable {D Cell Face Point FacePoint : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
'''
f=clean(read(S/'Finite.lean'))
geom,rest=f.split('/-- Every subinterval',1)
ref,rest=('/-- Every subinterval'+rest).split('/-- Boundary/ghost',1)
update,error=('/-- Boundary/ghost'+rest).split('/-- An auxiliary',1)
error='/-- An auxiliary'+error
put(FV+'FinitePhysicalGeometry',[FV+'CellVolumeAverage',FV+'PhysicalCoordinateGeometry'],geom+'\nend NumStability.FiniteDirectionalRepair','Actual measured active cells and shared physical faces, with incidence required almost everywhere under the face measure.')
put(FV+'FinitePhysicalUpdate',[FV+'FinitePhysicalGeometry','ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting'],ctx+update+'\nend NumStability.FiniteDirectionalRepair','Conservative finite-array steps and ordered sweeps. Exterior boundary transfer and the actual stencil are retained.')
put(FV+'FinitePhysicalReferenceError',[FV+'FinitePhysicalUpdate',FV+'LocalCellErrorBounds'],ctx+ref+error,'All-subinterval physical reference balance and the resulting local finite-volume error estimate.')
q=clean(read(S/'Quality.lean'))
qhead,qrest=q.split('noncomputable def windowVariation',1)
variation,qrest=('noncomputable def windowVariation'+qrest).split('/-- Logical line',1)
spatial,family=('/-- Logical line'+qrest).split('/-- Data of a refining',1)
localbody=qhead.replace('DirectionalQualityRepair','LocalConservationLaw')+spatial+'\nend NumStability.LocalConservationLaw'
put(CL+'LocalRectangleReference',[FV+'RiemannInterface','Mathlib.Analysis.Calculus.ContDiff.Defs'],localbody,'Local physical conservation on every subrectangle, with explicit smooth and spatial-flux variants.')
qctx='''open MeasureTheory Filter
open scoped BigOperators Topology
namespace NumStability.DirectionalQualityRepair
open NumStability.LocalConservationLaw
variable {m : ℕ}
local notation "State" => Fin m → ℝ
'''
put(FV+'RefiningLineMethod',[CL+'LocalRectangleReference','Mathlib.Analysis.SpecialFunctions.Pow.Real'],qctx+variation+'/-- Data of a refining'+family,'Refining full-line finite-volume families with actual mesh comparability, fixed-region coverage, uniform smooth-reference order, perturbation stability and oscillation control.')
ex=clean(read(S/'Execution.fragment'));core,est=ex.split('theorem LineCoordinates.extract_error_le',1)
put(FV+'CoordinateLineMethod',[FV+'FinitePhysicalUpdate',FV+'RefiningLineMethod'],core+'\nend NumStability.FiniteDirectionalRepair','Actual finite-cell line coordinates, supplied ghost values, physical law linkage and equality with the selected line operator.')
exctx='''namespace NumStability.FiniteDirectionalRepair
open DirectionalQualityRepair NumStability.LocalConservationLaw
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
'''
pr=clean(read(S/'Propagation.lean'))
put('ComputationalMathematics.Analysis.Normed.Group.SequentialError',['Mathlib.Analysis.Normed.Group.Basic','Mathlib.Algebra.Order.Ring.Pow','Mathlib.Tactic.Linarith','Mathlib.Tactic.NormNum','Mathlib.Tactic.Push'],pr,'Finite successive-operator perturbation estimates with separate local and reference-mismatch defects.')
com=clean(read(S/'Composition.fragment'))
put(FV+'CoordinateLineMethodEstimates',[FV+'CoordinateLineMethod',FV+'FinitePhysicalReferenceError','ComputationalMathematics.Analysis.Normed.Group.SequentialError'],exctx+'theorem LineCoordinates.extract_error_le'+est+'\n'+com,'Locality, uniform constituent error bounds and actual finite successive-step error propagation.')
lift=read(S/'Lift.lean')
proj=lift.split('namespace NumStability.CartesianProjectionRepair',1)[1].split('end NumStability.CartesianProjectionRepair',1)[0]
put(FV+'CartesianCellProjection',[FV+'CartesianGridGeometry',FV+'CellVolumeAverage','Mathlib.MeasureTheory.Integral.Pi'],'open MeasureTheory\nopen scoped BigOperators\nnamespace NumStability.CartesianProjectionRepair'+proj+'\nend NumStability.CartesianProjectionRepair','Projection of measured Cartesian cell integrals and normalized means onto an actual coordinate interval.')
gpath=D/'finite-cartesian-geometry-draft';g=read(gpath/'Cartesian.lean.fragment')
gimports=imports(read(gpath/'final01-Checks.lean')) if (gpath/'final01-Checks.lean').exists() else []
# Exact fragment uses only the existing measured-grid definitions and the new finite physical data.
put(FV+'FiniteCartesianGeometry',[FV+'FinitePhysicalGeometry',FV+'CartesianGridGeometry','Mathlib.MeasureTheory.Integral.Pi','Mathlib.Topology.Instances.Int'],g,'A nonempty finite selection of actual Cartesian cells, shared physical faces and restricted pushforward face measures.')
cart=clean(read(S/'FiniteCartesian.fragment'))
put(FV+'FiniteCartesianReference',[FV+'FiniteCartesianGeometry',FV+'CartesianCellProjection',FV+'CartesianDirectionalReference'],cart,'Identification of the same finite physical cells, means and normal fluxes with actual Cartesian geometry, and rectangle-law transport.')
lp=D/'dim-local-characteristic-witness';localraw=read(lp/'Candidate.lean')
localhead=localraw.split('/-- A genuine local conservation reference',1)[0]
localtail='variable {E : Type*}'+localraw.split('variable {E : Type*}',1)[1]
localbody=clean(localhead)+clean(localtail)
localbody=localbody.replace('namespace DimLocalCharacteristicWitness','namespace DimLocalCharacteristicWitness\nopen NumStability.LocalConservationLaw')
put(CL+'LocalLinearAdvection',imports(localraw)+[CL+'LocalRectangleReference'],localbody,'Deriving the classical scalar transport equation and characteristic identity from a genuine smooth local rectangle law.')
cflraw=read(D/'dim-cfl1-witness'/'Candidate.lean')
put(FV+'Examples.CFLUnitShift',imports(cflraw),clean(cflraw),'Unit-speed transport at CFL one: exact shifts, local projections, finite-window oscillation control and nonconstant smooth/discontinuous examples.')
connection=read(lp/'Connection.lean.fragment')
connection=connection.replace('namespace DimLocalCharacteristicWitness','namespace DimLocalCharacteristicWitness\nopen NumStability.LocalConservationLaw')
fam=read(D/'dim-quality-family-witness'/'Family.lean.fragment')
put(FV+'Examples.HighResolutionAdvectionLine',[FV+'RefiningLineMethod',CL+'LocalLinearAdvection',FV+'Examples.CFLUnitShift'],connection+'\n'+fam,'A full nonvacuous high-resolution line family on a fixed physical interval, using genuine local smooth references and the exact CFL-one operator.')
primary=clean(read(S/'Primary.fragment'))
primary=primary.replace('open MeasureTheory DirectionalQualityRepair','open MeasureTheory NumStability.LocalConservationLaw DirectionalQualityRepair')
put(FV+'HighResolutionCoordinateSweep',[FV+'CoordinateLineMethodEstimates',FV+'FiniteCartesianReference'],primary,'A combined conditional coordinate construction with supplied method quality, actual successive execution, physical error propagation and same-data Cartesian correspondence.')
manifest={'status':'placed-awaiting-native-checks','files':files,'input_sources':[{'path':p,'sha256':s} for p,s in inputs.items()],'namespace_changes':renames,'source_wrapper_placed':False}
(P/'initial-placement.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps({'files':len(files),'authored_names_awaiting_check':sum(len(f['declarations']) for f in files)},indent=2))
