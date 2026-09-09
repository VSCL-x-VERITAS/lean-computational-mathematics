# Final publication policy preparation — root review required

Use **policy-final-02.json**, SHA256 `0dc6d8d74c98c51284170c6c50119bf5423b53d663e8dcb0cfea02f46715ca10`, with the unchanged reviewed `check-publication-allowlist-v3.py`, SHA256 `8022f5e367fd9bdb8081e30634b29a038925211e2724a674c2022a380df7adc7`. All earlier policies, discovery outputs, failed attempts and checker versions remain unchanged. This is a concrete path policy, not a claim that publication or source formalization is complete.

Read-only POSIX Git discovery completed with unchanged HEAD and index. It found exactly 47 staged paths: 46 Lean files and the tier manifest. The 46 Lean paths are precisely the two aggregates plus all current goal-owned source/reusable leaves; no blanket production prefix is allowed. Their discovery-time byte pins are retained in `policy-final-01-derivation.json`. Root has subsequently repaired Analysis import order, so these observations are not substituted for the final sorted-source byte check.

The policy preserves all 21 exact owned repair audit directories, including `LEV-CH01-CERTIFIED-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908` and `LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908`. It allows the owned `unblock-nine-20260908/` evidence prefix, the exact current Chapter1 gate, the tier manifest, and only the two selected current issue ledgers. No blanket session, audit or ledger prefix was added. All failed and superseded attempts inside owned evidence roots remain selected as history, regardless of their mathematical outcome.

There were 174 observed session-root `unblock-nine-*` receipts at discovery and nine further existing JSON/text files at the additive graph correction. Those 183 paths are individually enumerated. Later session-root receipts remain excluded until root adds their exact existing paths and hashes. The six exact graph paths cover JSON and Markdown for:

- `unblock-nine-final-source` — retained historical pair;
- `unblock-nine-certified-high-resolution-final-source` — the intervening capture;
- `unblock-nine-certified-high-resolution-sorted-source` — root's planned final sorted-source capture.

The attempted name-collision capture was interrupted; its diagnostic output/receipt remains preserved, including the reported zero exit. That exit is **not** accepted as evidence of a completed graph capture. The failed layout and later import-order repair likewise remain distinct records. This policy includes paths; root's final organization/global evidence checks establish which exact successful outputs apply.

All five complete gzip archives are pinned through actual receipts: final-fingerprints, local-replacement-fingerprints, riemann-routine-fingerprints, dim-high-resolution-fingerprints and riemann-certified-fingerprints. Preparation checked each receipt hash, gzip hash/size and retained raw-stream size. The existing reviewed v3 checker will independently decompress every archive and compare the exact raw hash/size during root's final screen. No raw-stream content was regenerated or discarded.

The fifth archive is `riemann-certified-fingerprints/native-expression-stream.jsonl.gz`, 9,691,471 bytes, SHA256 `6afe9c130c88bb52388582cb69095e65f72ee2dd21416592db956dac8523ed34`. Its recorded reconstruction is 692,825,929 bytes with raw SHA256 `b127641fc8ae023e8bbb1500a19c5a892923bed7caefa237b338f507916d4014`; the frozen fingerprint receipt is `73ba5adc54a1ede1baba252743d5425d96d7bd67a61694a33c8d170a766859ff`. The total native inventory now comprises seven inventories, 1,426 constants and 171 owners; that inventory count is distinct from five large raw archives.

Every one of the five large raw JSONL paths is explicitly excluded. The original lock, old pathspec, phantom `.faithfulness-audit/VERSION`, and unrelated prepare-session ledger exclusions remain. Observed lock paths are excluded. Generated caches remain held for review by the unchanged checker and therefore are not selected; inert historical cache snapshots remain distinguishable. Any new future lock needs explicit exclusion before publication. The unchanged checker also holds unexpected conflicts, renames/deletions, symlinks, gitlinks, nonregular files, production placeholder hits and selected files/index blobs at or above 90,000,000 bytes. No issue is automatically repaired.

Eight focused pure guard tests passed. They verify the 46-source/21-audit/five-archive scope, all raw exclusions, failed-attempt retention, cache/deny precedence, and the receipt-only extension's refusal to add source paths, audit roots, raw streams, locks, traversal paths, duplicate or malformed pins. The actual discovery and policy derivations each exited zero. No staging, index mutation, commit, push, gate edit, audit role or final operational publication screen ran in this preparation.

## Root's next concrete steps

1. Finish live audits and global checks, then freeze the intended current source, gate and evidence bytes. Preserve all unsuccessful outputs; do not turn a zero process exit into semantic success when the capture was interrupted or incomplete.
2. For receipts created after this policy, fill a new additions manifest using `receipt-extension.template.json`. Each `add_exact_files` entry must name an existing session-root `unblock-nine-*.json` or `unblock-nine-*.txt` file and its exact SHA256. The template's empty list is intentionally invalid. Run the pure-filesystem helper below with a fresh output basename. It can add only these receipt paths; it cannot broaden source, audit, graph, archive or ledger scope. Other changes require a separately reviewed explicit policy successor.
3. Review the selected policy and run the exact v3 screen through the existing POSIX launcher. Review `issues`, holds, unknown exclusions, archive reconstruction, unchanged HEAD/index and actual source bytes. Checker exit zero alone does not certify publication completeness. New snapshot outputs are created during screening; root's final staged-byte review must include intended evidence produced after the snapshot.
4. Root performs the already authorized ordinary commit and fast-forward `HEAD:main` publication after exact staged-byte/diff verification. No new permission or protected-campaign admission receipt is required for that ordinary publication. Protected campaign integration/stable promotion remain separate and must not be claimed without their actual released receipts.

Pure receipt extension (native Python is allowed because this helper does not invoke Git):

```text
<native-python> -B <P>/extend-final-policy-receipts.py --additions <P>/ACTUAL-ADDITIONS.json --additions-sha256 ACTUAL-SHA256 --output-name policy-final-FRESH.json
```

Final read-only screening, from the workspace, with real absolute paths:

```text
<native-python> -B <W>/workflow-v5.0.1-local/run_workflow_posix.py <P>/check-publication-allowlist-v3.py --policy <P>/policy-final-02.json --policy-sha256 0dc6d8d74c98c51284170c6c50119bf5423b53d663e8dcb0cfea02f46715ca10 --label FINAL-FRESH-LABEL
```

If an extension was made, replace both policy path and digest with the actual returned pair. Here `P` is this publication-preparation directory. The screen has no stage/install option. Root owns the final publication decision, source acceptance and actual commit/push results.
