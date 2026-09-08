# Verification capture notes

All three native Lean runs (`first`, `final`, and `declarations`) exited 0. The first and final candidate outputs are empty. All 24 axiom reports use only `propext`, `Classical.choice`, and `Quot.sound` (or a subset).

The first metadata freeze exited 1 because its declaration-name parser did not allow the apostrophe in Mathlib's `Filter.Tendsto.congr'`. The unchanged Lean check output was complete and successful. `freeze.py`, `freeze-output.txt`, and `freeze-exit.json` preserve that unsuccessful metadata attempt.

The second metadata freeze corrected that parser and exited 0, but its artifact enumeration included its own still-open output file. Therefore `final-receipt.json` is retained as superseded metadata, not the authoritative receipt. `freeze-v2.py` and its output/exit remain unchanged.

`final-receipt-v3.json` is the authoritative receipt. Its capture excludes its own receipt and currently open freeze output/exit sidecars, binds the completed earlier artifacts, and rechecks all source/audit inputs and exact Lean run hashes. No Lean edits or repeats were needed for these capture-only corrections.
