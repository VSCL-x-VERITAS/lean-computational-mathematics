# Rename implementation report

**Validated implementation report.**
Source commit [`51c5540984780b0011f41739b9ddaf8e505b7c93`](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/commit/51c5540984780b0011f41739b9ddaf8e505b7c93),
tree `20298c7b62a6e75c6b4beba46c8b517d7d86f4fb`, passed
[CI run 34021942176](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021942176)
on 2026-09-06 at 12:45:10 UTC. Authenticated identity/axiom checks and the strict
full compiled-graph comparison passed. The later documentation commit and its
main publication are separate from this tested source revision; their exact
SHA and verification belong in the external publication receipt and final response.
Actual log review confirmed project cache restore/save were skipped, with the
permitted Mathlib cache used; see [validation](validation.md).

## Execution scope

- **Stage A:** public identity, README, citation and maintained navigation updated.
- **Stage B:** separately authorized canonical-module migration implemented and
  validated, retaining old imports, package identity and mathematical declarations.
- **Stage C:** separately authorized GitHub rename and URL cutover performed;
  the validated source is published on `codex/computational-mathematics-cutover`.
  The final documentation revision and main publication are verified separately.
- **Integration baseline:** clean `718beac641a8094611dc249c3508a2f5415381a3`,
  with 11,225 tracked files, was 136 commits ahead of the original dirty checkout
  at `d602405cdd2a25915e5ba09dfd542886f4f9e2fa`. The original owner work was
  preserved separately; it was not copied over the newer baseline.

## Changes made

The project is **Lean Computational Mathematics** at the verified canonical
repository. [README](../../../README.md), [architecture](../../../ARCHITECTURE.md),
[contribution guidance](../../../CONTRIBUTING.md), [citation](../../../CITATION.cff),
[agent guidance](../../../AGENTS.md) and current navigation describe the actual
mathematical breadth and supported interfaces. Live module references, Lake,
CI, source scanners, diagnostics and benchmark defaults follow the approved map.
The [benchmark guide](../../../tools/benchmark/README.md) names the configured
library and smoke-test targets.

The exact [module map](module-map.json) relocates 2,401 implementation/aggregate
modules under `ComputationalMathematics`, retaining all 3,198 old imports,
including 797 prior compatibility modules. The 5,599 production files are those
2,401 canonical modules plus 3,198 forwarders, not additional mathematical results.
The current source census is 14,236 Lean paths; production has 1,503,619 nonblank
lines and 47,223 imports, complete documentation/tier classification and no
cycles, unresolved project imports or forbidden reusable-to-source paths.

Canonical changes beyond mapped initial import tokens are the recorded
[14-import permutation](import-order-adjustments.json) and
[explicit original instance-name insertion](public-instance-name-adjustments.json).
The latter preserves its type, proof and registration behavior. One generated
[forwarder header](forwarder-header-adjustments.json) was ordered before its
unchanged module documentation/license notice. The exact
[private-name adapters](live-private-name-adjustments.json) preserve all 1,153
approved and 1,079 retired entries in 21 existing test files, with 51 additional
canonical retired-name absence checks. The 152-owner map is explicit; 5,768
existing tests are byte-identical and all 5,789 retain their authority content.
The [fixture inventory](fixture-inventory.json) records 2,846 generated files,
including the public-instance regression and three added root imports.

## Mathematics and sources preserved

The exact source comparison preserves mathematical bodies, authored names,
statements, hypotheses, proofs, notation, attributes and attribution. Protected
examples include `NumStability.FPModel`, `isBackwardStable`, `isNumericallyStable`,
`mixedForwardBackward_of_backward`, Gaussian moment integration,
`HDP.Contract.hdp_02_hthm_h2_d2_d6` and
`leveque01_equation03_advectedProfile`. Numerical stability remains in scope.
The original `NumStability.instFactLtRealOfNat_numStability` public instance is
preserved; strict graph comparison now has no removed, added or changed rows.

[Verified source scope](source-scope.md) includes selected Higham correspondence
across Chapters 1–28, LeVeque finite-volume Chapter 1, Vershynin Chapters 1, 2
and 5, and Drineas–Mahoney RandNLA. The companion catalogue records Higham as
`maintenance`, Vershynin and LeVeque finite volume as `active`, and Greenbaum,
Saad, LeVeque finite differences, Krüger, Succi and Kettner et al. as
`not-started`. The finite-difference source contains only Chapters 1–4; kinetic
models remain `needs-source`. The separate finite-volume record's
`formalization.state = not-started` conflicts with its tracked Chapter 1 work;
that companion discrepancy is retained. These are not whole-book completion claims.

The LeVeque gate retains 47 rows: 1 PROVED, 23 READY and 23 SKIPPED. Its 26
completed faithfulness manifests include rejection outcomes. Original-owner
preservation passed again at 08:44:16 UTC: unchanged HEAD/index, all 6,878
starting files accounted for, including 5,310 Lean and 2,348 owner-untracked
files. Exactly 11 authorized Stage A existing-file changes and seven new files
remain; the saved patch is unchanged. All 2,127 frozen integration paths match
both working bytes and the baseline-to-tested-commit Git diff. See
[preservation evidence](validation.md#original-checkout-and-frozen-record-preservation).

## Validation

The table records results for the tested source commit, not a later final tip.
[Validation](validation.md) retains exact commands, authenticated artifact
identities, earlier failures, repairs and operational outcomes.

| Check | Exact command or procedure | Baseline | After | Evidence |
|---|---|---|---|---|
| Source/structural gates | [17 baseline commands](validation.md#exact-clean-baseline-commands); current 18-command [CI block](../../../.github/workflows/lean_action_ci.yml) | All 17 PASS | All 18 local checks PASS; current CI source gate PASS by 08:36:41 UTC | [Current CI evidence](validation.md#validated-source-commit-and-current-ci-evidence) |
| Exact source and old interfaces | [Preservation checker](verify_source_preservation.py), immutable map and narrow adjustment manifests; 27 adversarial checks | Exact baseline bytes | PASS; mathematical bodies/names and old forwarder contracts retained | [Source preservation](source-preservation.json), [adjustments](public-instance-name-adjustments.json) |
| Pins, owner work and frozen evidence | Compare pins, original HEAD/index/files, exact saved patch and 2,127 frozen paths | Saved original and clean integration snapshots | PASS at 08:44:16 UTC; no unauthorized owner/source changes | [Preservation](validation.md#original-checkout-and-frozen-record-preservation) |
| Full build | `lake build --quiet ComputationalMathematics NumStability NumStabilityTest` | [Baseline CI PASS](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/33990533439) | PASS, 08:36:41–12:37:42 UTC | [Run 34021942176](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021942176) |
| Tests and diagnostics | `lake test`; configured warning/lint capture and unchanged enforcement | Baseline CI PASS | Test PASS 12:38:18; warnings 12:42:26; lint 12:43:18; enforcement 12:43:20 UTC | [Current CI evidence](validation.md#validated-source-commit-and-current-ci-evidence) |
| Project-cache provenance | Inspect actual action input and cache restore/save log outcomes | Dependency cache permitted | PASS 12:48:01 UTC: input false at log line 207, restore 260–261 and save 871–872 skipped; official Mathlib cache used | [Current CI evidence](validation.md#validated-source-commit-and-current-ci-evidence) |
| Canonical/old/mixed behavior | Full in-repository fixture library plus mathematical applications, notation and instance checks | Existing coverage retained | PASS, including all adapted private-owner tests and explicit public-instance regression | [Fixture inventory](fixture-inventory.json), [CI](../../../.github/workflows/lean_action_ci.yml) |
| Git dependency and downstream package | Actual canonical-URL Git acquisition plus guarded `lake --keep-toolchain update`; separately `lake build Consumer` with exact source/13 fixtures/nine pins verified | Not applicable | Git resolution PASS 08:38:45; independent Linux consumer PASS by 12:45:08 UTC; identities match | [Git resolution](validation.md#current-candidate-git-acquisition-and-resolution), [authenticated CI](validation.md#validated-source-commit-and-current-ci-evidence) |
| Compiled declarations and dependencies | Unchanged format-2 extractor and strict mapped full-graph comparator | Cached baseline: 58,420 declarations; 269,218 signature and 386,408 body edges | PASS 12:46:37 UTC; zero removed/added/changed rows; zero authored project axioms | [Graph evidence](validation.md#validated-source-commit-and-current-ci-evidence) |
| Representative axioms | Seven exact `#print axioms` queries and authenticated identity checks | All seven use propext, Classical.choice, Quot.sound | PASS 12:46:36 UTC; all seven sets identical | [Identity and axiom evidence](validation.md#validated-source-commit-and-current-ci-evidence) |
| Supplemental Windows | Six initially clean targets; scoped 13-fixture local-path consumer; focused instance build; full native attempt | Cached baseline leaf for priority query | Focused/consumer checks PASS with stated scope; full native build intentionally stopped for disk, NOT COMPLETED | [Native limits and history](validation.md#runtime-segments-and-compiled-baseline) |
| Documentation and residual names | Scoped links/fences/whitespace and maintained-name audit | Existing policy and mathematical names retained | Reviewed active names corrected; historical/compatibility names retained | [Residual audit](validation.md#maintained-name-and-navigation-residual-audit) |
| GitHub and publication | Verify repository ID/redirects, then fast-forward and inspect exact main revision | Original repository ID 1327134933 | Rename verified; tested source branch published; final documentation/main publication recorded separately by SHA/tree | [Cutover](github-cutover.md), [execution](execution.md) |

## Intentionally retained old names

| Name or group | Reason retained |
|---|---|
| Stability, conditioning, backward error and Higham's book title | Mathematical meaning and source identity |
| `numStability`, `NumStabilityTest`, authored `NumStability.*` names | Explicit public-interface contract |
| `NumStability.instFactLtRealOfNat_numStability` | Original public instance, preserved by source and compiled checks |
| All 3,198 old module imports | Forwarding compatibility; no removal release authorized |
| Source IDs, theorem numbers and historical paths/hashes | Immutable provenance and recorded audit decisions |
| `AlexGeorgantzas/lean-numerical-stability` | Distinct upstream repository/history |
| Former organization slug in cutover observations | Accurate redirect/preflight history; keep the former slug unused |

The [rename map](rename-map.md) classifies these uses. The bounded residual audit
covered 29 maintained docs/configurations and classified nine retained branding
occurrences; it does not assert absence of every old identifier across the repo.

## Internal interface decision

Lake package `numStability`, test root `NumStabilityTest` and authored declaration
namespaces remain unchanged. `ComputationalMathematics` is the canonical module
root; `NumStability` remains the forwarding library. These are distinct interfaces,
not a duplicated declaration/instance layer. Lean `4.29.0-rc3`, Mathlib
`e8ea1afc32790ce1d4e1a4e45cc412ba9388716b` and all nine pins are unchanged.
The exact map SHA-256 is `cbd53b282d8832245bb58b4c0d56958b6f15fb4810fd5da9cf748f24948429d5`.
[Internal migration and recovery](internal-migration.md) explains usage and inverse recovery.

## GitHub and external status

The repository is [`VSCL-x-VERITAS/lean-computational-mathematics`](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics),
with unchanged ID `1327134933`, node `R_kgDOTxp41Q` and fork parent `1171530090`.
Rename, old-URL redirect and new `origin` were verified on 2026-09-06; active
README/citation/badge/clone/dependency links use the new identity. The tested
source commit passed the complete manual run; its authenticated artifact is
`9989557173`, SHA-256 `186d3495933536865797f15663e8c5165a7ebc3136eceaa2b02819cf46ebca40`.

No hosted action, reusable workflow, Pages/site deployment or package-publishing
configuration was found in the inspected checkout. Full GitHub App grants,
private consumers and external registry/cloud settings remain owner-visible
unknowns; no deployed-site or universal external compatibility claim is made.
The [cutover inventory](github-cutover.md#integration-inventory-and-treatment)
records observed settings, verification owners and recovery actions.

## Limitations and remaining actions

- The external publication receipt identifies the final documentation revision,
  its exact SHA/tree, non-force publication and applicable checks. Do not attribute the tested source run to a later SHA.
- The comparison baseline used cached Windows objects, supplemented by verified
  baseline CI; it was not a clean local baseline build. Format-2 graph equality
  covers authored project declarations and signature/body edges. Axiom comparison
  covers seven representatives; it is not a new all-declaration axiom audit.
- Actual Git acquisition/resolution and Linux local-path consumer compilation
  are distinct checks tied by exact source/fixture/pin identity. The 13 fixtures
  establish covered behavior, not all possible downstream programs.
- The supplemental full Windows build was intentionally incomplete for disk
  headroom. Focused Windows passes do not turn that attempt into a full build.
  Bounded cleanup/compression preserved owner files and evidence; detailed
  operational results remain in [validation](validation.md).
- Frozen faithfulness/source audits retain their original hashes and outcomes;
  external source PDFs, companion tools and private integrations were not
  re-audited. Catalogue discrepancies and coverage limits remain explicit.
