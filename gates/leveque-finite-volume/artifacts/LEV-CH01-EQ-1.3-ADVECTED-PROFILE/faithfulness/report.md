# Faithfulness audit: LEV-CH01-EQ-1.3-ADVECTED-PROFILE

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `aa8490df1e2e54c8c7f6d4898ba83c9afc97c21448e0e579cab14f1961f5ed07`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The target correctly preserves the real scalar setting, phase x-speed*t, coefficient signs, and local chain-rule identity. D008 is unambiguously a classical derivative-at-a-point predicate, making C04 a substantive mismatch with the source's explicit arbitrary-function scope. The source nevertheless implies the Lean conditional proposition: once the target's own HasDerivAt premise is assumed, equation (1.3) yields the required pointwise derivative witnesses by the chain rule. The converse fails because the conditional pointwise result does not establish the source's unconditional arbitrary-profile solution family. Therefore the consistent classification is not-faithful-weaker and the target is not accepted.

## Implications

- **Lean implies source:** `no`. Lean proves only that, at a selected x,t where the profile is classically differentiable at x-speed*t, the constructed traveling wave satisfies the classical advection identity at that point. It does not establish the source's literal arbitrary-profile, whole-space-time solution-family claim. The construction encodes rigid translation, but that does not supply the missing unconditional global PDE assertion.
- **Source implies lean:** `yes`. Assume the source claim and then fix the Lean binders and its HasDerivAt premise. Equation (1.3) identifies q with profile(x-speed*t). The chain rule gives q_t=-speed*profile' and q_x=profile' at the selected point, so the expanded D001 conclusion follows. This derivation uses the target's premise and does not require choosing between classical and generalized global solution notions.

## Findings

- **major / added-regularity-and-reduced-applicability:** Profiles lacking that local classical derivative fall outside the target's substantive conclusion, so the added premise is reduced applicability rather than genuine theorem strength.
- **major / global-family-versus-pointwise-conclusion:** The target cannot imply that one translated field solves the PDE throughout space-time for every source-allowed profile.
- **note / source-solution-notion-underspecified:** The printed claim needs an explicit regularity or generalized-solution convention for standalone mathematical validity, but this source defect must not be silently repaired when judging literal faithfulness.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `fail` | `fail` |
| `C04` | `unclear` | `unclear` |
| `C05` | `fail` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `fail` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `fail` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `fail` | `fail` |

## Dependency coverage

- Blind translator covered `86` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `86` dependencies (`0` hash-reused); failing or unclear: `D001, D008`.

## Remaining uncertainties

- The source does not specify a classical, weak, or distributional solution notion, and its phrase "any function" conflicts with the derivatives displayed in equation (1.2). This remains a source-validity ambiguity, but it does not alter the adjudicated implication directions because equation (1.3) plus the Lean premise suffices for the local Lean conclusion, while Lean cannot recover the literal arbitrary-profile global claim.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/agent_outputs/adjudicator.json` (`4a9b992b0b8630e57952b4a1d70133462a54af01644bde804b22c6d0cae0cc0f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/agent_outputs/agent_runs.json` (`22652b70757946036a753256642ba405676c7a743e35a55174b4172c64f8093f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/agent_outputs/blind_translation.json` (`da53745c5cd874a40188946e5bbf8f24ead496d0a131bb0d62438c7f337b7517`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/agent_outputs/direct_judge.json` (`9733e297c7146468db12c0ca3395420ce3bce0479fc841f9434b1721ecaa29ae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/agent_outputs/roundtrip_judge.json` (`b2929bda33b786bb5fa2a81647fdc1964acd023d1eabb54a75e47e053e3a9d1e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/agent_outputs/source_contract.json` (`4fd99f75048a3acd44d2c81094650fb2db443dcef223bc435918c44b6f9fd9ff`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/decision.json` (`25d95d126196f300eaac6b093b06b2ab894d9f8c9e2d56f9c208127591cdc0e8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/inputs/blind_dependency_inventory.json` (`bc13330ad21244444d8251fa0fd50d589c30cb0d71f87040d9fc878011be8a74`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/inputs/blind_dossier.md` (`0bb4fba4a660dbd30f3b90842eb91e6733e82ec24e712d44031774c5191b92d4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/inputs/blind_review_packet.md` (`0bb4fba4a660dbd30f3b90842eb91e6733e82ec24e712d44031774c5191b92d4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/inputs/declaration_dossier.md` (`8242827febfc99290f1d851c4d845bb9a360bcad804285ae81698c0322ad984c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/inputs/dependency_inventory.json` (`181e1be55ff35503b5dc7e7a813b82a96a7fd09d5f935b0434e56d81f54687cf`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/inputs/direct_review_packet.md` (`e78afe8e6693596e5dfb149a467b5454995e08db24551559a1de4e917c6f48a1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.3-ADVECTED-PROFILE/faithfulness/inputs/source_locator.json` (`bc52a1d52489d398e3c016fc53450a4ad47248ac05a99e32ea2631e8a374ead4`)
