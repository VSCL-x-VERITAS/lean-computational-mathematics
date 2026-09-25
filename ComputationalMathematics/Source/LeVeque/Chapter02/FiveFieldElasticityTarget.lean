/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FiveFieldElasticityModel

/-! Proof-free target for C2.U.082, with Chapter 22 source cross-reference. -/
namespace NumStability.Leveque02Tracer.PlaneElasticity

/-- Proof-free target for full directional real hyperbolicity.
The assumptions match the positive P/S speed conditions stated around
equations (2.89), (2.90), and (2.94). -/
def directionalHyperbolicityTarget : Prop :=
  ∀ lam mu rho nx ny : ℝ,
    0 < rho → 0 < mu → 0 < lam + 2 * mu →
    NumStability.IsRealHyperbolicMatrix
      (directionalSymbol lam mu rho nx ny)

/-- Proof-free combined target for the two-dimensional five-field strain model,
its coordinate coupling, the x-only P/S restriction, and its real spectrum.
Chapter 2 prints the one-dimensional formulas and identifies the five-field
general system. Chapter 22 prints the stress-velocity equations (22.31) and
normal constitutive relations (22.33)–(22.34); the strain-state symbols here
are derived from those printed equations and the symmetric-strain kinematics. -/
def fiveFieldElasticityTarget : Prop :=
  (∀ lam mu : ℝ, ∀ e : Fin 3 → ℝ,
    isotropicStress lam mu e 0 0 =
        (lam + 2 * mu) * e 0 + lam * e 1 ∧
    isotropicStress lam mu e 0 1 = 2 * mu * e 2 ∧
    isotropicStress lam mu e 1 0 = 2 * mu * e 2 ∧
    isotropicStress lam mu e 1 1 =
        lam * e 0 + (lam + 2 * mu) * e 1) ∧
  (∀ (q : ℝ → ℝ → ℝ → (Fin 5 → ℝ))
      (lam mu rho x y t : ℝ), 0 < rho →
    (IsSolutionAt q lam mu rho x y t ↔
      IsComponentSystemAt q lam mu rho x y t)) ∧
  (∀ lam mu rho : ℝ, 0 < rho → 0 < mu →
    xSymbol lam mu rho 4 2 ≠ 0 ∧
    ySymbol lam mu rho 3 2 ≠ 0 ∧
    ySymbol lam mu rho 1 4 ≠ 0) ∧
  (∀ (p s : ℝ → ℝ → (Fin 2 → ℝ))
      (lam mu rho x y t : ℝ),
    0 < rho → 0 < mu → 0 < lam + 2 * mu →
    (IsSolutionAt
        (fun x _ t => planeState (p x t) (s x t))
        lam mu rho x y t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
          p (pWaveCoefficientMatrix lam mu rho) x t ∧
        NumStability.IsConstantCoefficientLinearSystemSolutionAt
          s (shearWaveCoefficientMatrix mu rho) x t)) ∧
  directionalHyperbolicityTarget

/-- Proof-free cross-reference to Chapter 22. Equation (22.31) prints the
coupled five stress/velocity equations. Equations (22.33)–(22.34) give the
normal stress/strain map, and (22.43)–(22.44) print the x-only P/S systems.
The strain-state symbols intertwine with these equations through the
constitutive map. This does not assert that the map is invertible for every
allowed Lamé pair. -/
def stressChapter22Target : Prop :=
  (∀ (q : ℝ → ℝ → ℝ → (Fin 5 → ℝ))
      (lam mu rho x y t : ℝ), 0 < rho →
    (IsStressMatrixSolutionAt q lam mu rho x y t ↔
      IsStressComponentSolutionAt q lam mu rho x y t)) ∧
  (∀ lam mu rho : ℝ, ∀ q : Fin 5 → ℝ,
    (stressXSymbol lam mu rho).mulVec (stressOfStrain lam mu q) =
      stressOfStrain lam mu ((xSymbol lam mu rho).mulVec q) ∧
    (stressYSymbol lam mu rho).mulVec (stressOfStrain lam mu q) =
      stressOfStrain lam mu ((ySymbol lam mu rho).mulVec q)) ∧
  (∀ lam mu : ℝ, ∀ p s : Fin 2 → ℝ,
    stressOfStrain lam mu (planeState p s) =
      ![(lam + 2 * mu) * p 0, lam * p 0,
        2 * mu * s 0, p 1, s 1]) ∧
  (∀ lam mu rho : ℝ, ∀ p s : Fin 2 → ℝ,
    (pWaveStressVelocityMatrix lam mu rho).mulVec
        (pStressPair lam mu p) =
      pStressPair lam mu
        ((pWaveCoefficientMatrix lam mu rho).mulVec p) ∧
    (shearWaveStressVelocityMatrix mu rho).mulVec
        (sStressPair mu s) =
      sStressPair mu
        ((shearWaveCoefficientMatrix mu rho).mulVec s))

/-- Printed Chapter 22 stress-state consequences. The eigenvalue list is
`0, ±cp, ±cs` with direction-scaled P/S speeds. Explicitly requiring an
independent eigenfamily covers coincident P/S speeds. -/
def stressPrintedClaimsTarget : Prop :=
  (∀ (p s : ℝ → ℝ → (Fin 2 → ℝ))
      (lam mu rho x y t : ℝ),
    0 < rho → 0 < mu → 0 < lam + 2 * mu →
    (IsStressMatrixSolutionAt
        (fun x _ t => stressPlaneState lam mu (p x t) (s x t))
        lam mu rho x y t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        p (pWaveStressVelocityMatrix lam mu rho) x t ∧
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        s (shearWaveStressVelocityMatrix mu rho) x t)) ∧
  (∀ lam mu rho nx ny : ℝ,
    0 < rho → 0 < mu → 0 < lam + 2 * mu →
    nx ≠ 0 ∨ ny ≠ 0 →
    let cp := Real.sqrt (((lam + 2 * mu) / rho) *
      (nx ^ 2 + ny ^ 2))
    let cs := Real.sqrt ((mu / rho) * (nx ^ 2 + ny ^ 2))
    ∃ evec : Fin 5 → (Fin 5 → ℝ),
      LinearIndependent ℝ evec ∧
      ∀ i, (stressDirectionalSymbol lam mu rho nx ny).mulVec (evec i) =
        (![0, cp, -cp, cs, -cs] : Fin 5 → ℝ) i • evec i) ∧
  (∀ lam mu rho nx ny : ℝ,
    0 < rho → 0 < mu → 0 < lam + 2 * mu →
    NumStability.IsRealHyperbolicMatrix
      (stressDirectionalSymbol lam mu rho nx ny))

/-- Joint Chapter 2 and Chapter 22 source-contract target. -/
def chapter22CrossReferencedTarget : Prop :=
  fiveFieldElasticityTarget ∧ stressChapter22Target ∧
    stressPrintedClaimsTarget

end NumStability.Leveque02Tracer.PlaneElasticity
