The exact native command, UTC start/end timestamps, output hash, actual exit code, and before/after source/compiled input pins are recorded in each `native-NN/receipt.json`.

To replay in a fresh attempt directory, from any current working directory:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -X utf8 -B 'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-time-step-admission-draft/run.py' native-fresh-label
```

The helper invokes native `lake.EXE env lean` from the pinned repository and refuses an existing attempt label. It does not use released audit Python, run model roles, create a compiled scratch module, or mutate a canonical owner. After a future production dependency change, a new replay is required; an old successful receipt is historical evidence, not validation of changed inputs.

The prior native-01 through native-04 attempts remain exact failed inputs/output/receipts. Their failures were local elaboration (`Int.cast_lt` inference, an untyped integer window, dependent-if rewriting), a missing `noncomputable` annotation on a canonical projection, and an unsupported optional printer-width setting. The fourth attempt already checked all mathematical declarations with allowed axioms, but its nonzero command exit is not accepted; only the final zero-exit report is consumed by the freeze validator.
