from pathlib import Path
import json,re
G=Path(__file__).resolve().parent;R=G.parents[5];D=G.parent
inv=json.loads((G/'current-check-inventory.json').read_text())
renames=inv['renames']
oldpath=D/'dim-joint-primary-witness/native-03/Input.lean';old=oldpath.read_text()
old=old.split('namespace DIMJointPrimaryWitness',1)[0]
old='\n'.join(l for l in old.splitlines() if not l.startswith(('#check ','#print axioms ')))+'\n'
def renamed(n):
    for a,b in renames:n=n.replace(a,b)
    # Reference definitions have a single canonical owner.
    for name in ('RectangleReferenceOn','SmoothReferenceOn','SpatialRectangleReferenceOn','SpatialSmoothReferenceOn','spatial_rectangle_const_iff','spatial_smooth_const_iff'):
        n=n.replace('NumStability.DirectionalLine.'+name,'NumStability.LocalConservationLaw.'+name)
    return n
ns=[];mapping={}
for line in old.splitlines():
    n=re.match(r'^namespace\s+(\S+)',line)
    if n:ns.append(n[1]);continue
    if re.match(r'^end\b',line):
        if ns:ns.pop()
        continue
    d=re.match(r'^(?:@\[[^]]+\]\s*)?(?:noncomputable\s+)?(?:def|theorem|structure|abbrev)\s+([^\s(:]+)',line)
    if d:
        name='.'.join(ns+[d[1]]);mapping.setdefault(renamed(name),name)
pairs=[]
for f in inv['files']:
    for name in f['declarations']:
        assert name in mapping,name
        pairs.append((mapping[name],name))
imports='\n'.join('import '+f['module'] for f in inv['files'])+'\nimport Lean\n'
allimports=sorted(set(re.findall(r'^import\s+\S+',imports+old,re.M)))
old='\n'.join(l for l in old.splitlines() if not l.startswith('import '))+'\n'
prefix='\n'.join(allimports)+'\n'+old+'\n'
bridges='''namespace NumStability.DimensionalPlacement
open MeasureTheory
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
'''
def make(name,a,b,fields):
    return f'noncomputable def {name} (x : {a}) : {b} where\n'+''.join(f'  {f} := x.{f}\n' for f in fields)+'\n'
phys='D Cell Face Point FacePoint m';coord='(m := m) D Cell Face Line'
pf='cells measure positive finite leftFace rightFace faceMeasure facePoint left_incidence right_incidence admissibleStates normalFlux hyperbolic'.split()
cf='cellLine cellIndex faceLine faceIndex lookup lookup_cell lookup_sound ghost'.split()
ff='flux states left right interval_nonempty hyperbolic horizon horizon_pos grid mesh mesh_pos mesh_tendsto meshRatio meshRatio_pos dt dt_pos dt_le_horizon cfl cfl_pos activeStart activeCount activeCount_two_le targetLeft targetRight target_nonempty target_inside active_coverage inputStart inputCount input_covers input_geometry mesh_comparable numericalFlux admitted line_local'.split()
for name,a,b,fields in [('physical','FiniteCoordinate.PhysicalData '+phys,'FiniteDirectionalRepair.PhysicalData '+phys,pf),('coordinates','FiniteCoordinate.LineCoordinates '+coord,'FiniteDirectionalRepair.LineCoordinates '+coord,cf),('family','DirectionalLine.LineFamily m','DirectionalQualityRepair.LineFamily m',ff)]:
    bridges+=make(name+'ToDraft',a,b,fields)+make(name+'FromDraft',b,a,fields)
    bridges+=f'theorem {name}_roundtrip (x : {a}) : {name}FromDraft ({name}ToDraft x) = x := by cases x; rfl\n'
    bridges+=f'theorem {name}_draft_roundtrip (x : {b}) : {name}ToDraft ({name}FromDraft x) = x := by cases x; rfl\n\n'
bridges+='''theorem quality_iff (family : DirectionalLine.LineFamily m) :
    family.HasControlledHighResolution ↔ (familyToDraft family).HasControlledHighResolution := by
  constructor <;> intro h <;> exact ⟨h.order, h.stability, h.oscillation⟩

theorem physical_reference_iff (data : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → Fin m → ℝ) (s t : ℝ) :
    data.ReferenceOn d q s t ↔ (physicalToDraft data).ReferenceOn d q s t := Iff.rfl

theorem physical_mean_eq (data : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m)
    (q : Point → ℝ → Fin m → ℝ) (cell : Cell) (t : ℝ) :
    data.cellMean q cell t = (physicalToDraft data).cellMean q cell t := rfl

theorem physical_flux_eq (data : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → Fin m → ℝ) (face : Face) (t : ℝ) :
    data.faceFlux d q face t = (physicalToDraft data).faceFlux d q face t := rfl

theorem family_advance_eq (family : DirectionalLine.LineFamily m) (n : ℕ)
    (values : ℤ → Fin m → ℝ) (j : ℤ) :
    family.advance n values j = (familyToDraft family).advance n values j := rfl

theorem extraction_eq (coord : FiniteCoordinate.LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current : Cell → Fin m → ℝ) (j : ℤ) :
    coord.extract d line current j = (coordinatesToDraft coord).extract d line current j := rfl

variable {data : FiniteCoordinate.PhysicalData D Cell Face Point FacePoint m}
variable {coord : FiniteCoordinate.LineCoordinates (m := m) D Cell Face Line}
variable {families : D → Line → DirectionalLine.LineFamily m}
'''
rf='level duration duration_eq area area_pos left_line right_line left_index right_index active_cell volume_eq physical_flux states_eq'.split()
ra='FiniteCoordinate.LineRealization data coord families'
rb='FiniteDirectionalRepair.LineRealization (physicalToDraft data) (coordinatesToDraft coord) (fun d line => familyToDraft (families d line))'
bridges+=make('realizationToDraft',ra,rb,rf)+make('realizationFromDraft',rb,ra,rf)
bridges+=f'theorem realization_roundtrip (x : {ra}) : realizationFromDraft (realizationToDraft x) = x := by cases x; rfl\n'
bridges+=f'theorem realization_draft_roundtrip (x : {rb}) : realizationToDraft (realizationFromDraft x) = x := by cases x; rfl\n'
bridges+='''theorem rule_eq (method : FiniteCoordinate.LineRealization data coord families)
    (d : D) (dt : ℝ) (current : Cell → Fin m → ℝ) (face : Face) :
    method.rule d dt current face = (realizationToDraft method).rule d dt current face := rfl

theorem admission_iff (method : FiniteCoordinate.LineRealization data coord families)
    (d : D) (current : Cell → Fin m → ℝ) :
    method.Admitted d current ↔ (realizationToDraft method).Admitted d current := Iff.rfl

theorem update_eq (method : FiniteCoordinate.LineRealization data coord families)
    (d : D) (dt : ℝ) (current : Cell → Fin m → ℝ) :
    FiniteCoordinate.advance data method.rule d dt current =
      FiniteDirectionalRepair.advance (physicalToDraft data) (realizationToDraft method).rule d dt current := rfl

end NumStability.DimensionalPlacement
'''
bn=re.findall(r'^(?:noncomputable )?(?:def|theorem) (\w+)',bridges,re.M)
directives='\n'.join('#check NumStability.DimensionalPlacement.'+n+'\n#print axioms NumStability.DimensionalPlacement.'+n for n in bn)+'\n'
meta='''open Lean Meta Elab Command in
run_cmd liftTermElabM do
  let pairs : List (Name × Name) := [
'''+',\n'.join('    (`'+a+', `'+b+')' for a,b in pairs)+''']
  let rewriteName := fun name =>
    let text := name.toString
    let exact := pairs.find? (fun p => p.1 == name)
    match exact with
    | some p => p.2
    | none => name
  let rewrite := fun (expr : Expr) => expr.replace fun sub =>
    match sub with
    | .const n ls => some (.const (rewriteName n) ls)
    | .proj n i e => some (.proj (rewriteName n) i e)
    | _ => none
  for (oldName, newName) in pairs do
    let oldInfo ← getConstInfo oldName
    let newInfo ← getConstInfo newName
    unless oldInfo.levelParams.length == newInfo.levelParams.length do
      throwError "universe arity mismatch {oldName} -> {newName}"
    let levels := (List.range newInfo.levelParams.length).map fun i => Level.param (Name.mkSimple s!"placementLevel{i}")
    let oldType := rewrite (oldInfo.type.instantiateLevelParams oldInfo.levelParams levels)
    let newType := newInfo.type.instantiateLevelParams newInfo.levelParams levels
    unless ← isDefEq oldType newType do
      throwError "type mismatch after explicit nominal-name transport: {oldName} -> {newName}\\n{oldType}\\n{newType}"
    logInfo m!"TYPE_TRANSPORT_OK {oldName} -> {newName}"
'''
(G/'Comparisons.lean').write_text(prefix+bridges+directives+meta,encoding='utf-8',newline='\n')
(G/'comparison-plan.json').write_text(json.dumps({'old_input':oldpath.relative_to(R).as_posix(),'pairs':pairs,'bridge_declarations':['NumStability.DimensionalPlacement.'+n for n in bn],'method':'Native definitional type comparison only after explicit authored-constant name transport; nominal structures separately have field-preserving conversions/round trips. No nominal DefEq claim.'},indent=2)+'\n',encoding='utf-8',newline='\n')
print(len(pairs),len(bn))
