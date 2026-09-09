# Publication cache proposal

Use `../policy-final-physical-03-private-successor.json` for root review. Its SHA-256 is `8c2e359c6960e5b277019b45df3814b64f8aef995a0626c4d08788931245366b`. The initial proposal 03 remains unchanged at SHA-256 `f20247c346a2901faff1aced68d35b9f2c8f39c736399afd69852630dea1ebec`.

Compared with policy 02, only `generated_cache_suffixes` and `exclude_exact` change. `.ir`, `.olean.private`, and `.olean.server` are now conservative HOLD suffixes. Eight exact native-generated caches from the frozen FTaylor/Defs probes have receipt-, byte-, and hash-bound exclusions; their `.lean` sources remain eligible. Six of those caches previously leaked into SELECT through the evidence prefix. Unverified or ongoing diagnostic caches are held by suffix, not asserted to belong to the frozen exclusion census.

The private successor additionally excludes exactly `physical-dim-overlay-diagnostic/closure01/environment-stdout.txt`, as requested by root through the coordinating agent. Only its path, size and hash were inspected. Its content was not decoded, copied or printed; it remains private local provenance.

All 59 production paths, seven archive entries, existing raw exclusions, other allowed paths/prefixes and the 90,000,000-byte limit are unchanged. Seven archive files and their receipts were hash-checked; expensive decompression and raw-stream rehashing were not repeated. Historical policy notes mentioning five archives remain historical text; the unchanged actual array contains seven.

The unchanged checker v3's pure `verify_policy` and `disposition` functions passed 352 tests (actual POSIX exit 0, 1,875 ms). The private successor passed the exact-exclusion, unchanged-allow-dispositions and Lean-source eligibility checks. Neither official checker entry point nor Git, staging, source, gate, audit or policy installation was invoked. This is a proposal, not a final publication census or authorization.
