import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LowRankApproximation
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation09.LowRankApproximation.StructuralBound

/-! # Structural low-rank bound in compatible SVD coordinates -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem correctedLowRankApproximationStructuralBound :
    Targets.correctedLowRankApproximationStructuralBound := by
  intro m k q r N A Ufull sigma Vfull Z _hwidth hSVD hfull
  exact randNLA2016_equation09_structuralBound_of_svd N A Ufull sigma Vfull hSVD Z hfull

theorem existsCompatibleFullRightSVD {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ (U : Matrix (Fin m) (Fin n) ℝ) (sigma : Fin n → ℝ)
      (V : Matrix (Fin n) (Fin n) ℝ), IsRealFullRightSVD A U sigma V := by
  refine ⟨realSVDLeftCoordinates A, rectSingularValue A, realSVDRightCoordinates A, ?_⟩
  exact {
    singularValues_nonneg := rectSingularValue_nonneg A
    singularValues_antitone := rectSingularValue_antitone A
    representation := realSVDCoordinates_reconstruction A
    right_orthonormal := realSVDRightCoordinates_orthonormal A
    left_cross := realSVDLeftCoordinates_cross A
    left_diag := realSVDLeftCoordinates_diag A
  }

end NumStability.Source.DrineasMahoney.RandNLA2016
