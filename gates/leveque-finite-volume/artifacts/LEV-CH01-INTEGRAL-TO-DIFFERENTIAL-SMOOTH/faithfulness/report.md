# Faithfulness audit: LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `7c6ff2be021dd77b1a3ad98e3488daebf1e17921fa9e4ce92bb6fc3516bedcbf`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The explicit analytic assumptions are a rigorous unpacking of the source's 'sufficiently smooth' proviso. The endpoint signs, universal interval quantification, differentiation-under-integral step, continuous residual, and forward-only conclusion reproduce the classical derivation without extending it to shocks.

## Implications

- **Lean implies source:** `yes`. The all-interval endpoint balance plus interchange, FTC-compatible derivatives, integrability, and residual continuity forces q_t+d_x f(q)=0 pointwise, exactly the source's classical conclusion.
- **Source implies lean:** `yes`. The Lean hypotheses are an explicit sufficient-smoothness package for the standard source derivation, so the source's smooth all-interval claim yields the target implication.

## Findings

- **note / regularity-explicitization:** These are technical witnesses for the source's smooth regime, not a substantive change of claim.

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

- Blind translator covered `94` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `94` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/agent_outputs/agent_runs.json` (`d3f7759c521a805b090e9d00d2bcdb42ec05f3a0fca475e64c7f351f7497f26b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/agent_outputs/batch_source_contract.json` (`01d18cafac5980a1ef30e5dd62c3b5c1d2c0698b31b34b16c4e66e96fbb17aea`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/agent_outputs/blind_translation.json` (`988ae1a0dd61f453bab12313920d8c4bf0779a11334f8b86c8d1bf29b4b1baa2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/agent_outputs/direct_judge.json` (`754fffec861eb51956f8d864671e678beeefa214b1fd5345312bff8bc7b0e273`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/agent_outputs/roundtrip_judge.json` (`1b92c055d57f6257ed84a8da0706c224d9d7850f9281289e3c5c061b3465bbf2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/agent_outputs/source_contract.json` (`4a725643a6c1c5a191c433e4ab5eca18eb96abdb6ed768f0aee4c27e77e0f20e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/decision.json` (`7c77d61ab71288a9c48ac69933abb0e97e3c6e65bd6ea60d66e084d37d63ab79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/inputs/batch_source_locator.json` (`903d9a89b0834bb17300a6f194a89f28c332dc3313cccd3490dacc2520501bf5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/inputs/blind_dependency_inventory.json` (`95bf2f193f1d4a8c6385c316391c68f7144e6b416f779f1cf34bdd07f70b308d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/inputs/blind_dossier.md` (`05b7f85c8b1de5de4ceac89af7509c773327953210eed2c7c14f86e242aeeec7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/inputs/blind_review_packet.md` (`05b7f85c8b1de5de4ceac89af7509c773327953210eed2c7c14f86e242aeeec7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/inputs/declaration_dossier.md` (`303a651ce763f18ea864575838dd6b52841a117ee6e923f85607197bdaff89ef`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/inputs/dependency_inventory.json` (`9fb568d3baba38b0e316ba2d322aecd5da6e300c98b96f8f78d3a7eb4a75a271`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/inputs/direct_review_packet.md` (`c6ad03a8585f7c2b3bbff328c21d24cfc9989fd055f5b67d637c78fb27809394`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH/faithfulness/inputs/source_locator.json` (`001cafb8711b034a05331b9a3cb32e9b39a52623b335ffa4e451a572e2ac664e`)
