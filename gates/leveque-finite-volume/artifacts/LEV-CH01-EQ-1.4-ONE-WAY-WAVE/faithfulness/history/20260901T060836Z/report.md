# Faithfulness audit: LEV-CH01-EQ-1.4-ONE-WAY-WAVE

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `36f1a954467c38d6c9429b7e7e1eea49849ebf2177a1df35b33d1f1ece305648`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The apparent disagreement comes from treating equation (1.4) as though the source asserted a global, exhaustive proposition about every acoustic field. It does not: the source uses modeling language, explicitly links (1.4) to the advection equation, and supports arbitrary translated profiles without claiming they exhaust all solutions. The Lean target is universally quantified over profiles and points and proves the exact plus-sign zero-residual equation together with concrete positive-c rightward, unchanged-profile behavior. Its positive-time and local-derivative premises are explicit choices within source-acknowledged domain and regularity ambiguity. The abstract scalar profile is compatible with the unspecified acoustic combination, and the scalar-real form carries the source's inherited hyperbolic classification. Both implication directions therefore hold in the source context and under the target's stated applicability premises, so the existing theorem can close as faithful-equivalent.

## Implications

- **Lean implies source:** `yes`. For arbitrary profile and arbitrary audited point satisfying the explicit regularity and positive-time premises, D001-D003 make the first conjunct exactly w_t(x,t)+c w_x(x,t)=0 for w(x,t)=profile(x-c t). The other conjuncts prove a strictly rightward displacement at positive time and exact transport of the profile value. This realizes the source's admitted right-going one-way-wave model; the generic scalar field can stand for the source's unspecified appropriate acoustic combination, and no incompatible physical identification is made.
- **Source implies lean:** `yes`. The source explicitly states that the identical advection equation admits profile(x-c t) for arbitrary profile and transports its shape unchanged. Under the Lean target's disclosed local derivative premise, the ordinary chain rule gives q_t=-c profile' and q_x=profile', hence q_t+c q_x=0. Under c>0 and t>0, real order gives x<x+c t, and direct substitution gives q(x+c t,t)=profile(x). Thus the complete Lean conclusion follows from the source result in the target's explicit applicability context.

## Findings

- **note / explicit applicability scope:** The theorem closes the selected claim as a positive-time, pointwise classical realization. It should not be cited as a global well-posedness or all-time theorem.
- **note / non-exhaustive solution construction:** This matches the source's admitted-solution wording and does not establish an if-and-only-if classification of all one-way-wave solutions.
- **note / abstract acoustic variable:** The equation and propagation semantics are faithful, but the theorem alone does not formalize the later concrete acoustic derivation w^1=p+rho c u or c=sqrt(K/rho).

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `fail` |
| `C05` | `pass` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `fail` |
| `C11` | `pass` | `fail` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `not-applicable` | `not-applicable` |

## Dependency coverage

- Blind translator covered `91` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `91` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/adjudicator.json` (`115e88102eaa48b9f091c6231f0e59d5495fd89ede6f2d0dde2aea23675facd0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/agent_runs.json` (`b586cf0d7b15f7625aa14d668d9f3515493c8babc9ff643a72f03483f4370e20`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/batch_source_contract.json` (`d130c5e8ca7f3418f94e3aae9568d90bf21cc5f1ca255b2d4e113510b3ef2088`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/blind_translation.json` (`c95b855422ca5a7e178fcaa72803c37b498a940393d6d6ce5a1b264ae7d54202`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/direct_judge.json` (`dc8592aed658e56dda824cc51bb27ba5f1180699a4564107bb93f66724595a9a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/roundtrip_judge.json` (`47717739f30fd8d2e5fdd75cce5e86984f0e2e37ef43d394b7f5657aeadf3470`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/source_contract.json` (`17bac218d5dd2fb3c337fac43ce323b376f05b2d4bb731d4513b80d991a7af6a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/decision.json` (`6036e25844e3c8f9fe6b426b112568d298b21b24f66f3a408278c6b36362716a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/agent_outputs/agent_runs.json` (`f785bccb7bdf04fdc9fd021ddc7243c392cd7c4f5ef1a41d87aeeae243395fd5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/agent_outputs/batch_source_contract.json` (`80110095831f6efd5aa2f52c8f3df8472abf682c640ebbfd2815ea9773271536`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/agent_outputs/source_contract.json` (`e80aaea014bb4097bf1afa63344285d6cacb2ed548518ed5368897c3730a9257`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/inputs/batch_source_locator.json` (`81d5c88e01fd1294a616e09d4de65d1ef6e93d0f7fa4aa6ddc9cb5b5a92d37e5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/inputs/blind_dependency_inventory.json` (`b2500a8caa2857d435332472729ef4fd1011b72300fa43622721db761ce06cf4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/inputs/blind_dossier.md` (`c60ede677eb5ff8deb863dfbd1abee230a7b2c924eaddd978412030546367792`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/inputs/blind_review_packet.md` (`c60ede677eb5ff8deb863dfbd1abee230a7b2c924eaddd978412030546367792`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/inputs/declaration_dossier.md` (`ba3fcce61c356e83aa884ec3cdbb0d179323a4e2c9e3a3f7306ee971cc439f19`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/inputs/dependency_inventory.json` (`25a761768646088011d185e3f47e8db06b2d960e0b0f75785dfaf2c301514cb1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/inputs/direct_review_packet.md` (`70a3ff5112291c0f47935432af0b3a402b8e56e30144fd3daab004d283e07433`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T023149Z/inputs/source_locator.json` (`8878c5725b841f4418aba83d7ebff64cad75c3c680d59da84cbe913a71a9bd7c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/agent_outputs/agent_runs.json` (`63229b491f10ddc204978185590ae5358db72219ded4471ac2312e89f7fbada3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/agent_outputs/batch_source_contract.json` (`80110095831f6efd5aa2f52c8f3df8472abf682c640ebbfd2815ea9773271536`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/agent_outputs/blind_translation.json` (`c2dde85d2de4492949d752f48c165d683f9447710e5980e7759034ba49e14779`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/agent_outputs/direct_judge.json` (`919e52ed35f83d9808d28820f26382ea534a9e8ea1974e2a70165dd267655ad0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/agent_outputs/source_contract.json` (`e80aaea014bb4097bf1afa63344285d6cacb2ed548518ed5368897c3730a9257`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/inputs/batch_source_locator.json` (`81d5c88e01fd1294a616e09d4de65d1ef6e93d0f7fa4aa6ddc9cb5b5a92d37e5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/inputs/blind_dependency_inventory.json` (`9ae5120810b789451b175794fc56f80284048470e09c29dab0e32ec696d6a271`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/inputs/blind_dossier.md` (`941d8ac200c40f68798524575389b687db34532f509c4928a6372fb8ece42132`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/inputs/blind_review_packet.md` (`941d8ac200c40f68798524575389b687db34532f509c4928a6372fb8ece42132`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/inputs/declaration_dossier.md` (`789562303fc1a1d3ce64edeab092a51d1d9848f7f162cf51827ed54c5f23284b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/inputs/dependency_inventory.json` (`bca4cc1a3c9f4bc4dfc9647b8c155a4dfd4aa037d408df1ea9fe9da7dccdffb9`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/inputs/direct_review_packet.md` (`44e5be7d91faa6dc8e221b1d64f6a2a0e6f5ffec057311ad216a812aa890e042`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/inputs/source_locator.json` (`8878c5725b841f4418aba83d7ebff64cad75c3c680d59da84cbe913a71a9bd7c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/tmp/pdfs/source-page-023.png` (`aaf5cd3a4c029d675373a9b3ef7c6e4e4fdc6a1d858e04dc32900082ce222883`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T031525Z/tmp/pdfs/source-page-024.png` (`f06cde84f0e1d3148f29764a8f1a4592889ef92c705b8505beafa42b5f0a9d56`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/batch_source_locator.json` (`81d5c88e01fd1294a616e09d4de65d1ef6e93d0f7fa4aa6ddc9cb5b5a92d37e5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/blind_dependency_inventory.json` (`ec94ef09b33e34d86a9ad8d3bb3ce8852bdf1663138f029a219b208b052ab4b1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/blind_dossier.md` (`18aa43b4327effbd7dd8f405684903cb3ec1492c1a1fcd092d53c33a4d380a37`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/blind_review_packet.md` (`18aa43b4327effbd7dd8f405684903cb3ec1492c1a1fcd092d53c33a4d380a37`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/declaration_dossier.md` (`b13ac155688a600cf370ffe8c3d79384306fae956ec2790ec7bd6098e5f82610`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/dependency_inventory.json` (`ac9ffc423d9525639ec24ea40b7ff7e019db417d6fa9e64df814149c939b434d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/direct_review_packet.md` (`b58278af7b48a91a43dcaf079b752f528fe945db2d7b37908f0a81897cd235a1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/source_locator.json` (`8878c5725b841f4418aba83d7ebff64cad75c3c680d59da84cbe913a71a9bd7c`)
