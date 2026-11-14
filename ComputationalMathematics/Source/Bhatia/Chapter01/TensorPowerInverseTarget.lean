/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.InnerProductSpace.Defs
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.PiTensorProduct

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Bhatia I.4, tensor-power property 2 (printed p. 15).
The first conjunct retains both invertibility directions for every operator.
For genuine factor inverse data `e`, the second conjunct states the inverse
formula using the actual induced tensor equivalence. No tensor inverse is
supplied as a hypothesis and no inverse is evaluated on a singular operator.
-/
def tensorPowerInverse : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ), 0 < k →
    ∀ (A : H →ₗ[ℂ] H),
      (Function.Bijective
          (PiTensorProduct.map (fun _ : Fin k => A) :
            PiTensorProduct ℂ (fun _ : Fin k => H) →ₗ[ℂ]
              PiTensorProduct ℂ (fun _ : Fin k => H)) ↔
        Function.Bijective A) ∧
      (∀ (e : H ≃ₗ[ℂ] H), e.toLinearMap = A →
        (PiTensorProduct.congr (fun _ : Fin k => e)).symm.toLinearMap =
          PiTensorProduct.map (fun _ : Fin k => e.symm.toLinearMap))

end NumStability.Bhatia.Chapter01.Targets
