# Faithfulness audit: HDP-02-EX-2.5.7

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The judges agree on the exact functional, finite sub-gaussian domain, real scalar field, probability context, constants, boundary handling, nonvacuity, and completeness of the norm laws. Their sole difference is whether the source permits the standard implicit identification of random variables almost everywhere. Equation (2.13) depends only on expectation, while Exercise 2.5.7 asserts a genuine norm; on literal pointwise functions that assertion would generally be false because null-set modifications are invisible to the gauge. The intended and mathematically coherent reading is therefore the standard almost-everywhere quotient. Lean's measurable finite-gauge carrier, a.e.-zero submodule, quotient lift, and real finite-gauge conversion state exactly that reading. Both implications are yes, so the classification is faithful-equivalent and accepted.

## Implications

- **Lean implies source:** `yes`. Lean states all norm laws for the exact source gauge on the source's sub-gaussian domain, with the expectation-invariant equality convention made explicit as an almost-everywhere quotient. Thus the Lean proposition implies the source norm assertion in its intended measure-theoretic sense.
- **Source implies lean:** `yes`. The source's genuine-norm assertion for equation (2.13) necessarily uses almost-everywhere identity; under that convention it entails the same nonnegativity, zero, definiteness, triangle, and homogeneity laws on the same finite-gauge real random variables. Lean's explicit probability-space parameter and quotient packaging add precision without changing the claim.

## Findings

- **note / implicit almost-everywhere equality convention:** The explicit quotient is a faithful clarification, not a specialization or semantic mismatch. It resolves C08 and both previously unclear implications.

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
| `C08` | `pass` | `unclear` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `154` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `154` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/agent_outputs/adjudicator.json` (`e23c24a93406fa577aebe535ca5a1446f9318bd7a90453f390cb92af5112ae94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/agent_outputs/agent_runs.json` (`ac5506f7800822f10429bf332b944b5924914b8811287eb3efd9da2857abd86c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/agent_outputs/blind_translation.json` (`c48b9ec8d048ba768ef1f681c720b8c42a4f22227542416638f18a594ea7c9b2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/agent_outputs/direct_judge.json` (`1870af154fbf0ef898e068bd7bd1b0bffd5d2b18a6d295fd4a93a56de9eaa51b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/agent_outputs/roundtrip_judge.json` (`8fe2dc5677d6ee7079b2014554bae155ec710a7365f9ea771b56328c0e0de29c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/agent_outputs/source_contract.json` (`b6e038ce8117c2d7faff8dd198f5ec25f36f450351c8bb285869c3ce17c81c21`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/decision.json` (`b166d1fb0ee460c162a5f6dc048dea671e22245755cdab4126a2cc2af72dc566`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/agent_outputs/adjudicator.json` (`f6c1553e44a2ed12131ee21a5ae74fe5c3fa1a6f1648dd0af8337026d45c7875`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/agent_outputs/agent_runs.json` (`067a230dfb16649e694a570b36379ed903245d75b259c78bafdc874ec1e8ac50`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/agent_outputs/batch_source_contract.json` (`3cd675eedbead941ac098d13a2c6ba1f819f571ca161fd3b5017762c466ce507`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/agent_outputs/blind_translation.json` (`f5792a029102e3808596c161ec25ea5343e802d41277ad4cec2179f70c688618`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/agent_outputs/direct_judge.json` (`5395feebd009ed89c23c8b1f16ad646150bd217d79ab613b67c4344d6bb4098b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/agent_outputs/roundtrip_judge.json` (`20f64b180499d61b4267256af7a07b1b4b3e17b4e97b55947c685961ebb725ee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/agent_outputs/source_contract.json` (`b6e038ce8117c2d7faff8dd198f5ec25f36f450351c8bb285869c3ce17c81c21`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/decision.json` (`4cd11e7923f422304aa31924dccd2738780db87d7dbe02dc0ec836d4f7766877`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/batch_source_locator.json` (`1dfe65f82a215f65b6cb1f6f851d4b67c260dca271ca0ba5f89b053addc7b137`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/blind_dependency_inventory.json` (`518b2bbaeaa4a602d868415b9e02832845fa352e4977f0be443830308606394b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/blind_dossier.md` (`4f9956966df6c02b5729a77e9a58822b83810db49aa839fd570ca0c85aeaee5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/blind_review_packet.md` (`830c70cd1322b8939a4d8cbb478f2b1b82aea37338e2d2f12ccd0bb12e01e010`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/declaration_dossier.md` (`18e5227678c0270cd36dc5fc517c8aca1fa2e082bc2f28d289b0a78b5e84fb75`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/dependency_inventory.json` (`21d5da20278b120c252e7fdd9f71262344ea3ff477fe1216e0f27c86abb3e0fe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/dependency_reuse_blind.json` (`e6f60560a3a0d3078d8d58aabcc890055fae00b732aeee89c3c2a9912460a9da`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/dependency_reuse_direct.json` (`2afc7d69db3dde2d8c9d1dcd4e8e82a25f055607c0686a8e7bf24692fcee6d0d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/direct_review_packet.md` (`f7c3e21913f5b1847898dc403425d88ae96d36c19148cd83e07307b2122fba06`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T084351Z/inputs/source_locator.json` (`8eb0b6b66680847591a821eac0b7e74816cbeebdc97bfea830e0a8467c96a504`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/agent_outputs/adjudicator.json` (`e23c24a93406fa577aebe535ca5a1446f9318bd7a90453f390cb92af5112ae94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/agent_outputs/agent_runs.json` (`ac5506f7800822f10429bf332b944b5924914b8811287eb3efd9da2857abd86c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/agent_outputs/blind_translation.json` (`c48b9ec8d048ba768ef1f681c720b8c42a4f22227542416638f18a594ea7c9b2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/agent_outputs/direct_judge.json` (`1870af154fbf0ef898e068bd7bd1b0bffd5d2b18a6d295fd4a93a56de9eaa51b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/agent_outputs/roundtrip_judge.json` (`8fe2dc5677d6ee7079b2014554bae155ec710a7365f9ea771b56328c0e0de29c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/agent_outputs/source_contract.json` (`b6e038ce8117c2d7faff8dd198f5ec25f36f450351c8bb285869c3ce17c81c21`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/decision.json` (`4732d7cd2146fa37aa948acf107df926f828792319432ef174c96e051121224b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/inputs/blind_dependency_inventory.json` (`518b2bbaeaa4a602d868415b9e02832845fa352e4977f0be443830308606394b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/inputs/blind_dossier.md` (`4f9956966df6c02b5729a77e9a58822b83810db49aa839fd570ca0c85aeaee5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/inputs/blind_review_packet.md` (`4f9956966df6c02b5729a77e9a58822b83810db49aa839fd570ca0c85aeaee5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/inputs/declaration_dossier.md` (`18e5227678c0270cd36dc5fc517c8aca1fa2e082bc2f28d289b0a78b5e84fb75`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/inputs/dependency_inventory.json` (`21d5da20278b120c252e7fdd9f71262344ea3ff477fe1216e0f27c86abb3e0fe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/inputs/direct_review_packet.md` (`0959a7887d7a3336106e023d5058f36c8a909cd7a5cee7dc31140d39505a6236`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/history/20260831T101604Z/inputs/source_locator.json` (`8eb0b6b66680847591a821eac0b7e74816cbeebdc97bfea830e0a8467c96a504`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/inputs/blind_dependency_inventory.json` (`518b2bbaeaa4a602d868415b9e02832845fa352e4977f0be443830308606394b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/inputs/blind_dossier.md` (`4f9956966df6c02b5729a77e9a58822b83810db49aa839fd570ca0c85aeaee5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/inputs/blind_review_packet.md` (`4f9956966df6c02b5729a77e9a58822b83810db49aa839fd570ca0c85aeaee5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/inputs/declaration_dossier.md` (`2be9ad42699a9a2fa02d2db5e69f8ba9e0a74acad14c625a2c82a8c0063cfc45`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/inputs/dependency_inventory.json` (`21d5da20278b120c252e7fdd9f71262344ea3ff477fe1216e0f27c86abb3e0fe`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/inputs/direct_review_packet.md` (`0959a7887d7a3336106e023d5058f36c8a909cd7a5cee7dc31140d39505a6236`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EX-2.5.7/faithfulness/inputs/source_locator.json` (`8eb0b6b66680847591a821eac0b7e74816cbeebdc97bfea830e0a8467c96a504`)
