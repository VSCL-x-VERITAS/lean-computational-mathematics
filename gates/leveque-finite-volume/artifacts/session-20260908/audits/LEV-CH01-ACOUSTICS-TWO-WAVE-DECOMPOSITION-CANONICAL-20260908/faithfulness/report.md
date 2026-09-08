# Faithfulness audit: LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `314da48d06992924535db624d9872074d95ad6d44320e8b42682ee9f3c708e37`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source pages and the proof-free readable and explicit target types agree on the coupled input system, both transformed fields, their sound-speed dependence, and their paired transport signs. All 100 dependencies preserve this meaning, including genuine derivative existence and standard real arithmetic. The inherited page-1 domain and classical physical context justify the explicit formal setting. Nondegeneracy supports the decomposition interpretation, and an explicit nonconstant two-mode example establishes nonvacuity. Both implications hold in that setting. No tools, proofs, prior judgments, or independent hash recomputation were used.

## Implications

- **Lean implies source:** `yes`. In the inherited classical real-coordinate physical setting, package p,u and their equations (1.5) using D008–D009. Unfolding the target yields precisely the two displayed transport equations for p±ρ√(K/ρ)u. Positive material parameters give positive c, hence distinct opposite coefficients. The transformation's determinant −2ρc is nonzero, so its explicit formulas retain the full state and support the source's decomposition interpretation. This implication does not extend the claim to nonphysical negative parameters or unspecified weak solutions.
- **Source implies lean:** `yes`. Given any target system and its positive parameters, its fields satisfy the source's coupled classical acoustic equations at every real x,t. Applying the two page-2 assertions with c=√(K/ρ) gives both scalar equations. Ordinary differentiation of the fixed linear combinations provides exactly the derivative-existence witnesses required by D007. D004 is merely an alias, so the resulting conjunction at every point is the elaborated target.

## Findings

- **note / implicit-physical-context:** These assumptions express the ordinary physical setting of this passage. Acceptance does not assert coverage of an algebraic extension to negative density and negative bulk modulus, nor classify additional assumptions as stronger conclusions.
- **note / decomposition-interpretation:** Completeness of the change of variables follows algebraically from its exact definitions and the parameter assumptions. The judgment does not claim that inverse formulas, a converse theorem, or an initial-value uniqueness theorem appear as explicit target conjuncts.
- **note / explicit-physical-side-conditions:** This makes the ordinary nondegenerate material interpretation explicit. The acceptance does not extend the source claim to negative or zero material parameters.
- **note / decomposition-interpretation:** Completeness of the state transformation follows algebraically from the displayed combinations and ρc ≠ 0. Acceptance concerns the selected scalar decoupling, not a separate characteristic-profile or well-posedness theorem.

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
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `100` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `100` dependencies (`8` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`5bddb1ec45cf36e09d610dd881889fa4295e7b979410ebf91220e3d17f6fdaca`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`5988b7bb758193f30783c8fa83a54bf593c5f0955a9aa22b97776ca09e80f2c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`319996a886fe9e2d9ad3be95f6abbb927a339e8612b214e789f24c19efadb22f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`4745744d9dd82489cc864df023fbf686116290fcd48983f79d7c2d2fb55cac2d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`275388841a13e19e01e864e16b1a1ac425ec469b2d1b64ae64cb7835d3716318`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/decision.json` (`42af2da45a10ecf5fced133ef3f28ec0bdd370427b5ed762f3a72611346c7a1b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`c37ff48a69268ce33e2ed68baaf28bdea33b54ab06fc1fd7c94402d531207940`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`c5f5a4ef07c73762228075ba1f68e24a295800b15646c7acc5dd33c1aae3a1f4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`c5f5a4ef07c73762228075ba1f68e24a295800b15646c7acc5dd33c1aae3a1f4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`54ef6f8becf545bda33c27f145a285fe77b9dfcc25253c07db0f02a01a669fbc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`bcb5e0cb89675c82c782bb7042d1f9bb36c94ef766370c2f8c7d9b048ec05884`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`0f51cad2a542d967a1b33a0a419e37a428300934555b4a5a904081850d11cf5d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`7fdbdc6ce55f59cfae923e06d32b0a2df6f7398bc44ecf7b2e8fec4128fae1a3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`7480a6bef7685595619d72f19470408e7c88d6f70e8dc5dfb64fc87b61793333`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`c60cdbbaa78200aa337bf289716a20f35feb184ce45c821b903ead95726db60a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`29b645ecf51446ce1b09b88603a49700b545dc8f4b8c81f2962b78050414c4a0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`5988b7bb758193f30783c8fa83a54bf593c5f0955a9aa22b97776ca09e80f2c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`0629e285995427e9bb5aa391f930055ad1e698a45daca2a4d122cae3ee7092e2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`b97284319a27a8aa8119aa11e12b46ef54db4acd5ab36d00df82f5389fcb5fb3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`ca991a9794ccfbb7391582b051230a1453e041d6ac11c9def3d8d8cf013d75e4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`2371039cf110dcf94ffd85825a648b6971ddd9e9dc07c0e26b3b9367c10b8070`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/coordinator_context_image_pause_20260908.json` (`4533ce25703065dd5c21a47c223959a60e9a7d0ec17e2cba46d580600081576a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/coordinator_context_image_resume_20260908.json` (`0864fd582fb94946c0b099b39c079d978ee501e1653adf20b050f534f38e2dd3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`9117ea3afc764f0dc99315d9439381b13085a19986b65a21d061aa21c62e0716`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`319996a886fe9e2d9ad3be95f6abbb927a339e8612b214e789f24c19efadb22f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`01c181a765cf0a0f34f51c438554e45a4c57bd7f9f2c1a03942de72b03a06268`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`4ed31627c65a067cb9b04f5567bd7c09af44f3fcf9e127c7fe92ea6d72f82958`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`e153465aa0e7d24c3a6ac59198ada222b1786299fff376757c456738f0e7b76e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`f89eb63ec4ed6a175b573b511fca43e874e32564343c6dacd1c1cd7eca8a190d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/page-024.png` (`9374c58069ddf2cc64e5aa888141ee9aa41977be7af9f29fd0cff786a5df3b02`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`a78e0eee45505bea093cb3d2b713d7124f14e4b048d7484bf51c026288cf2c5e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`4745744d9dd82489cc864df023fbf686116290fcd48983f79d7c2d2fb55cac2d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`7e7ee3fdf7d11e831778d10e5ed015f5b2f00722618630e0e97c9bcdff35a4a3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`bf78765f3fee6b0e9dfef30436a49c9b5569d9061ef3ab4455aa4855ac7f97b0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`c4757ed08f69c3d176f821c24d7a0774e737ab035b14628f25fb281c35e08354`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`4c91d64df824dd7a390d33cfbdddb3fbb7d1072158425c919d24c69a8829054e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`b8c2390c1a01772a7d8d7299580aa0ce44e76e51d60e6fe6f6283d3e73d09b36`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`275388841a13e19e01e864e16b1a1ac425ec469b2d1b64ae64cb7835d3716318`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`643c3c90ea04d2883b05751b961df3afbec2e3f18c29a50b85e8f4990c054777`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`a31ea60ec206b7524e10556ad7c9136c0670b58bebe2047440898378798a4754`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`b110d3a5f9f9f2357272f37daa6fa8acb420e3cb67784cc863a77efd37857e89`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-ACOUSTICS-TWO-WAVE-DECOMPOSITION-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`11150e445ef50c39f9b620dea75b104e7dcc384123fdb03d06f1349eaf1bdc07`)
