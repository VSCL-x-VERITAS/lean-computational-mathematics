# HDP source-locator migration queue

Status: Waves A and B completed on 2026-09-01. All 69 reviewed source locators
now live at their `NumStability.Source.Vershynin` targets, and every historical
`NumStability.HDP.ContractSignatures.C_*` or `NumStability.HDP.Contracts.C_*`
path is an import-only compatibility wrapper.

The exact 69-row old-to-canonical map is
[`hdp-source-locators.tsv`](hdp-source-locators.tsv). The proposed canonical
dialect treats the source as Vershynin's *High-Dimensional Probability*, uses
fixed-width chapter, section, and numbered-result locators, and separates each
proof-free `Signature` from its checked `Contract` declaration. Existing Lean
declaration names remain unchanged.

## Role decision

All 69 historical locator leaves now have the reviewed primary role
`compatibility`; the corresponding canonical `Signature` and `Contract` leaves
have primary role `source`. The 27 results with both stages have import-only
result umbrellas with primary role `aggregate`. The semantic HDP files still
own Chapter-numbered aliases; until those declarations are extracted, `source`
is the only non-`mixed` role that describes each entire module honestly.
`GraphDegreeLaw` is the sole reviewed `reusable` exception: it contains no
source locator or contract declaration.

## Execution record

1. **Complete:** Wave A moved the 30 proof-free signatures into the Vershynin
   tree, retained every old module as an exact one-import compatibility wrapper,
   added 30 canonical-only and 30 old-only per-path smoke tests, and updated the
   source and chapter aggregates plus both architecture manifests.
2. **Complete:** Wave B moved the 39 source-contract locators, retained exact
   one-import compatibility wrappers, added 39 canonical-only and 39 old-only
   per-path checks, retargeted the HDP contract umbrella, and added the 27
   required two-stage result umbrellas.
3. **Not scheduled:** A later semantic split may extract Chapter-numbered aliases from
   `Scalar/*` and `Concentration/MetricMeasure` into the Vershynin tree. Only
   after that split should those semantic modules be reconsidered for the
   `reusable` tier.

Each wave must preserve namespaces and declaration signatures, keep aggregate
imports sorted and unique, update the compatibility table, and pass targeted,
canonical-only, old-only, entry-point, layout, compatibility, and full-project
checks before the next wave begins.
