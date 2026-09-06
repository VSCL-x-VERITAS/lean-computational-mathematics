# Chapter 1 organization baseline

## Import-preserving checkpoint integration

Chapter 1 canonical alias placement remains complete: the 24 aliases extracted
from Preliminaries and LimitTheorems remain declared in the Vershynin source
tree, with none returned to the Scalar implementation bodies. The old Scalar
paths are import-only facades over their new `Basic` leaves and those source
declaration owners. They preserve the historical alias exports together with
the semantic API.

The four existing Jensen, Corollary 1.2.5, Exercise 1.2.2 and Lemma 1.2.1
`Contract` modules retain their former Preliminaries import surface as facades.
Their declarations move to `Contract.Theorem`; Scalar imports those leaves,
whose implementation dependencies use `Basic`, so this export preservation
introduces no import cycle. Existing ProjectIdentity assertions remain intact.

The two `Basic` leaves retain the reviewed `source` role. This dependency split
does not claim a reusable-tier reclassification. Exact candidate validation is
recorded separately from the historical checkpoint measurements below.

## Historical checkpoint organization record

The following counters and build results describe the checkpoint-era scan,
not a fresh census or validation result for the merged repository.

The source architecture baseline was generated with the repository's
`tools/architecture/generate_baseline.py --skip-declarations --strict-source`
workflow and the portable book-migration scanner.

Historical measured counters:

| Counter | Value | Evidence |
|---|---:|---|
| unclassified production modules | 309 | checkpoint `tools/architecture/check_layout.py` output after classifying the Chapter 1 leaves |
| duplicate wrappers | 0 | one semantic producer per inspected Chapter 1 alias |
| placeholder findings | 0 | corrected repository scan: ordinary structure fields named `constant` are no longer misclassified as Lean commands |
| canonical placement pending | 0 | checkpoint `rg` scan found no `hdp_01_*` declaration in either scalar producer |

That checkpoint baseline covered 2,326 production modules and 3,290,496
production lines; 2,016 modules were classified (86.672%). It also reports two
forbidden reusable-to-source direct edges and four reusable-to-source reachable
pairs introduced by the current shared organization increment. The portable
scan covered 4,006 Lean modules, 3,307,157 lines, and 15,345 internal import
edges with zero cycles.

The Chapter 1 source-alias placement scan is now clean. The final 14 embedded
`hdp_01_*` declarations moved out of
`NumStability/HDP/Scalar/Preliminaries.lean` into their source-facing contract
leaves without duplicating the reusable semantic producers. The aggregate
`NumStability.HDP.Contracts` build then passed all 3,599 jobs.

The extracted declarations are owned by the existing Banach/quasinorm,
convexity, Jensen, layer-cake, Markov-decomposition, Chebyshev, Equation (1.3),
Hölder, and CDF-determination leaves, plus new dedicated leaves for Exercise
1.2.6, Minkowski's inequality, and the historical Remark 1.1.1 alias.

The Exercise 1.2.6 leaf now also owns
`hdp_01_hex_h1_d2_d6_derivation`, the source-facing proposition that exposes
the prescribed event-squaring, Markov, variance-substitution, and final-bound
route. The reusable Chebyshev and Markov producers remain declaration owners
for the underlying mathematics and contain no Chapter 1 aliases.

The existing standard-normal leaf now owns Equation (1.6)'s theorem wrapper
`hdp_01_heq_h1_d6`; its semantic producer continues to own the reusable
Gaussian law and density calculation.

The new normalized-sum leaf `C_01_hdef_hzn.lean` owns the Chapter 1 definition
and its source-normalization theorem. It imports reusable expectation,
variance, and limit-theorem producers but adds no Chapter alias to those
producer modules; the architecture tier registry classifies the leaf as
source-facing.

The Exercise 1.2.2 increment moved `hdp_01_hex_h1_d2_d2` into
`NumStability/HDP/Contracts/C_01_hex_h1_d2_d2.lean` after its obstruction and
corrected theorem audits completed. The reusable producer retains the
underlying signed-tail and Cauchy-divergence mathematics, but no longer owns
the source-facing chapter wrapper.

The Exercise 1.2.3 increment moved `hdp_01_hex_h1_d2_d3` into the new
canonical leaf
`NumStability/HDP/Contracts/C_01_hex_h1_d2_d3.lean`. The producer retains
`momentTailFormula`; the 3,596-job aggregate contract build passed after the
split.

The LimitTheorems organization increment moved the Poisson-law alias, the
independent-variance-sum alias, and Equation (1.5)'s sample-mean variance alias
into `C_01_hdef_hpoisson.lean`, `C_01_hclaim_hvariance_hsum.lean`, and
`C_01_heq_h1_d5.lean`, respectively. The reusable producer now contains no
Chapter 1 `hdp_01_*` declarations.

The Poisson contract leaf now also owns `hdp_01_heq_h1_d8`, the stable
Equation (1.8) wrapper. The reusable `poissonLaw_mass` theorem remains the
single mathematical producer; the wrapper introduces no duplicate proof.

The pointwise layer-cake increment moved
`hdp_01_hlem_hlayer_hcake_hpointwise` from the scalar producer into
`NumStability/HDP/Contracts/C_01_hlem_hlayer_hcake_hpointwise.lean`.

The indicator increment removed the embedded alias whose type represented the
later expectation identity and replaced it with the source-shaped value rule
in `NumStability/HDP/Contracts/C_01_hdef_hindicator.lean`; the expectation
identity now has its own strict-superlevel contract leaf.

The layer-cake proof's previously internal Tonelli step now has a standalone
source-facing contract in
`NumStability/HDP/Contracts/C_01_hlem_h1_d2_d1_hfubini.lean`.

The MGF increment moved `hdp_01_hdef_hmgf` into
`NumStability/HDP/Contracts/C_01_hdef_hmgf.lean`; the producer retains only
the reusable MGF definitions and model.

The moments increment likewise moved `hdp_01_hdef_hmoments` into
`NumStability/HDP/Contracts/C_01_hdef_hmoments.lean`, beside its obstruction
and corrected-contract declarations.

The 309 unclassified production modules and global source-graph/layout
findings were repository-wide organization debt in that checkpoint. Resolving
them was broader than that Chapter 1 unit; this historical blocker is not a
claim about the current integrated repository.
