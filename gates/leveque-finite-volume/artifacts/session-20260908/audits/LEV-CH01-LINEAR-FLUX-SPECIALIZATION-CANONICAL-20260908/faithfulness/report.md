# Faithfulness audit: LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `bcbd5a841abdbacece42bde7625f3edfff6c7a69342bf550e30dbbdf1d37d38c`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the three attached primary-source page images confirms the selected differential-form identification and its inherited real, finite-dimensional, constant-coefficient context. The proof-free header, readable type, explicit type, and all 78 supplied dependencies preserve the field, matrix action, derivative directions, composed flux, and exact homogeneous balance. The spatial derivative hypothesis is an explicit classical-domain condition already satisfied by every solution of the referenced linear system; it correctly controls the converse for singular matrices. The target is therefore a faithful equivalent formulation of the selected assertion, with no claim about integral or weak solutions. Hash provenance is taken from the supplied evidence and was not independently recomputed.

## Implications

- **Lean implies source:** `yes`. For a classical solution of (1.1), D005 supplies a spatial derivative witness satisfying the outer hqx. The right-to-left direction of the Lean equivalence then yields D004 with flux v↦Av, namely a time derivative and the spatial derivative of A q summing to zero. This is precisely the source assertion that the constant-coefficient linear system is a conservation law with the specified flux. Applying it at arbitrary points gives the corresponding classical PDE statement. No hyperbolicity or invertibility restriction removes a source case.
- **Source implies lean:** `yes`. The selected sentence, together with (1.1), (1.8), and the constant real matrix convention, identifies the differential expressions after substituting f(v)=Av. At any point satisfying hqx, the derivative of ξ↦A q(ξ,t) is A qx by finite-dimensional linear differentiation. Actual derivative witnesses are unique, so D004 is equivalent to D005, whether a temporal derivative exists or not: when it does not, both predicates are false. The source's classical differential identification therefore yields the stated pointwise equivalence with explicit derivative witnesses. Dimension zero adds only the automatically true empty-system case.

## Findings

- **note / explicit-classical-domain:** This makes the classical differential domain explicit without losing any linear-system solution. It is essential for the converse with singular A: for A=0 and q(x,t)=|x| at x=0, the flux is differentiable although q is not, so an unrestricted equivalence of the two derivative-existence predicates would be false. The theorem correctly avoids that claim.
- **note / empty-dimension-extension:** All intended positive-dimensional systems remain covered. The additional empty-vector case is tautological and does not constitute substantive theorem strengthening.
- **note / explicit-classical-domain:** This makes the classical domain explicit and appropriately avoids an unrestricted equivalence for nondifferentiable fields whose irregularities could be hidden by a singular matrix.
- **note / empty-dimensional-extension:** The empty-dimensional instance is trivial and preserves every intended positive-dimensional case. It is a harmless extension, not evidence of nonvacuous stronger content.

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

- Blind translator covered `78` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `78` dependencies (`73` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`5bfd9cfb4c4a369183132c662fb1f9f7fc057c1ef01d41fbc7e064ce166c8325`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`456c0dca91ac0bcaa54dd9b1119626d55c1d81f432f73783a6dd399b15d74324`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`7e15718720df18bb03d5da933256164769f988e65954b65a0c61377feb5c7d4e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`4373b1ff7361f79dc62885e363d4f3f1c6bdafacc1ca73665e6e409c19012a3e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`902658c360dc818320b3b324f4ba9ceafc06d6ccade8e43081ba956f2b29df5b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/decision.json` (`14727e8a7ac5b01aa6aa787861764e4b51aa7e22a0cae15df63a532eeadd26e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`c877fd4f66c6d75e0c609cd56d61f90bb119041ff6062f0ca4c29bbb82c80fe2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`7cf14722e89d1e99f50846e47111c5596834ecf08ffc64d34a7efefe511e4c6d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`7cf14722e89d1e99f50846e47111c5596834ecf08ffc64d34a7efefe511e4c6d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`bba4c5611d09b27735a0329fb67a76eb9e45290cc1e14c561067ac5209daaa9a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`00c093185c36dd5686d5b96e9e0d723583b6b8ec52913c5a4c0b632898f85675`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`4565cc6df438a7bbdd34cd953253db66c8a045d0b870058c83ed0e81b3d492b4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`8182c38e43fcf70e34c8f1ce186765bdf6ef88451da311e87a34ad619b5a5c94`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`4c4dba3b4c8bbea48f59b2cd9281d8a16b38c1779e358edcf9eadb9e43cbda92`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`7ccdd34fa97d610ce2465b8702c50984f2f6d355b4774ea03c9151aacb7af68b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`456c0dca91ac0bcaa54dd9b1119626d55c1d81f432f73783a6dd399b15d74324`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`4372b10b6a1ce6318819e87e7b319112f51b9d91a54ef69820bd2630e3ba9fce`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`276cde153c499702ad0d72b654f6b550c0203233632b842a1b2be9f8e20bca20`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`27c9068afefe8eab8aaa11fd068f6d17aa5c8b0cabf5a95d4de2639e33a4e2e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`34ff56864f5e328b0ec97c2abba60d6549692234798e9cbfabbb305b6ba54698`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`f2b5c5b91b1864f4ade8909cb5ce1d19ddec1f1db6312d247b0b4aa41472589e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`7e15718720df18bb03d5da933256164769f988e65954b65a0c61377feb5c7d4e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`4c5565a3aeadd832e1990145e8d3b116b5016499fc80ac805969e9e24d5a4711`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`31291bbd7cfbbd6eb4af7fcd8317fc32461c9d3ab583536a7679eb443997ac47`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`26c638e4bacbce39a8dd77ced25ebf675ec377d2b396d478f7a88490a9ebe88a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`3e08ef90092e329f3c8801df7e662dd5b3369457ea991817c4c8faa0356624aa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/page-029.png` (`38ddcc8e4f9afb72079edd7484088dea7c2d299b72df4e78113ca972fa2c816b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/page-030.png` (`ae7d4dfee2a41e3a9c4d65b47cf17f0bffe1704f5cd9b67675d85ba70a190931`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`bb955cda61ba10504292c5db319d07ec09f89c11b8dfa5c175ce840ac7fddcbe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`4373b1ff7361f79dc62885e363d4f3f1c6bdafacc1ca73665e6e409c19012a3e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`49059ae835d4ecd3bac9eb2438d3af4ef1181e02444da29aa9c5102ece5e184a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`4183028fb94b458cbee0db9241dcaebceed8fd95f45b46da8e54166ce238c014`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`b1a116b256cbf8cbfaf1f998988206376c9c0a06eaf0844c69274788614a2e3f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`428b54873e0ff9a2688c566bad5f6905a5d841a7379e9f1a691e4349bd928cd3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`3750eb9ccd48555c943ac2b6d987e7a4faf5919c593a621becdd5d899070c6b6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`902658c360dc818320b3b324f4ba9ceafc06d6ccade8e43081ba956f2b29df5b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`3dbe15aff1533fa64c479e6cd4095b5322862a8760a95322ff5a692235ef6725`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`df94703f8a074086379eccb28055d021a7833004acd0d9894b5069648da4653e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`de85dd68b200d70d47f4e48ada4ebc44ef662e2dea3eada2231f3a8e7db5afd9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-LINEAR-FLUX-SPECIALIZATION-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`ebb606f611af849b5f392747a5ba883027148d50999d4d76f119d5d9d4f074f9`)
