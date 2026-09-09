# Local finite-volume source target and fresh-audit preparation

The new selected source target is `NumStability.leveque01_finiteVolumeLocalFluxUpdate_sourceContract` in `ComputationalMathematics/Source/LeVeque/Chapter01/FiniteVolumeLocalFluxUpdate.lean`. It explicitly uses a state `q`, a flux law `flux`, the slices `q(·,s)` and `q(·,t)`, and the physical histories `flux(q(a,·))` and `flux(q(b,·))`. Its conservation premise is the balance on this one positive-width cell and positive-duration slab, with exactly those two slice and two face integrabilities. No global rectangle-solution predicate, all-real integrability, global smoothness, or hyperbolicity premise is required. The globally typed function arguments impose no solution conditions outside this slab.

The reusable producer remains `NumStability.finiteVolumeLocalCell_error_contract`, alongside the public `NumStability.norm_le_of_weighted_error_balance`, in `Analysis/PartialDifferentialEquations/FiniteVolume/LocalCellErrorBounds.lean`. Its density and face-history inputs are generic. The source wrapper instantiates it with the actual state/flux using Bool for physical left/right selection; numerical Cell and Face index types remain arbitrary. The wrapper proves normalized averages and their native-volume connection, the numerical update, the exact weighted error identity, and the next-step norm estimate conditional on independent old-average and two face-flux bounds. The specified norm and bounds are interpretation data, not numerical quantities supplied by the book.

Native focused build and declaration/axiom checks both returned actual exit 0. `production-local-law-declarations-output.txt` contains all three production types and five separately compiled consumer types with their axiom reports. Reports use only `propext`, `Classical.choice`, and `Quot.sound`. Consumers include the old global theorem's applicability, an explicit state which fails the global conservation predicate yet satisfies the local slab example, a nonzero numerical error with exact norm 1, and AE invariance of normalized interval averages. They remain outside production. The current source wrapper itself is a native checked direct instantiation of the generic producer; consumers do not add source claims.

`local-law-production-freeze.json` pins all final source inputs, actual receipts, native output and the historical source. The original `FiniteVolumeUpdateError.lean` is unchanged. The earlier generic prospective wrapper is preserved as `FiniteVolumeLocalFluxUpdate-generic-superseded.lean.fragment`, with its successful build receipt retained. No aggregate, tier, gate, audit decision, Git, or runtime mutation was performed here. Input commit is the actual `5e3f63594aa964263469ada134aee2809559d50d`; no future commit is asserted.

## Source boundary

The primary selection remains exactly the prior §1.2 finite-volume paragraph on raw PDF page 27 (printed page 5). Raw page 26 supplies its explicitly referenced equation (1.10) and endpoint-flux explanation; the inherited §1.1.2 discussion across pages 26–27 supplies the smoothness/discontinuity context. These are inherited context, not additional independently audited rows. The authoritative PDF SHA is `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. Both copied source renderings match the existing pinned source-review renderings.

Q7 remains the coordinator-selected conditional accuracy convention under the user's objective to unblock all nine rows. The exact earlier Eq1.10 user receipt is separate: SHA `b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030`, question call `call_GV856xXH10OQXasWapraHP5y`, answer “Adopt this interpretation and preserve the source ambiguity”. Its original scope and all fields remain literal. Neither this receipt nor Q7 is treated as adopting global solution extensions or a new pointwise representative convention. Fresh judges must independently assess the source correspondence and the applicability of the inherited receipt. This preparation supplies no verdict.

## Additive preparation interface

`../prepare-successor-audit-with-source-context.py` is derived from the pinned `prepare-successor-audit-with-companions.py` without changing that parent. Existing `additional_supplement` behavior and real-measure supplement copying remain intact. A spec may additionally contain `source_context_extension: {path, sha256}`. With that field absent, the parent's source and interpretation behavior is retained.

The referenced JSON uses a closed schema with exactly these keys:

- `format`: `pinned-source-context-extension-1`.
- `source`: exactly `{path, sha256}`, matching the prior task and the PDF bytes.
- `primary_locations`: the exact original nonempty location list.
- `inherited_locations`: a nonempty list of new `{location, anchor}` strings, disjoint from the primary list.
- `pages`: unique positive raw-PDF page integers, in precisely the order of the spec's comma-separated `pages` argument.
- `images`: one `{page, path, sha256}` per listed page, matching both the pinned repository bytes and the corresponding existing source-review PNG bytes.
- `interpretation_receipts`: nonempty unique exact `{path, sha256}` references to original explicit-user-adoption receipts for the same source SHA.

Paths are repository-relative POSIX paths; traversal, duplicate JSON keys, unknown top-level fields, changed hashes, different primary locators, image/page mismatches and mismatched source/authority receipts are rejected. Receipt question, answer, scope, adopted interpretation and authority-limit fields are required and are copied both as exact UTF-8 bytes and parsed fields.

Before released preparation, the helper sets the new task locator to original primary locations plus explicit inherited locations. It creates a separate `inherited-source-interpretation-packet.json` and manifest-binds the extension, original receipts, PDF and images. Source-context pins are checked before every released command and against the completed prepared manifest. Source-facing role transport requires the exact configured pages and rechecks image hashes. Only judging roles receive the inherited interpretation packet; blind translation keeps its exact sealed packet, and source-only extraction receives the source locator/images without either interpretation packet. The inherited packet states its original scope and distinct authority. It contains no prior judgment.

The additive helper also uses an extended native Windows path for the final generated-packet preflight, avoiding the previously observed MAX_PATH transport problem without changing released scripts. Fifteen synthetic or read-only checks passed. The first fixture attempt encountered a Windows directory path limit; the second uses an explicit extended path. An initial production-freeze parser rejected a line-wrapped axiom list; it was corrected to parse whitespace, and all eight reports were then checked against the same three allowed axioms. No native proof was changed by either evidence-script correction.

## Ready invocation and remaining work

From the repository root, after coordinator review:

```powershell
& 'C:/Users/qed_s/AppData/Local/Programs/Python/Python312-arm64/python.exe' -X utf8 -B 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/prepare-successor-audit-with-source-context.py' 'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/finite-volume-local-flux-update-audit-spec.json'
```

This prepares the new `LEV-CH01-FINITE-VOLUME-LOCAL-FLUX-UPDATE-INTERPRETED-PRODUCTION-20260908` task, retaining the prior failed interpreted task and its original primary selection. The spec reuses the Eq1.10 native real-measure supplement/config, adds the exact local-law native statement packet, and supplies the two separately attributed interpretation receipts. It does not invoke model roles. Root then owns fresh independent audit launch, any findings, organization/exposure, declarations in the complete campaign manifest, updated structural fingerprints, final bindings and gate work. None of those later outcomes is claimed here.

For the information-solver successor, reuse the same optional interface with its exact original primary locations, add only the necessary inherited equation context, and pin all source-facing pages for that task. Do not reuse the FV primary locator or claim an independent interpretation verdict from this packet.
