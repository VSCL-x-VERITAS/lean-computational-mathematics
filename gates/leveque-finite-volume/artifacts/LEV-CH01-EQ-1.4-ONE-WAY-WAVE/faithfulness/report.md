# Faithfulness audit: LEV-CH01-EQ-1.4-ONE-WAY-WAVE

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `5bf2bb153e9deea7d4c8bae7d7d448ed32f1766eb9ca0336abfd8791f80c95d1`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Expanding every local definition shows the exact plus-c scalar transport equation, the positive-speed rightward characteristic, the one-dimensional real-hyperbolicity fact, and the identity with the advection solution predicate. The abstract scalar profile is appropriate because the source leaves the pressure-velocity combination unspecified and states no all-solutions converse.

## Implications

- **Lean implies source:** `yes`. Expanding oneWayWaveAt and IsLinearAdvectionSolutionAt gives w_t+c*w_x=0; hc, scalar hyperbolicity, and monotonic x+c*t establish the source's positive right-going one-way interpretation, while the alias records mathematical identity with advection.
- **Source implies lean:** `yes`. The source explicitly gives c>0, scalar hyperbolicity, mathematical identity with advection, and translated profiles in x-c*t; standard differentiation and the 1-by-1 eigenbasis yield every Lean conjunct.

## Findings

- **note / model-realization:** This makes supporting mathematics explicit without changing the source claim.

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

- Blind translator covered `115` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `115` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/agent_runs.json` (`b4fe95622920c9b244bcfb090a35deea41d91ee8e4cadbd9f6ac359d344d561d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/blind_translation.json` (`0bfec89b73b37367bf582ba557938724499633efceb93c15438980fffabad6d7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/direct_judge.json` (`347f7c99909e8837215e39051066f325981dacd4b6f4468e7e783536c293eca7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/roundtrip_judge.json` (`922253dfb882aee3b2b47955274685cf3c96d64d1fb0b1085d32f534ff5472c2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/agent_outputs/source_contract.json` (`46d77f829131065f4f1208ad448b3fba390a5dd920e56e20850153620a77e580`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/decision.json` (`a138fb1e8154fee63570df6696fbe7187df84a414f93a481f6c4fa5b94a4f932`)
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
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/agent_outputs/adjudicator.json` (`f975fd72ce9204cccbdfbe6d80f89c41f558cefe7293c414c8fda868131f3874`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/agent_outputs/agent_runs.json` (`74fe9e4ec582400431fa58f82502dab790b8861deb6b95cddd10dbaaf2619a5a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/agent_outputs/batch_source_contract.json` (`07b5cb23032d902d4562359219d877aa7842adee87f053fb665056701fb4bb33`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/agent_outputs/blind_translation.json` (`88ba98d323acf6ff92488264ad0956e91f22509568452c2d83850d8eadd52df2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/agent_outputs/direct_judge.json` (`277a9faca0894049cae991bab9c3d6a6b973cbcdacc9c56a7f2bca589a9fead1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/agent_outputs/roundtrip_judge.json` (`c1b20bf54a7cf04ff3f7ca447980dc00185876e387c75448472af29917347d7f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/agent_outputs/source_contract.json` (`2b15eefa9803653ab3312e1881bdf3a2f712eafc002188041be5c3235a51e434`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/decision.json` (`6036e25844e3c8f9fe6b426b112568d298b21b24f66f3a408278c6b36362716a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/inputs/batch_source_locator.json` (`81d5c88e01fd1294a616e09d4de65d1ef6e93d0f7fa4aa6ddc9cb5b5a92d37e5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/inputs/blind_dependency_inventory.json` (`ec94ef09b33e34d86a9ad8d3bb3ce8852bdf1663138f029a219b208b052ab4b1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/inputs/blind_dossier.md` (`18aa43b4327effbd7dd8f405684903cb3ec1492c1a1fcd092d53c33a4d380a37`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/inputs/blind_review_packet.md` (`18aa43b4327effbd7dd8f405684903cb3ec1492c1a1fcd092d53c33a4d380a37`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/inputs/declaration_dossier.md` (`b13ac155688a600cf370ffe8c3d79384306fae956ec2790ec7bd6098e5f82610`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/inputs/dependency_inventory.json` (`ac9ffc423d9525639ec24ea40b7ff7e019db417d6fa9e64df814149c939b434d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/inputs/direct_review_packet.md` (`b58278af7b48a91a43dcaf079b752f528fe945db2d7b37908f0a81897cd235a1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/history/20260901T060836Z/inputs/source_locator.json` (`8878c5725b841f4418aba83d7ebff64cad75c3c680d59da84cbe913a71a9bd7c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/blind_dependency_inventory.json` (`ac4bc18b397b5198677a203fc16c8c7b877fce334e53faf6773f2ced80178176`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/blind_dossier.md` (`aad56a3dae183fb10cd419e397bbd199175255bfc49557909a83cf1c377ce6c4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/blind_review_packet.md` (`aad56a3dae183fb10cd419e397bbd199175255bfc49557909a83cf1c377ce6c4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/declaration_dossier.md` (`3987df45c4caa3155a53cf1f1eb01867fbbc2a3d4c16ede86bba3a58a027fae1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/dependency_inventory.json` (`ca46465fc2972c2bbe8666eac47d79552658f99146584033058945d3767184e6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/direct_review_packet.md` (`1135d65318020a2571d6f00ded7c41325753199b211c7d92b5c26be4b8061843`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-EQ-1.4-ONE-WAY-WAVE/faithfulness/inputs/source_locator.json` (`8878c5725b841f4418aba83d7ebff64cad75c3c680d59da84cbe913a71a9bd7c`)
