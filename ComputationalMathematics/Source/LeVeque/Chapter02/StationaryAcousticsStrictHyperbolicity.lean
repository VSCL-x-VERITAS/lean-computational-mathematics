/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsEigenvalues
import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsStrictHyperbolicityTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicity

/-!
# Strict hyperbolicity of stationary linear acoustics
-/

namespace NumStability.Leveque02Tracer

/-- The two sound speeds of stationary acoustics are distinct, with a full
real eigenbasis of the pressure-velocity coefficient matrix. -/
theorem stationaryAcousticsStrictHyperbolicity :
    stationaryAcousticsStrictHyperbolicityTarget := by
  intro bulkModulus density hbulkModulus hdensity
  let soundSpeed := Real.sqrt (bulkModulus / density)
  let coefficient := linearAcousticsMatrix bulkModulus density
  let eigenvalues : Fin 2 → ℝ := ![-soundSpeed, soundSpeed]
  let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
    ![linearAcousticsLeftEigenvector density soundSpeed,
      linearAcousticsRightEigenvector density soundSpeed]
  change 0 < soundSpeed ∧
    Function.Injective eigenvalues ∧
    (∀ p, coefficient.mulVec (eigenvectors p) =
      eigenvalues p • eigenvectors p) ∧
    LinearIndependent ℝ eigenvectors ∧
    IsRealHyperbolicMatrix coefficient
  have hacoustics :=
    NumStability.leveque01_acousticsMatrixEigenvalues hbulkModulus hdensity
  dsimp only at hacoustics
  rcases hacoustics with
    ⟨hsoundSpeed, hleftNe, hleft, _, hrightNe, hright, _⟩
  have hinjective : Function.Injective eigenvalues := by
    intro i j hij
    fin_cases i <;> fin_cases j
    · rfl
    · have h : -soundSpeed = soundSpeed := by
        simpa [eigenvalues] using hij
      exfalso
      linarith
    · have h : soundSpeed = -soundSpeed := by
        simpa [eigenvalues] using hij
      exfalso
      linarith
    · rfl
  have hnonzero : ∀ p, eigenvectors p ≠ 0 := by
    intro p
    fin_cases p
    · simpa [eigenvectors] using hleftNe
    · simpa [eigenvectors] using hrightNe
  have heigen : ∀ p, coefficient.mulVec (eigenvectors p) =
      eigenvalues p • eigenvectors p := by
    intro p
    fin_cases p
    · simpa [coefficient, eigenvalues, eigenvectors, soundSpeed] using hleft
    · simpa [coefficient, eigenvalues, eigenvectors, soundSpeed] using hright
  have hstrict :=
    symmetricStrictHyperbolicity.2 coefficient eigenvalues eigenvectors
      hinjective hnonzero heigen
  exact ⟨hsoundSpeed, hinjective, heigen, hstrict.1, hstrict.2⟩

end NumStability.Leveque02Tracer
