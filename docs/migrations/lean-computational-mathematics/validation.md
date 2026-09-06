# Validation record

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
| Public documentation | `git diff --check`; compare mathematical/current-baseline prose and resolve updated local links | PASS at 01:27 UTC: 53 changed prose files, no missing local Markdown targets, unmatched fences or trailing whitespace; source-ledger original bodies preserved |
| Canonical source preservation | [Exact source-preservation procedure](verify_source_preservation.py) against the immutable module map | PASS at 01:23:21 UTC; [record](source-preservation.json): 2,401 canonical modules, 3,198 old forwarders, 797 preserved old wrapper comment bodies; one explicit 14-import header permutation |
| Pins and identity | Compare `lean-toolchain`, `lake-manifest.json`, package `numStability`, test root and authored namespaces | PASS for toolchain/manifest diff and retained configured package/test identities; authored names covered by exact source comparison |
| Frozen evidence | `git diff --quiet HEAD -- gates ledgers 'docs/source_coverage/AUDIT_*.md'`; compare retained phase/baseline/review files | PASS at 01:14 UTC, no changes; final pre-publication comparison still required |
| Migrated source gates | Original baseline coverage plus canonical-root-aware checks, 18 commands | PASS for all 18 commands after the sole recorded import-order correction; original layout failure retained, corrective layout recheck exit 0 (207.6 s) |
| Representative clean build | Six canonical targets spanning floating point, stability, Gaussian moments, Vershynin, LeVeque and matrix algebra | PASS, exit 0, 01:07:23–01:15:32 UTC; project artifacts initially empty and dependency pins verified |
| Full target coverage | `lake build ComputationalMathematics NumStability NumStabilityTest` | RUNNING since 01:15:32 UTC; no successful full compilation claimed |
| Test driver | `lake test` | PENDING |
| Warnings and lint | Capture configured build/lint logs and run `check_placeholders.py --completion`, `check_warnings.py --check`, `check_lint.py --check` with the reviewed manifests | PENDING; do not reduce checks to pass |
| Compatibility behavior | Independent canonical/legacy leaves, mixed imports, actual mathematical uses, notation/instances | PENDING fixture results |
| Downstream consumer | Isolated package pinned to this migration snapshot; retained package name and both import styles | PENDING |
| Remote publication | Verify renamed repository ID, exact candidate CI and fast-forwarded `main` | Rename/ID/redirects/integration origin verified at 01:25:22–01:25:37 UTC; candidate CI and `main` publication PENDING in [execution record](execution.md) |

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
ceiling are retained. Dispatch and results remain pending until recorded.

After the ordinary build, test and diagnostic gates succeed, this manual mode
runs the existing format-2 declaration extractor and its self-test, generates
a compiled summary, and captures `#print axioms` for seven representative
declarations. The axiom output is evidence for review, not an additional claim
that every declaration in the library was independently re-audited.

It also builds a separate `Consumer` library from 13 focused fixtures: six
canonical/old import pairs and one mixed-import test. Its Lake package requires
`numStability` from the exact checked-out `GITHUB_SHA` via a local path, checks
the inherited toolchain and all transitive Git dependency revisions, and builds
its own consumer artifacts. The compressed declaration graph, consumer
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

The authoritative final source-gate result is
`migrated-source-checks-final.json` in the local evidence directory. It records
all 18 commands passing after the corrective layout check, while retaining
the first suite, original layout failure and hashes of its logs. The original
17-command clean baseline and final 18-command suite are distinct records.

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

## Evidence limitations

The CI baseline does not run the external LeVeque faithfulness validator or
re-audit all books. The tracked 26 completed faithfulness manifests bind old
source/task hashes. Their historical validity is not automatically a fresh
validation of moved files. The `.faithfulness-audit` runtime/source PDFs and
companion gate tools are not shipped in this checkout.

The migrated strict-source capture at 01:24:30 UTC records 5,599 modules
(2,401 canonical plus 3,198 old forwarders), 1,503,619 nonblank lines and
47,223 imports (32,152 internal; 15,071 external). Classification and module
documentation are complete, and import cycles, unresolved project imports
and forbidden reusable-to-source paths are zero. The normalized source-tree
SHA-256 is `a345c00884ddea4def6c4892928ea70b7c4b566b5707844ce504c4ee77fe6aa5`.
This is a working-tree capture based on `718beac...`, made before the candidate
commit and remote rename. Its metadata correctly retains that capture context.
Local evidence is `migrated-ci-architecture/source.json` and `source.md`;
build and consumer outcomes remain separately pending. The passing
source-preservation result covers 17,600 mapped canonical import tokens and
11,292 preserved external import tokens, plus the one documented
14-import header permutation. All other canonical bytes are unchanged. GitHub's green checks on the older remote base do not certify the new
candidate commit.
