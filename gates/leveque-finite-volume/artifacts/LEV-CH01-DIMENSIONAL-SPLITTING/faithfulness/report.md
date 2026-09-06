# Faithfulness audit: LEV-CH01-DIMENSIONAL-SPLITTING

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `9da7ff3657528cfe9ecac48471049d86136efee09114198ba3a9c5f4131acc25`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Adjudication should distinguish genuine additional mathematical content from the data and invariants needed to represent an informal algorithm. Here the grid fields unpack rectangular or logically rectangular finite-volume geometry; the duplicate-free list is an arbitrary enumeration of all coordinate directions; the fractions remain freely chosen; constant preservation is a minimal compatibility condition for the supplied high-resolution finite-volume solve; and schedule identity and trace length follow from recording the required in-turn execution. Because the target preserves every source instance without prescribing any choice the source leaves open, both implication directions hold and the repaired declaration is faithful-equivalent.

## Implications

- **Lean implies source:** `yes`. The structured grid is rectangular or logically rectangular, the constructed schedule contains a fractional one-dimensional solve for every coordinate direction without fixing a privileged order or fraction value, and the execution relation applies those solves sequentially to the evolving state. This realizes every required facet of the source procedure.
- **Source implies lean:** `yes`. A source instance supplies a finite-volume grid, its finite coordinate directions, a one-dimensional high-resolution method, fractional directional steps, and their in-turn execution. A duplicate-free exhaustive list merely represents the finite direction family; admissible positive fractions represent the source's fractional steps; measurable coordinate cells and reversible logical coordinates unpack the stated grid geometry; and the execution trace and its length are obtained by recording the sequential steps. None requires a source-fixed order, fraction, composition formula, or performance guarantee.

## Findings

- **note / representational-explicitization:** These commitments make the qualitative source procedure executable and auditable but add no fixed ordering, fraction values, numerical composition, accuracy theorem, stability result, or effectiveness guarantee. They therefore do not create a distinct stronger source-level claim.

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
| `N01` | `pass` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `87` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `87` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/agent_outputs/adjudicator.json` (`b98bb541eb273903cbf16f620acb2f3fb2e8afd4c2f939d197ae48679833cfde`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/agent_outputs/agent_runs.json` (`48f865de3ac5e01ccd9e90c57277d9b7f93703f606ad4b0612c0a8780b95de71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/agent_outputs/blind_translation.json` (`abab16ec27f491dc9bcd357d5fd5a9a51eb8fa3d67d9f9f1fb6d726993fd01cb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/agent_outputs/direct_judge.json` (`bba1eeb7c48379f7aac7e9ead2906433b65f1e011150319e1a193cb307c4ca06`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/agent_outputs/roundtrip_judge.json` (`63b93c75707e0e2005b7bbbff3c5e6292f6985e59e406c4773ec2a5849d260bb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/agent_outputs/source_contract.json` (`91a4301d06434d5f4a967873a1432b15f9c640d6d956b6c58d81f00f814ad31e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/decision.json` (`bd06ed3d2be531bf7d2efe978896fb6615ab2a124b51dfc7d7777f57655b17ae`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/agent_outputs/agent_runs.json` (`e7244881cb732fb5899a7f5dc431328af33fd2832b59faf6f37f0554d7e8c4a7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/agent_outputs/batch_source_contract.json` (`bddda9768531429c363af90d5c05ed2bfc848979a985ecdf5d08386318ecab93`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/agent_outputs/blind_translation.json` (`5f3045486579b423f3dacd4bdbc49baa28456bd0ceb19e7a05541c03d86e23de`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/agent_outputs/direct_judge.json` (`b9441e7c93cc35edcaedb29e32113d8719ae5988394a85aca388282cce9081c8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/agent_outputs/roundtrip_judge.json` (`5b8332ce588e16c38d8d39e18bfd4a4b641338b05aa9f1e8f7024292d0a77469`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/agent_outputs/source_contract.json` (`9e137197170bae5ea6f44d8b1d6182017d37e5c6d7e245ee72226f93e67f0867`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/inputs/blind_dependency_inventory.json` (`5d10096f1ccaab923c0095bac2d7d871b70e2f23069dd78b524fc38603e9ebe5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/inputs/blind_dossier.md` (`e620853a5133515880dbb8139c5b298e524d3e63aab21004ffc6ed2892bd2054`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/inputs/blind_review_packet.md` (`e620853a5133515880dbb8139c5b298e524d3e63aab21004ffc6ed2892bd2054`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/inputs/declaration_dossier.md` (`854e270883965fd9821d0f689712e59cd52ed28a4b96ddda1e6f297129624f66`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/inputs/dependency_inventory.json` (`b45d2eccb494f65890d30811ef38bd78d2c6134ac88a9ff252a14b98332e621e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/inputs/direct_review_packet.md` (`a31014086029a53f8c3e9309a696d00ec3561f134e32d08a62842a3cd60859a1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T072539Z/inputs/source_locator.json` (`eb145448e5fecca3a14eb5d36c8b324ce3c339724f2ab92f7785902d3d339c2d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T073324Z/inputs/blind_dependency_inventory.json` (`4376b061cc1c487fefc5345efb2e600a7f8587ed3342571791a763a8ac1eb995`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T073324Z/inputs/blind_dossier.md` (`32a7336e740e6c072a33bafab03601b29aea11de8a04f3dede4d57a096306d08`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T073324Z/inputs/blind_review_packet.md` (`32a7336e740e6c072a33bafab03601b29aea11de8a04f3dede4d57a096306d08`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T073324Z/inputs/declaration_dossier.md` (`be20bb076a02db5b94a3cf9d943930d35c19fd5d46d30f313eabf278b7f0f614`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T073324Z/inputs/dependency_inventory.json` (`32e79dcf363152916a26ecc0e3f787bd4ff96c9f5bb3de6c1a6d4f33f81e03b6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T073324Z/inputs/direct_review_packet.md` (`49b6389163b917af0f100e548a8fd19687d89495d3976ba6bae29f6aa793e90d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T073324Z/inputs/source_locator.json` (`eb145448e5fecca3a14eb5d36c8b324ce3c339724f2ab92f7785902d3d339c2d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/agent_outputs/agent_runs.json` (`944991a3d85c1c9b77cbdc8eab350e80d65607ad7196cd339f04f5d9224e69ba`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/agent_outputs/batch_source_contract.json` (`bddda9768531429c363af90d5c05ed2bfc848979a985ecdf5d08386318ecab93`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/agent_outputs/blind_translation.json` (`59257f4eaf96a5bd909975ae11dcb277a1bd7657a2b88409c11edeb171665b02`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/agent_outputs/direct_judge.json` (`5005be4e32675b5653ff5035315c62a1db4178c86205d9d97437c43ff0215188`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/agent_outputs/roundtrip_judge.json` (`cd9a833298705b73a25f55832cc5749350c5d7b80f75f76a2ae34bd5ea7aba55`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/agent_outputs/source_contract.json` (`9e137197170bae5ea6f44d8b1d6182017d37e5c6d7e245ee72226f93e67f0867`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/inputs/blind_dependency_inventory.json` (`4376b061cc1c487fefc5345efb2e600a7f8587ed3342571791a763a8ac1eb995`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/inputs/blind_dossier.md` (`32a7336e740e6c072a33bafab03601b29aea11de8a04f3dede4d57a096306d08`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/inputs/blind_review_packet.md` (`32a7336e740e6c072a33bafab03601b29aea11de8a04f3dede4d57a096306d08`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/inputs/declaration_dossier.md` (`be20bb076a02db5b94a3cf9d943930d35c19fd5d46d30f313eabf278b7f0f614`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/inputs/dependency_inventory.json` (`32e79dcf363152916a26ecc0e3f787bd4ff96c9f5bb3de6c1a6d4f33f81e03b6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/inputs/direct_review_packet.md` (`49b6389163b917af0f100e548a8fd19687d89495d3976ba6bae29f6aa793e90d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T085809Z/inputs/source_locator.json` (`eb145448e5fecca3a14eb5d36c8b324ce3c339724f2ab92f7785902d3d339c2d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/agent_outputs/agent_runs.json` (`f4c84b5f4074ee49e724bbe466404149e2c896dda4e9456edcdffd4c4189d337`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/agent_outputs/blind_translation.json` (`3c7a3b0adadea42b292511529532b2f9d74299e34761e4b37749bd4aceb9675c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/agent_outputs/source_contract.json` (`fe2ef3264b55613e7a7b6cf1166e7e77044d50e8b40395d9cbe731bfb6fd5003`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/inputs/blind_dependency_inventory.json` (`75da77ac8352b1eaf7f594ab9aa29a4bddea06d7c7d0e134fef90c9aa1baee42`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/inputs/blind_dossier.md` (`cf07bdd441cd45a9d5bdfed67ed1c0e6e871afaa6e9862dcbe57e207ef94a942`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/inputs/blind_review_packet.md` (`cf07bdd441cd45a9d5bdfed67ed1c0e6e871afaa6e9862dcbe57e207ef94a942`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/inputs/declaration_dossier.md` (`81aee692bc3c8bae1dcdb53a79fb9cc63d94ed40b39c431200834f8ca3f90efe`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/inputs/dependency_inventory.json` (`84862621eb1dc41966e68548b9b66b85c462a64d85fca8ec1e14310de49b6ba2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/inputs/direct_review_packet.md` (`f5388854b3e26c02cdcd43a83154bdc6934d80e4ab22fb54e1aa832b5224068b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T100017Z/inputs/source_locator.json` (`eb145448e5fecca3a14eb5d36c8b324ce3c339724f2ab92f7785902d3d339c2d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/agent_outputs/agent_runs.json` (`4e7e0ff7f9a71c7e51e155706cd38aa6da8e59204f1052671ba4ff28c09341cc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/agent_outputs/blind_translation.json` (`38830ccfbc151a6600caf09763d865d4f395c93d9732e6574f1e49ca1f398c37`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/agent_outputs/source_contract.json` (`fe2ef3264b55613e7a7b6cf1166e7e77044d50e8b40395d9cbe731bfb6fd5003`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/inputs/blind_dependency_inventory.json` (`2733ad71d7c574d4c643c647e378da612143d8ecd43419fb473f3a6b2d32b33a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/inputs/blind_dossier.md` (`1c6bab992e5c7d57a71473a9a654f69a1114ab08037ea92b85cb2204cfb8c7f4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/inputs/blind_review_packet.md` (`1c6bab992e5c7d57a71473a9a654f69a1114ab08037ea92b85cb2204cfb8c7f4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/inputs/declaration_dossier.md` (`a8d788d5fd0fa421ddd13f09e940588116a7291e4be091b2fe0d6b35d8e927f7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/inputs/dependency_inventory.json` (`31a28cdef963da5be2ac542766891ce92e751f9544c646431c163f2678816289`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/inputs/direct_review_packet.md` (`b9d028f519dbcf4e9b95fd36163f13066c0534f1e9bef7638717595baff41dca`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T104449Z/inputs/source_locator.json` (`eb145448e5fecca3a14eb5d36c8b324ce3c339724f2ab92f7785902d3d339c2d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/agent_outputs/agent_runs.json` (`149165a28e79852756287a5c2038c28071c23e52821ec4b4099e93aa7067b720`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/agent_outputs/blind_translation.json` (`9cc7880b7142b786b3add8055194279d0526a22b489db4f72ec0dec428e23511`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/agent_outputs/direct_judge.json` (`0a7a904dbe6fe13b88c35a5452ce72bf8ec5643fc5f3aee8e913f63951cecbb9`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/agent_outputs/roundtrip_judge.json` (`e0f6ff7674d20af58ac91beec16121d57b10e10308b0d34d8c896a9848628f43`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/agent_outputs/source_contract.json` (`91a4301d06434d5f4a967873a1432b15f9c640d6d956b6c58d81f00f814ad31e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/inputs/blind_dependency_inventory.json` (`a838d1825cb427e3012c5f74fb29dac7221d5abc048945719988712e558e7872`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/inputs/blind_dossier.md` (`739d77caa34adcaa90bc8570a17b854e52c6b3b3e264c58cb40303cc23fccd94`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/inputs/blind_review_packet.md` (`739d77caa34adcaa90bc8570a17b854e52c6b3b3e264c58cb40303cc23fccd94`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/inputs/declaration_dossier.md` (`91c14f168f1529f3d1eaff02c4216332554602b84738d6d31a7f094729feacf8`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/inputs/dependency_inventory.json` (`e20adabf243a18fb5e4689fdbbf3c8f97361ed397c315f81a0a72fb0c05a4b48`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/inputs/direct_review_packet.md` (`dcfb9e0f72eb84d57420266d04e7a9117e04318b372a59277e1574e42197e792`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/history/20260901T120825Z/inputs/source_locator.json` (`eb145448e5fecca3a14eb5d36c8b324ce3c339724f2ab92f7785902d3d339c2d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/inputs/blind_dependency_inventory.json` (`ece696fcd4fdb05ecef11454726240945dce512ea34a94ce7c0b2006cd5e614f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/inputs/blind_dossier.md` (`8280bc0a125976cf3b415f63ad4770520970e826d14d458830d566d67f8cfaf2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/inputs/blind_review_packet.md` (`8280bc0a125976cf3b415f63ad4770520970e826d14d458830d566d67f8cfaf2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/inputs/declaration_dossier.md` (`41b3f577c66fecb23c83273eca5945b40618c8cc40e211e0f6f71e93766f256e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/inputs/dependency_inventory.json` (`a99ead42d13a39e1769dbafb27ea52cf20d1d9ca7bcaa62831da82eb5a02a499`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/inputs/direct_review_packet.md` (`242e835b01190b974cd42272caadfaee953f4c28d9c2a06e2bece6f8547387c9`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-DIMENSIONAL-SPLITTING/faithfulness/inputs/source_locator.json` (`eb145448e5fecca3a14eb5d36c8b324ce3c339724f2ab92f7785902d3d339c2d`)
