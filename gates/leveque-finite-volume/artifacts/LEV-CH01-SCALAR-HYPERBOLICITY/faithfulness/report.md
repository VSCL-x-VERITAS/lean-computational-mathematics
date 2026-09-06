# Faithfulness audit: LEV-CH01-SCALAR-HYPERBOLICITY

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `a0a5a1d94cd71a62eae4d2bc522348c2cffbc921be2b0933ddca3ece4285ae3a`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The arbitrary real coefficient is exactly the sole entry of a 1-by-1 matrix, whose real-eigenbasis property is the source hyperbolicity criterion.

## Implications

- **Lean implies source:** `yes`. The singleton matrix has sole entry speed and Lean proves it has a full real eigenbasis; by the cited definition, the scalar problem is hyperbolic.
- **Source implies lean:** `yes`. The source covers every real scalar coefficient, so substituting arbitrary speed and its exact singleton-matrix encoding yields the Lean claim, including speed = 0.

## Findings

- **note / matrix-level-encoding:** In the inherited constant-coefficient context hyperbolicity is defined entirely by this matrix, so no selected mathematical content is lost.
- **note / coefficient-level-representation:** The representation suppresses surrounding PDE syntax but preserves the complete classification criterion because the source makes hyperbolicity depend only on the coefficient.

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
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `34` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `34` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/agent_outputs/agent_runs.json` (`bdec641c1736a724d00ff20512bac86f21e0dbe9b0c8058826b444a6070e8fac`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/agent_outputs/batch_source_contract.json` (`fe7d116cf60b85222283c704141de3ad0bdb72cda6da84ca010c19fbb4d75440`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/agent_outputs/blind_translation.json` (`739642ecb6bffa075b3b424cc53c6ba11e0baa605b736b4052f4217d8cbb6bbb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/agent_outputs/direct_judge.json` (`c8389be6dce3b0f1287457f4e4887d6822e2f18cbbd0b03886d8242e1dfd5a0e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/agent_outputs/roundtrip_judge.json` (`597c097e6c1d26f5a4d25f70ea84293fa01ec9eca68d35b4ee587f9c604f7b77`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/agent_outputs/source_contract.json` (`a2fa0eb8056102f94de76ad802d87a30530da197f904dd4f7d06fb1a40dae454`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/decision.json` (`4bcb008b0caaba2813afb4c4229def7e5c5fdd0fd9e9aa3d0a63533b85639db7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/inputs/batch_source_locator.json` (`b56e3eeb27c8dfa2b3c34724ee064695b80433250e930ba13128ca7091d3973b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/inputs/blind_dependency_inventory.json` (`e5e67fb58017916d335e53906c77cc433ea952043b48f6bc8330071460bb845f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/inputs/blind_dossier.md` (`3183c33d1c31039bfb09fe51bad83e57bf6a6a65248fa036dcd717fefd317d71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/inputs/blind_review_packet.md` (`3183c33d1c31039bfb09fe51bad83e57bf6a6a65248fa036dcd717fefd317d71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/inputs/declaration_dossier.md` (`c2c3e42e67e950953d943c3deaee9e7f63a88c5a04dbe4faac61cdbc624452b5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/inputs/dependency_inventory.json` (`77f9d1b31aa71d23989b8e2c8905a06e4cd0a620b935007b029f824882e7585b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/inputs/direct_review_packet.md` (`81be05e56f964b4d6eec5f8fcf68b308b1ceb15230b97c74a07332117eb9bdab`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-SCALAR-HYPERBOLICITY/faithfulness/inputs/source_locator.json` (`5f58f1c6445b210af0da837145250d4b66ddb6cbfe552fdce140ec030c54fdf1`)
