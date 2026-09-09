# Retired architecture tools (2026-09-09)

These four scripts are preserved byte-for-byte from commit
`b8ccf0d8bd610b599b13708e8c8518771bcf71ab`. Their former locations under
`tools/architecture/` are retired. This directory is historical source, not
an operational tool directory.

| Archived script | Retired role | Historical input |
| --- | --- | --- |
| [implement_chapter11.py](implement_chapter11.py) | One-time Chapter 11 source split using fixed offsets into the old monolith | Pre-split commit `085a35331a596cb85af8fc60b66f32bb21dbe257` and its Chapter 9/11 ownership contracts |
| [generate_tier_manifest.py](generate_tier_manifest.py) | One-time schema-1 to schema-2 tier conversion; it rejects the current schema | Schema-1 manifest at `2fcdda6af6c2874ab16ad4af6d0320592b0559ad`; output at `ab91ad88cd0e1e99b6d194436e7b16a7e725a449` |
| [generate_c0005_planning_controls.py](generate_c0005_planning_controls.py) | Exact-C0004 R04/R08 control generation for the closed completion lifecycle | Accepted source `783ae9a4951407ece046adb8631d5a8ff1795a18`, control head `59115771c816e0f41967c854beb9e86532317e82`, and frozen graph/input bundles |
| [prepare_blocklu_phase12_source.py](prepare_blocklu_phase12_source.py) | Historical BlockLU source preparation and collision-shell replay | Pre-migration source `b36b4154d296cacb651ba31332f208b421b77ecc`, matching `.ilean`, format-2 graph, ownership map, and reviewed overlays |

[manifest.json](manifest.json) records each original path, Git blob, byte
length and SHA-256, immutable source/control trees, input and output
artifacts, and the pinned Lean/Mathlib environments. Git pins refer to the
historical versions, independently of the live paths. Chapter 11 candidate
paths and route tables remain in the pinned contract trees. The tier
conversion's recorded classification correction and role-map comparison
remain in the preserved script and historical output manifest.

Historical replay requires a disposable checkout with the appropriate
historical inputs. Restore the archived source to its original path there
before using it: some scripts derive their repository root from that path,
and the Chapter 11 script reads `HEAD`. Their embedded old usage strings are
preserved historical bytes. Invoking these files from this archive against
the current tree is unsupported. Current validation uses the active
[architecture checkers](../../../../tools/architecture/README.md).

The exact C0004 and BlockLU format-2 graphs, R04/R08 freeze inputs, reviewed
BlockLU overlays, command ledger and import witnesses were hash-verified and
retained in the untracked retirement implementation evidence. The manifest
records their logical names, sizes and hashes; private workspace paths are
kept only in the external custody receipt. These external inputs are not
distributed by this Git archive. No existing external input was removed.

This is not a claim of complete historical replay. The exact historical
BlockLU `.ilean` was not found in its retained baseline checkout. Its
expected hash and regeneration conditions remain recorded, and any future
replay must first recover or regenerate a matching file. This pre-existing
limitation is not repaired by substituting a current `.ilean`. No historical
writer was run during retirement.

The R07 generator and shared-postimage renderer remain in active tooling
because current completion checks and retained delivery auditors still
consume their exact paths and bytes. This retirement changes no canonical
Lean implementation, mathematical declaration, source-audit result, or
historical import wrapper.
