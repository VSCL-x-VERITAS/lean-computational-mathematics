# Faithfulness audit: LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `7a9fb679f2b59dbc7a4431e5ccc482fec94d254db1f1b9ba82fd07a5a1a80e33`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Inspection of the attached primary-source pages and the proof-free readable and explicit Lean evidence supports equivalence for the selected (1.8)–(1.9) classical rewrite. The target preserves vector and nonlinear scope, the spatial chain rule, the Jacobian evaluation and action order, the time derivative, and exact zero balance. Its local derivative premises explicate the classical reading rather than imposing global smoothness or hyperbolicity. All 83 dependencies and all configured checks are accounted for, including fresh target-effect assessments for both reused meanings. The separate spectral observation is outside the selected rewrite. No unresolved semantic discrepancy remains.

## Implications

- **Lean implies source:** `yes`. In the source's classical finite-dimensional setting, choose the actual spatial derivative as qx and the flux Jacobian as fluxDerivative(q x t). The target's premises then hold. D003 is precisely (1.8), and D004 is precisely (1.9), including existence of their partial derivatives. The target equivalence therefore yields the selected rewrite at each classical point. Its universal pointwise form supplies the same rewrite throughout any region where these conditions hold; it makes no claim about discontinuous weak solutions or the separate hyperbolicity observation.
- **Source implies lean:** `yes`. The source's rewriting means equality of the classical spatial terms wherever the chain rule applies. The target explicitly supplies those local conditions, giving derivative of ξ ↦ flux(q ξ t) equal to fluxDerivative(q x t)(qx). Actual derivatives are unique, so the existential flux derivative in D003 and spatial derivative in D004 cannot be chosen independently to change the balance. With a time derivative present, substitution gives both directions of the target Iff; without a time derivative both predicates are false. The unrestricted values of the derivative field away from q x t are irrelevant, and the zero-dimensional case is immediate. Thus the target is the pointwise, derivative-existence-explicit expression of the selected classical rewrite.

## Findings

- **note / classical-local-interpretation:** Acceptance concerns the classical rewrite selected by the locator. It does not attribute a particular global smoothness class, a weak-solution chain rule, or the neighboring hyperbolicity observation to this proposition.

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

- Blind translator covered `83` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `83` dependencies (`2` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`6bfd39a720bf748b38051b08b70ef407adb296e20a4a5338eebf2f61e1446865`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`e5f6173f88b151e228fb2cbaf87aead5200d04a122d730c91d3064aa37a0ad21`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`7494f1a99ae9c4a3646080bb72c1f3237bec77f83a9fd627263e1579e229a0b3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`8becd320842e3c97996ce31ad648b2ce5bc578fc1cd2aa1813426247fd2a8f7c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`90ddcca4362a9141b3941ba2b4ad97039ec1b3caea75164532a5d22062f5ea43`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/decision.json` (`0eb19bc7cc705d06d7fc3fbadf7805a0e2fd3f3c7649b323376f48dd9330b2c2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`2224072c971b82b808643139b050420f32d2308c23c1f7d8aeee3c732c8e5efc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`0eb9c77949b1cb661ac524dd925f6baf90a9f03bdc755116e56587b12dd33ffc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`0eb9c77949b1cb661ac524dd925f6baf90a9f03bdc755116e56587b12dd33ffc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`ac2ee31a0f5d11099e4572820e255f5baa8e9ca58f6ef7566eb5065bd669f69a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`067e16333ee387bc0f2e7f2e1212527b5d8e076b17de630ec1a71716fc971b63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`909c88f221e55b5a2f3093478a860206fd8e08d084385a9b76ce99edf7d86e50`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`871589dfba64cdb540b6f3cac9b7e14b8093c7b81fb17f0bab179d6183c5bd2d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`ca0dc205cafd070269336ba1da7fa08ef6aed8d7eb5e68df4e0f3e49b8a24777`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`059accf21805d4ed6fc402a3bf42354a4f1735cdbf891deb3d38d8ffcfcc2fce`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`ee8b4e9e40be6447f68c85987a42e060d853cd792202465b4dc1d381c23f4b42`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`e5f6173f88b151e228fb2cbaf87aead5200d04a122d730c91d3064aa37a0ad21`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`022c21226ed6e8a907202b11b4c7bb7d096d8b7f594528902b3d42051fc8a381`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`f87296063909b0c11c23e72662650260e867b1bdef43d7f30b301394f04d84ee`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`54676f046d30b2b2186905b98bb029309da8fabedd5537854428ee91a813c294`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`dfcac378913f0dd8d1d79a0a9be8342dbe360b7408f2d338a4e7a052b5fadba4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`4d808ac6cbc52b3f39a9f17a119e14ebd32498ca85e730d62b3832631b00777c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`7494f1a99ae9c4a3646080bb72c1f3237bec77f83a9fd627263e1579e229a0b3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`50dba77088f30d058960a4d2d0a71651e101c9617c1254051d8ebe50043ed8bb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`945c9cb5fbe7f440fec623e3607af48da595b8d7c5e6e91727143c218e863685`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`516f434753ead4fd68cefa46a7dc4daa4d03fff5aabc8e241733d67b1a3672dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`1cb36a931a3b219aea4bf345bf407499d5447b1784a9517d197eac9044580fd0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/direct_reuse_preparation_20260908.json` (`f8cf1eeff6fc5d1d038ace9b682c59a3c57a28ab03e3ce12a8a76b2e850717fc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`21dc2a47b1609154f1b5817e9a5f4f45bb7a88384cc628ca768cd74ffd61df3c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`8becd320842e3c97996ce31ad648b2ce5bc578fc1cd2aa1813426247fd2a8f7c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`5494e286f5e293b441b767c0fb7053cf3530594df1a374530b60474ae5c48de5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`a092421ad53172d0570ba8ddbc2bae7f0f6f0ccb3c6b010319c4c35c4c46be00`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`cafb7e001497ced2e2570dedb2c19f262ec2509eef477906dd729e582b05676f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`dd672737a4fd8e6646d78c07db3cf2b80ff2367d4532ffc24886df37a8d2bc48`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stdout.txt` (`f6a952e6fe4d8cb2b7abaf0c684ea336440db48daf8f620887896b13b711cb2f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stdout.txt` (`57caa210b071043d314e6c7a0d9bd74e4c466d7b96f44b90a76a85e0aed1ffc9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`1f31b93bf3ef8982e875b577340e2d50307eeb94eb204145589af0b213a4b608`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`90ddcca4362a9141b3941ba2b4ad97039ec1b3caea75164532a5d22062f5ea43`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`89b955da1de1a9cdee68c3b4a29cd04877f4862a27533a03803e899540246cf8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`4d347e0888a30cbfab8b892bae675488be54400bb80bbe3d1335365f50d60d6e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`9b3c563c2afeb734175bb95a0f9d228569e61408fd951a9e693538f751e66c2c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.9-QUASILINEAR-FORM-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`19d2ff9a350418a5f84403d3a41d018da4575cf52861ce9e4535f43f9bf43fe3`)
