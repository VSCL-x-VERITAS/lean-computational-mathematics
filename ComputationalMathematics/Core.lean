import ComputationalMathematics.Analysis.Error.Measures.All
import ComputationalMathematics.Analysis.FirstOrderFramework
import ComputationalMathematics.Analysis.FloatingPointArithmetic.ErrorModels.All
import ComputationalMathematics.Analysis.Rounding
import ComputationalMathematics.Analysis.Stability
import ComputationalMathematics.FloatingPoint.Model

/-!
# Reusable NumStability foundations

This entry point exposes the source-independent floating-point model and the
small foundational error-analysis surface.  It is deliberately narrower than
`NumStability.All`; algorithm-family entry points will be added as their APIs are
classified during migration.
-/
