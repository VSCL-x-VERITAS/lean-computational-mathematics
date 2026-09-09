# Direct transport readiness: existing lossless protocol does not fit

This is a size and reconstruction measurement, not an audit or an operational transport plan. The source and blind roles launched with the original guard remain separate and unchanged.

The frozen original direct plan is `../role-size-guard/direct-byte-01/plan.json`, SHA256 `9492c32a9bc0f132da869fe58d464b3b466cacf83a6369986f3231e617e47f96`. Its exact input SHA256 is `e5cfcc528c52b2f6dd8472e7164feaf90cee08c34dcf1e267199b42184f74971`: 1,971,309 UTF-8 bytes / 1,945,080 Unicode code points. The role was not invoked by that rejected guard plan. No native CLI failure is asserted.

The unchanged previously reviewed `direct-transport-recovery-v1/transport.py` and `compact.py` were evaluated in memory. They retain the entire 812,739-byte canonical direct packet verbatim once, preserve exact JSON string tokens via same-prompt canonical references, compact only JSON formatting outside strings, and use the existing exact-byte dictionary in the two large JSON documents. The native inverse reconstructs the complete original input byte-for-byte. Input and helper hashes were checked before and after the measurement.

The resulting representation is **1,241,288 Unicode code points / 1,265,499 bytes**, still **192,712 code points above** the native limit. Its SHA256 is `908157ca4b85e2c9d5557dc673ef24dbd1faac06f4b33da95606edc19b694b14`. There are 305 canonical-packet JSON token references, 343 dictionary blocks and 1,056 dictionary references. No replacement prompt was written.

Actual measurement exit: `actual-01/receipt.json`, SHA256 `edbe0b2b9ea6582cf785e47110a84f842a7b8db2c4c4f52515869e87a37aa2e3`. Output SHA256: `ae63ac68559e375f47cf119fdcf20238e6b32b26708cc883296c4b1664826539`. The exit is zero; `fits` is false. A prior inline diagnostic omitted the shim's required `os` import and failed before measurement; the subsequent inline calculation and this recorded run both produced the same represented input hash. No task files were written by these diagnostics.

Bounded in-memory threshold experiments using the same reference forms also failed to fit: token threshold / dictionary minimum 128/64 → 1,201,718 code points; 64/64 → 1,183,920; 64/48 → 1,173,551; 48/40 → 1,171,383. The last requires 1,688 packet-string references and 2,967 dictionary references, remains 122,807 over the limit, and makes the evidence less readable. These were diagnostics only, with byte-exact inverse assertions; no successor encoder or candidate prompt was retained or adopted.

The character-metric-only guard preparation in `../role-character-size-guard` was paused before tests, review, adoption or operational plans after the actual direct size became known. Its original sibling guard remains unchanged.

Recommendation: do not add further compression layers. Investigate an exact full-text native transport that avoids the exec input limit, preserving the prescribed role bytes and tool-free fresh role. Any such route needs its own verified transport and receipt integration. The old direct/adjudicator recovery runners cannot be used unchanged: their provenance requires an actual unstarted native failure, whereas this task has a pre-launch guard rejection.
