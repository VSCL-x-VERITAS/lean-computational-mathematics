# Faithfulness audit: LEV-CH01-LINEAR-FLUX-SPECIALIZATION

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `c3da5f0957e45af840d4c9e224e7eadb6c7c9409cad97ba652939843a28f0df2`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

constantLinearFlux is supplied as matrix-vector multiplication, and the derivative premise permits d_x(Aq)=Aq_x. Expanding the predicates makes the two sides exactly equivalent, without adding any hyperbolicity or spectral assumption.

## Implications

- **Lean implies source:** `yes`. constantLinearFlux unfolds to A.mulVec; under hqx, differentiating A*q gives A*q_x, so the two pointwise predicates are exactly the same equation.
- **Source implies lean:** `yes`. The source's constant-matrix linear-flux specialization is exactly the Lean Iff and supplies no extra spectral condition.

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

- Blind translator covered `78` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `78` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/agent_outputs/agent_runs.json` (`9a3ecdd25c73f270e8e7a7c292e397c8502865befb8b5fa3dae50ae0c0e28b31`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/agent_outputs/batch_source_contract.json` (`01d18cafac5980a1ef30e5dd62c3b5c1d2c0698b31b34b16c4e66e96fbb17aea`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/agent_outputs/blind_translation.json` (`eb77c86c2bda1c164f0535b0aaf498f038566d4ccbc04437df716c1aae1002e0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/agent_outputs/direct_judge.json` (`1c8edea5127a8304c6715c69903156ef2b718fab7397a127816e56f64a4df47e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/agent_outputs/roundtrip_judge.json` (`240aaf9e21b64a652f0e921e9e8641bcf55ddbde055eac54a61ff6333de10669`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/agent_outputs/source_contract.json` (`411ceb209ecdf306f9e6919ec870a81897160d6ad49152d9771a5080c1971a60`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/decision.json` (`3605165707e8fc50b14e61f3d6b44a2c5f8ec1e40bd3fb890a10fe6749cfb2ae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/inputs/batch_source_locator.json` (`903d9a89b0834bb17300a6f194a89f28c332dc3313cccd3490dacc2520501bf5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/inputs/blind_dependency_inventory.json` (`79f9943b53c2bae4bb93d860a74e75ee830e091b42c6e882997e3fed52604885`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/inputs/blind_dossier.md` (`f2fbdfed4cea3949059150b668779407ce3b1286ab2c3e0d89df46038e95e42b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/inputs/blind_review_packet.md` (`f2fbdfed4cea3949059150b668779407ce3b1286ab2c3e0d89df46038e95e42b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/inputs/declaration_dossier.md` (`1b5542434d44bfca22f968130d73db07abeb12c3fa081f1bd937ef9d9fe2e60b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/inputs/dependency_inventory.json` (`a59ae9bb5929195a00d3095233700bc83f62b688cbf8b740bc5df344756ec320`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/inputs/direct_review_packet.md` (`a706aeba8ee57c1235e1c1a8162b4428a7ca5661173a1db683918853f28b07a0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-LINEAR-FLUX-SPECIALIZATION/faithfulness/inputs/source_locator.json` (`ebdcc568195d4473bb9fba7dcfd91a70e21884cb77743cbcf77af79b7adbb861`)
