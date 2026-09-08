"""Build explicit nominal-structure transport checks against the exact draft."""
from pathlib import Path
import json,re
P=Path(__file__).resolve().parent;R=P.parents[4]
mp=json.loads((P/'placement-map.json').read_bytes())
t=(R/mp['draft']['path']).read_text(encoding='utf-8')
p=P/'Comparisons.lean.fragment';assert not p.exists()
out='''namespace NumStability.ReturnedFieldPlacementChecks

open ReturnedRiemannDraft

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

-- The two structures are nominally distinct. Both conversions preserve every
-- field explicitly, including all-real trace integrability and proof fields.
def toDraft (method : RiemannFieldFluxMethod law Result Information) :
    ReturnedRiemannDraft.FieldFluxMethod law Result Information where
  domain := method.domain
  solve := method.solve
  field := method.field
  initial := method.initial
  trace_integrable := method.trace_integrable
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

def fromDraft (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) :
    RiemannFieldFluxMethod law Result Information where
  domain := method.domain
  solve := method.solve
  field := method.field
  initial := method.initial
  trace_integrable := method.trace_integrable
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

theorem fromDraft_toDraft (method : RiemannFieldFluxMethod law Result Information) :
    fromDraft (toDraft method) = method := by cases method; rfl

theorem toDraft_fromDraft (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) :
    toDraft (fromDraft method) = method := by cases method; rfl

def methodEquiv : RiemannFieldFluxMethod law Result Information ≃
    ReturnedRiemannDraft.FieldFluxMethod law Result Information where
  toFun := toDraft
  invFun := fromDraft
  left_inv := fromDraft_toDraft
  right_inv := toDraft_fromDraft

'''
fields=[
 ('domain','','domain','domain'),
 ('solve',' (problem : HyperbolicRiemannProblem law) (h : method.domain problem)','solve problem h','solve problem h'),
 ('field',' {problem : HyperbolicRiemannProblem law} (result : Result problem) (x t : ℝ)','field result x t','field result x t'),
 ('initial',' {problem : HyperbolicRiemannProblem law} (result : Result problem)','initial result','initial result'),
 ('trace_integrable',' {problem : HyperbolicRiemannProblem law} (result : Result problem) (s t : ℝ)','trace_integrable result s t','trace_integrable result s t'),
 ('extract',' {problem : HyperbolicRiemannProblem law} (result : Result problem)','extract result','extract result'),
 ('numericalFlux',' (info : Information)','numericalFlux info','numericalFlux info'),
 ('constants_in_domain',' (state : Fin m → ℝ)','constants_in_domain state','constants_in_domain state'),
 ('consistent',' (state : Fin m → ℝ)','consistent state','consistent state')]
for conv,typ in [('toDraft','RiemannFieldFluxMethod'),('fromDraft','ReturnedRiemannDraft.FieldFluxMethod')]:
 for name,args,lhs,rhs in fields:
  out+=f'theorem {conv}_{name} (method : {typ} law Result Information){args} :\n    ({conv} method).{lhs} = method.{rhs} := rfl\n\n'
out+='''theorem toDraft_interfaceFlux (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    ReturnedRiemannDraft.interfaceFlux (toDraft method) old hdomain j =
      RiemannFieldFluxMethod.interfaceFlux method old hdomain j := rfl

theorem fromDraft_interfaceFlux (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    RiemannFieldFluxMethod.interfaceFlux (fromDraft method) old hdomain j =
      ReturnedRiemannDraft.interfaceFlux method old hdomain j := rfl

theorem toDraft_ofExact (method : RectangleRiemannInterfaceFluxMethod law Information) :
    toDraft (RiemannFieldFluxMethod.ofExact method) = ReturnedRiemannDraft.ofExact method := rfl

theorem fromDraft_ofExact (method : RectangleRiemannInterfaceFluxMethod law Information) :
    fromDraft (ReturnedRiemannDraft.ofExact method) = RiemannFieldFluxMethod.ofExact method := rfl

theorem ofExact_returnedField_commutes
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (problem : HyperbolicRiemannProblem law) (h : method.domain problem) :
    (toDraft (RiemannFieldFluxMethod.ofExact method)).field
      ((toDraft (RiemannFieldFluxMethod.ofExact method)).solve problem h) =
        (method.solve problem h).solution := rfl

'''
# These two bridges have exactly the old theorem types. The proof uses the new
# theorem after nominal conversion; no type DefEq is claimed for method inputs.
for name,next_marker,proof in [
 ('interface_error_le','/-- Error propagation','RiemannFieldFluxMethod.interface_error_le grid (fromDraft method) hq old hdomain hdt j hn he'),
 ('update_error_le','namespace Witness','RiemannFieldFluxMethod.update_error_le grid (fromDraft method) hq old hdomain hdt i a b hold hn he')]:
 block=t[t.index('theorem '+name):t.index(next_marker)]
 header=block.split(' :=',1)[0]
 header=header.replace('theorem '+name,'theorem '+name+'_fromDraft')
 out+=header+' :=\n  '+proof+'\n\n'
 out+=f'theorem {name}_type_comparison :\n    @{name}_fromDraft = @ReturnedRiemannDraft.{name} := rfl\n\n'
out+='''theorem stationary_method_commutes :
    toDraft (StationaryRiemannField.method (m := m)) =
      ReturnedRiemannDraft.Witness.method (m := m) := rfl

-- Here the types themselves are definitionally equal (concrete method
-- projections reduce); equality of theorem values additionally uses Lean's
-- proof irrelevance. This is not a claim of nominal structure identity.
'''
identities=[]
for x in mp['declaration_map']:
 old,new=x['draft'],x['canonical']
 if new is None or old.endswith(('.FieldFluxMethod','.interfaceFlux','.ofExact','.interface_error_le','.update_error_le','.Witness.method')):continue
 name='identity_'+str(len(identities)+1).zfill(2)
 out+=f'theorem {name} : @{old} = @{new} := rfl\n\n'
 identities.append(dict(check=name,draft=old,canonical=new))
out+='end NumStability.ReturnedFieldPlacementChecks\n\n'
decls=re.findall(r'^(?:noncomputable )?(?:def|theorem)\s+(\w+)',out,re.M)
out+='\n'.join(f'#check NumStability.ReturnedFieldPlacementChecks.{x}\n#print axioms NumStability.ReturnedFieldPlacementChecks.{x}' for x in decls)+'\n'
p.write_bytes(out.encode('utf-8'))
(P/'comparison-plan.json').write_bytes((json.dumps(dict(structure_policy='nominally distinct; explicit nine-field equivalence and round trips',projection_preservation_checks=18,conditional_estimate_bridges=2,identities=identities,checked_declarations=['NumStability.ReturnedFieldPlacementChecks.'+x for x in decls]),indent=2)+'\n').encode())
print(json.dumps(dict(comparison_declarations=len(decls),valid_type_identities=len(identities))))
