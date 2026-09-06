# HDP source-locator migration queue

Status: Waves A and B completed on 2026-09-01. Their 69-row map below is a
historical migration record. After the identity migration, canonical source
modules use `ComputationalMathematics.Source.Vershynin`, and every historical
`NumStability.HDP.ContractSignatures.C_*` or `NumStability.HDP.Contracts.C_*`
path is an import-only compatibility wrapper.

The exact 69-row old-to-canonical map is
[`hdp-source-locators.tsv`](hdp-source-locators.tsv). The proposed canonical
dialect treats the source as Vershynin's *High-Dimensional Probability*, uses
fixed-width chapter, section, and numbered-result locators, and separates each
proof-free `Signature` from its checked `Contract` declaration. Existing Lean
declaration names remain unchanged.

## Role decision

The historical locator paths remain import-only `compatibility` modules.
Canonical declaration owners retain the `source` role; result umbrellas and
the import-only contract facades described below use `aggregate`.

The Chapter 1 checkpoints extracted 24 aliases from `Scalar.Preliminaries`
and `Scalar.LimitTheorems`. Integration preserves their old import surfaces
with two declaration-free Scalar facades over `Basic` implementation leaves
and the source declaration owners. The four pre-existing Jensen, Corollary
1.2.5, Exercise 1.2.2 and Lemma 1.2.1 `Contract` paths are also facades:
their declarations live in `Contract.Theorem` leaves, and their imports retain
the former Preliminaries surface without creating cycles.

The two `Basic` leaves retain their reviewed `source` classification. Moving
their bodies does not establish a new reusable-tier decision. Reclassification
of these implementations and the remaining Scalar/concentration modules
requires a separate review of their complete mathematical role.

## Execution record

1. **Complete:** Wave A moved the 30 proof-free signatures into the Vershynin
   tree, retained every old module as an exact one-import compatibility wrapper,
   added 30 canonical-only and 30 old-only per-path smoke tests, and updated the
   source and chapter aggregates plus both architecture manifests.
2. **Complete:** Wave B moved the 39 source-contract locators, retained exact
   one-import compatibility wrappers, added 39 canonical-only and 39 old-only
   per-path checks, retargeted the HDP contract umbrella, and added the 27
   required two-stage result umbrellas.
3. **Chapter 1 checkpoint integration:** The 24-alias extraction is retained
   with the import-preserving Basic/facade split above. Existing identity
   witnesses remain unchanged; six new canonical leaves have isolated import
   probes. Broader semantic-tier reclassification is not part of this repair.
   Validation of the exact integrated candidate is recorded separately.

Each wave must preserve namespaces and declaration signatures, keep aggregate
imports sorted and unique, update the compatibility table, and pass targeted,
canonical-only, old-only, entry-point, layout, compatibility, and full-project
checks before the next wave begins.
