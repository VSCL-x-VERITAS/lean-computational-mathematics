# Real SVD transpose and common Gram spectrum

This is a reusable-mathematics increment for the Chapter 4 campaign, not a
statement-faithfulness decision or a chapter-completion certificate.

`ComputationalMathematics.Analysis.SingularValues.RealSVDTranspose` imports
the existing `RealSVD` certificate and transports arbitrary certificates across
transpose. It swaps the existing vector families, preserves rank and both Gram
eigenvector equations, and resizes only the scalar zero tail. There is no shape
or positive-rank hypothesis and no second SVD existence construction.

`ComputationalMathematics.Analysis.SingularValues.Transpose` imports that API,
the existing SVD construction and canonical uniqueness. A characteristic-root
bridge identifies the actual ordered real Gram eigenvalues with their existing
complexified representation. Its square-root theorem covers every index in
`Fin (min m n)`, including zeros after rank, while keeping the actual left and
right spectral dimensions separate. It does not invent out-of-dimension
eigenvalues or settle the source's unspecified index convention.

Both modules are reusable. Their dependency closure contains no numbered-source
module. They have no source-labelled declarations, new Gram definition, or
competing singular-value construction.

## Compatibility and placement

The new certificate-transport declarations initially occupied an unpublished
tail of `RealSVD.lean`. Only that new tail moves to `RealSVDTranspose.lean`;
the original file is restored byte for byte. The move preserves all authored
declaration names and proof bodies and restores the `BigOperators` elaboration
scope explicitly. No released API changes, so no compatibility shim is needed.
`Transpose.lean` directly imports the relocated certificate API. Existing root
imports and all previously selected source wrappers remain unchanged.

## Reproducible checks

Use the repository's unchanged Lean/Mathlib pins:

```console
lake build ComputationalMathematics.Analysis.SingularValues.RealSVDTranspose ComputationalMathematics.Analysis.SingularValues.Transpose
lake env lean ComputationalMathematics/Analysis/SingularValues/RealSVDTranspose.lean
lake env lean ComputationalMathematics/Analysis/SingularValues/Transpose.lean
lake build ComputationalMathematics NumStabilityTest
git diff --check
```

The independent boundary checks cover tall/wide matrices, rank-one zero tails,
zero matrices, empty dimensions, rank-zero certificates, and both actual Gram
eigenvalue lists. All new constants, including private and generated ones, must
use only the standard `propext`, `Classical.choice`, and `Quot.sound` axioms.
Campaign receipts and source/audit material remain checkout-local, outside Git.
