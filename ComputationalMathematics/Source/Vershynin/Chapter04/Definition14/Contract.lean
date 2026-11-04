import Mathlib.InformationTheory.Hamming

/-!
# Vershynin, Chapter 4, Definition 4.2.14

Source-correspondence contract for the binary Hamming cube, its distance, and
the induced Hamming metric space.
-/

open Finset

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Definition 4.2.14: binary
strings of length `n` form the Hamming cube, their Hamming distance counts the
coordinates where they disagree, and the `Hamming` type synonym equips this
cube with that metric. -/
theorem hdp_04_hdef_h4_d2_d14
    (n : ℕ) (x y : Fin n → Fin 2) :
    Nonempty {m : MetricSpace (Hamming (fun _ : Fin n => Fin 2)) //
        m.toDist = Hamming.instDist} ∧
      hammingDist x y = #{i | x i ≠ y i} ∧
      dist (Hamming.toHamming x) (Hamming.toHamming y) = (hammingDist x y : ℝ) := by
  exact ⟨⟨⟨Hamming.instMetricSpace, rfl⟩⟩, rfl, Hamming.dist_eq_hammingDist _ _⟩

end NumStability.HDP.Contract
