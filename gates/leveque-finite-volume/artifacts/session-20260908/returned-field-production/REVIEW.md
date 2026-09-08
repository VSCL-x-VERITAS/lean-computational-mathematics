# Returned Riemann field placement

This additive placement preserves the root-reviewed frozen draft's mathematics in four new leaves. It does not select a source interpretation or change a source wrapper. The full old-to-new declaration and owner map is `placement-map.json`.

| New finite-volume leaf | Public content | Reuse and dependency decision |
| --- | --- | --- |
| `CellAverageTraceEstimate.lean` | `norm_sub_oneDimensionalCellAverage_le_of_trace` | Imports only `CellAverageEstimates`. Composes its existing average-difference bound, the triangle inequality, and the existing constant-integral identity. No governing law or numerical method enters this theorem. |
| `RiemannFieldFluxMethod.lean` | Structure and namespace `interfaceFlux`, `ofExact`, `ofExact_interfaceFlux`, `ofExact_returnedField` | Imports `RectangleRiemannInterface`. The existing exact method retains its certified dependent result and extractor under `ofExact`; it is too restrictive to represent a generally inexact returned field itself. |
| `RiemannFieldFluxError.lean` | Namespace `interface_error_le`, `update_error_le` | Imports the preceding leaves and `FluxUpdateErrorBounds`. Uses the existing physical face average and conservative finite-volume update bound; does not reprove conservation or integral estimates. |
| `Examples/StationaryRiemannField.lean` | Fifteen declarations in namespace `StationaryRiemannField` | Imports `LinearRectangleRiemannInterface` and `RiemannFieldFluxMethod`. Reuses existing Riemann data, their integrability, translated rectangle solution and linear hyperbolic law. The old draft's separate identity-matrix hyperbolicity helper is inlined solely in `transportLaw`. |

The structure retains all nine fields, including a dependent result type, domain-dependent solve, actual returned field, strict-half-line initial data, interface trace integrability for **every real pair `s,t`**, the extractor of that very result, numerical flux, constant-state admissibility, and consistency. No spatial regularity, exact rectangle conservation, entropy criterion, accuracy tolerance or convergence theorem has been added. The error theorems retain independent extraction and returned/reference trace-error hypotheses on `Set.uIoc 0 dt`, an independent exact reference rectangle solution, and the old admitted array. The update theorem retains positive `dt`, the exact cell width, both adjacent interface bounds and the initial cell error.

The example still returns stationary Riemann data for unit-speed transport. Unequal states make that field fail rectangle conservation, while at positive times its interface trace equals that of the exact translated reference. This shows a substantive distinction between a consistent returned-field method and an exact solution method. It does not certify a desired numerical accuracy. Zero-dimensional and arbitrary finite-dimensional parameters were preserved from the draft; the concrete nonexact existential uses one component.

## Preservation evidence

The new structure is nominally distinct from `ReturnedRiemannDraft.FieldFluxMethod`. `Comparisons.lean.fragment` therefore defines explicit field-by-field `toDraft` and `fromDraft` maps, both round trips and an equivalence. Eighteen projection checks preserve all nine fields in both directions, including the proof fields and all-real temporal integrability. Interface fluxes commute in both directions; exact adapters commute as structures and preserve the actual returned certified field. The stationary method commutes after conversion.

Two compiled bridges apply the canonical error theorems to `fromDraft method` and produce the full old theorem types. Their type comparisons and seventeen other declaration comparisons are checked by Lean. The latter have definitionally equal types; equalities between proof-valued constants also use Lean's proof irrelevance. No identity or DefEq claim is made between the two nominal structure types, and these checks are not an assertion of arbitrary full normal-form or source-semantic equivalence.

`run.py` snapshots the exact new sources on every attempt, verifies the frozen draft and seventeen reused source/environment pins, hashes the direct compiled imports, executes native Lean/Lake, records actual exit/output, and checks that inputs remain unchanged. Comparison input contains the full, byte-exact frozen draft, including its existing inspections, before the new fragment. The isolated declaration check covers all 23 authored canonical declarations. The comparison check covers 50 authored conversion/comparison declarations, in addition to those canonical checks. `freeze.py` and `verify.py` require successful actual receipts, matching hashes and standard axioms only. Every attempted native input/output/receipt remains present.

## Commands and scope

Run from the repository root with Windows Python `C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe -B`:

```text
gates/leveque-finite-volume/artifacts/session-20260908/returned-field-production/run.py <fresh-label> build
gates/leveque-finite-volume/artifacts/session-20260908/returned-field-production/run.py <fresh-label> checks
gates/leveque-finite-volume/artifacts/session-20260908/returned-field-production/run.py <fresh-label> comparisons
gates/leveque-finite-volume/artifacts/session-20260908/returned-field-production/verify.py
```

Do not rerun `place.py` or `prepare_comparisons.py`: their one-time destinations are intentionally protected. Native commands are `C:/Users/qed_s/.elan/bin/lake.exe build <four modules>` and `lake.exe env lean <retained input>`, using Lean 4.29.0-rc3 and pinned Mathlib e8ea1afc32790ce1d4e1a4e45cc412ba9388716b.

Only the four new leaves and this placement-artifact folder were written. Existing owners, source wrappers, aggregates, tier manifests, gates, ledgers, audits, topology and Git were not edited. Root owns exposure, organization and any later source audit. Pending source choices remain pending.
