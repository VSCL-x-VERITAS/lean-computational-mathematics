# Remark 4.7.2: sample-size convention review

## Current disposition — October 30, 2026

The selected inventory excludes this remark as `SKIPPED`: the printed comparison
does not resolve its constants' dependence on the inherited subgaussian parameter.
The conditional fixed-`K` sufficient theorem and all historical judgments remain
preserved, without source-row credit. See [current coverage](coverage.md).

## Historical convention analysis

The analysis below retains its earlier source selections and audit epochs.
Its pending and refresh labels describe those historical snapshots.

Workflow: `formalization-workflow-v6.3.7`, commit `8d33f231db99a35d56bd340a7c8c4934b2bdcbb0`; stage `chapter-4`.

Status: prior workflow records a 2026-10-02 fixed-`K` policy selection,
whose original instruction is unavailable. On 2026-10-21 the user directed us
to keep the printed remark’s hidden-`K` dependence ambiguous. The comparable
integer-sample target compiles. The earlier independent audit was complete-valid
and adjudicated `faithful-equivalent`, but the current gate row is `IN_PROGRESS`
after exact imported-source changes. That historical adjudicator
SHA-256 is `0e05cc6ac983c186535f255bf85b07b34fead507126748026330d88cc3d6d292`.
The existing theorem establishes a fixed-`K` conditional interpretation; it does
not resolve whether the printed comparison hides `K`, assert uniform constants
independent of `K`, or establish necessity of the sufficient threshold.

## Source evidence

- The pinned 2018 first-edition Chapter 4 PDF (SHA-256
  `b7448935fe23081eefa4d1589a07550c384d986f6ae499fb06547d10c2f993f9`),
  PDF p. 26 / printed p. 100, writes `m ≍ ε⁻² n`. The local paragraph says
  “if we take a sample of size” and derives its guarantee from Theorem 4.7.1.
- The immediately preceding theorem, PDF pp. 25–26 / printed pp. 99–100,
  assumes a subgaussian parameter `K ≥ 1` and bounds expected relative error
  by `C K² (√(n/m) + n/m)` with an absolute `C`.
- The pinned first-edition Chapter 2 PDF, PDF p. 3 / printed p. 14,
  footnote 1 defines `f ≍ g` as two-sided comparison up to positive constant
  factors in the function variable, for all or sufficiently large inputs.
  This is the book's operative definition of the notation, not merely a
  convention inferred from the Chapter 4 paragraph. Applied here, `K` could
  be held fixed while the dimension and tolerance vary; the footnote does
  not explicitly declare which parameters are held fixed in Remark 4.7.2.
- The pinned first-edition Chapter 2 PDF, PDF p. 19 / printed p. 30,
  footnote 5 says that, in that proof and later, `a ≲ b` hides an absolute
  constant. This is evidence for a literal absolute-constant reading, but it
  does not explicitly say how the author intends the `≍` in this remark to
  treat `K`.
- The author's separately reviewed [first-edition PDF](https://www.math.uci.edu/~rvershyn/papers/HDP-book/HDP-1.pdf)
  renders this remark with the one-sided `m ≳ ε⁻² n`. This corroborates a
  sufficient-threshold reading, but is not the pinned source and still does
  not specify `K`-dependence. The [second-edition PDF](https://www.math.uci.edu/~rvershyn/papers/HDP-book/HDP-2.pdf)
  likewise cannot silently replace the pinned first-edition contract.
- A pre-existing, provenance-recorded lossless Chapter 2 + Chapter 4 PDF
  bundle (SHA-256 `be70c21b0467bba19da6279674b7618513b89f8bf9c8624e958f25e3920a4353`)
  permits the notation definition and the remark to be reviewed together in
  one v1 faithfulness-audit source artifact. It does not replace either pinned
  original PDF.

## Existing conditional fixed-`K` target

Let `A = max 1 C`, where `C` is the constant in Theorem 4.7.1. For
`0 < ε < 1`, `K ≥ 1`, and `n,m > 0`, the sufficient threshold

`m ≥ 4 A² K⁴ ε⁻² n`

gives `n/m ≤ (ε/(2 A K²))²`, hence the printed error conclusion. The existing
Lean declaration `hdp_04_remark_4_7_2_of_aspectRatio_le` proves precisely this
aspect-ratio implication. The source-facing `hdp_04_remark_4_7_2` now chooses
an integer `m` between `T` and `2T`, with
`T = (2 A K²/ε)² n`, and proves the expected relative-error conclusion for
every independent sample of that length. Hence `m ≍ ε⁻² n` with constants
depending on fixed `K`. Both declarations compile. This is a reviewed policy
choice applied to the pinned source, not a claim that the printed shorthand
explicitly states the dependence on `K`.

## Why absolute uniformity cannot hold

For any `p ∈ (0,1)`, let a one-dimensional random variable be `X = p⁻¹ᐟ²`
with probability `p` and `X = 0` otherwise. Then `E X² = 1`. The variable is
bounded, so it has a finite `ψ₂/L²` parameter `K` (for example,
`K ≥ 1/√(p log 2)` suffices). For `m` independent copies, on the event that
all samples are zero the empirical second moment is zero, so its error from
the population second moment is one. Consequently

`E |Σ_m − Σ| ≥ P(all samples zero) = (1−p)^m ≥ 1−mp`.

For any proposed absolute upper coefficient `B`, take `ε = 1/2`, `n = 1`,
an integer `M ≥ max(1, 4B)`, and `p = 1/(4M)`. Every `1 ≤ m ≤ 4B` then has
expected error at least `3/4 > ε`. Thus no sample size in an absolute-factor
window around `ε⁻² n` works uniformly for all admissible `K`. The same
construction refutes a uniform absolute sufficient threshold by choosing
`m` at that threshold. This is an analytic counterexample, not yet a Lean
witness or an audited `DISCREPANCY` artifact.

## Decision and verification

Prior workflow selected the fixed-`K` convention with explicit `K`-dependent
constants for this conditional theorem; its original instruction is unavailable. The 2026-10-21 instruction keeps the
printed remark’s hidden-`K` dependence unresolved. The analytic rare-spike
argument above cautions against a uniform-in-`K` reading; it does not by itself
choose the author’s intended comparison convention.

The earlier complete audit decision (SHA-256
`66caaf8505d65f149e69906c07774c4582e5a8dd881e5ddbf5c5bedaa337c338`,
`accepted=false`, `classification=undetermined`) applies to the former
aspect-ratio-only target and Chapter-4-only source packet; it is archived,
not evidence accepting this revised target. The earlier source-and-notation
audit was complete-valid on its recorded snapshot. Its decision SHA-256 is
`d7c71bedfb78301987c06076da9b6efb9524cfd79a384b5ec9d42f0b211633a6`:
`accepted=true`, `faithful-equivalent`, with both implication directions
`yes`. Fresh isolated roles used the exact `gpt-6.1-sol` / `xhigh` pairing,
and its then-current gate row was `PROVED`. Exact import changes have since
reopened the row; current producer-chain refresh and exact independent judgment
remain required. Historical acceptance does not close changed packets. That
earlier conclusion retains the declared
external-library semantic frontier and the explicit source ambiguity about
hidden `K` factors. It establishes the sufficient comparable integer window
`4 A² K⁴ ε⁻² n ≤ m ≤ 8 A² K⁴ ε⁻² n` for fixed inherited `K`, not optimal
dependence on `K` or necessity of that threshold.
