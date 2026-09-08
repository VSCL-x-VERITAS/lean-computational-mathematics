"""Generate explicit nominal transports and exact applicable type comparisons."""
from pathlib import Path
from hashlib import sha256
import json
import re

HERE=Path(__file__).resolve().parent
SESSION=HERE.parent
DRAFT=SESSION/'riemann-information-only-method-draft'
target=HERE/'Comparisons.lean.fragment'
assert not target.exists(), 'append-only comparison source'
out='''namespace NumStability.InformationMethodPlacementChecks

open InformationOnlyRiemannDraft InformationOnlyRiemannDraft.Method

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

-- Explicit maps preserve all six fields. The structure types are nominally distinct.
def fromDraft (method : InformationOnlyRiemannDraft.Method law Result Information) :
    RiemannInformationFluxMethod law Result Information where
  domain := method.domain
  solve := method.solve
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

def toDraft (method : RiemannInformationFluxMethod law Result Information) :
    InformationOnlyRiemannDraft.Method law Result Information where
  domain := method.domain
  solve := method.solve
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

theorem fromDraft_toDraft (method : RiemannInformationFluxMethod law Result Information) :
    fromDraft (toDraft method) = method := by cases method; rfl

theorem toDraft_fromDraft (method : InformationOnlyRiemannDraft.Method law Result Information) :
    toDraft (fromDraft method) = method := by cases method; rfl

def methodEquiv : InformationOnlyRiemannDraft.Method law Result Information ≃
    RiemannInformationFluxMethod law Result Information where
  toFun := fromDraft
  invFun := toDraft
  left_inv := toDraft_fromDraft
  right_inv := fromDraft_toDraft

theorem fromDraft_fields (method : InformationOnlyRiemannDraft.Method law Result Information) :
    (fromDraft method).domain = method.domain ∧
    (fromDraft method).solve = method.solve ∧
    (fromDraft method).extract = method.extract ∧
    (fromDraft method).numericalFlux = method.numericalFlux ∧
    (fromDraft method).constants_in_domain = method.constants_in_domain ∧
    (fromDraft method).consistent = method.consistent := ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

theorem toDraft_fields (method : RiemannInformationFluxMethod law Result Information) :
    (toDraft method).domain = method.domain ∧
    (toDraft method).solve = method.solve ∧
    (toDraft method).extract = method.extract ∧
    (toDraft method).numericalFlux = method.numericalFlux ∧
    (toDraft method).constants_in_domain = method.constants_in_domain ∧
    (toDraft method).consistent = method.consistent := ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

theorem selectedResult_fromDraft (method : InformationOnlyRiemannDraft.Method law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    RiemannInformationFluxMethod.selectedResult (fromDraft method) old hdomain j =
      InformationOnlyRiemannDraft.Method.selectedResult method old hdomain j := rfl

theorem selectedResult_toDraft (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    InformationOnlyRiemannDraft.Method.selectedResult (toDraft method) old hdomain j =
      RiemannInformationFluxMethod.selectedResult method old hdomain j := rfl

theorem interfaceFlux_fromDraft (method : InformationOnlyRiemannDraft.Method law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    RiemannInformationFluxMethod.interfaceFlux (fromDraft method) old hdomain j =
      InformationOnlyRiemannDraft.Method.interfaceFlux method old hdomain j := rfl

theorem interfaceFlux_toDraft (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    InformationOnlyRiemannDraft.Method.interfaceFlux (toDraft method) old hdomain j =
      RiemannInformationFluxMethod.interfaceFlux method old hdomain j := rfl

theorem ofField_fromDraft (method : RiemannFieldFluxMethod law Result Information) :
    fromDraft (InformationOnlyRiemannDraft.Method.ofField method) =
      RiemannInformationFluxMethod.ofField method := rfl

theorem ofField_toDraft (method : RiemannFieldFluxMethod law Result Information) :
    toDraft (RiemannInformationFluxMethod.ofField method) =
      InformationOnlyRiemannDraft.Method.ofField method := rfl

-- Explicit maps preserve all four result fields, including both indexing facts.
def resultFromDraft {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) :
    LeftStateInformationFlux.OrderedResult problem where
  left := result.left
  right := result.right
  left_eq := result.left_eq
  right_eq := result.right_eq

def resultToDraft {problem : HyperbolicRiemannProblem law}
    (result : LeftStateInformationFlux.OrderedResult problem) :
    InformationOnlyRiemannDraft.Witness.OrderedResult problem where
  left := result.left
  right := result.right
  left_eq := result.left_eq
  right_eq := result.right_eq

theorem resultFromDraft_toDraft {problem : HyperbolicRiemannProblem law}
    (result : LeftStateInformationFlux.OrderedResult problem) :
    resultFromDraft (resultToDraft result) = result := by cases result; rfl

theorem resultToDraft_fromDraft {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) :
    resultToDraft (resultFromDraft result) = result := by cases result; rfl

def resultEquiv (problem : HyperbolicRiemannProblem law) :
    InformationOnlyRiemannDraft.Witness.OrderedResult problem ≃
      LeftStateInformationFlux.OrderedResult problem where
  toFun := resultFromDraft
  invFun := resultToDraft
  left_inv := resultToDraft_fromDraft
  right_inv := resultFromDraft_toDraft

theorem resultFromDraft_fields {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) :
    (resultFromDraft result).left = result.left ∧
    (resultFromDraft result).right = result.right ∧
    (resultFromDraft result).left_eq = result.left_eq ∧
    (resultFromDraft result).right_eq = result.right_eq := ⟨rfl, rfl, rfl, rfl⟩

theorem resultToDraft_fields {problem : HyperbolicRiemannProblem law}
    (result : LeftStateInformationFlux.OrderedResult problem) :
    (resultToDraft result).left = result.left ∧
    (resultToDraft result).right = result.right ∧
    (resultToDraft result).left_eq = result.left_eq ∧
    (resultToDraft result).right_eq = result.right_eq := ⟨rfl, rfl, rfl, rfl⟩

-- The example changes both nominal types; transport its result as well as its method.
def witnessFromDraft (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    RiemannInformationFluxMethod law LeftStateInformationFlux.OrderedResult
      ((Fin m → ℝ) × (Fin m → ℝ)) where
  domain := (InformationOnlyRiemannDraft.Witness.method law).domain
  solve := fun problem h => resultFromDraft ((InformationOnlyRiemannDraft.Witness.method law).solve problem h)
  extract := fun result => (InformationOnlyRiemannDraft.Witness.method law).extract (resultToDraft result)
  numericalFlux := (InformationOnlyRiemannDraft.Witness.method law).numericalFlux
  constants_in_domain := (InformationOnlyRiemannDraft.Witness.method law).constants_in_domain
  consistent := fun _ => rfl

def witnessToDraft (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    InformationOnlyRiemannDraft.Method law InformationOnlyRiemannDraft.Witness.OrderedResult
      ((Fin m → ℝ) × (Fin m → ℝ)) where
  domain := (LeftStateInformationFlux.method law).domain
  solve := fun problem h => resultToDraft ((LeftStateInformationFlux.method law).solve problem h)
  extract := fun result => (LeftStateInformationFlux.method law).extract (resultFromDraft result)
  numericalFlux := (LeftStateInformationFlux.method law).numericalFlux
  constants_in_domain := (LeftStateInformationFlux.method law).constants_in_domain
  consistent := fun _ => rfl

theorem witnessFromDraft_eq (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    witnessFromDraft law = LeftStateInformationFlux.method law := rfl

theorem witnessToDraft_eq (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    witnessToDraft law = InformationOnlyRiemannDraft.Witness.method law := rfl

theorem witness_selectedResult_commutes (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (old : ℤ → Fin m → ℝ) (j : ℤ) :
    resultFromDraft (InformationOnlyRiemannDraft.Method.selectedResult
      (InformationOnlyRiemannDraft.Witness.method law) old (fun _ => trivial) j) =
    RiemannInformationFluxMethod.selectedResult (LeftStateInformationFlux.method law)
      old (fun _ => trivial) j := rfl

theorem witness_extract_commutes {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) :
    (LeftStateInformationFlux.method law).extract (resultFromDraft result) =
      (InformationOnlyRiemannDraft.Witness.method law).extract result := rfl

theorem witness_localTrace_commutes {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) (τ : ℝ) :
    LeftStateInformationFlux.localTrace (resultFromDraft result) τ =
      InformationOnlyRiemannDraft.Witness.localTrace result τ := rfl

theorem witness_interfaceFlux_commutes (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (old : ℤ → Fin m → ℝ) (j : ℤ) :
    RiemannInformationFluxMethod.interfaceFlux (LeftStateInformationFlux.method law)
      old (fun _ => trivial) j = InformationOnlyRiemannDraft.Method.interfaceFlux
        (InformationOnlyRiemannDraft.Witness.method law) old (fun _ => trivial) j := rfl

'''
bridges=[]
specs=[
 ('Core','interface_execution',' :=\n','RiemannInformationFluxMethod.interface_execution (fromDraft method) old hdomain j','Method'),
 ('Core','interfaceFlux_constant',' := by\n','RiemannInformationFluxMethod.interfaceFlux_constant (fromDraft method) state hdomain j','Method'),
 ('Accuracy','interface_error_le',' :=\n','RiemannInformationFluxMethod.interface_error_le grid (fromDraft method) old hdomain hst j localTrace hl hp hn he','Method'),
 ('Accuracy','update_error_le',' := by\n','RiemannInformationFluxMethod.update_error_le grid (fromDraft method) old hdomain hq hst i localTrace hold hl hr hnl hel hnr her','Method'),
 ('Examples','localTrace_integrable',' := intervalIntegrable_const','LeftStateInformationFlux.localTrace_integrable (resultFromDraft result) s t','Witness'),
 ('Examples','extraction_eq_localTrace',' := rfl','LeftStateInformationFlux.extraction_eq_localTrace (resultFromDraft result) τ','Witness'),
 ('Examples','localTrace_eq_transport_reference',' := by\n','LeftStateInformationFlux.localTrace_eq_transport_reference (resultFromDraft result) hτ','Witness'),
]
for file,name,separator,proof,ns in specs:
    text=(DRAFT/(file+'.lean.fragment')).read_text(encoding='utf-8')
    block=text[text.index('theorem '+name):]
    header=block[:block.index(separator)]
    if ns=='Witness' and 'open InformationOnlyRiemannDraft.Witness\n' not in out:
        out+='open InformationOnlyRiemannDraft.Witness\n\n'
    newname=name+'_fromDraft'
    out+=header.replace('theorem '+name,'theorem '+newname,1)+' :=\n  '+proof+'\n\n'
    old='NumStability.InformationOnlyRiemannDraft.'+ns+'.'+name
    out+=f'theorem {name}_type_comparison : @{newname} = @{old} := rfl\n\n'
    bridges.append(dict(name=newname,draft=old,producer=proof))
identities=[
 ('Method.ofField_solve','RiemannInformationFluxMethod.ofField_solve'),
 ('Method.ofField_extract','RiemannInformationFluxMethod.ofField_extract'),
 ('Method.ofField_numericalFlux','RiemannInformationFluxMethod.ofField_numericalFlux'),
 ('Method.ofField_interfaceFlux','RiemannInformationFluxMethod.ofField_interfaceFlux'),
 ('Method.ofField_finite_trace_integrable','RiemannInformationFluxMethod.ofField_finite_trace_integrable'),
 ('Witness.selected_pair','LeftStateInformationFlux.selected_pair'),
 ('Witness.selected_flux','LeftStateInformationFlux.selected_flux'),
 ('Witness.concrete_information_only','LeftStateInformationFlux.concrete_information_only'),
 ('Witness.selected_flux_eq_reference_average','LeftStateInformationFlux.selected_flux_eq_reference_average'),
 ('Witness.existing_field_embedding','LeftStateInformationFlux.existing_field_embedding'),
]
for index,(old,new) in enumerate(identities,1):
    out+=f'theorem exact_type_{index:02} : @NumStability.InformationOnlyRiemannDraft.{old} = @NumStability.{new} := rfl\n\n'
out+='end NumStability.InformationMethodPlacementChecks\n\n'
names=re.findall(r'^(?:def|theorem)\s+(\w+)',out,re.M)
out+='\n'.join(f'#check NumStability.InformationMethodPlacementChecks.{name}\n#print axioms NumStability.InformationMethodPlacementChecks.{name}' for name in names)+'\n'
target.write_text(out,encoding='utf-8',newline='\n')
plan=dict(nominal_maps=['six Method fields in both directions','four OrderedResult fields in both directions'],
          round_trips=4,structural_equivalences=2,nominal_theorem_bridges=bridges,
          exact_unaffected_type_comparisons=identities,
          checked_declarations=['NumStability.InformationMethodPlacementChecks.'+x for x in names],
          checked_declaration_count=len(names),source_sha256=sha256(target.read_bytes()).hexdigest(),
          policy='No nominal DefEq claim; equal theorem values are checked only at definitionally equal proposition types, using proof irrelevance.')
(HERE/'comparison-plan.json').write_text(json.dumps(plan,indent=2)+'\n',encoding='utf-8',newline='\n')
print(json.dumps(dict(fragment=str(target),sha256=sha256(target.read_bytes()).hexdigest(),comparisons=len(names))))
