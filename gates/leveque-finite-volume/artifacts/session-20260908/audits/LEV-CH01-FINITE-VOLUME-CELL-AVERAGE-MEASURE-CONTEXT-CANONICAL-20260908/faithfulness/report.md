# Faithfulness audit: LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `4c9e8eee7c8cfce7fa381cf1de2892d5b2326b46aacbbf3a2bff4efad1eca816`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source pages and inline declaration evidence establishes the same spatial normalized integral on both sides. The decisive supplement identifies the exact Real.measureSpace.volume used by the target, including its normalization and endpoint nullity, resolving every measure-dependent trigger. Both semantic implication directions hold for the selected one-dimensional definition with ordinary analytic admissibility made explicit. No reduced applicability is mislabeled as stronger, and neither empty vectors nor definitional reflexivity conceal a mismatch. I used no tools, accessed no external files or target proof, and did not independently recompute the supplied provenance hashes.

## Implications

- **Lean implies source:** `yes`. For the selected definition in its immediate one-dimensional context, fix time t and an admissible interval cell with left < right, and instantiate state x = q(x,t). D001–D003 give the exact average as (right - left)⁻¹ acting on D060's interval integral. The reverse interval is empty. The native supplement identifies the exact measure argument as spatial Lebesgue measure and the same cell's real volume as right - left. Endpoint choices are immaterial because singletons have zero measure. Thus the target and its defining dependencies represent the source quotient componentwise. This does not assert the surrounding numerical update process or a multidimensional theorem.
- **Source implies lean:** `yes`. On the target's positive-length, interval-integrable finite real-vector inputs, the source definition assigns precisely the spatial integral divided by interval volume. The supplied native declarations identify that volume with right - left, so D002 through D003 names the assigned vector. D001 then asks for the defining equality together with the already assumed order and integrability. Fixed-time instantiation and finite coordinate functions preserve the intended objects. The empty-vector case follows definitionally and contributes no substantive additional strength.

## Findings

- **note / resolved-integration-measure:** The round-trip measure uncertainty is discharged by declaration evidence; provenance hashes alone were not used to infer semantic correctness.
- **note / analytic-precisification-and-scope:** Acceptance concerns the conventional finite interval-average definition. These conditions are mathematical precisifications, not a claim that the source explicitly lists them or that the target proves a stronger theorem.
- **note / definitional-specification:** The specification is definitionally reflexive, but the checked defining expression matches the selected source definition and has nontrivial admissible instances.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `unclear` |
| `C12` | `pass` | `pass` |
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `60` dependencies (`0` hash-reused); unclear: `D025`.
- Direct judge covered `60` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`5601b0f48f08742499837daa9cacab78748a0a0f7e756bd8d252f915575b02f7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`0661092b4589524d282d19522bcc1a2ac41dc571ec6c369d79c766bdd944f4a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`a532bac3ae201d320d3f49b97af27de3ec39922f9514b3deebe64cb0a5576901`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`c30ff04b4cd97d09b21c6ca960e06620db5c216a68931e915d48719ebd0cfda3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`c39f1775090cf1fb42db1bcea3350f7b6339cf9fc75553718077b28af14abdb7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`4a09e47b9848a44e752df7b2937e602db9fd838760bd2b0f8222f2fc7c5f32e1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/decision.json` (`d2a133b2e23b485fba83a3beea97b27913bdc0dc13e6a71a3d36dddfe91b66d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`faf1efebd6c7bcfd531c150e18769462ec047338f44fbaa0e94d2f4db8b30381`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`62de33638fafec98124c7f90b54e3ad33222e4e8fedc457d80333ae5567b17c5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`62de33638fafec98124c7f90b54e3ad33222e4e8fedc457d80333ae5567b17c5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`06fdf293669448ab2668d6959ea530d32f289d37e4a320ed59222a49d27198d5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`7d0299a90a810c1e7da5b4d61eaa0003a286399d3c128028b891c5d602125978`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`3ef0a0d88f1eb4fa273e4cf845d7350a1f42ce1245ad109dbfc72b8ea2920cb8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`57f8385d6974cf90a38f441c3f4b0e9383d14a12a2e467f9fda0dd5bf9fbe078`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`c03a82654cac745e3ed8636bcff4fee84757e04e81547010f6dd458f2ee848f0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`5601b0f48f08742499837daa9cacab78748a0a0f7e756bd8d252f915575b02f7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`58c4870e132def337cc1bf9b4196c63da90b1db8604e6622b036b6f1ab221405`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`54840f304c64158c4635005ec57737566aaafeea642abe04b8123f6b88f6c11c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`c0bf0add7ad650cea1f459bca0a9eb35a0a2133cff900c269f10ae61200b22bd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`10524cb54bc2be39075fb238c614a8de4c2948617eccc87934b22f86e13eb80a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`b70c79ffa001d47b5189b7b3d5c3ccc0b177979f63f5ee4149265027b857aa0c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`08ee7d84d0e0b4e07a1c297de28dfd75bfdff83bf5472de61a961748493af0da`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`a532bac3ae201d320d3f49b97af27de3ec39922f9514b3deebe64cb0a5576901`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`2a8ed6314a98154c165b2792ab2fc60bbe12fecc8426c1432caff885c5028b38`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`2c97ff6ae2686d6d74a445c9cd0450b40bada377869278a2cad1d1672249e227`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`b7be13a2a5efe69ef53ac2f18dcd1e0b461daf62c28bb48607ad39fec445184b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`d416f057c5ddbb3c596ff4aadeed9d305399db73fcb53a80aa244db185568175`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/c.py` (`e5922aec62e57cd7c9457e3ba9698cdc272952959e42caddb758a696c145a5f4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`6f32e591d8f807c8a21cc2405a163f442a1ac355602b8ac02b926f4e0b214591`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`c30ff04b4cd97d09b21c6ca960e06620db5c216a68931e915d48719ebd0cfda3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`23928d299d040796b99b341a7a3598126e746529f7b338a435387581e2dd03db`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`ca3374de249112a65be51a9e702298ea777d205025fee7f9898fa7d37090b206`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`594ae6af7f5fcfb21d8de83edb8460e2a655ae65cb890cd248b5034dc4ad4f61`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`b8582acb9aa06c7fc896ed8f6ca7aa4ed1e7a2a0d59e4067a8115812b0ba8b36`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/q.py` (`5cf2a280bad968a94e7820ea62540d503f6704432bd4372ef7d7fb5c858fbe0f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/r.py` (`11acf12d6c1e604997e3a08908f3f0c7f8e8718cd47fea706c7104894b728860`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`3cf1532f9e414599f4427cd3e51e997a2e472a4ab103358cce9f0198ca31f947`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`c39f1775090cf1fb42db1bcea3350f7b6339cf9fc75553718077b28af14abdb7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`5ef4c179ab1bca83b9c88280a82370c0a0649fa862329ce4ee076c7654e32ade`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`16b1194dc32d474d8c3beb0ea7f2be015c68c9c4ef86b3c306e2b2554bf05772`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`bc8075203836599064c3a143557b9b6d0c13f81aaa9bbb8f23fbaf04a77515c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`bd823a913e6e21d670eae1cc9d3a7a0471434e318935d6daab26615247068dec`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`05eb72e5de408c37f6c0d538d911fd99f731ec75884d176e737c134506e9e7cb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`4a09e47b9848a44e752df7b2937e602db9fd838760bd2b0f8222f2fc7c5f32e1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`2d572436701b825effee23e90481bbdb3b2d47d19bb80574789968672a0b6bba`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`37d3d9ae270fea2ab796f8e2a214bccc3d844c4e68ac0a90be4b065d921f1711`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`1d9a04569578da1366d56ca30a115341d683c6d97604cbb0e4bff55153f3a0e5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-CELL-AVERAGE-MEASURE-CONTEXT-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`9137363518359e32191b9c0e0eaca92417a7251919b99efe124b2b49ae2ecd59`)
