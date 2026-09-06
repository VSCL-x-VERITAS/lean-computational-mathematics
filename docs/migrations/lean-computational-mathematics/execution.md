# Migration execution record

This file records observed outcomes, not planned success. The owner has
explicitly authorized Stages B and C and eventual publication to `main`.

| Event | Observed status / evidence |
|---|---|
| Original Stage A boundary | Local public-identity patch prepared in the older dirty checkout; original owner work retained |
| Integration-base decision | Isolated checkout from `718beac641a8094611dc249c3508a2f5415381a3`; original HEAD `d602405c...` is 136 commits behind |
| Clean integration baseline | 11,225 tracked files; snapshot captured 2026-09-06 00:52:30 UTC |
| Baseline source/structural checks | All 17 configured checks returned exit 0, 00:52:30–01:04:12 UTC; see [validation](validation.md) |
| Migrated source/structural checks | PASS, all 18 commands after the recorded ordering correction; original failure retained and corrective layout recheck returned exit 0 |
| Public documentation | Reapplied to newer README/policies; current scope and C0008 history retained |
| Approved interface mapping | 2,401 canonical modules, 3,198 retained old imports, unchanged package/test/declaration identities |
| Source-preservation verification | PASS, 2026-09-06 01:23:21 UTC; [record](source-preservation.json), 2,401 canonical modules, 3,198 old forwarders and one recorded 14-import ordering adjustment |
| Canonical/legacy/mixed consumer matrix | PENDING final recorded result |
| Representative clean build | PASS, six canonical targets, exit 0, 2026-09-06 01:07:23–01:15:32 UTC; initially empty project artifacts |
| Full build, `lake test`, warning and lint checks | Full build running since 01:15:32 UTC; final results PENDING |
| Documentation/frozen-evidence checks | PASS, 2026-09-06 01:27 UTC; 53 changed prose files checked for local Markdown targets/fences/whitespace; original source-ledger bodies and frozen evidence retained |
| Remote canonical identity | `POST_RENAME_PENDING_PUBLICATION`: `VSCL-x-VERITAS/lean-computational-mathematics`, unchanged ID `1327134933`, node `R_kgDOTxp41Q`, parent ID `1171530090`, default `main`; verified 2026-09-06 01:25:22 UTC |
| Target preflight | New slug returned REST HTTP 404 before the rename; same repository now occupies that slug |
| GitHub rename | EXECUTED and verified at 01:25:22 UTC; About description set to “Formalized computational mathematics and its foundations in Lean 4, developed from books and research papers.” |
| Candidate publication / exact-commit CI | PENDING; manual `clean_project=true` run configured for fresh project artifacts, compiled graph/axiom evidence and an independent 13-fixture consumer build |
| Fast-forward of `main` | PENDING |
| Post-cutover URLs/remotes/integrations | Old HTML URL returns 301 to the new URL; old and new Git URLs returned unchanged `main` `718beac...` at 01:25:37 UTC. Integration `origin` now uses the new HTTPS URL. Active badge/clone/citation/current compare links updated; repository, workflow, badge and compare HTTP checks all returned 200 at 01:27 UTC; candidate CI and other post-publication checks remain pending |

The observed rename and redirect evidence is retained locally as
`github-cutover-verified.json`, `git-redirect-and-origin.json` and
`github-old-url-redirect-headers.txt` in the evidence directory documented in
[validation](validation.md). The original dirty checkout remains preserved.

## Completion and recovery

Update each pending row only after an observed result. Record commit IDs,
repository IDs, exact CI runs and UTC times. Do not infer a remote rename,
green build or external-service completion from local documentation edits.

A local revert does not undo a GitHub rename. External recovery must recheck
slug availability and redirect behavior; preserve the upstream repository,
original dirty checkout, branches and immutable evidence. Reverse only this
migration's changes and keep the former organization slug unused after a
successful rename.
