# Faithfulness audit: LEV-CH01-EQ-1.9-QUASILINEAR-FORM

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `0c1949a00c1d1a535a25efc878cfedcc362c25bc05bcd5c0071b6278bc2e99aa`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The target is the pointwise chain-rule equivalence in the source: the Jacobian is evaluated at the current state, applied to q_x, and added to q_t with the same sign. It assumes only the differentiability required for that rewrite and no spectral condition.

## Implications

- **Lean implies source:** `yes`. The supplied derivative hypotheses turn d_x(flux(q)) into fluxDerivative(q)(q_x), making the two zero-residual predicates equivalent exactly as in (1.9).
- **Source implies lean:** `yes`. The source chain rule under differentiability is precisely the Iff proved by Lean at the arbitrary point x,t.

## Findings

No findings were recorded.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `83` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `83` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/agent_outputs/agent_runs.json` (`02e1457700896185421e1040fd7bd9bd7beda38c483bac11f6dbbec659430ed5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/agent_outputs/batch_source_contract.json` (`01d18cafac5980a1ef30e5dd62c3b5c1d2c0698b31b34b16c4e66e96fbb17aea`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/agent_outputs/blind_translation.json` (`d0e26362353c59157eab992fe5b86614b8c2dc3e51063c07b535631cacde3b11`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/agent_outputs/direct_judge.json` (`685947c390f9569676a0a80fea43c9ba7e5340e1d36435449ada92157db5c86f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/agent_outputs/roundtrip_judge.json` (`bfad259f1e98f902c952aa24e4e169733e1b0b9af12ac9b3dfeb60199efd0604`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/agent_outputs/source_contract.json` (`a11b58301bcd298750cbf19caacfe072c1f78e231342798d8518d96ca13c8af5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/decision.json` (`fab950c6733c3e94149fcd1462f6a273f254ce2bd4afb552bc7022796f576523`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/inputs/batch_source_locator.json` (`903d9a89b0834bb17300a6f194a89f28c332dc3313cccd3490dacc2520501bf5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/inputs/blind_dependency_inventory.json` (`9b37195ac0df28d425bbcf01e68a5b7a6cee9bb728d19b6e2917e5379dc6ec8b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/inputs/blind_dossier.md` (`e62916b18fc70cfb6dbc9b0843a43153a61b8093414a89700be3a2ca617523cb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/inputs/blind_review_packet.md` (`e62916b18fc70cfb6dbc9b0843a43153a61b8093414a89700be3a2ca617523cb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/inputs/declaration_dossier.md` (`b5e6d51057d7389ccc8bff389eb351a141cf2dc190b718dfbd8d19eb5ff688f2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/inputs/dependency_inventory.json` (`f4d12bab8ec68ce5a43ebc269ead974a90b3548bc9a8c67efd57945ce014cdb3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/inputs/direct_review_packet.md` (`84c16a61619d61fb01451cadeeff4ab2dbd3291272bf6818c2b7a802615dd82c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.9-QUASILINEAR-FORM/faithfulness/inputs/source_locator.json` (`a3ba5de938c5b44990dc77be135bdfd5435f0d1f18457e494a574e3600c11dd9`)
