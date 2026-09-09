# Additive native Windows transport repair

The original source-context preparer and spec remain frozen. Root's first FV invocation failed while creating `inherited-source-interpretation-packet.json`, before any released route/prepare command. The operational task then contained exactly `audit-task.json` (SHA `af06463548515f564b0acf4cea1fa51a73630a41ff340ceda81352bf80cf3156`) and `user-interpretation-packet.json` (SHA `27b20ced2dbc1cd6dd4044679e9bc68ac69513b309d0d7aaefa8052df6e15263`). This task read those bytes and did not modify its directory.

The additive `prepare-successor-audit-with-source-context-long-paths.py` installs process-local extended-path conversion for native Path open/stat/mkdir/iterdir/resolve operations. Conversion happens at I/O only. Repository-relative strings, `relative_to`, source paths, and POSIX launcher arguments stay unchanged. The same I/O shim is placed into newly generated role transports; no prompt, role, source, interpretation, validation or verdict behavior is altered. The original helper remains unchanged.

Fresh preparation retains the same `helper.py spec.json` command and schemas. Guarded recovery adds `--recover-partial manifest.json --recovery-sha256 SHA`. It requires the pinned original preparer and spec, the exact task directory, only the two expected regular files, and no successor configuration. It independently regenerates the two existing payloads and demands exact equality, without opening either for writing. The first new write repeats the initial directory and byte checks. Later released commands and completion recheck the preserved two hashes. All other writes retain exclusive creation. No prepared/sealed task or role result can enter this recovery mode.

`long-path-recovery-checks.json` records an actual successful native write of the exact inherited packet at a 345-character scratch path ending in the same full task ID and filename. It checks logical path preservation, exact regenerated original bytes, unchanged original timestamps, and rejection of changed originals, changed regenerated data, wrong recovery manifest hashes and any unexpected third partial-task entry. It does not claim operational recovery or audit success; root owns that invocation and its actual receipts.

From the repository root, the reviewed recovery invocation is:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -X utf8 -B 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/prepare-successor-audit-with-source-context-long-paths.py' 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/finite-volume-local-flux-update-audit-spec.json' --recover-partial 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/fv-local-domain-review/fv-partial-preparation-recovery.json' --recovery-sha256 c09ae07dfec56808608e51f249e68196bebf78bdd0ce0ffb5009079c6a5c47a7
```

This command is intentionally unusable after recovery has added further task files. Do not rerun it against a later preparation phase.
