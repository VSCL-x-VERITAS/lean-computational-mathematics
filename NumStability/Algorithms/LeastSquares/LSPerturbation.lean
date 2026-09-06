import Mathlib.Data.Real.Basic
import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.Analysis.MatrixSpectral
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.Basic
import ComputationalMathematics.Analysis.Perturbation.LeastSquares.Wedin
import ComputationalMathematics.Analysis.SingularValues.Realification
import ComputationalMathematics.Source.Higham.Chapter20.Lemma11.Support

/-!
# LSPerturbation (historical compatibility wrapper)

Import-only wrapper retained so historical imports of
`NumStability.Algorithms.LeastSquares.LSPerturbation`
keep resolving. Its declarations moved unchanged to the canonical
modules imported above. Its own historical imports are re-stated so
consumers that reached an identifier transitively through this module
still see the same surface.
-/
