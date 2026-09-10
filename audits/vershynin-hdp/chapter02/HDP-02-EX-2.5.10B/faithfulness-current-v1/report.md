# Faithfulness audit: HDP-02-EX-2.5.10B

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `a524f044596ff4ed2134e16ec2face62f23f750dfe1cc26012375c79b1eb9997`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target preserves the universal absolute constant, arbitrary dependence, absence of centering, global all-sequence ψ₂ bound, and finite first-N expected absolute maximum. All-Nat iSup defines K, whereas Fin N iSup defines the left side; Nat zero-based indexing is a bijective renaming. PsiTwoGauge implements the source infimum. Global <⊤ and finite-prefix structure make ENNReal.toReal sound. Explicit Integrable states finiteness implicit in the source expectation bound. Under the standard uniform-supremum reading of the source’s infinite max, both implications hold.

## Implications

- **Lean implies source:** `yes`. After reindexing X₁,X₂,… as X 0,X 1,…, Fin N is the first-N maximum and the all-Nat gauge is global K. The outer C is absolute and the Lean inequality gives the source inequality; explicit integrability is already forced by the finite bound.
- **Source implies lean:** `yes`. With the source’s meaningful finite-global-K convention, sub-gaussian coordinates are measurable, their global ψ₂ supremum is below top, and their finite absolute maximum is integrable. Reindexing and the guarded toReal conversions then give every Lean conjunct without independence or centering.

## Findings

- **note / global-gauge-scope:** K remains global; iSup formalizes the source’s uniform-bound reading and toReal is safe.
- **note / index-origin:** The +1 bijection is harmless and has no off-by-one loss.
- **note / explicit-integrability:** This exposes implicit finiteness and blocks total-integral vacuity; it does not change the claim.

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

## Dependency coverage

- Blind translator covered `91` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `91` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/agent_outputs/agent_runs.json` (`da286d1b6f3449abbbdb4fab41273a0fac66ecb3b63921108e98ab4283633392`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/agent_outputs/blind_translation.json` (`2997ce03c5328f047758aeaa98f274f747bb55da0dab52a7be6ad775ee109f26`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/agent_outputs/direct_judge.json` (`3c488ef54ab2cd85ab492951bc1c66ea0ae776b1a539a8428e122f4d7f6e027b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/agent_outputs/roundtrip_judge.json` (`4f373f1851487b949c816ad05d6f82f33a3b59e1973bcd30ab240397bf5f68ba`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/agent_outputs/source_contract.json` (`6ed718270cce26e1a3a21d28f3e79fbeec02e1eaa46ae6eb293fdd67b0f28c9b`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/decision.json` (`34264f3bec2c6af7feccbc67f313d0223b2a44153ce11d552208a9f315b2daf5`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/inputs/blind_dependency_inventory.json` (`e980628aa6cb25afc5607e08dde04a12b80e1e4622db241fde5807be5280a8dd`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/inputs/blind_dossier.md` (`a8f4efb85696f9b7841b5d74694f5a1db32ac17a1c6016d6b9015226db014689`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/inputs/blind_review_packet.md` (`a8f4efb85696f9b7841b5d74694f5a1db32ac17a1c6016d6b9015226db014689`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/inputs/declaration_dossier.md` (`30f6aafb5ea8fa0c96ec117ad7554d1f883ac9b6f9fb0920825483d31f9fd939`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/inputs/dependency_inventory.json` (`17a5446d0f5df5c2f2349293f15b797ca1a52d7d18afede9bf1b6dc1bdbaaa38`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/inputs/direct_review_packet.md` (`bfec8810a67be120e89a15171c5145a2d3010ce63879c3b1e9524c1e615477f2`)
- `lean-computational-mathematics/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.10B/faithfulness-current-v1/inputs/source_locator.json` (`e2f6e502747abae8ebe0e9c455f4a055d7294e8011782fa7d0c68ca92515add1`)
