/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveCoefficientModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveCoefficientModel
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveStressVelocityModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveStressVelocityModel
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import Mathlib.Tactic

/-! Model declarations for C2.U.082, cross-referenced to Chapter 22. -/
namespace NumStability.Leveque02Tracer.PlaneElasticity

/-- Five-field stress symbol in the first spatial direction. -/
noncomputable def xSymbol (lam mu rho : ℝ) : Matrix (Fin 5) (Fin 5) ℝ :=
  !![0, 0, 0, -1, 0;
     0, 0, 0, 0, 0;
     0, 0, 0, 0, -(1 / 2 : ℝ);
     -((lam + 2 * mu) / rho), -(lam / rho), 0, 0, 0;
     0, 0, -(2 * mu / rho), 0, 0]

/-- Five-field stress symbol in the second spatial direction. -/
noncomputable def ySymbol (lam mu rho : ℝ) : Matrix (Fin 5) (Fin 5) ℝ :=
  !![0, 0, 0, 0, 0;
     0, 0, 0, 0, -1;
     0, 0, 0, -(1 / 2 : ℝ), 0;
     0, 0, -(2 * mu / rho), 0, 0;
     -(lam / rho), -((lam + 2 * mu) / rho), 0, 0, 0]

/-- Directional symbol formed from the two spatial stress symbols. -/
noncomputable def directionalSymbol (lam mu rho nx ny : ℝ) :
    Matrix (Fin 5) (Fin 5) ℝ :=
  nx • xSymbol lam mu rho + ny • ySymbol lam mu rho

/-- A pointwise constant-coefficient 2D first-order system. -/
def IsSolutionAt (q : ℝ → ℝ → ℝ → (Fin 5 → ℝ))
    (lam mu rho x y t : ℝ) : Prop :=
  ∃ qt qx qy : Fin 5 → ℝ,
    HasDerivAt (fun τ => q x y τ) qt t ∧
    HasDerivAt (fun ξ => q ξ y t) qx x ∧
    HasDerivAt (fun η => q x η t) qy y ∧
    qt + (xSymbol lam mu rho).mulVec qx +
      (ySymbol lam mu rho).mulVec qy = 0

/-- The three planar symmetric-strain coordinates of a five-field state. -/
def strainPart (q : Fin 5 → ℝ) : Fin 3 → ℝ :=
  ![q 0, q 1, q 2]

/-- The standard isotropic linear Hooke relation on the three planar strain
coordinates. Chapter 2 prints its x-only specializations (2.89)–(2.90)
and identifies the full three-stress/two-velocity system on raw p. 63.
Chapter 22 prints the two normal relations (22.33)–(22.34). -/
noncomputable def isotropicStress (lam mu : ℝ) (e : Fin 3 → ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![(lam + 2 * mu) * e 0 + lam * e 1, 2 * mu * e 2;
     2 * mu * e 2, lam * e 0 + (lam + 2 * mu) * e 1]

/-- The five scalar laws: two normal kinematics, symmetric shear
kinematics, and two momentum balances using the isotropic stress. -/
def ComponentEquations (lam mu rho : ℝ)
    (qt qx qy : Fin 5 → ℝ) : Prop :=
  qt 0 - qx 3 = 0 ∧
  qt 1 - qy 4 = 0 ∧
  qt 2 - (qx 4 + qy 3) / 2 = 0 ∧
  rho * qt 3 -
    isotropicStress lam mu (strainPart qx) 0 0 -
    isotropicStress lam mu (strainPart qy) 0 1 = 0 ∧
  rho * qt 4 -
    isotropicStress lam mu (strainPart qx) 1 0 -
    isotropicStress lam mu (strainPart qy) 1 1 = 0

/-- Pointwise PDE with precisely the component laws above. -/
def IsComponentSystemAt (q : ℝ → ℝ → ℝ → (Fin 5 → ℝ))
    (lam mu rho x y t : ℝ) : Prop :=
  ∃ qt qx qy : Fin 5 → ℝ,
    HasDerivAt (fun τ => q x y τ) qt t ∧
    HasDerivAt (fun ξ => q ξ y t) qx x ∧
    HasDerivAt (fun η => q x η t) qy y ∧
    ComponentEquations lam mu rho qt qx qy

/-- Five-field stress state assembled from pressure and shear components. -/
def planeState (p s : Fin 2 → ℝ) : Fin 5 → ℝ :=
  ![p 0, 0, s 0, p 1, s 1]

/-! ## Source-exact Chapter 22 stress representation -/

/-- Coefficient of the x derivative in LeVeque (22.31), with state order
`(σ11, σ22, σ12, u, v)`. -/
noncomputable def stressXSymbol (lam mu rho : ℝ) :
    Matrix (Fin 5) (Fin 5) ℝ :=
  !![0, 0, 0, -(lam + 2 * mu), 0;
     0, 0, 0, -lam, 0;
     0, 0, 0, 0, -mu;
     -(1 / rho), 0, 0, 0, 0;
     0, 0, -(1 / rho), 0, 0]

/-- Coefficient of the y derivative in LeVeque (22.31). -/
noncomputable def stressYSymbol (lam mu rho : ℝ) :
    Matrix (Fin 5) (Fin 5) ℝ :=
  !![0, 0, 0, 0, -lam;
     0, 0, 0, 0, -(lam + 2 * mu);
     0, 0, 0, -mu, 0;
     0, 0, -(1 / rho), 0, 0;
     0, -(1 / rho), 0, 0, 0]

/-- Chapter 22's directional stress symbol (22.39), without restricting the
direction to unit length. -/
noncomputable def stressDirectionalSymbol (lam mu rho nx ny : ℝ) :
    Matrix (Fin 5) (Fin 5) ℝ :=
  nx • stressXSymbol lam mu rho + ny • stressYSymbol lam mu rho

/-- The five printed equations (22.31) as scalar relations on pointwise
time, x, and y derivatives of the stress-velocity state. -/
def StressComponentEquations (lam mu rho : ℝ)
    (qt qx qy : Fin 5 → ℝ) : Prop :=
  qt 0 - (lam + 2 * mu) * qx 3 - lam * qy 4 = 0 ∧
  qt 1 - lam * qx 3 - (lam + 2 * mu) * qy 4 = 0 ∧
  qt 2 - mu * (qx 4 + qy 3) = 0 ∧
  rho * qt 3 - qx 0 - qy 2 = 0 ∧
  rho * qt 4 - qx 2 - qy 1 = 0

/-- Pointwise matrix form of the five stress-velocity equations. -/
def IsStressMatrixSolutionAt (q : ℝ → ℝ → ℝ → (Fin 5 → ℝ))
    (lam mu rho x y t : ℝ) : Prop :=
  ∃ qt qx qy : Fin 5 → ℝ,
    HasDerivAt (fun τ => q x y τ) qt t ∧
    HasDerivAt (fun ξ => q ξ y t) qx x ∧
    HasDerivAt (fun η => q x η t) qy y ∧
    qt + (stressXSymbol lam mu rho).mulVec qx +
      (stressYSymbol lam mu rho).mulVec qy = 0

/-- Pointwise printed component form of (22.31). -/
def IsStressComponentSolutionAt (q : ℝ → ℝ → ℝ → (Fin 5 → ℝ))
    (lam mu rho x y t : ℝ) : Prop :=
  ∃ qt qx qy : Fin 5 → ℝ,
    HasDerivAt (fun τ => q x y τ) qt t ∧
    HasDerivAt (fun ξ => q ξ y t) qx x ∧
    HasDerivAt (fun η => q x η t) qy y ∧
    StressComponentEquations lam mu rho qt qx qy

/-- Constitutive map from planar strain and velocity to planar stress and
velocity. The normal entries are (22.33)–(22.34); the shear entry uses
`σ12=2με12` as in Chapter 2 (2.90). -/
noncomputable def stressOfStrain (lam mu : ℝ) (q : Fin 5 → ℝ) :
    Fin 5 → ℝ :=
  ![(lam + 2 * mu) * q 0 + lam * q 1,
    lam * q 0 + (lam + 2 * mu) * q 1,
    2 * mu * q 2, q 3, q 4]

/-- Longitudinal stress and velocity induced by a longitudinal strain pair. -/
noncomputable def pStressPair (lam mu : ℝ) (p : Fin 2 → ℝ) : Fin 2 → ℝ :=
  ![(lam + 2 * mu) * p 0, p 1]

/-- Shear stress and transverse velocity induced by a shear strain pair. -/
noncomputable def sStressPair (mu : ℝ) (s : Fin 2 → ℝ) : Fin 2 → ℝ :=
  ![2 * mu * s 0, s 1]

/-- X-only stress state with the remaining normal stress constrained by
(22.45). `p` and `s` are the stress-velocity P/S pairs. -/
noncomputable def stressPlaneState (lam mu : ℝ)
    (p s : Fin 2 → ℝ) : Fin 5 → ℝ :=
  ![p 0, lam / (lam + 2 * mu) * p 0, s 0, p 1, s 1]

end NumStability.Leveque02Tracer.PlaneElasticity
