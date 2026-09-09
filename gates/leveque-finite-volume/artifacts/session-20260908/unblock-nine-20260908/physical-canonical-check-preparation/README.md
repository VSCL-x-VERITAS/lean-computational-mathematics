# Current physical owner declaration checks

These are prepared inputs, not native verification results. Run them only after root's canonical owner build succeeds. The current sixteen owner files were byte-compared with the frozen attempt-06 proposals and the actual placement receipt before generation.

`AllCurrentDeclarations.lean` imports the exact sixteen modules and emits one `#check` and one `#print axioms` for each of their 169 explicit authored declarations. `expected-declarations.json` records exact source lines and declaration kinds, five unchanged moved lookup names, eighteen retained names in the changed mathematical owners, and each check's expected report count. Generated/private implementation names are not invented.

The three independent smoke inputs have deliberately narrow imports:

- `SourceImportSmoke.lean`: only the source module; 14 source/core contract names.
- `LookupImportSmoke.lean`: only `FiniteLineCoordinates`; all 10 explicit lookup/ghost declarations.
- `LegacyLookupImportSmoke.lean`: only the existing `CoordinateLineMethodEstimates`; 18 lookup and retained realization/execution names.

Root should use the established native Lake capture helper with fresh labels for `lake env lean <input>`, preserving actual command, exit, stdout/stderr, source and compiled dependency pins. An actual result must check all expected reports, permitting empty axiom output or only `propext`, `Classical.choice`, and `Quot.sound`, and preserving displayed universe parameters. These inputs request full names, universe parameters and deep terms; they do not truncate printed statements.

This packet does not perform the separate nominal transport comparisons, prove old/new source equivalence, or claim that an import smoke check excludes every unrelated transitive dependency. The existing five-owner C∞/choice group and its old 149-author packet remain separate root-owned verification scopes. No Lean, build, Git, audit, gate or production mutation is executed by the preparer.
