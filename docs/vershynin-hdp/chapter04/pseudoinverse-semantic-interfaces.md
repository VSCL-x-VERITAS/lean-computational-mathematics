# Real-kernel and Penrose interfaces

The smallest-singular-value paragraph on page 77 links three assertions: a
nonzero last singular value requires at least as many rows as columns; full
column rank is equivalent to positivity of that value; and at full column rank
the value is the reciprocal Euclidean operator norm of the Moore–Penrose
pseudoinverse. The preceding pages specify the decreasing, zero-padded
singular-value sequence and the Euclidean operator norm.

Two source-independent modules expose the meanings used in that paragraph:

| Module | Interface | Existing producer |
|---|---|---|
| `ComputationalMathematics.Analysis.SingularValues.FullColumnRank` | Trivial real kernel iff positive last singular value | Wedin positivity and lower-action bounds, plus the real/complex endpoint bridge |
| `ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.PenroseEquations` | Existing Moore–Penrose certificate iff all four matrix equations | The four fields of the existing certificate |

Both modules belong to the reusable tier. They import reusable mathematics
only. The Penrose interface introduces no second pseudoinverse predicate, and
the kernel interface does not repeat the singular-value positivity proof.

The additive source declaration
`NumStability.HDP.Contract.hdp_04_smallest_singular_value_kernel_and_penrose_equations`
uses these literal meanings while forwarding the shape and reciprocal norm
conclusions to the existing source contract. Its column dimension is positive,
its rank equivalence retains the tall-or-square condition, and its reciprocal
formula retains full column rank. The spectral/rank declaration
`NumStability.HDP.Contract.hdp_04_smallest_singular_value_full_rank_and_pseudoinverse`
keeps its original type and proof.

These are new canonical module paths. Existing import paths, namespaces,
declaration names, the `numStability` package, and the checked-in identity
migration map stay unchanged. Statement faithfulness is checked separately
from compilation. At introduction, the new source declaration required its own
independent audit before source-row credit. The current accepted source-row
index includes this interface; see [current coverage](coverage.md).
