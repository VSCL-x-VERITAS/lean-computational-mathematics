# Additive review of the changed draft

The initial freeze stopped with actual exit 1 because root changed the draft before its freshness guard. That draft was preserved as `PhysicalRefinement.reviewed.snapshot`; no Lean or operational role ran. The first `REVIEW.md` remains historical and its reference construction route remains applicable.

I independently read the complete retained newer snapshot. It changes the target guard to `(interior target).Nonempty` and counts each interior coordinate edge once, adding a right-edge term only where the next physical lookup is absent. This resolves the specific target-degeneracy and boundary-to-interior weighting issues identified in the initial review. For the counterexample previously reported, both the incoming and outgoing variations are now 1. No full oscillation theorem is inferred from this correction.

The newer snapshot retains reference-specific measured ghosts, the same physical tensor flux and state/measure linkage, and the correct shared accuracy quantifiers. The affine Fin 2 proof route and its remaining exact cell/face-integral calculation are unchanged. The all-slots boundary-region obligations remain a generality/packaging observation, not an identified false theorem; used neighboring boxes plus a fixed filler region for unused slots can instantiate them.

The current design has no further required correction identified in this bounded review. A genuine affine reference, actual ghost means, method admission/accuracy and the oscillation fixture still require their own native proofs. This report neither compiles them nor supplies a source-faithfulness judgment.
