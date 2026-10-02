import ComputationalMathematics.Source.Vershynin.Chapter04.Equation45.Contract

/-!
# Vershynin Chapter 4, distance-distortion check

Source contract for the pairwise Euclidean distortion bounds supplied by the
extreme singular values.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, inline check following Equation (4.5): the least and greatest
singular values bound the distance between the images of every pair. -/
theorem hdp_04_distance_distortion_check {m n : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ) :
    spectrum ℝ
        (NumStability.rectCourantFischerRightGram A).toEuclideanLin =
      Set.range (NumStability.hermitianOrderedEigenvalue
        (NumStability.rectCourantFischerRightGram_isHermitian A)) ∧
    (∀ μ : ℝ,
      Module.End.HasEigenvalue
          (NumStability.rectCourantFischerRightGram A).toEuclideanLin μ →
        Finset.card {i |
          NumStability.hermitianOrderedEigenvalue
              (NumStability.rectCourantFischerRightGram_isHermitian A) i = μ} =
          Module.finrank ℝ (Module.End.eigenspace
            (NumStability.rectCourantFischerRightGram A).toEuclideanLin μ)) ∧
    (∀ x : EuclideanSpace ℝ (Fin (n + 1)), ∀ i : Fin m,
      Matrix.toEuclideanLin A x i = ∑ j : Fin (n + 1), A i j * x j) ∧
    (∀ i j : Fin (n + 1), i ≤ j →
      NumStability.rectCourantFischerSingularValue A j ≤
        NumStability.rectCourantFischerSingularValue A i) ∧
    (∀ i : Fin (n + 1),
      NumStability.rectCourantFischerSingularValue A (Fin.last n) ≤
          NumStability.rectCourantFischerSingularValue A i ∧
        NumStability.rectCourantFischerSingularValue A i ≤
          NumStability.rectCourantFischerSingularValue A (0 : Fin (n + 1))) ∧
    NumStability.AreOptimalExtremeSingularValueBounds A
      (NumStability.rectCourantFischerSingularValue A (Fin.last n))
      (NumStability.rectCourantFischerSingularValue A (0 : Fin (n + 1))) ∧
    ∀ x y : EuclideanSpace ℝ (Fin (n + 1)),
      Matrix.toEuclideanLin A x - Matrix.toEuclideanLin A y =
          Matrix.toEuclideanLin A (x - y) ∧
        NumStability.rectCourantFischerSingularValue A (Fin.last n) * ‖x - y‖ ≤
            ‖Matrix.toEuclideanLin A x - Matrix.toEuclideanLin A y‖ ∧
          ‖Matrix.toEuclideanLin A x - Matrix.toEuclideanLin A y‖ ≤
            NumStability.rectCourantFischerSingularValue A
              (0 : Fin (n + 1)) * ‖x - y‖ := by
  obtain ⟨hspectrum, hmultiplicity, haction, hantitone, hendpoints, hoptimal⟩ :=
    hdp_04_equation_4_5 A
  refine ⟨hspectrum, hmultiplicity, haction, hantitone, hendpoints, hoptimal, ?_⟩
  intro x y
  refine ⟨(map_sub (Matrix.toEuclideanLin A) x y).symm, ?_⟩
  exact NumStability.rectCourantFischer_extremeSingularValues_distanceBounds A x y

end NumStability.HDP.Contract
