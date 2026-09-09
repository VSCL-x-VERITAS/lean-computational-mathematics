# A complete CFL-one high-resolution family witness

The concrete `CFL1QualityFamilyWitness.family m` satisfies the full frozen `quality03` `LineFamily.HasControlledHighResolution` predicate, including its fixed target coverage, width comparability, accuracy for every smooth local physical reference, perturbation stability, and finite-window variation bound. `scalar_family_exists` gives a literal `LineFamily 1` instance. This is scratch mathematical evidence, not a source audit or a production placement.

The exact native-zero input `directional-reference-repair/quality03-Quality.lean` is copied and hash-pinned. Its definitions and structure fields are retained without modification. The prior frozen local-characteristic connection is also included exactly apart from deduplicating import lines. The assembly script removes only import lines and trailing `#check`/`#print` commands from those inputs before combining their bodies. No mutable scratch module is imported. The new authored material lives in `Family.lean.fragment`.

## Concrete family

The physical flux is unit-speed identity transport on all finite real vectors, using the existing `StationaryRiemannField.transportLaw` hyperbolicity producer. The physical interval is `[-2,2]`, the fixed positive-length target is `[0,1]`, and the horizon is `1`. The target does not shrink with refinement.

At refinement `n`, `h_n=dt_n=1/(n+2)`. Cell `j` is `[(j−1)h_n,jh_n]`. Active cells have indices `[0,n+4)`; input cells have indices `[-1,n+4)`, explicitly including the entering ghost cell. Thus active cells cover `[-h_n,1+h_n]` and input cells cover `[-2h_n,1+h_n]`, all inside the physical interval. Floor bounds prove actual coverage of every point of `[0,1]`, including its endpoints. Every input cell has volume exactly `h_n`, so both comparability bounds hold with ratio `1`, and CFL is exactly `1`. Positivity, the time horizon bound, and `h_n→0` are proved.

The numerical flux is the actual left-adjacent value `F[j]=Q[j−1]`. Every array is admitted; this is a concrete admission rule, not an arbitrary eligibility predicate. The finite stencil/locality field proves that fluxes at every active face, including exterior faces, depend only on the supplied finite input window.

## Full quality proof

For every smooth local physical rectangle reference, the already checked local rectangle-to-classical-to-characteristic theorem gives exact next-time cell averages. Only the actual projected predecessor value and physical containment are used. The class's accuracy clause is fulfilled by order `p=2`, the uniform constant `C=0`, and threshold `N=0`; no actual error or mesh-dependent quantity is chosen as the constant. The local reference is not required to have an assumed transported representation, a global physical extension, or globally integrable initial data.

The actual conservative update equals `Q[j−1]`. Consequently a uniform input perturbation bound transfers to each active output with stability rate `L=0`. Output variation equals the variation of the shifted active input window. That window's internal edges are a prefix of the full input window's internal edges, and nonnegativity proves the requested bound with `K=0` and identically zero noise. The incoming ghost edge is included; no fixed-window comparison discards entering variation.

The smooth nonconstant profile `φ(x)=x` supplies an actual `SpatialSmoothReferenceOn` and exact initial projection at every refinement. The discontinuous scalar step supplies an actual `SpatialRectangleReferenceOn`; its failure of continuity is retained separately, so it is not mislabeled as smooth or as nonlinear shock formation. The earlier frozen witness already provides exact translated-step refinement. The full oscillation clause here applies to every input array, including its projected averages.

This special CFL-one family is exact for unit-speed transport and therefore has any algebraic consistency order along this refinement sequence. It is not a claim that ordinary upwind schemes have order greater than one at other CFL numbers, or that a high-resolution family exists for every hyperbolic flux. Coordinate composition and source faithfulness remain separate work owned by the coordinator.

## Reuse and evidence

Current project searches selected the canonical grid, conservative update, interval/volume average, `StationaryRiemannField.transportLaw` and `physicalFlux`, and `hyperbolicConservationLaw_isHyperbolicFluxAt`. The prior frozen CFL-one and arbitrary local-reference proofs are reused rather than rederived. Pinned Mathlib supplies integer floor bounds, the natural-index shift of a convergent sequence, interval arithmetic, and nonnegative finite-sum inclusion. No duplicate scalar numerical update, measure definition, flux Jacobian proof, or global characteristic theorem was introduced.

The first native attempt's real failures concerned arithmetic congruence, an unannotated negative integer in a window bound, and polynomial normalization in coverage. Its input/output are retained. The second native attempt checked the complete family and quality proof without warnings. The final attempt adds scalar applicability and prints every newly authored declaration and its actual axioms. The immutable source PDF and literal high-resolution interpretation are linked through the previously frozen evidence manifests; no new interpretation, gate status, audit verdict, or publication authority is inferred.
