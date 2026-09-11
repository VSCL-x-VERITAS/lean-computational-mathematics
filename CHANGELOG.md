# Changelog

All notable user-facing changes to Lean Computational Mathematics are recorded here. The project
follows semantic versioning for its public module paths and declaration API.

## [Unreleased]

### Added

- A link contract: `tools/architecture/check_links.py` fails CI on any relative
  link or image in tracked Markdown whose target does not exist. Every removal
  in the 0.2.0 work left such assertions behind, and grepping for a deleted
  path finds the links but never the prose describing it. The narrative of the
  retired campaigns is exempt and reports a count instead, so the rule is
  exactly zero everywhere else.

### Removed

- `ledgers/` (44 files, 429 KB), the last campaign working record tracked in the
  repository. The gates, issue ledgers, audit evidence and formalization runtime
  state are now local files by policy: the book-formalization workflow reads and
  writes them inside a checkout, and `.gitignore` plus
  `tools/architecture/check_layout.py` keep them out of `main` and out of every
  work lane.

- The vendored faithfulness audit kit at `.faithfulness-audit/` (45 files,
  204 KB) and `RENAME_LEDGER.md`. The kit survived the working-record
  retirement because 252 audit manifests hashed its files; none remain, so it
  followed the packages it produced. Restore either with
  `git restore --source afb25bab1 -- <path>`; the kit's version and provenance
  are recorded in
  `docs/architecture/reviews/2026-09-working-record-retirement.md`.

## [0.3.0] - 2026-09-11

Breaking release. The unfinished Vershynin Chapter 5 experiment is removed so
the supported HDP source surface contains the completed Chapter 1 work and the
Chapter 2 work selected for clean migration. This removes the Chapter 5 source
wrappers, their chapter-specific metric-measure provider, and the
`ComputationalMathematics.HDP.Concentration` front door. No Chapter 1 or
Chapter 2 import or declaration is removed. See
[`HDP-CHAPTER05-REMOVAL-0.3.0.md`](docs/architecture/migrations/HDP-CHAPTER05-REMOVAL-0.3.0.md)
for the complete API list and recovery instructions.

Repository agent instructions now match formalization-workflow v5.1.1: gates,
ledgers, audits, faithfulness workspaces, topology and coordinator state remain
checkout-local and outside Lean Git history.


## [0.2.0] - 2026-09-10

Breaking release. The historical `NumStability` import paths are removed.
`import ComputationalMathematics...` is the only supported form.

### Added

- Canonical `NumStability.Source` and `NumStability.Source.Higham` entry points.
- Canonical Chapter 14, Chapter 24, and Chapter 25 source trees with
  independently compiled compatibility imports.
- A canonical Chapter 4 source tree for the §4.1 six-term pairwise example and
  Problem 4.3.
- A reusable `NumStability.Algorithms.LinearSystems.Triangular` family entry
  point.
- Reusable `NumStability.Analysis.Summation.Signs` and
  `Summation.ErrorBounds` leaves, and a declaration-free summation-analysis
  umbrella.
- Reusable `Summation.Recursive.Core`, `Summation.Pairwise.Core`, and
  `Summation.Tree.Chain` modules with complete family umbrellas and isolated
  import tests.
- Reusable insertion-summation `ActiveList`, `Executor`, `Schedule`,
  `RunningError`, and `ScheduleExecution` leaves, plus a canonical Chapter 4
  Section 4.1 insertion-example source module.
- A complete, declaration-free `NumStability.Algorithms.Sylvester` family
  aggregate and isolated aggregate/import smoke tests.
- Architecture, naming, compatibility, and layout checks for repository
  migrations.
- Explicit Apache-2.0 license text, per-file provenance policy, Mathlib
  attribution, citation metadata, and a provenance CI check.

### Changed

- `lake build` and CI build `ComputationalMathematics` and `NumStabilityTest`.
- The architecture tooling has a single production root. `tiers.json` no longer
  carries 3,334 `compatibility` rules.


- The project display name is now Lean Computational Mathematics, reflecting
  its multiple source developments. Mathematical stability terminology and
  source identities are preserved; the
  [migration report](docs/migrations/lean-computational-mathematics/README.md)
  records interface and repository-address changes separately.
- The approved canonical module root is `ComputationalMathematics`; all
  original `NumStability` imports remain forwarding interfaces. The Lake
  package `numStability`, test root `NumStabilityTest` and authored
  `NumStability` declaration namespaces are retained. Validation and cutover
  completion are recorded in the migration report.
- Historical source and triangular-system paths are now import-only forwarding
  modules. They remain supported until a declared breaking release.
- `NumStability.Analysis.Summation` is now an import-only complete aggregate;
  reusable consumers import its semantic leaves directly. `ErrorBounds` is now
  classified as reusable rather than mixed.
- The historical `Summation.Tree.RecursiveBridge` path now forwards to the
  semantic `Summation.Tree.Chain` module.
- `Summation.Insertion` is now a declaration-free complete family aggregate;
  production consumers import its narrow reusable layers, while the historical
  `InsertionSum` path retains the complete reusable and source surface.
- The Algorithms aggregate imports the Sylvester family through one umbrella
  (a step that, at the time, reduced its direct imports from 490 to 463), and
  its imports are sorted and deduplicated by a repository-owned formatter. The
  checked ceilings in
  [`docs/architecture/layout-exceptions.json`](docs/architecture/layout-exceptions.json)
  now cap the aggregate at 446 direct imports below `NumStability`, including
  44 below `NumStability.Analysis` and 73 below `NumStability.Source`; these
  are enforced ceilings, not the live import count.
- `NumStability.Higham` now forwards to the canonical
  `NumStability.Source.Higham` surface.
- Mathlib is pinned to an exact revision and `lake test` has an explicit test
  driver.
- The in-progress 2026-08 reorganization-completion phase canonicalized the
  remaining historical Higham surfaces, including the Chapter 9, 11, 13, 14,
  20, 21, and 28 source trees, the R09 TestMatrices canonicalization, and the
  R10 RandNLA canonicalization. Historical paths remain supported as 712
  import-only forwarding modules over 2,364 canonical targets, and the
  executable tier inventory classifies 2,928 of 2,928 production modules with
  0 unclassified and 0 mixed; CI forbids regression from that state.
- The reviewed I01 wave (R0014/R0015) landed on `main` at
  `9fbb1e36bcc85f866893e902cbe206ba468a65b0`: the Chapter 2 Problem 2.9
  double-rounding counterexample umbrella was split into declaration-free
  aggregates over source leaves, `Source.Higham.Chapter19.Core` was retargeted
  to canonical Householder QR imports, and the retained-production
  compatibility-exception mechanism was retired from
  `tools/architecture/check_compatibility.py`.
- Repository reorganization is now governed by
  [`docs/architecture/PROCESS.md`](docs/architecture/PROCESS.md): per-batch
  static gates, plain-language recorded review, and fast-forward-only `main`.

### Deprecated

- Historical source, triangular-system and root Higham import paths were
  deprecated through the 0.1.x series and are removed in this release, under
  the removal policy they carried. The mapping each one resolved to is retained
  in [`docs/architecture/migrations/COMPATIBILITY-0.1.x.md`](docs/architecture/migrations/COMPATIBILITY-0.1.x.md)
  and, machine-readable, in
  [`docs/architecture/migrations/2026-09-forwarder-map.json`](docs/architecture/migrations/2026-09-forwarder-map.json).

### Removed

- The 3,334 `NumStability` import-path forwarders. Every one was import-only:
  no declaration, proof or definition existed anywhere under `NumStability/`,
  and all 14,688 forwarding edges resolved into `ComputationalMathematics`.
  The old-path to canonical-path table is preserved at
  `docs/architecture/migrations/2026-09-forwarder-map.json`; 2,429 of the 3,334
  paths map to the same relative path, and 383 fan out to more than one
  canonical module, so a mechanical prefix rewrite is correct only for the
  former and the table is authoritative for the rest.
- 6,366 old-path smoke tests, which existed to prove that those forwarders kept
  resolving. The 2,551 canonical import tests are retained and still run under
  `lake test`.
- The `NumStability` Lake library and default build target, and the
  `compatibility` tier and its manifest.


- The working record of completed campaigns, keeping their outcomes: the 254
  faithfulness audit packages and their chapter gate documents (7,140 files,
  215.2 MB), the machine data of the finished reorganization campaign (713
  files, 118.7 MB of TSV, JSON, patches and one-off tools), and the 2,401
  rename import witnesses. Gate verdicts are preserved in
  `docs/architecture/reviews/2026-09-faithfulness-outcomes.md`, the 259
  narrative documents of the campaign are kept so every documentation link
  still resolves, and the whole pass is recorded in
  `docs/architecture/reviews/2026-09-working-record-retirement.md`. No Lean
  module, build target or diagnostic baseline changed.
- Four phase checkers and thirteen one-off campaign tools, which had nothing
  left to validate: `tools/architecture/` goes from 30 scripts to 13 and CI
  from 21 Python invocations to 15.


- 18,205 files (1.30 GB) of audit working artifacts that no gate document,
  tool, document or CI step referenced: the unreferenced part of the
  2026-09-08 formalization session, 370 superseded faithfulness reruns across
  121 packages, the checkpoint-archive fragments already present in git
  history, and `examples/LibraryLookup.lean`, which no Lake target built. The
  retained evidence, the rules that computed it and the recovery commands are
  recorded in `docs/architecture/reviews/2026-09-evidence-retirement.md`. No
  Lean module, build target or diagnostic baseline changed.
- The tracked copy of the LeVeque source book and its 11 rendered page images,
  on rights grounds. Audit manifests keep their sha256 records.


- A tracked Python bytecode artifact from the experiments tree.
- The stale generated benchmarking PDF; its TeX source and rebuild command
  remain tracked.

### Migration

Rewrite `import NumStability.X` as the canonical import named for `NumStability.X`
in `docs/architecture/migrations/2026-09-forwarder-map.json`. Declaration names
are unchanged: the `NumStability` namespace and every authored declaration name
inside it are untouched by this release. Consumers pinning `v0.1.0` keep the
forwarders.

## [0.1.0] - 2026-07-21

- Initial tagged NumStability release.

[Unreleased]: https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/AlexGeorgantzas/lean-numerical-stability/releases/tag/v0.1.0
