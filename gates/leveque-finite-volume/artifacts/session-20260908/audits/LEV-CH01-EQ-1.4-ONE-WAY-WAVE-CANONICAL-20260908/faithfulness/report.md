# Faithfulness audit: LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `false`
- Target SHA-256: `6c8a8809067f4ea87aa82e1a4e0e52275aeb9a9c2b7390a7b78a99b634fd102f`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached source pages and all supplied declaration dependencies support a determinate distinction. The Lean proposition faithfully establishes nonvacuous scalar transport consequences of the surrounding mathematics, including the correct PDE, positive direction, and scalar hyperbolicity. It does not represent the selected passage's acoustic identity and modeling relationship. The source in its inherited mathematical context implies these transport consequences, whereas the Lean proposition does not recover the acoustic modeling claim. This is a weaker representation of the selected result, not a stronger theorem. No unresolved evidence or implication remains requiring adjudication.

## Implications

- **Lean implies source:** `no`. The Lean statement establishes correct abstract transport facts: [c] is hyperbolic, x + c*t increases when c > 0, and a differentiable translated profile satisfies w_t + c*w_x = 0 and retains its value along a characteristic. It has no premise, construction, or conclusion connecting that dependent function to pressure and particle velocity, or identifying c with the acoustic speed of a material. Consequently these facts alone do not establish the selected assertion that a right-going sound wave has this model with w an appropriate acoustic combination. Recovering that assertion requires the independent acoustic modeling relation supplied by the source, not merely unfolding the Lean dependencies.
- **Source implies lean:** `yes`. Under the inherited mathematical context and ordinary real calculus, the Lean claims follow from the source's mathematical content. Printed page 1 states scalar real-coefficient hyperbolicity and gives profile(x - speed*t) as an advection solution; printed page 2 identifies the mathematical forms of advection and (1.4). With a profile derivative d at x - c*t, the chain rule gives temporal derivative -c*d and spatial derivative d, hence exact zero balance. Substitution gives profile((x + c*t) - c*t) = profile(x), and c > 0 gives strict increase of x + c*t. The real one-dimensional basis witnesses D006 for [c]. These consequences do not require a global regularity class or a uniqueness theorem. They retain only the abstract mathematical part of the source's richer acoustic modeling claim.

## Findings

- **major / missing-acoustic-model-linkage:** The target proves mathematical transport properties without representing the selected acoustic modeling assertion. Lean does not imply the full source claim, so acceptance as equivalent or stronger is unwarranted.
- **minor / constructed-solution-scope:** The construction and local regularity make a valid classical solution-verification theorem, but they do not complete the selected source claim. The additional trajectory and cancellation conjuncts do not compensate for this loss of applicability and meaning.
- **note / preserved-equation-direction-and-nonvacuity:** The rejection concerns source coverage, not an incorrect transport sign, scalar dimension, hidden derivative default, or impossible hypothesis.
- **major / missing-acoustic-modeling-connection:** The translated mathematical result does not imply the selected source modeling claim. Correct signs, positivity, scalar hyperbolicity, and characteristic identities do not restore the missing acoustic relationship.
- **note / explicit-classical-regularity:** This is a reasonable pointwise classical interpretation, not evidence of totalized derivatives or a claim about nondifferentiable profiles. It does not repair the substantive modeling omission.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `fail` | `fail` |
| `C04` | `fail` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `fail` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `fail` | `fail` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `fail` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `115` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `115` dependencies (`54` hash-reused); failing or unclear: `D003, D004`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`4e27410789b5ce046cbe2f108bb1e6824bcea8f32f741cfc3a9aa3539dee811e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`293656e9ce5f62e0ca8eee314e04710db71d5be029c4259347170f4bcb6e315f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`a730f661aef54a5e753ec437de87a746e036ae1e98de15757940fe6e486e0b69`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`e8804d5c7a9b5aa9f557d04d0bb0498d4d4b8cec7da5d286f7218414c01e88d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`e36cd94a7e99f75516ce1e448c7b40b274d12e7cbfdb06ea292ce254defd0afe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/decision.json` (`77601b25183ffff2ec98185b1cafe3103e0968a94e151d7ef78d00a7f88fbaee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`78e2049e93ff36c519e17cf17153e80ac6bb6243b33201cd16d774ffcf6981cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`30dd425bb38a51bcce0cec8d7882d104f2d82d29670a998ee496b4b83703ca4c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`30dd425bb38a51bcce0cec8d7882d104f2d82d29670a998ee496b4b83703ca4c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`5797b552ea49e51a17374dd9ca8705f1a1c6e3e45eaad34c2b54d494fa26eac4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`9b34917ad922ae32b9b309b3b43b3095cb829388812d7beb493a773d29042d6f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`c85565cf38ebf14ff8df5d663174c0e7b4479e4cbb37e5875c992cfe4132e96e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`3d91e75e7c3464c1a98d02687dde65f8bb90bf1480f7dda68e63f0bc37d0c9aa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`23e68ef4fceb27ddde239c6ac457ca9a78678e63456d2f3a33b2af855e22d0c3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`f742e8afce974b0d634395b25c22e65fa43ffb3d6c645dfdd3ec24f4e7db7c9b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`293656e9ce5f62e0ca8eee314e04710db71d5be029c4259347170f4bcb6e315f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`a604c9c9f4e23a8d3a3e47fc3abc47e976f854f68d6258ef1b0d6b5f9168ef1f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`662e3ae9178fe4fcd25168c7e6285fcfd90c70427c77a5620545f9a3e0682caa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`2598d7e3285f6c1b5c2e58dc2462eeefe0b3e413cb0c17804eaddc4b5e233f9f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`358fe7582f6b980ff9e9ff1e6ad20a30630683afd4a942f1dabd79a3a1bb689d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`7019b4557fa5e7605f2e17f97648cc45fbf0b825bfde2f81d747c2c1076ffe7c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`a730f661aef54a5e753ec437de87a746e036ae1e98de15757940fe6e486e0b69`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`fa5d139c8082af5fa0bdca941f2187a2dc8024454aa8e18beba1c07e8643d699`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`5adc21ac6375be87f287b6ea0d2201c388d90c68e192ba480077f08a34611646`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`5d04ff7892129c6bb7faa586f4086370b78d6f54a749bde15df9ee23e73ea2f7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`087e509843bb89cf5c930c54d3a95549fd4821c94cc15b03daee7c182ea27667`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`890e685d4ae6026506863992594450886559d35b6048e58da9571156fdbec7fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`e8804d5c7a9b5aa9f557d04d0bb0498d4d4b8cec7da5d286f7218414c01e88d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`39e89775099f7d9a22f274a49d2d6d49e30184adbe3c0c8fb8646ca7e43a8a20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`349d331e6ffe4607342823f246ef07f23a0a4a47082f98c8d49ea6fbd8e6e098`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`4a6954dd603233fb3540817df7697e63afec8fbdfaf8386cc4bdaa593ad57306`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`785936fbe2436cbea961ec0d78ecbfaff2277f16c547c52c482ed6e8b26439a5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`a4a0ee231445fc1dc1e99b7b860bbe2e46b9c737b2f17db63e22efdf7092371f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`e36cd94a7e99f75516ce1e448c7b40b274d12e7cbfdb06ea292ce254defd0afe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`1c2dd4e5df612b43461093645ec938666043fbbb05c7ba4a3c6b469bda2425b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`297d1e21893ed5848a7866eeadc65d33865a3d94cd0c96a4432c13f8d050af0a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`b87db5b0edf42cfcb5209dacb35f871e7f81eabdc70e707070fcf978813009a7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.4-ONE-WAY-WAVE-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`be0fed0f89818ff8c8772fe9ab69ac24f67ad48be7becc4d6c337fb76f0abd39`)
