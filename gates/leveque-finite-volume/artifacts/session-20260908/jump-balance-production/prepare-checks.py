"""Assemble comparisons from exact frozen source, retaining the transformation map."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
manifest=json.loads((P/'initial-placement.json').read_bytes())
modules=[r['module'] for r in manifest['created']]
mi=S/'material-interface-general-draft/candidate.lean';ba=S/'nonconservation-integral-source-draft/RectangleBalance.lean'
def sha(b):return hashlib.sha256(b).hexdigest()
assert sha(mi.read_bytes())=='6f4ff70e5aa05fb68f1d68dc8a809468cd4de25fb0bacec83d17d020ffb99957'
assert sha(ba.read_bytes())=='991452bbf04ad34dfafada3782e9c21085db5721ca14e97dfbebcad8e7e601cd'
mi_maps={
 'HasJumpAt':'HasJumpAt','HasJumpAt.not_continuousAt':'HasJumpAt.not_continuousAt',
 'HasJumpAt.congr':'HasJumpAt.congr','hasJumpAt_of_isRiemannData':'IsRiemannData.hasJumpAt',
 'materialStateInterface_iff_product_traces':'hasJumpAt_and_iff_product_traces',
 'varyingMedium':'LocalMaterialInterface.varyingMedium',
 'varyingMedium_hasJumpAt':'LocalMaterialInterface.varyingMedium_hasJumpAt',
 'varyingMedium_not_isRiemannData':'LocalMaterialInterface.varyingMedium_not_isRiemannData',
 'varyingMedium_interface_witness':'LocalMaterialInterface.varyingMedium_interface_witness',
 'product_jump_with_constant_medium':'LocalMaterialInterface.product_jump_with_constant_medium'}
ba_maps={name:name for name in [
 'IsRectangleBalanceLawSolution',
 'IsRectangleBalanceLawSolution.integrated_source_eq_mass_defect',
 'IsRectangleBalanceLawSolution.rectangle_conservation_iff_source_integral_zero',
 'IsRectangleBalanceLawSolution.conservation_iff_source_integrals_zero',
 'IsRectangleBalanceLawSolution.not_conservation_iff_exists_nonzero_source_integral',
 'IsRectangleBalanceLawSolution.integrated_source_unique',
 'IsRectangleBalanceLawSolution.hasDerivAt_mass_ae']}
ba_maps.update({'zero_source_iff_conservation':'isRectangleBalanceLawSolution_zero_iff',
 'linear_amplitude_balance':'linearAmplitude_isRectangleBalanceLawSolution',
 'linear_amplitude_mass_derivative':'linearAmplitude_hasDerivAt_mass',
 'linear_amplitude_classical_balance':'linearAmplitude_isBalanceLawSolutionAt',
 'stationaryStep_unitCell':'riemannStep_unitCell','stationaryStep_signed_source_integral':'riemannStep_signed_source_integral',
 'stationaryStep_source_nonvacuity':'riemannStep_source_nonvacuity'})
mapping=[{'old':'NumStability.'+ns+'.'+a,'new':'NumStability.'+b} for ns,mp in [('MaterialInterfaceDraft',mi_maps),('IntegralSourceDraft',ba_maps)] for a,b in mp.items()]
checks='\n'.join('#check '+r['new']+'\n#print axioms '+r['new'] for r in mapping)+'\n'
decls=''.join('import '+m+'\n' for m in sorted(modules))+'\n'+checks
(P/'canonical-checks.lean').write_bytes(decls.encode())
inputs=[];bodies=[];imports=set(modules)
for src in [mi,ba]:
 text=src.read_bytes().decode().replace('\r\n','\n')
 imps=re.findall(r'^import (\S+)\n',text,re.M);imports.update(imps)
 body=re.sub(r'^import \S+\n','',text,flags=re.M)
 inputs.append({'path':str(src.relative_to(R)).replace(chr(92),'/'),'sha256':sha(src.read_bytes()),
 'assembly':'Normalize CRLF to LF and hoist import lines. No declaration, definition, statement, proof, or namespace edits.',
 'hoisted_imports':imps,'assembled_body_sha256':sha(body.encode())})
 bodies.append(body)
prefix=''.join('import '+m+'\n' for m in sorted(imports))+'\n'+'\n'.join(bodies)
comparisons='\nnamespace NumStability.JumpBalancePlacementCheck\n\n'
for i,r in enumerate(mapping,1):
 comparisons+=f'/-- Draft-to-canonical identity {i}: definitions unfold identically; proof equality uses proof irrelevance. -/\ntheorem identity_{i:02d} : @{r["old"]} = @{r["new"]} := rfl\n#print axioms identity_{i:02d}\n\n'
comparisons+='''open MeasureTheory Filter Set
open scoped Topology

/-- The omitted interface alias unfolds to the two canonical jumps. -/
theorem interface_alias {M Q : Type*} [TopologicalSpace M] [TopologicalSpace Q]
    (medium : ℝ → M) (state : ℝ → Q) (a : ℝ) (ml mr : M) (ql qr : Q) :
    MaterialInterfaceDraft.HasMaterialStateInterfaceAt medium state a ml mr ql qr ↔
      HasJumpAt medium a ml mr ∧ HasJumpAt state a ql qr := Iff.rfl

/-- The omitted discontinuity wrapper is reconstructed from the canonical jump API. -/
theorem interface_discontinuity {M Q : Type*} [TopologicalSpace M] [TopologicalSpace Q]
    [T2Space M] [T2Space Q]
    {medium : ℝ → M} {state : ℝ → Q} {a : ℝ} {ml mr : M} {ql qr : Q}
    (h : MaterialInterfaceDraft.HasMaterialStateInterfaceAt medium state a ml mr ql qr) :
    ¬ ContinuousAt medium a ∧ ¬ ContinuousAt state a :=
  ⟨(show HasJumpAt medium a ml mr from h.1).not_continuousAt,
    (show HasJumpAt state a ql qr from h.2).not_continuousAt⟩

/-- The omitted Riemann-pair wrapper is two applications of the canonical bridge. -/
theorem riemann_pair {M Q : Type*} [TopologicalSpace M] [TopologicalSpace Q]
    (ml m0 mr : M) (ql q0 qr : Q) (hm : ml ≠ mr) (hq : ql ≠ qr) :
    MaterialInterfaceDraft.HasMaterialStateInterfaceAt
      (riemannData ml m0 mr) (riemannData ql q0 qr) 0 ml mr ql qr :=
  ⟨(riemannData_isRiemannData ml m0 mr).hasJumpAt hm,
    (riemannData_isRiemannData ql q0 qr).hasJumpAt hq⟩

/-- The pending source-shaped bundle can be reconstructed without promoting it. -/
theorem local_medium_bundle {M Q : Type*} [TopologicalSpace M] [TopologicalSpace Q]
    [T2Space M] [T2Space Q]
    {medium : ℝ → M} {state : ℝ → Q} {ml mr : M} {ql qr : Q}
    (hl : Tendsto medium (𝓝[<] 0) (𝓝 ml)) (hr : Tendsto medium (𝓝[>] 0) (𝓝 mr))
    (hm : ml ≠ mr) (hs : IsRiemannData state ql qr) (hq : ql ≠ qr) :
    MaterialInterfaceDraft.HasMaterialStateInterfaceAt medium state 0 ml mr ql qr ∧
      IsRiemannData state ql qr ∧ ¬ ContinuousAt medium 0 ∧ ¬ ContinuousAt state 0 := by
  have hjm : HasJumpAt medium 0 ml mr := ⟨hl, hr, hm⟩
  have hjq := hs.hasJumpAt hq
  exact ⟨⟨hjm, hjq⟩, hs, hjm.not_continuousAt, hjq.not_continuousAt⟩

theorem stationary_step_alias : IntegralSourceDraft.stationaryStep = riemannData 0 0 1 := rfl

theorem stationary_step_integrability (a b : ℝ) :
    IntervalIntegrable IntegralSourceDraft.stationaryStep volume a b :=
  riemannData_intervalIntegrable 0 0 1 a b

#print axioms interface_alias
#print axioms interface_discontinuity
#print axioms riemann_pair
#print axioms local_medium_bundle
#print axioms stationary_step_alias
#print axioms stationary_step_integrability
end NumStability.JumpBalancePlacementCheck
'''
(P/'draft-comparisons.lean').write_bytes((prefix+comparisons).encode())
record={'inputs':inputs,'declaration_mapping':mapping,'canonical_declarations':[r['new'] for r in mapping],
 'comparison_identity_count':len(mapping),'eliminated_alias_bridges':6,
 'canonical_checks_sha256':sha(decls.encode()),'draft_comparisons_sha256':sha((prefix+comparisons).encode())}
(P/'comparison-inputs.json').write_bytes((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps({'mapped_declarations':len(mapping),'alias_bridges':6,'input_sha256':record['draft_comparisons_sha256']}))
