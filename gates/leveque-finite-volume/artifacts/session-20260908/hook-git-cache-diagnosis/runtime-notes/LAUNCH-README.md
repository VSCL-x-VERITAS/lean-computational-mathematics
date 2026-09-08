# LeVeque Chapter 1 launch handoff

Execution addendum, 2026-09-08: use the prepared POSIX Git consistently for repository worktree/index operations. Native Git can rewrite the shared file-status cache and make the next guard check exceed 20 seconds. See [the measured Git runtime correction](GIT-RUNTIME-NOTE.md). Native Lean/Lake remains unchanged; the earlier launch evidence below is historical.

Prepared 2026-09-08 for the user's request to finish setup and produce the correct execution prompt. The selected book is *Finite Volume Methods for Hyperbolic Problems*, first printed 2002 (selected PDF copyright 2004), Chapter 1, Introduction. This setup does not start theorem formalization.

## Use the prepared prompt

1. Open `C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/EXECUTE-LeVeque-Chapter-1.md` and paste its entire contents into a fresh Codex task in this workspace. The submission hook needs the prompt's actual markers; sending only a filename is insufficient.
2. Let that task run the generated initialization checks and begin the remaining Chapter 1 work. The generated stopping and reconciliation rules govern that later task.

Codex hook trust is complete. On the user's explicit request, the agent reviewed and trusted `UserPromptSubmit` and `Stop` individually through the supported interactive Codex CLI review. A fresh read-only app-server snapshot at 2026-09-08T06:20:39Z reports both definitions `enabled: true` and `trustStatus: trusted`, with no warnings or errors. The temporary configuration CLI was closed without submitting a model prompt. No hook definition was changed, no trust cache was edited directly and no bypass flag was used. Evidence: `provider-guard-evidence/hook-trust-activation-20260908.json`. Future edits to hook definitions require a new exact-definition review.

The handoff contains these Windows execution notes followed by the official generator output, unchanged byte for byte. The pristine output is `C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/leveque-chapter-1-start-prompt-ready-v5.0.1.md`. `launch-prompt-manifest.json` records both hashes and verifies the unchanged suffix.

## Verified campaign and branch selection

The user confirmed: "all checkpoints have been merged with the main." The historical mathematical baseline is therefore the integrated `main` tree at `9e2225705fed906b1120d55105d607baabef57c9`. Current-tree library and pinned Mathlib searches must reuse compatible integrated results.

The local Lean checkout is `C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics`, on existing branch `work/formalization/leveque-finite-volume/1/codex` at `c5110fa68d0dc140cafe2809fea44ef1adf6e944`. This is a direct child of the baseline containing 19 Chapter 1 gate/readiness artifacts; it introduces no mathematical implementation. No old mathematical checkpoint lane is selected for re-import.

Campaign `leveque-finite-volume-main-2026q3` uses local branch `integration/leveque-finite-volume-main-2026q3`, pinned to the same baseline. Stable `main` is separate and remains unchanged. Chapter 1 has no predecessor units in the newly reviewed admission policy. Exactly one current merge input resolves: `leveque-ch01-work`. The other configured lane, `reorganization-baseline-inspection`, is read-only.

The user's setup authorization is recorded in `.formalization/topologies/setup-authority-20260908.md`. `project-owner` denotes the user for campaign ownership and stable-promotion authority. That setup authorization is not an integration or promotion receipt. The current Chapter 1 lane is `checkpointed`; this describes its readiness/future-work state and does not contradict the integration of historical mathematics into main.

Operational topology: `C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/.formalization/library-topology.json`.

Topology SHA-256: `054f263942b0d5577ad699d6abdb9730cd8ecdd5f837577e0d25ed505a331df4`.

Its exact bytes were independently reviewed against the published schema and repository resolution. The named authority copy is `.formalization/topologies/library-topology-20260908-owner-setup-posix-v2.json`. Prior topology proposals and review artifacts remain preserved. `.formalization/` is ignored through the repository's local `.git/info/exclude`.

## Windows command execution

Released workflow scripts require POSIX Python/filesystem behavior. Use the isolated MSYS2 runtime through this external launcher from native PowerShell:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -B 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py' 'C:/absolute/path/to/workflow-script.py' --argument value
```

For a generated command beginning `python3 SCRIPT ...` or `/usr/bin/python3 SCRIPT ...`, pass `SCRIPT ...` to this launcher, omitting the leading interpreter. Keep each argument separate; do not paste the POSIX command as one PowerShell string. Windows absolute path arguments are translated; existing `/c/...` paths work directly. Native filesystem tools use `C:/...` paths for those same files.

The launcher runs unchanged release scripts under real POSIX Python with Git, `fcntl` locks, atomic writes, private permissions, directory fsync and symlink checks. It preserves stdin/stdout/stderr, literal arguments and process exit status. The full unchanged reconciliation regression passed all 85 cases in disposable fixtures. No real campaign admission or promotion was performed by those tests.

Use the pinned native Lean toolchain for Lean/Lake commands from the Lean checkout. The focused existing LeVeque module build and declaration/axiom checks passed. This is focused environment verification, not a new full-library build or a fresh semantic audit.

The earlier `run_workflow_windows.py` ordering shim and `windows-runtime/` native-port experiment are historical diagnostics, not the operational runtime. See `POSIX-RUNTIME.md` and `provider-guard-evidence/README.md` for installation and test evidence. The released checkout, source PDF, profile, schemas, validators and audit seals were not changed.

## Regeneration and read-only checks

The helper selects the exact validated LeVeque package and the operational runtime. Its default session is `codex-start-1-v5-0-1-20260908`, avoiding a preexisting session that was bound to an older profile.

```powershell
& 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/Generate-LeVequePrompt.ps1' -Check
& 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/Generate-LeVequePrompt.ps1' -ExplainRoute
```

Both are expected to exit 0. The readiness result must say `formalize`, with no readiness defects. To deliberately regenerate after changes, use the same helper with `-OutputPath` and an appropriate session id, then rerun `make_launch_handoff.py` if updating the current handoff. Generation creates/binds a durable reconciliation request; the read-only flags do not constitute a theorem run.

The generated initial request is `ccf62eb5de1e580f71a5565089b1fa3c45e3712b089c8caa17b4a879052ba0ba`, under `.formalization/reconciliation/requests/`. Its initial state is `FROZEN`, awaiting the later task's actual checkpoint flow. No external authority receipt was created. The generated refresh uses `--remote-write-policy forbid --admission-backend none`.

## Gate and source evidence

Gate: `C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/chapter-01.json`.

The checker derives `ACTIVE`: 1 formalized object of 24 counted objects (4.17%), 23 remaining, 23 separately skipped, 0 deferred, 47 inventory rows. An `ACTIVE` chapter is valid to start but is not complete. The `--require-pass` closure condition is not satisfied.

The existing gate's single Lean result has recorded blind, direct and round-trip evidence, with zero unresolved adjudications. These are existing bound artifacts, not new audits performed during setup. A current organization scan was rerun: 0 unclassified modules, 0 duplicate wrappers, 0 placeholder findings and 0 canonical-placement debt; 5,877 canonical modules were classified, including 9 LeVeque canonical and 9 compatibility modules. The native focused build and the three declaration/axiom checks were actually replayed; only `propext`, `Classical.choice` and `Quot.sound` were reported. Other inherited build evidence was not relabeled as a fresh replay.

Profile: `C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/formalization-collaboration-v5.0.1/books/candidates/leveque-finite-volume/module/book-profile.json`.

Profile SHA-256: `b140898932e6b43e2340459f2d7b4cfee42fddc18ef1ae307ed1c11e55b2d9ea`.

Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.

The selected module remains `READY`, Chapter 1 remains audited under `leveque-source-unit-index-2026-08-31-v1`, and project lifecycle validation at released tag `formalization-workflow-v5.0.1` passes. No lifecycle-start event or new formalized object was created in preparation.

Process findings and resolutions are appended under `lean-computational-mathematics/ledgers/leveque-finite-volume/skill-issues/book-formalization/leveque-finite-volume/sessions/codex-start-1-v5-0-1-20260908`. Earlier sessions remain intact. No new book/source issue was inferred from setup work.

Validation commands actually run include the unchanged `validate_profile.py --require-ready`, `project_lifecycle.py validate --require-tag`, `gate.py check --unit 1 --mode default`, `reconciliation.py preflight --resolve-repositories`, `organization_preflight.py`, the current organization-counter scan, `provider_guards.py check`, `issue_tracker.py check`, `book_prompt.py --check`, `book_prompt.py --explain-route`, the generated `reconciliation_launcher.py verify-latest`, the unchanged 85-case reconciliation regression, the native focused `lake build ComputationalMathematics.Source.LeVeque.Chapter01.Equation03AdvectedProfile`, the native declaration-check Lean file, and `git diff --check` in both repositories. Exact request validation argv/results are in `.formalization/topologies/review-posix-20260908/generated-request-review.json`. Runtime/provider logs are linked above. `launch-final-verification.json` records the final hashes, tracker check and last dispatcher readiness result.

One interrupted disposable regression fixture remains at `C:/Users/qed_s/AppData/Local/Temp/reconciliation-launcher-5hb2ozrh`. Automatic approval review rejected its recursive cleanup with reason "blocked by policy". The folder was retained without retrying deletion through another tool; this does not affect the runtime, source checkout or prepared prompt.

Remaining operator input: none for launch preparation. Campaign ownership, the integrated baseline and Codex hook trust are established. Execute the existing handoff in a fresh task when ready.
