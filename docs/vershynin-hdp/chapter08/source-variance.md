# Chapter 8 source-variance preparation ledger

The pinned Chapter 8 PDF is authoritative. This ledger records source-facing
questions exposed during inventory; it does not declare a discrepancy without
a formal witness and a separately audited correction.

| Gate row | Printed material | Preparation finding | Current state | Exact next check |
|---|---|---|---|---|
| `HDP-08-EQ-8.23` | `mu_n({X_i}) = 1/n` for every sample index. | If two sample values coincide, the singleton receives their combined mass under the usual empirical measure `(1/n) sum_i delta_{X_i}`. The display is literal only with distinct sample values or with an indexed-multiset interpretation. | `READY`; no correction assumed. | Define the multiplicity-aware empirical measure, exhibit the repeated-sample case, and adjudicate the exact source-facing contract. |
| `HDP-08-BODY-8.2-EMPIRICAL-DEVIATION` | The Section 8.2.3 body says `X_f = mu f - mu_n f`. | Definition 8.2.5 and Equation (8.21) define `X_f = mu_n f - mu f`; the body reverses the sign. Later absolute-value bounds are sign-invariant, but the identity itself is not. | `READY`; printed conflict preserved. | Prove both expansions from the empirical-process definition and record the sign correction through the discrepancy protocol if confirmed. |
| `HDP-08-BODY-8.2-WASSERSTEIN` | The text calls the quantity in (8.24) the Wasserstein distance `W_1(mu,mu_n)`. | Display (8.24) includes an outer expectation, while `W_1(mu,mu_n)` is normally the sample-dependent distance before expectation; the nearby class (8.19) also carries a general Lipschitz bound `L`, whereas the exact dual formula uses the unit-Lipschitz class. | `READY`; normalization and quantifiers remain open. | Separate the pointwise dual distance from its expectation and audit the class normalization and moment hypotheses. |
| `HDP-08-EQ-8.17` | An integral is written approximately equal to a random sample average. | The approximation sign has no quantified error, probability, or convergence mode. | `SKIPPED` as `underspecified`. | Use Equation (8.16) for almost-sure convergence and (8.18) for a quantitative average-error statement. |
| `HDP-08-EQ-8.43` | The proof says it “would like” a simultaneous increment inequality. | This is an aspirational proof shape without a probability level or constant; Equation (8.44) is the actual quantified estimate. | `SKIPPED` as `narrative`. | Formalize and use Equation (8.44), not the aspirational display as an asserted theorem. |

No other source discrepancy is asserted at preparation time. Results supplied
without an in-chapter proof remain `READY` with `source_proof` recorded as
`none` or `citation-only`; they are not weakened or silently deferred.
