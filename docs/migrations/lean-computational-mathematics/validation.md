# Validation record

## Validated source commit and current CI evidence

All implementation acceptance checks passed for source commit
`51c5540984780b0011f41739b9ddaf8e505b7c93`, tree
`20298c7b62a6e75c6b4beba46c8b517d7d86f4fb`.
[Clean run 34021942176](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021942176),
attempt 1/job 101456009191, completed SUCCESS on 2026-09-06 at 12:45:10 UTC
(4h16m41s). The final documentation commit/publication receipt is separate;
this run is not attributed to a later tip. Historical failures below remain
unchanged evidence of their own attempts, not unresolved current failures.

| Current step | UTC interval / result |
|---|---|
| Source architecture/tooling | 08:28:57–08:36:41, PASS |
| `lake build --quiet ComputationalMathematics NumStability NumStabilityTest` | 08:36:41–12:37:42, PASS |
| `lake test` | 12:37:42–12:38:18, PASS |
| Warning baseline | 12:38:18–12:42:26, PASS |
| Lint baseline | 12:42:26–12:43:18, PASS |
| Diagnostic upload / final enforcement | 12:43:18–12:43:20, PASS |
| Compiled graph, seven axiom queries and independent Consumer update/build | 12:43:20–12:45:08, PASS |
| Comparison-evidence upload | 12:45:08–12:45:09, PASS |

Authenticated artifact **9989557173** has archive SHA-256
`186d3495933536865797f15663e8c5165a7ebc3136eceaa2b02819cf46ebca40`.
The acquisition directory under the local evidence root is
`ci-candidate-51c5540/acquisitions/20260906T124538Z-ef3167ea/`.
All ten required steps succeeded and all 18 artifact files match recorded sizes
and hashes. Exact run/job/attempt/repository/source bindings are in
`provenance.json`, SHA-256
`d706630b8cded1abbb16e1c37c9c05218b283d8c464b3811bb72c7e0abaec537`.
Its collector-time cache-pending label is resolved by the separate actual-log
review below; the original record was not rewritten.

`identity-and-axiom-verification.json` passed at 12:46:36 UTC, SHA-256
`8a0b60ff1f2234613522df6f08cabd53c11e95b9ab3e031745428bc5be5ddafa`.
It verifies the exact commit/tree/compiler/extractor, all nine dependency pins,
all 13 canonical/old/mixed consumer fixture hashes and successful consumer
artifacts. All seven representative axiom sets equal the baseline:
`propext`, `Classical.choice`, `Quot.sound`. The actual Git requirement was
resolved separately at this exact commit; the Linux local-path consumer build
is bound to that same source/fixture/pin identity, rather than being described
as a native Git-consumer compile.

The unchanged strict comparator produced PASS at 12:46:37 UTC in
`full-graph-comparison.json`, SHA-256
`b2a5cfc23aa4c233f7a84566bcd41dea1a81f659965f81a17240d52c30578bdf`.
Both mapped graphs have 58,420 declarations, 269,218 signature edges, 386,408
body edges and zero authored project axioms. Every removed/added/changed count
is zero. The public-instance discrepancy is resolved by preserving the original
name in source, with no comparator exception; the earlier strict FAIL remains
recorded. This is format-2 authored-declaration and dependency-edge equality,
not an unrecorded fingerprint or all-generated-axiom check. The cached Windows
baseline and seven-representative axiom limits remain below.

Independent `cache-provenance-review.json` passed at 12:48:01 UTC, SHA-256
`9eec1371c08b0360728ca3a475faa461bdcdc36e88f42ecccdf063107ad3fb93`.
The actual job log has `use-github-cache: false` at line 207 within action group
203–222; the matched project restore at 260–261 and save at 871–872 both skipped.
The permitted official Mathlib cache actually fetched 8,033 files. Raw job-log
SHA-256 is `6d8f2c603fb8bb357ad4dca81e0a62c9d7e2a51e5ff7728c7fdee6663dc41704`.
This establishes fresh project build provenance without requiring fresh builds
of Mathlib dependencies.

A read-only prepublication review at 12:48:34 UTC verified that all 14,236
source/test files (86,869,580 raw bytes), core configurations, five adjustment/map
manifests and 2,846 fixture-inventory entries match the tested 51c source. Only
the eight reviewed prose paths differed. Local
`prepublication-worktree-reviews/20260906T124828Z-23b7a806/review.json` has SHA-256
`18e37aef2a3da0c65e8f7ce1abdffd12b46a65fb2540588f58c5883c289dc45d`.
The final documentation commit still needs its own exact tree/publication
receipt; this earlier boundary check does not invent a final commit SHA.

## Baseline separation

The original dirty checkout was based on `d602405cdd2a25915e5ba09dfd542886f4f9e2fa`.
Its earlier source checks had pre-existing failures, and its attempted full
build ultimately encountered a full system disk. Those results are neither a
regression caused by branding nor a green baseline for the authorized internal
migration.

The isolated integration checkout began clean at
`718beac641a8094611dc249c3508a2f5415381a3`. Its 11,225 tracked files were
snapshotted before editing at 2026-09-06 00:52:30 UTC. The complete configured
17-command source/structural baseline passed between 00:52:30 and 01:04:12 UTC.
This is source validation, not a claim that the compiler/consumer matrix passed.

Local raw evidence is in
`C:/Users/qed_s/AppData/Local/Temp/lean-computational-mathematics-stage-bc-20260906/`:
`baseline-main.json`, `main-baseline-checks.json` and
`main-baseline-check-00.log` through `main-baseline-check-16.log`.
The table below preserves exact commands and outcomes for repository readers;
raw local logs are not part of the published patch.

## Exact clean-baseline commands

| Log number | Command | Baseline result |
|---|---|---|
| 00 | `python -m py_compile tools/architecture/generate_baseline.py tools/architecture/check_compatibility.py tools/architecture/check_layout.py tools/architecture/check_phase.py tools/architecture/check_phase_projection.py tools/architecture/check_completion_phase_projection.py tools/architecture/check_completion_phase.py tools/architecture/check_warnings.py tools/architecture/check_lint.py tools/architecture/check_provenance.py tools/architecture/normalize_apache_notices.py tools/architecture/sort_aggregate_imports.py tools/benchmark/run.py` | PASS (exit 0) |
| 01 | `python tools/architecture/check_phase.py --self-test` | PASS (exit 0) |
| 02 | `python tools/architecture/check_phase_projection.py --self-test` | PASS (exit 0) |
| 03 | `python tools/architecture/check_completion_phase_projection.py --self-test` | PASS (exit 0) |
| 04 | `python tools/architecture/check_completion_phase.py --self-test` | PASS (exit 0) |
| 05 | `python tools/architecture/check_warnings.py --self-test` | PASS (exit 0) |
| 06 | `python tools/architecture/check_lint.py --self-test` | PASS (exit 0) |
| 07 | `python tools/architecture/check_phase.py --all-phases` | PASS (exit 0) |
| 08 | `python tools/architecture/check_completion_phase.py` | PASS (exit 0) |
| 09 | `python tools/architecture/check_layout.py` | PASS (exit 0) |
| 10 | `python tools/architecture/check_tiers.py --self-test` | PASS (exit 0) |
| 11 | `python tools/architecture/check_tiers.py` | PASS (exit 0) |
| 12 | `python tools/architecture/check_placeholders.py --self-test` | PASS (exit 0) |
| 13 | `python tools/architecture/check_placeholders.py` | PASS (exit 0) |
| 14 | `python tools/architecture/check_compatibility.py` | PASS (exit 0) |
| 15 | `python tools/architecture/check_provenance.py` | PASS (exit 0) |
| 16 | `python tools/architecture/generate_baseline.py --skip-declarations --strict-source --output-dir benchmark-results/ci-architecture --name source` | PASS (exit 0) |

## Migration validation matrix

| Check | Required procedure | Current recorded result |
|---|---|---|
| Public documentation | Scoped links/fences/whitespace and comparison with retained policy/mathematical prose | Maintained identity/navigation reviewed; final documentation revision verified separately from the tested source |
| Source preservation | [Exact checker](verify_source_preservation.py), immutable map and adjustment manifests | PASS 08:18:00 UTC; mathematical bodies/names preserved, exact public-instance insertion and fixed test included; 27 adversarial cases PASS |
| Pins and identities | Compare toolchain/manifest/package/test/declaration identities | PASS; all nine pins and exact source/consumer identities authenticated |
| Original owner/frozen records | Baseline hash/index/patch and frozen-path comparison | PASS 08:44:16 UTC; [scope](#original-checkout-and-frozen-record-preservation) |
| Source gates | 17 baseline commands; current canonical-aware 18-command block | All PASS locally and in current CI |
| Full libraries/test | Build all three libraries; `lake test` | PASS current 51c build 12:37:42 UTC and test 12:38:18 UTC |
| Warning/lint enforcement | Configured log capture and unchanged diagnostic ratchets | PASS through 12:43:20 UTC |
| Canonical/old/mixed compatibility | Compile full in-repository fixture library and independent mathematical-use/notation/instance fixtures | PASS; covered behavior, not universal client compatibility |
| Independent downstream | 13-fixture Consumer update/build at exact source with pins verified | PASS by 12:45:08 UTC; authenticated with separate actual Git acquisition/resolution |
| Documented Git dependency | Actual canonical-URL Git fetch and guarded Lake resolution | PASS for exact51c at 08:38:45 UTC; that separate workspace did not compile the consumer |
| Clean project artifacts | Actual action input and matched cache restore/save logs | PASS 12:48:01 UTC; project restore/save skipped, official Mathlib cache permitted and used |
| Compiled graph | Strict exact-map format-2 comparison | PASS 12:46:37 UTC; 58,420 declarations, 269,218 signature / 386,408 body edges, zero row differences and zero authored project axioms |
| Representative axioms | Seven authenticated baseline/current `#print axioms` comparisons | PASS 12:46:36 UTC; all seven sets identical |
| Supplemental Windows | Representative clean targets, scoped local-path consumer and focused instance build | Scoped PASS; full native attempt intentionally NOT COMPLETED for disk. Historical raw exits retained |
| GitHub/publication | Verify canonical repository ID/redirects and exact published revision | POST_CUTOVER identity and tested source publication verified; final documentation/main receipt remains a separate verification record |


Diagnostic manifest path updates must follow the exact migration mapping and
retain their substantive diagnostic identities and ceilings. Do not regenerate
baselines solely to silence new findings. Compatibility files and fixtures are
reported separately from canonical mathematical code; larger file counts do
not represent additional formalized results.

The migration adds an optional manual CI input, `clean_project` (default
`false`). With `clean_project=true`, the workflow does not restore the
lean-action project cache; the official Mathlib dependency cache remains
available. This provides a Linux build of fresh project artifacts for the
exact candidate. Default push/PR checks, check names and the 360-minute build
ceiling are retained. The candidate `abceba9f3f45f5432ed24ed9ba3902f7bd5d5bbf` was dispatched
with this input at 2026-09-06 01:33:51 UTC. [Run 34004222002](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34004222002)
finished FAILURE at 04:14:16 UTC. The library/test build failed at 04:14:13;
`lake test`, diagnostics, candidate compiled graph/axiom capture and the
independent consumer stages were skipped. Repaired candidate
`feb121c8813abc72f6e6ea1f419e8fe5427dfb43` was published subsequently. Its
[clean run 34012018278](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34012018278)
was created at 04:38:41 UTC with `clean_project=true`. Build/test/diagnostics
passed, but its consumer setup failed and the job ended FAILURE at 08:03:54 UTC;
see the [recorded outcome](#repaired-candidate-buildtest-success-and-consumer-setup-failure).

After the ordinary build, test and diagnostic gates succeed, this manual mode
runs the existing format-2 declaration extractor and its self-test, generates
a compiled summary, and captures `#print axioms` for seven representative
declarations. The axiom output is evidence for review, not an additional claim
that every declaration in the library was independently re-audited.

It also builds a separate `Consumer` library from 13 focused fixtures: six
canonical/old import pairs and one mixed-import test. Its Lake package requires
`numStability` from the exact checked-out `GITHUB_SHA` via a local path, checks
the inherited toolchain and all transitive Git dependency revisions, and builds
its own consumer artifacts. The CI consumer uses a local-path dependency. The
separate external runner fetched the canonical Git URL and prior candidate
`abceba9f...` at 01:59:11 UTC, verifying Git tree
`846cff7bc2cdd5e6918a9af77240db8e7d54e7ec` and unchanged shared dependency
checkout state. Evidence is `git-consumer/acquisition-result.json` in the local evidence
directory. Lake Git-requirement resolution then passed at 02:12:47 UTC using
`lake --keep-toolchain update` and the pinned Mathlib hook’s verified
`MATHLIB_NO_CACHE_ON_UPDATE=1` control. Its `resolution-result.json` verifies
the exact candidate/tree, package identity `numStability`, unchanged toolchain,
all nine transitive Git URL/revision pairs and preserved shared checkout state.
Consumer compilation is still `NOT_RUN` in that result. The acquisition and
resolution evidence can be combined with the same-source CI consumer build
only with matching candidate and fixture hashes. At that earlier stage,
downstream behavior was not established. Those Git records cover
`abceba9f...` only. A fresh acquisition and Lake resolution for `feb121c8...`
passed at 04:43:31 UTC (exit 0, 44.922 seconds), independently verifying tree
`4887a721274aeff20bc632ce61fb000ab792933f`, all nine dependency pins and all
13 consumer fixture hashes. Its final review completed at 04:44:04 UTC; local
`git-consumer-repaired/final-resolution-review.json` has SHA-256
`74630f49088681f90705cd91bf9f7e8f84bb36ab1a9f5837bf41215122c389ee`.
Compilation is explicitly `NOT_RUN` in that earlier Git-resolution workspace;
the feb Linux consumer setup subsequently failed before compilation, as recorded
below. The current 51c Git/CI checks are separately successful.

After the repaired Git resolution passed, guarded cleanup finished at
04:47:11 UTC and removed only `C:/Users/qed_s/lcgc2/.lake/packages`:
25,815 temporary files, 527,056,241 logical bytes. Independent verification
at 04:47:35 UTC confirmed that 19 retained consumer files, 17 existing evidence
files and all nine shared dependency states were unchanged. Local evidence is
`git-consumer-repaired/package-cleanup-result.json` (SHA-256
`452f62b2fcbb63c24fd311e11eb5fed77c12f5b60f7dacdf6c0c3a783e781775`)
and `package-cleanup-verification.json` in that same directory. Observed free
space changed from 2,199,367,680 to 2,771,632,128 bytes; concurrent processes
can affect that net change. The disposable package working copies are gone;
configuration, fixtures and successful acquisition/resolution evidence remain.
No compilation occurred during cleanup. The later feb build/test/diagnostic
gates passed before its consumer setup failed. Current 51c complete validation
is recorded at the start of this document.

The compressed declaration graph, consumer
configuration and logs are uploaded for 14 days. This extends the optional
manual evidence run; it does not replace any original diagnostic gate.

The one-time migration source-preservation checker remains part of this
migration's evidence. It is deliberately not run by generic future clean CI,
so later mathematical development is not frozen to this migration snapshot.

## Representative build and migration findings

The representative clean build returned exit 0 with this exact command:

```powershell
lake --no-ansi build ComputationalMathematics.FloatingPoint.Model ComputationalMathematics.Analysis.Stability ComputationalMathematics.Analysis.Probability.Gaussian.AbsoluteMoment ComputationalMathematics.Source.Vershynin.Chapter02.Section02.Theorem06 ComputationalMathematics.Source.LeVeque.Chapter01.Equation03AdvectedProfile ComputationalMathematics.Analysis.MatrixAlgebra
```

Its local evidence is `migrated-targeted-build.json` and
`migrated-targeted-build.log` in the evidence directory above. The subsequent
full build includes both libraries and the test library; its result is separate.

The historical repaired source-gate result is `repaired-source-checks.json`: all 18
commands passed at 04:35:50 UTC after the repairs. It scanned 14,235 Lean
files with no `sorry`, `admit` or unreviewed project axiom. That snapshot
summary is `repaired-ci-architecture/source.json` and `source.md`. The earlier
`migrated-source-checks-final.json` records the first complete source pass after
the corrective layout check; its initial failure and logs remain preserved.
The 17-command clean baseline and both 18-command suites are distinct records.

The first migrated source-gate pass identified one aggregate ordering change
required by the new root: `ComputationalMathematics` sorts before `Mathlib`,
where `NumStability` had sorted after it. The reviewed correction is limited to
permuting the same 14 imports in
`ComputationalMathematics.Source.Higham.Chapter14.Problem14`. The [adjustment manifest](import-order-adjustments.json) records the exact
permutation and before/after/header/body hashes. The revised preservation
check passed at 01:23:21 UTC, including this sole ordering adjustment; all
other canonical bytes outside mapped import tokens are unchanged. The
mathematical body and old forwarder of this aggregate are unchanged.

Four pre-existing trailing spaces in canonical
`Source.Higham.Chapter22.VandermondeSystems` (lines 3425, 3874, 3881 and 8005)
are retained by the exact-source comparison. Eight newly generated fixtures
had trailing blank lines trimmed. The module map has an exact-path
`.gitattributes` `-text` exception to retain its original CRLF bytes; its staged
blob SHA-256 remains the recorded `cbd53b...` hash.

## Candidate CI failure under repair

Run 34004222002 for `abceba9f3f45f5432ed24ed9ba3902f7bd5d5bbf` is terminal
FAILURE. Its source/Python gate passed, but `Build library and smoke tests`
failed at 2026-09-06 04:14:13 UTC; the job completed at 04:14:16 UTC. Later
`lake test`, warning/lint, compiled graph/axiom and independent consumer steps
were skipped. The failed attempt's metadata and logs are retained locally in
`ci-candidate-abceba9/failed-run-34004222002-attempt-1/`.

The two identified migration defects were repaired and committed in
`feb121c8813abc72f6e6ea1f419e8fe5427dfb43`, tree
`4887a721274aeff20bc632ce61fb000ab792933f`. The
[forwarder-header adjustment](forwarder-header-adjustments.json) moves the
sole affected generated import before the unchanged module documentation and
license notice. An independent 2,401-forwarder census/protection review passed.
A pinned-parser reproduction replacing the imported dependency with `Init`
failed before and passed after at 04:19:44 UTC; this tests header parsing only.

The [live private-name adjustment](live-private-name-adjustments.json) binds
21 insertion-only test adaptations retaining all original production imports,
public probes, 1,153 approved entries and 1,079 retired entries. The adapter
uses 152 exact owner pairs (146 approved owners and six retired-only owners),
and adds 51 canonical retired-name absence checks without removing the
original absence checks. It adds one helper, one standalone probe and a second
added test-root import. The remaining 5,768 existing test files are byte-identical;
authority content is preserved across all 5,789 existing test files.

The pre-instance-fix [combined preservation record](source-preservation.json)
passed at 04:31:03 UTC and binds the forwarder/private-test adjustment hashes. Original authority manifests
and earlier raw/Git evidence remain retained. The pinned adapter leaf build
passed at 04:28:02 UTC (three jobs, 10.61 seconds); its first small probe had
failed because of reserved-prefix local binders, and that failed evidence is
retained. Only local probe binders were corrected. Local evidence is under
`forwarder-header-parser-probe/`, `private-owner-adapter-runtime02/` and
`private-normalization-fix/`. These focused probes do not establish compilation
of all 21 adapted fixtures or the full library/consumer matrix.

All 18 repaired source gates passed at 04:35:50 UTC. The replacement clean
CI run 34012018278, created 04:38:41 UTC and started 04:38:45 UTC, is bound to
`feb121c8...`; its build/test/diagnostic gates subsequently passed before the
consumer-setup failure below. Earlier baseline/source passes alone did not
establish that compiled result. The native Windows disk stop remains a separate
operational outcome and does not reclassify either CI failure.

## Repaired candidate build/test success and consumer setup failure

Run 34012018278, attempt 1, job 101429376399 is terminal FAILURE for exact
`feb121c8813abc72f6e6ea1f419e8fe5427dfb43`. Saved `job.json` confirms the clean
three-library build passed at 07:58:13 UTC, `lake test` at 07:58:43 UTC, warning
baseline at 08:01:44 UTC, lint baseline at 08:02:23 UTC and final diagnostic
enforcement at 08:02:25 UTC. These are successful in-repository build/test and
diagnostic results, including the existing and migrated regression fixtures.
Actual clean-project provenance is separately recorded in
`cache-provenance-review.json`: `use-github-cache: false` at log line 196,
matched restore action skipped at 249–250 and save action skipped at 834–835.
The official Mathlib dependency cache remained enabled.

The subsequent combined graph/consumer step failed at 08:03:51 UTC. Its log
shows extractor self-test success and generated `compiled.json`/`compiled.md`
at 08:03:37 UTC, followed by failure during the consumer's `lake update`.
Mathlib's post-update cache hook could not prune the missing relative path
`.lake/packages/proofwidgets/.lake/build/lib`. Consumer compilation was not
reached. The partial clean-evidence upload succeeded at 08:03:52 UTC and the
job ended FAILURE at 08:03:54 UTC. Its authenticated artifact was later inspected: core bindings and seven axiom
sets matched, while strict full-graph comparison failed on a public instance
name. That failure and its explicit repair are recorded below. Consumer
completion and remaining acceptance were outstanding at that point; both
subsequently passed for 51c55409.

Raw evidence is retained in
`ci-candidate-feb121c/failed-run-34012018278-attempt-1/`: `run.json`, `job.json`,
`job.log` and `capture.json`. The log SHA-256 is
`94e2553ea461d27244997121caf3c8444541a29e99e1fdebfd112cc77e595489`;
lines 2322457–2322466 record the extractor output and actual setup failure.
The earlier `build-test-milestone-20260906T080023Z/` snapshot remains a
historical milestone, superseded for terminal status by the failed-job record.
This is a downstream setup failure, not a failed library proof or a passing
full workflow. Its replacement workflow runs are recorded below; final
documentation/main publication is identified by its separate receipt.

## Consumer-update workflow fix and current run

Previous candidate `e42535d9a8e0522e6e6d9f866a3ed4e59b0ad94e`, tree
`f175754be9cf3bbd91490ad05e2f7e864615a7b9`, changes only one consumer-update
command and its explanatory comment in `.github/workflows/lean_action_ci.yml`.
The command is now `MATHLIB_NO_CACHE_ON_UPDATE=1 lake --keep-toolchain update`,
using the verified pinned Mathlib hook control while reusing dependencies
already built by this job. Lean sources, Lake/package configuration, all pins,
fixtures and all other workflow fields are unchanged from `feb121c8...`.

`consumer-cache-guard-validation/result.json` records PASS at 08:07:41 UTC for
the exact diff, YAML, Bash syntax and both embedded Python blocks. The workflow
SHA-256 is `9dad1600ac365ecb1b6179554cb4f55b0a81d82e2a080c916db372250bff9459`.
These are static checks, not a runtime result. New clean
[run 34021018603](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021018603), attempt 1, job 101453496296,
was created at 08:08:14 UTC and canceled during the architecture gate after
5m25s because it shares the generated-instance regression found in the feb
graph. Watcher 66361 is terminal; the new repair run is recorded below. A fresh bounded
Windows 13-fixture consumer compiled successfully; its scoped adjudication is
recorded below. Its 22-module closure excludes AddCircle and does not validate
this separate public-instance fix.

Current candidate `51c5540984780b0011f41739b9ddaf8e505b7c93`, tree
`20298c7b62a6e75c6b4beba46c8b517d7d86f4fb`, publishes the seven-file exact-instance
repair (213 insertions, 14 deletions). All 18 source checks passed during
08:19:11–08:26:38 UTC: local `public-instance-source-checks.json` records the
exact commands and logs. The resulting `public-instance-ci-architecture/source.json`
has normalized source SHA-256
`915ed2d52ada797abca1e37d5d7c8f35bcbf3bad2f30c7a6b1c282b3cc32d819`;
the source census covers 14,236 Lean paths. Production counts remain 5,599
modules, 1,503,619 nonblank lines and 47,223 imports.
[Clean run 34021942176](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/actions/runs/34021942176), attempt 1/job 101456009191, was created at
08:28:24 UTC and started at 08:28:29 UTC. It completed SUCCESS at 12:45:10 UTC,
with strict comparison PASS at 12:46:37 UTC and actual cache proof PASS at
12:48:01 UTC. Fresh exact-candidate Git acquisition/resolution passed below.

## Original checkout and frozen-record preservation

The read-only refresh at 08:44:16 UTC passed for candidate `51c55409...`.
Original HEAD/index were unchanged; all 6,878 starting files were accounted
for, including 5,310 Lean files and 2,348 owner-untracked files. Source and pins
were preserved. The only original-checkout differences remain the authorized
Stage A changes to 11 existing files and seven new files. The recreated Stage A
patch matched its saved SHA-256 `cae34570d902d6a0911cab4b95902cee8a206288e8e827fb6b54a6d15aa35ee3`;
its reverse `git apply --check` returned exit 0 without applying it.

All 2,127 frozen integration paths matched their baseline working bytes, with
no Git changes from `718beac...` to `51c55409...`. Local evidence
`original-preservation-refreshes/20260906T084259Z-c79bf2af/preservation-refresh.json`
has SHA-256 `51875b08c2dd6b9f1f8b364ca7bd9d625248bdf1f7209dacc22ccd8ef3dc4238`.
The earlier preservation records remain intact. This check performed no source
writes, cleanup or builds and is separate from compiled/CI acceptance.

## Current candidate Git acquisition and resolution

The documented Git dependency at exact candidate `51c55409...` was acquired and
resolved with `MATHLIB_NO_CACHE_ON_UPDATE=1 lake --keep-toolchain update`, passing
at 08:38:45 UTC. Independent postchecks passed at 08:39:00 UTC. Local
`git-consumer-51c5540/final-resolution-review.json` has SHA-256
`87892d7949c20a60a3355058c394f982cfebdcb4e4b3b8463f87adde65c339de`;
`resolution-result.json` has SHA-256
`92ac4b052cb49ce76ce44b4c3b6505c70ee74b62063ba8de2c054c5f773f008e`.
These verify exact tree `20298c7b62a6e75c6b4beba46c8b517d7d86f4fb`, nine
transitive pins, 13 fixture hashes, all ten checkout identities and shared
source/configuration/compiled-metadata preservation. All 18 initial consumer
files were preserved; the resulting actual manifest makes 19 root/fixture files.
All 11 consumer/package build directories remained absent. **Compilation was
NOT RUN** in that workspace; the separate same-source Linux Consumer build
succeeded in run 34021942176, and authenticated identity checks bind the two.
This preserves the distinction between Git acquisition and local-path compilation.

Owned `lcgc3/.lake/packages` was compressed losslessly at 08:37:49 UTC before
resolution: 25,779 files and 410,868,459 logical bytes retained identical names,
lengths and content; ten checkout states, existing evidence and shared dependency
states were preserved. `package-compression-result.json` records PASS. The later
resolution created 116,203,571 additional logical bytes, mainly a 111,214,648-byte
Git pack. The 08:39:49 UTC storage snapshot observed 2,132,385,792 free bytes;
net free-volume changes may include other processes. Local
`post-resolution-storage.json` has SHA-256
`ec847a927f61ad9cd6526060f0d13af4b86a6be8d26fda3912bde562c96df935`.
No further native compilation is recorded; this space measure does not close
any remaining runtime acceptance requirement.

## Strict graph failure and explicit public-instance repair

Authenticated partial artifact evidence is retained under
`ci-candidate-feb121c/partial-failed-acquisitions/20260906T081155Z-fc5ca0e9/`.
`partial-core-and-axiom-verification.json` passed its limited checks at
08:13:58 UTC: exact feb candidate/tree, extractor/toolchain, nine dependency
pins, 13 fixture hashes and all seven baseline axiom sets. Each set is exactly
`propext`, `Classical.choice`, `Quot.sound`. The failed workflow and absent
consumer completion files remain explicit; fixture identity is not compilation.

`full-graph-comparison.json` returned FAIL at 08:12:42 UTC. Both graphs have
58,420 declarations, 269,218 signature edges and 386,408 body edges, with zero
authored project axioms. The sole removed/added public declaration is
`NumStability.instFactLtRealOfNat_numStability` versus
`NumStability.instFactLtRealOfNat_computationalMathematics`; 13 signature and
16 body edges change only their endpoint to that instance. Equal counts do not
establish interface preservation, and the strict failure is retained.

The local repair explicitly names the original instance in
[AddCircle](../../../ComputationalMathematics/Analysis/Equidistribution/AddCircle.lean),
leaving its type and proof unchanged. A new `GeneratedInstanceName.lean` focused
test and one test-root import accompany it. The
[exact adjustment manifest](public-instance-name-adjustments.json) and updated
preservation checker passed at 08:18:00 UTC, with all 27 adversarial cases.
The manifest permits only the 33-byte name/space insertion at byte 733, leaving
type, proof, attributes, registration and other file bytes unchanged. It also
binds the fixed new test and third root import; the generated-file inventory
now contains 2,846 entries. Independent static review passed. Current source
evidence is external `generated-instance-name-fix/source-preservation-with-public-instance.json`
(SHA-256 `093e20037fcd5d839107ae56e5a8bca72a9081b03d96358130ca986a9b1d29b4`),
with `implementation-review.json` in the same directory. The tracked source
report was refreshed at 08:25:47 UTC with its prior raw/Git versions preserved.
All 18 renewed source gates passed at 08:26:38 UTC; the repair is committed
and published as `51c55409...`. Strict full-graph verification passed at
12:46:37 UTC, resolving this interface gap. No public-name normalization
exception was introduced; earlier source/build/test/diagnostic results remain
valid only for their recorded snapshots.

The focused Windows regression passed at 08:22:30 UTC. Its cached-baseline leaf
query returned priority 1000; the new test checked the original public name and
type, replacement-name absence, priority, Fact inference, and old/canonical
imports. `lake --no-ansi build NumStabilityTest.Import.ProjectIdentity.GeneratedInstanceName`
returned exit 0, building canonical AddCircle, its old forwarder and the test.
All three source hashes and nine shared dependency states were preserved; all
three full root objects remained absent. Local
`generated-instance-probe-e42535d/result.json` has SHA-256
`56898d38e0bb18c262a2cff7ddd97cad8bc1f8cfa1ac4fbcce0694b2e3d2b540`.
This is focused runtime evidence with a cached baseline, not a full native or
clean CI result.

## Supplemental Windows consumer: scoped pass

The separate local-path `Consumer` package used the e425 source closure and
existing canonical/dependency objects. Its guarded Lake update returned exit 0
at 08:14:05 UTC; `lake build Consumer` returned exit 0 after compiling all 13
fixtures plus the aggregate during 08:14:17–08:18:13 UTC. The raw driver then
returned exit 1 because its broader checkout postcheck saw the authorized
AddCircle, test-root and new-test edits made outside that import closure.
That raw failure remains recorded rather than overwritten.

Independent `local-path-consumer-e42535d/scope-adjudication.json` accepted a
scoped pass at 08:19:53 UTC (SHA-256
`6f39697af454235312e042aa3a11cb3cec5f0a87d492b7cf37b51240f766e0e3`).
It verified all 22 consumed module hashes, 17 initial consumer files and nine shared
dependency source/configuration and compiled-metadata states were unchanged.
The compiled consumer objects are recorded. This result uses existing objects;
it is not a clean full native build, actual Git-dependency compilation or a
pass of the complete CI workflow. Its closure excludes AddCircle, so it cannot
validate the new explicit public-instance name; the separate focused regression
above covers that leaf; the later current 51c strict full-graph comparison also passed.
The retained `record-label-clarification.json` (SHA-256
`e92af9dbd6cc614cab04f9c33b23a213f49dc7373031d9f4192c84c9be467da2`)
binds the original records: 17 initial files are 13 fixtures, aggregate, Lake
configuration, toolchain and ownership marker; the post-update manifest was
checked separately. The original root-status field contains `exists()` values:
all false means all three root objects were absent. No original evidence was rewritten.

## Runtime segments and compiled baseline

The first Windows full-build segment ran from 01:15:32 to 02:11:05 UTC. The
coordinator intentionally paused it to release the shared Lean mutex for the
Git-consumer resolution and baseline declaration/axiom captures. Its exit 1
is retained in `migrated-full-build.json`; `migrated-full-build-pause.json`
classifies it as `INTENTIONAL_OPERATIONAL_PAUSE`, not a compiler regression.
Completed project artifacts and the original log were retained. The unchanged
three-target command resumed at 02:23:29.1762705 UTC using
`run-full-build-resumed01.ps1` and separate `migrated-full-build-resumed01.log`.
It was intentionally stopped at 03:05:05.8763485 UTC when free space reached
1,607,999,488 bytes, below the reviewed 1.5 GiB threshold (1,610,612,736 bytes).
The resumed segment ended at 03:05:05.8863822 UTC with retained exit 1; it is
an operational disk stop, not an observed compiler regression. No native error
markers were observed. Only the exact owned process tree was stopped.

`native-disk-stop-closure.json` passed at 03:05:29 UTC: no Lean/Lake processes
remained, the shared mutex was free and all three root `.olean` files were
absent. The supplemental native full build therefore **did not complete**.
The existing driver had removed 375 completed regenerable `.setup` files
(814,445,969 logical bytes) during the resumed interval; source files,
completed compilation artifacts and run evidence were retained. See
`native-disk-stop.json`, `migrated-full-build-resumed01.json` and
`native-disk-stop-closure.json` for this platform outcome. Clean Linux run
34004222002 subsequently finished FAILURE at 04:14:16 UTC for the exact
prior candidate. Repaired run 34012018278 passed its library/test/diagnostic
gates, then failed during consumer setup. Consumer completion, evidence review
and compiled comparisons were outstanding at that point and subsequently
passed for 51c55409. Final publication is verified by its separate receipt.

After successful Git/Lake resolution, bounded cleanup at 02:42:16.9837906 UTC
removed only `C:/Users/qed_s/lcgc/.lake/packages`: ten verified temporary
acquired clones, comprising 25,811 files and 526,631,493 logical bytes. Their
HEADs, pins, origins, tracked cleanliness, absence of reparse points and process
quiescence were checked first. The 13 consumer fixtures, manifests, configuration,
toolchain, owner marker and external run records were retained with unchanged
hashes; four raw runtime files were also copied to external evidence. Original,
integration and shared dependency source/object storage were not targeted.
`git-consumer/package-cleanup-result.json` records PASS. Observed free space
changed from 2,063,339,520 to 2,524,692,480 bytes while the Windows build
continued, so this net change is not an exact allocation-recovery measurement
or a guarantee of headroom for the remaining build.

Lossless NTFS compression of the retained baseline graph passed at
02:54:33.0032681 UTC: 118,302,647 logical bytes occupy 23,924,736 stored bytes,
with SHA-256 `56d81ba976a4a10eb0b00244092a443e003da6f4488ed950ceeb41352f897a15`
unchanged. `declaration-comparison/baseline-graph-compression.json` records the
result. This and the temporary-clone cleanup preserved evidence but did not
provide sufficient sustained disk headroom for the supplemental native build.

A later safe-space pass finished at 03:26:17.2803596 UTC and losslessly
compressed 161 inactive older plaintext runtime logs (3,412,820,026 logical
bytes), with zero skips. Every pre/post SHA-256 and file length matched; no
files were removed or moved, and no databases or configuration were touched.
Observed free space changed from 1,261,309,952 to 2,895,818,752 bytes; concurrent
writes affect that net change. The aggregate result is recorded locally in
`inactive-text-log-compression-result.json`; private per-file audit paths are
not part of this report. This does not change the terminal, intentionally
stopped native-build outcome. The later clean Linux build failure is a
separate historical validation failure. The feb run passed its library/test/
diagnostic gates and later failed in downstream setup. The subsequent 51c run
passed the complete acceptance matrix, without changing the native stop outcome.

The baseline format-2 graph was captured at 02:15:56.272235 UTC in 149.094 s.
`declaration-comparison/baseline-dependencies.tsv` has SHA-256
`56d81ba976a4a10eb0b00244092a443e003da6f4488ed950ceeb41352f897a15`.
It records 58,420 declarations in 1,812 owning modules, 269,218 signature
edges and 386,408 proof-body edges. The seven baseline axiom queries completed
at 02:20:21.391314 UTC in 43.109 s; each reports exactly `propext`,
`Classical.choice` and `Quot.sound`. These are baseline observations, not
current-candidate counts or a proof that the candidate matches them.

Exact commands, environments and outcomes are in
`declaration-comparison/baseline-graph-run.json` and
`baseline-print-axioms-run.json`; counts and raw results are in
`baseline-graph-summary.json` and `baseline-print-axioms.log`. The extraction
uses existing cached current-main Windows objects, supplemented by the
verified green baseline CI runs. It is **not a clean local baseline build**.
The prior candidate graph/axiom capture and consumer compilation were skipped.
The repaired run generated graph/metadata output before consumer setup failed.
Authenticated core bindings and seven axiom sets matched; strict full-graph
comparison failed on the public instance name. The explicit repair is published
in `51c55409...`; complete clean CI, strict comparison and consumer acceptance
subsequently passed. Final documentation/main publication is verified separately.

## Maintained-name and navigation residual audit

The bounded audit passed at 2026-09-06 04:53:44 UTC after the benchmark wording
correction. It reviewed 29 maintained documents/configurations, resolved 2,400
qualified canonical module references against `feb121c8...` and checked root
interfaces separately, plus 237 local Markdown paths and 13 maintained fragments.
Nine remaining old-branding occurrences were classified as upstream history or
recorded cutover/redirect evidence; no actionable mismatches remained in that
scope. This does not cover every old identifier in the repository, re-query
remote links, certify compilation or re-audit frozen evidence/source PDFs.

Local `residual-name-audit-feb121c-20260906T045344Z.json` has SHA-256
`2d138822ac08091c967b5f05df38ab662e44575e6fba63127acc82abfcbe70f7`.
Its per-file hashes identify the reviewed snapshot; later outcome prose is
checked separately rather than attributed retroactively to this audit.

## Evidence limitations

The CI baseline does not run the external LeVeque faithfulness validator or
re-audit all books. The tracked 26 completed faithfulness manifests bind old
source/task hashes. Their historical validity is not automatically a fresh
validation of moved files. The `.faithfulness-audit` runtime/source PDFs and
companion gate tools are not shipped in this checkout.

The prior repaired strict-source capture, made in the source-gate run ending
04:35:50 UTC, records 5,599 modules (2,401 canonical plus 3,198 old forwarders),
1,503,619 nonblank lines and 47,223 imports (32,152 internal; 15,071 external).
Classification and module documentation are complete; import cycles, unresolved
project imports and forbidden reusable-to-source paths are zero. Its normalized
source-tree SHA-256 is
`47d648e5f54f4f526361c9461c12e885aea89f19d289e3c61596e1076d84e78e`.
The capture metadata records HEAD `abceba9f...` plus the then-uncommitted
forwarder repair, subsequently published in `feb121c8...`. Local evidence is
`repaired-ci-architecture/source.json` and `source.md`. The original 01:24:30
capture and hash remain historical evidence in `migrated-ci-architecture/`.

The pre-instance-fix passing source-preservation result covers 17,600 mapped canonical
import tokens, 11,292 preserved external tokens, the recorded 14-import header
permutation, and the separately bound forwarder/test adjustments. All other
canonical bytes, authored names and mathematical bodies are unchanged. The subsequent strict
compiled comparison failed on a generated public instance name. Its explicit
repair is published in `51c55409...`; the complete clean run and strict
comparison passed for that exact source commit. Earlier failed records remain
unchanged. A successful check certifies its recorded SHA, not another final tip.
