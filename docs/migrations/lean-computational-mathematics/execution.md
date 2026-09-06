# Migration execution record

Stages A/B are implemented and validated. GitHub identity is **POST_CUTOVER**.
This record identifies the tested source revision; the final documentation
commit and main publication are verified in a separate external receipt and
delivery response, without attributing this run to a different final SHA.

| Event | Observed status / evidence |
|---|---|
| Integration | Clean baseline `718beac641a8094611dc249c3508a2f5415381a3`, 11,225 tracked files; original dirty `d602405c...` checkout preserved separately, 136 commits behind |
| Identity/interfaces | Lean Computational Mathematics; 2,401 canonical modules and 3,198 retained old imports; package `numStability`, test root and authored names retained |
| Source preservation | PASS: exact map plus recorded import ordering, forwarder header, private-test adapters and original public-instance name; 27 adversarial checks; [report](source-preservation.json) |
| Source gates | Baseline 17 PASS; migrated 18 PASS, including current clean CI through 08:36:41 UTC; 14,236 Lean paths |
| Validated source commit | `51c5540984780b0011f41739b9ddaf8e505b7c93`, tree `20298c7b62a6e75c6b4beba46c8b517d7d86f4fb`, published on `codex/computational-mathematics-cutover` |
| Complete clean CI | [Run 34021942176](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021942176), attempt 1/job 101456009191, SUCCESS at 12:45:10 UTC; elapsed 4h16m41s |
| Full libraries/test | `ComputationalMathematics`, `NumStability`, `NumStabilityTest` build PASS 12:37:42 UTC; `lake test` PASS 12:38:18 UTC |
| Diagnostic enforcement | Warning PASS 12:42:26 UTC, lint PASS 12:43:18 UTC, final enforcement PASS 12:43:20 UTC; existing ratchets retained |
| Actual clean-cache proof | PASS 12:48:01 UTC: false action input line 207, restore 260–261 and save 871–872 skipped; permitted official Mathlib cache fetched 8,033 files |
| Git acquisition/resolution | Exact 51c source/tree, nine pins, 13 fixtures and ten checkout identities verified at 08:38:45/08:39:00 UTC; this separate acquisition did not compile the consumer |
| Independent downstream | Linux 13-fixture Consumer update/build PASS by 12:45:08 UTC; authenticated source/fixture/pin identities match the exact Git-resolution result |
| Artifact authentication | ID 9989557173; archive SHA-256 `186d3495933536865797f15663e8c5165a7ebc3136eceaa2b02819cf46ebca40`; all 18 files match sizes/hashes |
| Identity/axioms | PASS 12:46:36 UTC: exact commit/tree/extractor/compiler/nine pins/13 fixtures and seven identical representative axiom sets |
| Strict compiled graph | PASS 12:46:37 UTC: 58,420 declarations, 269,218 signature edges, 386,408 body edges, zero authored project axioms; zero removed/added/changed rows |
| Public-instance repair | Original name/type/priority/inference preserved; focused runtime and full in-repository tests PASS; strict graph now equal without a public-name normalizer exception |
| Original/frozen preservation | PASS 08:44:16 UTC: original HEAD/index unchanged; 6,878 starting files accounted, including 5,310 Lean and 2,348 owner-untracked; 2,127 frozen paths unchanged as working bytes and baseline-to-51c Git diff |
| Supplemental Windows | Six representative clean targets and scoped consumer/instance checks PASS. Full native attempt intentionally stopped for disk, NOT COMPLETED; raw operational exits retained |
| Space recovery | Bounded temporary-clone cleanup and lossless owned-file compression passed preservation checks; detailed measured scope and concurrent-allocation caveats remain in [validation](validation.md#runtime-segments-and-compiled-baseline) |
| GitHub rename | EXECUTED and verified 01:25:22 UTC: canonical `VSCL-x-VERITAS/lean-computational-mathematics`, ID 1327134933, node `R_kgDOTxp41Q`, parent 1171530090, default branch main |
| Redirect/current links | Old HTML URL returned 301 to new; old/new Git reads matched after rename; integration origin and active URLs use new slug; historical observations retained |
| Final documentation/main publication | Separate from validated source `51c5540`; exact final SHA/tree, non-force publication and applicable tip checks are recorded in the external publication receipt/delivery |
| External settings | Inspected integrations and owner-visible unknowns recorded in [cutover inventory](github-cutover.md#integration-inventory-and-treatment); no universal external-service claim |

[Current validation evidence](validation.md#validated-source-commit-and-current-ci-evidence)
binds the successful run, artifact and comparisons. Earlier failed/canceled runs,
native interruptions and cached-baseline qualifications remain explicitly
historical in [validation](validation.md); their raw evidence is retained.

## Completion and recovery

The publication receipt must distinguish the clean-tested implementation from
any later documentation-only revision. A badge or successful earlier run does
not certify a different SHA. Refresh remote state before a non-force main update
and verify the actual published revision and its applicable checks afterward.

A Git revert cannot undo the GitHub rename. Follow the [internal recovery](internal-migration.md#internal-recovery)
and [external recovery](github-cutover.md#recovery) procedures, preserving original
owner work, later changes, dependency pins and immutable evidence.
