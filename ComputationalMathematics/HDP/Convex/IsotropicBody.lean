import ComputationalMathematics.HDP.Convex.Uniform
import ComputationalMathematics.HDP.Vector.Isotropy

/-!
# Isotropic convex bodies

This module names convex bodies whose normalized-volume coordinate law is
centered and isotropic.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Convex

/-- A convex body is isotropic when its normalized-volume coordinate law has
zero mean and identity second-moment matrix. -/
def IsIsotropicConvexBody {n : ℕ} (K : Set (Fin n → ℝ)) : Prop :=
  IsConvexBody K ∧
    NumStability.HDP.Vector.Covariance.meanVector
      (uniformConvexBodyMeasure K) (fun i x => x i) = 0 ∧
    NumStability.HDP.Vector.Isotropy.IsIsotropic
      (uniformConvexBodyMeasure K) (fun i x => x i)

/-- The centered normalized-volume characterization of an isotropic convex
body. -/
theorem isIsotropicConvexBody_iff {n : ℕ} {K : Set (Fin n → ℝ)} :
    IsIsotropicConvexBody K ↔
      IsConvexBody K ∧
        NumStability.HDP.Vector.Covariance.meanVector
          (uniformConvexBodyMeasure K) (fun i x => x i) = 0 ∧
        NumStability.HDP.Vector.Isotropy.IsIsotropic
          (uniformConvexBodyMeasure K) (fun i x => x i) :=
  Iff.rfl

end NumStability.HDP.Convex
