"""Add thin source correspondence wrappers over checked mathematical producers."""
from pathlib import Path
import hashlib, json
SESSION=Path(__file__).resolve().parent
ROOT=SESSION.parents[3]
PREFIX="ComputationalMathematics/Source/LeVeque/Chapter01/"
records=[]
def write(leaf,imports,title,page,body):
    p=ROOT/(PREFIX+leaf+".lean")
    if p.exists():raise ValueError(f"existing owner {p}")
    text="/-\nSPDX-License-Identifier: MIT\n-/\n\n"
    text+="\n".join("import "+i for i in sorted(set(imports)))+"\n\n"
    text+="/-!\n# LeVeque Chapter 1, "+title+"\n\n"
    text+="Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,\nprinted page "+page+".\n-/\n\n"+body.strip()+"\n"
    p.write_bytes(text.encode())
    records.append({"path":p.relative_to(ROOT).as_posix(),"sha256":hashlib.sha256(text.encode()).hexdigest()})

write("FluxJacobianHyperbolicity",
["ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.Hyperbolicity"],
"flux Jacobian hyperbolicity","3 (raw PDF page 25)",r"""
namespace NumStability

/-- The flux is hyperbolic at a state exactly when its actual Jacobian admits
a complete independent real eigenvector family. Repeated eigenvalues are allowed. -/
theorem leveque01_fluxJacobian_hyperbolicity_iff {m : ℕ}
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (state : Fin m → ℝ)
    (derivative : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (hderivative : HasFDerivAt flux derivative state) :
    IsHyperbolicFluxAt flux state ↔
      ∃ (eigenvalues : Fin m → ℝ) (eigenvectors : Fin m → (Fin m → ℝ)),
        LinearIndependent ℝ eigenvectors ∧
          ∀ p, derivative (eigenvectors p) = eigenvalues p • eigenvectors p :=
  isHyperbolicFluxAt_iff_independent_real_eigenvectors flux state derivative hderivative

end NumStability
""")

write("RiemannInitialConfiguration",
["ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann"],
"Riemann initial-value configuration","5 (raw PDF page 27)",r"""
namespace NumStability

/-- Add the displayed two-state data to the selected hyperbolic evolution
equation. The equation is an independent predicate, so this definition retains
its solution convention and does not assert existence or choose a solver.
The same data construction is available for any equation predicate. -/
abbrev leveque01RiemannInitialConfiguration {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) : Prop :=
  IsRiemannInitialValueSolution evolutionEquation leftState rightState q

/-- A Riemann configuration is precisely the chosen equation together with
the left and right initial states. No origin value is prescribed. -/
theorem leveque01_riemannInitialConfiguration_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧
        (∀ x, x < 0 → q x 0 = leftState) ∧
        (∀ x, 0 < x → q x 0 = rightState) :=
  isRiemannInitialValueSolution_iff evolutionEquation leftState rightState q

end NumStability
""")

write("MaterialInterfaceRiemannData",
["ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann"],
"material-interface Riemann data","8 (raw PDF page 30)",r"""
namespace NumStability

/-- Joint medium/state Riemann data is exactly the componentwise two-state
data at the same interface. This statement supplies no reflection or transmission dynamics. -/
theorem leveque01_materialInterfaceRiemannData_iff {Material State : Type*}
    (medium : ℝ → Material) (initialState : ℝ → State)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) :
    IsRiemannData (fun x => (medium x, initialState x))
        (leftMaterial, leftState) (rightMaterial, rightState) ↔
      IsRiemannData medium leftMaterial rightMaterial ∧
        IsRiemannData initialState leftState rightState :=
  isRiemannData_prod_iff medium initialState leftMaterial rightMaterial leftState rightState

/-- Independently chosen origin values remain free in the paired construction. -/
theorem leveque01_materialInterfaceRiemannData_pair {Material State : Type*}
    (leftMaterial originMaterial rightMaterial : Material)
    (leftState originState rightState : State) :
    (fun x => (riemannData leftMaterial originMaterial rightMaterial x,
      riemannData leftState originState rightState x)) =
      riemannData (leftMaterial, leftState) (originMaterial, originState)
        (rightMaterial, rightState) :=
  riemannData_prod leftMaterial originMaterial rightMaterial leftState originState rightState

end NumStability
""")

write("LinearRiemannEigensolution",
["ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution"],
"linear Riemann solution in an eigenbasis","5 (raw PDF page 27), continuing on printed page 6 (raw PDF page 28)",r"""
namespace NumStability

/-- A real hyperbolic matrix gives a Riemann solution by finite eigenmode
superposition. Conservation is the time-integrated rectangle balance, and the
origin value is independently selected. -/
theorem leveque01_linearRiemann_eigensolution
    {ι : Type*} [Fintype ι] {coefficient : Matrix ι ι ℝ}
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (leftState valueAtOrigin rightState : ι → ℝ) :
    ∃ q : ℝ → ℝ → (ι → ℝ),
      IsRectangleConservationLawSolution q coefficient.mulVec ∧
      (∀ x, q x 0 = riemannData leftState valueAtOrigin rightState x) ∧
      (∀ x t, 0 < t → q x t = q (x / t) 1) :=
  hcoefficient.exists_rectangle_riemann_solution leftState valueAtOrigin rightState

end NumStability
""")

write("RiemannRayZero",
["ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity",
 "ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration"],
"the selected Riemann value on ray zero","11 (raw PDF page 33)",r"""
namespace NumStability

/-- Ray-zero value for an independently selected Riemann similarity solution.
Its time-one profile determines the trace convention. -/
abbrev leveque01RiemannRayZeroValue {State : Type*}
    (q : ℝ → ℝ → State) : State :=
  similarityRayValue q 0

/-- The notation denotes the value on the entire positive-time ray x/t=0.
Initial data and the evolution equation are retained for the selected field;
uniqueness between different selected fields is not a premise or conclusion. -/
theorem leveque01_riemannRayZeroValue_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State)
    (_hriemann : leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q)
    (hself : IsPositiveTimeSelfSimilar q) (value : State) :
    leveque01RiemannRayZeroValue q = value ↔ ∀ t, 0 < t → q 0 t = value := by
  simpa only [leveque01RiemannRayZeroValue, zero_mul] using hself.rayValue_iff 0 value

end NumStability
""")

write("NonconservationSourceTerms",
["ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw.BalanceLaw"],
"source terms for nonconserved contaminant mass","4 (raw PDF page 26)",r"""
open MeasureTheory

namespace NumStability

/-- Under classical differentiation and integrability hypotheses, a mass rate
different from boundary transport requires a nonzero internal source. The scalar
contaminant is represented in one component and the transport speed is constant. -/
theorem leveque01_nonconservation_requires_sourceTerm
    (q : ℝ → ℝ → (Fin 1 → ℝ)) (speed : ℝ)
    (qt qx : ℝ → (Fin 1 → ℝ)) (a b t : ℝ) (massRate : Fin 1 → ℝ)
    (hqt : ∀ x, HasDerivAt (fun τ => q x τ) (qt x) t)
    (hqx : ∀ x, HasDerivAt (fun ξ => q ξ t) (qx x) x)
    (hqtIntegrable : IntervalIntegrable qt volume a b)
    (hqxIntegrable : IntervalIntegrable qx volume a b)
    (hmassRate : HasDerivAt (fun τ => ∫ x in a..b, q x τ) massRate t)
    (hinterchange : HasDerivAt (fun τ => ∫ x in a..b, q x τ) (∫ x in a..b, qt x) t)
    (hdefect : massRate ≠ speed • q a t - speed • q b t) :
    ∃ production : ℝ → (Fin 1 → ℝ),
      (∀ x, IsBalanceLawSolutionAt q (fun state => speed • state) (production x) x t) ∧
      IntervalIntegrable production volume a b ∧
      (∫ x in a..b, production x) = massRate - (speed • q a t - speed • q b t) ∧
      production ≠ 0 ∧ ¬ (∀ x, IsConservationLawSolutionAt q (fun state => speed • state) x t) :=
  nonconservation_requires_nonzero_source q (fun state => speed • state) qt
    (fun x => speed • qx x) a b t massRate hqt
    (fun x => (hqx x).const_smul speed) hqtIntegrable (hqxIntegrable.smul speed)
    hmassRate hinterchange hdefect

/-- Unit production with zero transport provides an actual application:
the mass of a unit cell changes and the source has a nonzero integral. -/
theorem leveque01_sourceTerm_unitProduction (t : ℝ) :
    (∀ x, IsBalanceLawSolutionAt
      (fun (_x : ℝ) (τ : ℝ) (_i : Fin 1) => τ)
      (fun (_state : Fin 1 → ℝ) => 0) (fun _ => 1) x t) ∧
    HasDerivAt (fun τ => ∫ _x in (0 : ℝ)..1, (fun _i : Fin 1 => τ))
      (fun _ => 1) t ∧
    (∫ _x in (0 : ℝ)..1, (fun _i : Fin 1 => (1 : ℝ))) ≠ 0 :=
  uniform_unit_production_nonvacuity t

end NumStability
""")

receipt=SESSION/"production-placement-source.json"
if receipt.exists():raise ValueError("receipt exists")
receipt.write_text(json.dumps({"schema":1,"files":records,"verification":"pending production build and source audits"},indent=2)+"\n",encoding="utf-8")
print(json.dumps({"placed":len(records),"paths":[r["path"] for r in records]},indent=2))

