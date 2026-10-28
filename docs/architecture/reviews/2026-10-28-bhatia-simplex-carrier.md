# Euclidean simplex carrier review

`ComputationalMathematics.Geometry.Euclidean.SimplexCarrier` is reusable
geometry. It defines the convex hull of a nonempty indexed family of real
Euclidean vertices, its affine span and direction, vertices as points of that
span, the simplex set inside the span, and its centered image under
`AffineIsometryEquiv.vaddConst`.

The definitions apply when `k = 0`, when vertices repeat, and when the ambient
space has dimension zero. They add no affine independence, nonzero, rank, or
volume assumption. The centered image uses displacement from its chosen
carrier point. The implementation composes Mathlib's `convexHull`,
`affineSpan`, and affine isometry; it does not create a competing convex hull
or affine carrier API. No source-specific statement or proof lives in this
module. Later Bhatia volume claims require their own target, independent
faithfulness audit, and proof.

The 57-line module was introduced in commit
`4a4084440083f7737321ec64e5ccd0c54c660a89` with SHA-256
`d7ed2907e1477fca59b97912c6f1c1ede1c819c951d0cd1404fb0c190d3b03b3`.
The pinned Lean 4.29.0-rc3 and Mathlib
`e8ea1afc32790ce1d4e1a4e45cc412ba9388716b` compiled it in the owned
local job `5b0be8fa71e896be822e72c8efeb277c0fdc7121baee366b5c1bbd9777bef039`
on attempt 1, with return code 0 and empty compiler output. The job's
authenticated compiled-candidate and terminal stages were consumed before
compiler release. This is a definition compilation result, not a Bhatia
statement or proof acceptance.
