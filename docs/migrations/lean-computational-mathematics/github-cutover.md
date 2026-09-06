# Stage C: authorized GitHub cutover

**Status: repository rename executed and verified; candidate CI and publication
to `main` remain pending.** See the [execution record](execution.md).
The owner explicitly requested execution of Stages B and C and publication to
`main`. The initial Stage A-only limitation no longer describes that authority.
This runbook preserves the sequencing and verification boundary: preparation,
rename, publication and external checks are separate observable operations.

## Verified cutover outcome

At **2026-09-06 01:25:22 UTC**, GitHub returned the canonical repository
`VSCL-x-VERITAS/lean-computational-mathematics` with unchanged ID `1327134933`,
node ID `R_kgDOTxp41Q`, default branch `main` and parent ID `1171530090`.
The About description was updated to the approved text in the table below.
The old HTML address returned HTTP 301 with the new address as its destination.
At 01:25:37 UTC, old and new Git URLs both returned `main` at
`718beac641a8094611dc249c3508a2f5415381a3`; the integration checkout origin
was changed to the new HTTPS URL with its topology preserved.

Current documentation now uses the new repository, badge, clone, dependency,
citation and current compare URLs. The historical inspection table and
commands below deliberately retain old addresses where they record or verify
the transition. They are not instructions to rename the repository again.
Exact-candidate Linux CI, full validation and publication to `main` are still
pending. Uninspected external settings remain unknown.

## Verified pre-cutover identity

The read-only refresh on **2026-09-06 01:14 UTC** returned:

| Item | Observed value |
|---|---|
| Canonical repository | `VSCL-x-VERITAS/lean-numerical-stability` |
| Repository ID / node ID | `1327134933` / `R_kgDOTxp41Q` |
| Default branch / tip | `main` / `718beac641a8094611dc249c3508a2f5415381a3` |
| Visibility / archived | Public / false |
| Parent/source fork | `AlexGeorgantzas/lean-numerical-stability`, ID `1171530090` |
| Planned target | `VSCL-x-VERITAS/lean-computational-mathematics` |
| Target REST observation | HTTP 404, not a name reservation |
| Last HTML checks, 2026-09-05 23:50 UTC | Old address HTTP 200, target HTTP 404; no redirects |
| Last Git read checks, 2026-09-05 23:50 UTC | Old organization URL with and without `.git` returns the recorded `main` tip |
| Integration branch | `codex/computational-mathematics-cutover` based on the current remote tip |
| Integration `origin`, checked 2026-09-06 01:09 UTC | HTTPS old organization URL |
| Description / homepage | Both null |
| Permissions | Current account reports repository admin capability |
| Branches | 27 observed branches; none is deleted or renamed by this runbook |

The original dirty checkout remains at the older base with its owner work.
The integration checkout already has the remote base locally; no destructive
synchronization is needed. The upstream author's repository is a distinct
repository and remains unchanged. The rename must retain ID `1327134933`.

GitHub documents ordinary repository/Git redirects after a rename, but project
site URLs and calls to hosted actions have different behavior; reusing the old
slug destroys its redirect. Verify actual results rather than assuming that
all integrations follow a browser redirect. See [GitHub's rename documentation](https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository).

## Integration inventory and treatment

The current remote tree and integration base contain one ordinary CI workflow,
`.github/workflows/lean_action_ci.yml`. No action manifest, `workflow_call`,
Pages/domain configuration, `.gitmodules`, Git gitlinks, hosted-site
configuration or package/container publishing configuration was found. The
complete remote tree response was not truncated. Current README contains a
live Lean CI badge; it must move with the active links after cutover.

| Setting / consumer | Current evidence | Cutover treatment | Owner / dependency | Verification / recovery |
|---|---|---|---|---|
| Repository slug | Old org slug, stable ID | Rename to selected target | Repository admin; recheck target first | Require same ID, branch and fork parent; recheck availability before any rename-back |
| About description | Null before rename | Applied at 01:25:22 UTC: “Formalized computational mathematics and its foundations in Lean 4, developed from books and research papers.” | Repository admin; record any actual setting edit | Re-read value; restore null only if that setting is rolled back |
| Homepage | Null; no site found | Keep absent unless a real site is identified | Repository/site owner | No fabricated site URL |
| Active URLs | README badge, repository/clone/dependency links; citation and current compare links | Change after new canonical identity is verified | Documentation maintainer | Open new repository, workflow badge, compare and Git URLs; retain upstream history links |
| Remotes | Original and integration clones use HTTPS old org URL | Update authorized relevant `origin` URLs after cutover | Clone owner | Preserve protocol/topology; `git ls-remote` must return expected tip |
| CI | `Lean CI`, job `build`; 360-minute ceiling; push/main, PR, manual events; build/test and warning/lint enforcement | Preserve default push/PR behavior and public check identity; manual `clean_project=true` disables the restored project cache while retaining the official Mathlib cache | CI maintainer | Require exact-candidate green CI before fast-forwarding `main`; do not lower gates |
| Protection / Actions settings | Rulesets `[]`; main unprotected; Actions enabled, allowed actions `all`; successful `build` checks on base | Preserve settings, recheck before publication | Repository admin | Empty legacy commit statuses do not mean a failed required check |
| Hosted action / reusable workflow | None found on inspected base | No hosted-interface cutover identified | CI maintainer / any discovered consumers | If one appears, resolve its consumers independently before rename; ordinary redirects are insufficient |
| Pages / deployment | `has_pages:false`; Pages API 404; deployments `[]`; no base-path/domain/publishing config | No site mutation currently identified | Repository admin / documentation owner | Refresh state; if a site exists, test deployed navigation, assets, deep and source links |
| Webhooks / environments | Both API lists `[]` | No mutation identified | Repository admin | Recheck lists; do not log secret endpoints or values |
| OIDC | Default customization; CI has `contents:read`, no `id-token:write` | No repository OIDC change identified | Identity-provider owner | External cloud trust policies are not established by repository evidence |
| GitHub Apps / external services | `github-actions` seen on checks; complete App grants/external account settings not inspected | Identify any newly discovered slug-bound setting | Organization/service owners | Explicit unresolved external observations remain in execution record |
| Packages / containers | No publishing config found; external registries not inspected | Preserve package coordinates/versions unless separately part of an evidenced cutover | Package/service owners | No package rename inferred from repository rename |
| Releases / citations | Org releases `[]`; annotated `v0.1.0` tag exists; no DOI in citation metadata | Keep historical release/title/author/version/date references; update current software title/pointer only | Maintainer / citation-service owner | Verify tag/compare/citation display; no release or DOI repurposing |
| External consumers | Global indexed search for qualified old org slug returned `[]` | Update only identified authorized consumers | Consumer owners | Private/unindexed consumers remain unknown; verify actual consumers when identified |

## Recorded sequence and remaining steps

1. Complete source-preservation, source/structural, build, compatibility and
   diagnostic checks for the mapped implementation. Record the exact candidate
   commit. Preserve the newer remote CI and the original dirty checkout.
2. Refresh canonical identity and target state. If the target already resolves
   to ID `1327134933`, continue from observed post-cutover state. If it resolves
   to another repository, stop dependent cutover actions and record the conflict.
   Inspect any newly discovered hosted interface/site/integration blocker.
3. Rename only the organization repository in GitHub Settings, or use the
   explicit repository CLI operation:

   ```powershell
   gh repo rename lean-computational-mathematics --repo VSCL-x-VERITAS/lean-numerical-stability
   ```

4. Read the new canonical repository metadata and require unchanged repository
   ID, owner, branch and fork parent. Observe old-address redirect destinations
   and old/new Git read access, recording UTC time.
5. Update active current-project links and the relevant HTTPS `origin` remote
   after that confirmation. Preserve historical upstream links, old tags,
   source identities and all other branch/remote topology.

   ```powershell
   git remote set-url origin https://github.com/VSCL-x-VERITAS/lean-computational-mathematics.git
   ```

6. Publish the gated work branch and dispatch the manual workflow with
   `clean_project=true` to compile project artifacts afresh on Linux while
   retaining the official Mathlib dependency cache. After the ordinary gates,
   this mode also captures the compiled graph/axiom evidence and builds the
   independent 13-fixture consumer against the exact checkout and dependency
   pins. Obtain a successful
   complete CI run on the exact candidate, then fast-forward `main` under the
   repository process.
   Refresh remote `main` immediately beforehand; integrate any intervening
   changes without force-pushing or dropping their checks. The remote rename
   itself need not wait for an internal namespace change; namespaces are
   deliberately retained by this approved migration.
7. Verify current clone/dependency instructions, citation display, badges,
   workflow/required checks and identified consumers. Record exact main SHA,
   CI URL, repository ID and observation times. Verify any actual deployed
   site separately. Keep the old organization slug unused.

Settings, Git commits and external services do not change atomically. Between
rename and link publication the old operational addresses may use verified
redirects. Keep that short transition explicit rather than claiming atomicity.

## Inspection commands

```powershell
gh api repos/VSCL-x-VERITAS/lean-numerical-stability --jq '{id,full_name,default_branch,parent:{id:.parent.id,full_name:.parent.full_name}}'
gh api repos/VSCL-x-VERITAS/lean-computational-mathematics --jq '{id,full_name,default_branch,parent:{id:.parent.id,full_name:.parent.full_name}}'
gh api repos/VSCL-x-VERITAS/lean-computational-mathematics/branches/main --jq '{name,sha:.commit.sha,protected}'
curl.exe -sS -o NUL -w 'status=%{http_code} target=%{redirect_url}\n' https://github.com/VSCL-x-VERITAS/lean-numerical-stability
git ls-remote https://github.com/VSCL-x-VERITAS/lean-computational-mathematics.git HEAD
```

These are verification recipes, not claims that their future post-cutover
outcomes have been observed. Never publish authentication tokens, cookies or
secret values in migration logs.

## Recovery

A Git revert cannot undo a repository rename or restore external settings.
Reverse only this migration's changes; do not reset the original dirty
checkout, delete branches or repurpose the upstream repository. Renaming back
requires a fresh availability and redirect assessment. Restore only settings
actually changed and re-run the same affected consumer/CI checks. Outstanding
external observations must remain explicit rather than being declared complete.
