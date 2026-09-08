# Faithfulness audit: LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `ff38f13c8d6dfa9b66558340d588eb92b9d0d02d677b09a1825000d3e3e7a753`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source pages and inline declarations supports faithful-stronger. The source's selected assertion is qualitative possibility, and the target supplies a concrete, nonvacuous realization with additional witness properties. The rectangle predicate preserves accumulated conservation through discontinuities, while its distinction from everywhere classical temporal differentiation must remain explicit. The inline Huber definitions resolve the stronger existence concern without consulting the target proof or relying on majority agreement.

## Implications

- **Lean implies source:** `yes`. Under the selected passage's integral interpretation of discontinuous conservation-law evolution, the existential tuple witnesses spontaneous discontinuity formation from smooth initial data. Analytic initial regularity implies smoothness; T is positive; every preceding nonnegative-time spatial slice is continuous; unequal finite one-sided traces force an actual jump at T; and D001 preserves exact accumulated conservation across that time. The scalar C1 nonaffine flux belongs to the source's nonlinear conservation-law setting. This implication does not claim an everywhere pointwise time derivative for equation (1.10).
- **Source implies lean:** `no`. The selected qualitative assertion does not entail the target's joint additional requirements: analytic initial data, a globally C1 scalar flux, conservation for all real times, continuity at every earlier nonnegative time, and a nonzero downward jump attained at that interval's endpoint. Establishing this strengthened witness requires additional mathematics, available here through the explicit formulas rather than through the source sentence alone.

## Findings

- **note / exceptional-time-conservation:** The round-trip judge correctly identified a distinction from everywhere differentiability. That distinction limits the claimed equivalence of formulations but does not omit the selected spontaneous-formation phenomenon.
- **note / genuine-existential-strength:** The additional requirements are nonvacuous witness strength, not reduced applicability caused by extra antecedents.
- **note / actual-discontinuity:** The statement establishes a discontinuity of the conserved state, rather than merely gradient growth, differentiability failure, or a changed value at one isolated spatial point.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `unclear` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `pass` | `pass` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `64` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `64` dependencies (`17` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The selected source does not specify exceptional-time conventions for the derivative in equation (1.10). Acceptance concerns its qualitative formation assertion with integral conservation; equivalence to an everywhere classical time-derivative formulation is neither established nor claimed.
- Standard meanings at the supplied external library frontier are retained. Foundational implementations and supplied source or dossier hashes were not independently recomputed.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`4f689cec341c28e46b4e808ab70bc589f6a478d5d526169535958de895a1a604`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`7a7db31b6bd7ddb4688460e2c52ef3a0b3cd5e81fe814119f879a7309dcfcee9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`6864db971588a4cbd45767309de1a4a31586c170c61389129edccdb68eee5192`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`df0b75d3249808c99984706ed9385ece16d00977574f9de2ac73fb6ee850057d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`fa8ff96b15ece5b7ce7c3a00ca36c88f0ca58fadc4f4684ff02f23d6f4b049d2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`41f8b52c7d996f82f62169c1be6447d9b9db7d893cd7a2045a8796e3c37b86ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/decision.json` (`44edb527ee90075daac4ed1ce93e91388f2e064838757954678fe04fbdee0648`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`04f5fbbd035521625d55f82f5dbe3edab41d303803dd65d3da4b6976d216c16a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`190c081afe228cf1970f0cd71e06071d7513aeb64c5fbae51ca896e94ee6021a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`190c081afe228cf1970f0cd71e06071d7513aeb64c5fbae51ca896e94ee6021a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`4eaa3a8851dfc4518b5d7b5a0c781c84ca428370d37871ec81343bcaca00fb37`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`24b0049d57736cf5f3e2239ec488636f7ed85a1fb5379c7e07f5d80bdb578ad1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`0f70f23682eec3a1a8cefbd0c26e133c7182e86d612abbf606d12eb5f6fbca67`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`d12f6e52db99a43f69df9dd6509052818abde8c82c57012131cf3a995d0f41b5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`fdbd9c71902e27f0e422b81a57a28aa776459abf7873f9d3f58c43a74f26ad8f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`585f0b4f26d939014f2c9694bc0972adf364336933fe7bfe15575e0689d2ad0d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`4f689cec341c28e46b4e808ab70bc589f6a478d5d526169535958de895a1a604`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`2698f5cb1c67635ea99f1cc591ff54bb58044dd484b755eb6ab54b3bd97aec57`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`da9fda3623218f9ce1359d459036f751f662977a53f205a80e8f7896d6af7a63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`d90a7a30fb23b3c3854659f5f0d51e557ed6298b8e2891420ae10fa625c08333`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`7866dbdf2d5e8f8cf02cdd525e1c63cddef502d426b5b4186424898b6bd4fa64`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`f4c2ae078c5ab4f4053bdc4b55b9ee1f8c6cf7ead642efae1fb0ea1ddf436fc2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`4e4e570ccaeca21f82c7ea33aba6c8b89cca6bdf0c510febe3e2bd6f2c5f0846`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`91a374b7ef30fac4366e9425e700fdb3321eb6a0d05a87abc8dfe2618e76ddf2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`6864db971588a4cbd45767309de1a4a31586c170c61389129edccdb68eee5192`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`e6e37d1bc76f26d3851cfd176ec147e18211f43820f99a8ee9a0bd848dd48ff1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`c4e5703b543d163dd730b08f59898d11b4a2e0223ba27300d7f76494e3882a63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`08982469e003a418816e791ce9f15975206a2c7d155a08a31eefe7e5ce248ccc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`2d117c07fd9b3507c84361b4c4270c9bbad3add24b9051359d2df0e2e7744323`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`abf70f8a846dee0d4261c79dcaf2abdd5ec407b69c7ab3ea50ca610b8c15aa01`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`df0b75d3249808c99984706ed9385ece16d00977574f9de2ac73fb6ee850057d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`554bd922d8a3a9c5c44c54a33088a3738d83d4e2bd76e29f41383b12487beeec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`02a2d5e3a308219a7970909759f6c5aa6f5d8f74e13104dc12ea9ddc956591f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`e001b185fa512b32d424935b9e7eb60d5e2f4ebc6bab2f86470fccb38a328913`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`e96d35f33189cb97ceb2a88d47ba740e03f782053013bef3c2ee5da9ddabdcff`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`6617dcfe4469c27c8a9525a3077ab829b78bb4caa741a8cc1d5013842705b05d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`0a0ce8c9a7976d6042571c0d5ceeb55952c1e43c930b1ad64277ebb6e5fbac1f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`5c3c0a10c6dc8c5d39a21302f9cd515dd4a46ee15f45d01e0f7b78db4bdaf582`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`5c95d361f840b21b85d79ea3df1b84c32fed882809a3cb0b6dce26252e0051de`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`fa8ff96b15ece5b7ce7c3a00ca36c88f0ca58fadc4f4684ff02f23d6f4b049d2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`22da405c45c7d0dcbf2e430485327b6bfeb9c23c07a3a3c767b70e1d00b20493`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`c1ccd3e6d8349db758526bae75158ed7e2b6fae1d066cce98e83023190cb1940`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`04f48a1ee0d725f47649da2a94a964dd403ba894b8fa7b5a08901111721ef833`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`a11bc33d74776313dcdd517feb79fe12bb3390e6652fddf159b8c59cc7541ce6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`66788ddd1a11bfe94ed8bc4c3af13700dacf5f1a0e821b37701d9e73a86e2c9c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`41f8b52c7d996f82f62169c1be6447d9b9db7d893cd7a2045a8796e3c37b86ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`9435119bbf9cd66007918dc7b10462fe03b899ab3ddc848c38b7988abfce8e16`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`007ad9653c9fe98479bb0fb596236f2a9ef303e49c1a6a204567450a4f227e8c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`63f1dcb9f53215d87bc52c8850d01e51a92cc5a00f3dd382abc923b585b38c9f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-NONLINEAR-SHOCK-FORMATION-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`2075981a55c66668c123bee7f51509136899debfb4c1f70834b3b397f6f07578`)
