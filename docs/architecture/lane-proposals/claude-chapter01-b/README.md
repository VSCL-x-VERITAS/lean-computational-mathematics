# Applied classification — session `claude-chapter01-b` (2026-08-29)

This directory records the tier classification applied to
`docs/architecture/tiers.json` to close the repository-wide
`unclassified_modules` counter, which was holding open the organization loop of
the Vershynin HDP chapter gates.

## What changed

`unclassified_modules` went **309 → 0** (`tools/architecture/check_layout.py`).
310 modules received an exact tier entry (309 from the scan that opened this
work, plus `NumStability.HDP.Scalar.BerryEsseen`, which a concurrent session
created mid-run).

| Applied tier | Modules |
| --- | ---: |
| source | 184 |
| reusable | 71 |
| compatibility | 54 |
| aggregate | 1 |

None of the 309 were HDP modules: 255 were `NumStability.Algorithms.*` and 54
`NumStability.Analysis.*`, i.e. the Higham numerical-stability lane.

## Provenance of each decision

`applied-classification.tsv` carries one row per module with its applied tier,
provenance, the frozen proposal's tier where one exists, and the rationale.

- **179 `frozen-proposal`** — taken verbatim from the reviewed
  `lane-proposals/claude-classification/classification/modules.tsv`. These were
  not re-litigated.
- **24 `frozen-proposal-mixed-resolved`** — the frozen proposal marked these
  `mixed_pending_split`. The shared manifest maps that to tier `mixed`, but the
  reviewed layout baseline admits exactly 9 named mixed modules, so applying it
  verbatim would have converted a passing counter into a failure. Each was
  therefore given the primary tier of its dominant role (20 source, 4 reusable),
  and **the split obligation is retained, not discharged** — see
  `pending-splits.json`.
- **107 `new`** — not covered by the frozen proposal (mostly modules created
  after it froze: `Sylvester.Higham16*`, `Underdetermined.Higham21*`,
  `MatrixPowers*`). Classified with the frozen proposal's own documented
  methodology: module docstring title, declaration roles, and whether
  declarations carry numbered/book-specific names. Per that methodology,
  *historical filenames and citations alone do not make declarations source
  correspondence*; a module whose declarations are all generically named is
  `reusable` even when its filename cites a chapter.

Validation of the method: on the 179 modules where the frozen reviewed proposal
gives a `source`/`reusable` verdict, this session's independent rule agreed on
**179/179 with zero disagreements**.

`compatibility` and `aggregate` were applied only to modules that are
import-and-docstring-only, as `check_layout.py` requires; this was asserted
programmatically (0 violations).

## Baseline edits

`docs/architecture/layout-exceptions.json` was edited for exactly the two keys
this work resolved, rather than by a wholesale `--write-baseline`:

- `unclassified_modules`: 309 → 0.
- `noncanonical_modules`: 261 → 246, dropping 15 entries that stopped being
  noncanonical because `noncanonical_name` exempts the `compatibility` tier.

No other baseline key was touched, so the pre-existing HDP contract-module
naming debt was **not** silently absorbed.

## Known residue (not caused by this increment)

- `check_layout.py` still fails on `new noncanonical modules` for ~110
  `NumStability.HDP.Contracts.*` / `ContractSignatures.*` modules. Reproduced on
  a detached worktree at pristine `HEAD` (`d602405cd`) before any edit here.
- `NumStability` / `NumStability.All` miss canonical descendant
  `NumStability.HDP.Scalar.BerryEsseen`, a module a concurrent session created
  and has not yet wired into the aggregates.
- HDP modules are tiered by ~134 *exact* entries rather than a prefix rule, so
  each new HDP module reopens `unclassified_modules`. A
  `NumStability.HDP` prefix rule would make that classification-by-construction.
