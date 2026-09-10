# Provenance — formalization faithfulness audit kit

Original internal intake artifact (received 2026-08-26 06:42), SHA-256:
`5a8d240dec6910baf25f6ee7565e9f02854f15655e23d2e84266f9b6f2ba7cb9`.
That machine-local path is not part of this repository or a runtime
dependency.

Kit `VERSION`: 1.1.0. The distributed `SHA256SUMS` verifies 42/42 files, both
in the intake extraction and in this installed copy (checked 2026-08-26).

This `PROVENANCE.md` itself is a **local, unhashed addition** written at
intake — it is not in the distributed `SHA256SUMS` manifest, so `sha256sum -c`
cannot detect edits to it. Everything else in the directory is manifest-covered
and must verify 42/42.

Two rules of the superseded HighamBench skill were deliberately not carried
into the kit (recorded here so the drop is a decision, not an accident):
its Codex-specific "close completed or failed agents promptly" housekeeping,
and its per-task commit staging discipline. The provider-neutral half of the
latter lives on in the router skill's finish-cleanly note.

## What this is

The generalized, book-agnostic successor to the earlier HighamBench-specific
faithfulness skill (`SKILL-faithfullness-audit---244e8f60-...md` in the intake
inbox, skill name `highambench-faithfulness-audit`, hard-wired to
`lean-fp-analysis/paper_bencmark/highambench/`). This kit installs into any Lean
repository as `.faithfulness-audit` and is the executable implementation of the
blind / direct / round-trip protocol that the book coordinator requires. It is the
"faithfulness skill" Max asked Kimon to send during the 2026-08-25 meeting.

Keep the directory complete. `START_HERE.md` is the entry point and
`METHODOLOGY.md` is canonical; do not reduce the kit to its `SKILL.md`.

## Method origin and citation

The protocol adapts the semantic-correctness audit in §3.2.1 of Theodore Meek,
Siyuan Ge, Di Qiu Xiang, Simon Chess, and Vasily Ilin, "Formalizing Numerical
Analysis: An Agent Pipeline and Quality Audit Beyond Kernel Acceptance",
arXiv:2606.14000v1 [cs.AI], 2026 — see `REFERENCES.md` for the exact
relationship and suggested citation. Record this if the faithfulness work is
reported in a grant application or publication.

## Local configuration repair, 2026-09-09

`audit.config.json` is the only repository-specific file in this kit and is not
covered by `SHA256SUMS`. It still described the pre-rename checkout: it resolved
`repository_root` to the parent of this repository and looked for task metadata
under a `lean-numerical-stability/` directory that no longer exists, so the kit
could not locate the `audits/vershynin-hdp` packages from a current checkout.

It now matches the shape of the working session configuration recorded at
`gates/leveque-finite-volume/artifacts/session-20260908/audit.config.json`:
`repository_root` is `..`, paths are relative to the repository root, and Lean
runs as `lake env lean`. The task glob points at
`audits/vershynin-hdp/**/audit-task.json`. No hashed kit file changed.
