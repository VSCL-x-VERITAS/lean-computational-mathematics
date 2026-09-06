# Faithfulness audit: HDP-02-BODY-2.7-SG-IMPLIES-SE

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `f29a9dd1af3a66b28273b29ad97411a28af8dff86a6e1f380260f3bdd6fa68d3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The Lean statement faithfully formalizes the selected qualitative inclusion. Its existential premise covers exactly the four non-centered sub-gaussian characterizations used by Definition 2.5.6, while explicitly excluding the centered linear-MGF branch. Its conclusion chooses the moment-growth member of the equivalent sub-exponential characterizations, which is sufficient for Definition 2.7.5. Both directions between the selected source claim and the Lean proposition hold once the source's stated characterization equivalences are used. The independent scale witnesses correctly reflect that the selected sentence asserts no quantitative norm bound.

## Implications

- **Lean implies source:** `yes`. A Lean premise witness has one of the four general sub-gaussian forms underlying Definition 2.5.6, because linearMGF is excluded. The produced positive-K moment-growth conclusion is one of Proposition 2.7.1's equivalent sub-exponential properties, hence establishes the source conclusion.
- **Source implies lean:** `yes`. A source sub-gaussian variable satisfies one of properties i--iv and therefore supplies one of the Lean premise's four allowed kind/scale witnesses. The source conclusion gives sub-exponentiality, whose equivalent moment characterization supplies the positive K required by the Lean conclusion.

## Findings

- **note / qualitative-scope:** This is faithful to the selected qualitative source claim; it should not be presented as a quantitative norm comparison.

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

- Blind translator covered `103` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `103` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/agent_outputs/agent_runs.json` (`2bb5a4e2d7bc2f6cbad90a77fe9ece33b074b401880ddc38303d4ee3929def8c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/agent_outputs/batch_source_contract.json` (`856d0400f37d309d6e394f4e5d704d0cd26bb8d59f2cdc4932f9f89bb4eb46e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/agent_outputs/blind_translation.json` (`c3148aa39a459f133a41b3bce55be3787a12dde2749087755286708ab69712b1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/agent_outputs/direct_judge.json` (`0df4af12985cd426846d08c3c171b071223495fe7084be9c343079255df14c11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/agent_outputs/roundtrip_judge.json` (`0e3cccc6f02be0d426abe1ca4cd38f5da91b6346888f28e3b7d22d6968ea9b53`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/agent_outputs/source_contract.json` (`8382e02a58cc71b4a8a320aa5a67b773ec069a6ce10b727a0cba3137ed95a345`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/decision.json` (`f62658e0160649a3e9d4a55d5c68fe301158f34b227aec33f4050b41ae69c2e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/agent_outputs/batch_source_contract.json` (`3e39d619b3c4737f1beebc1f4a6d89d80928155a0af9cf2c3a44f3fd92e95975`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/agent_outputs/source_contract.json` (`9aa91377b320b8c94105f05a26688f106bc3e258a938df2d4a779793f3fec745`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/inputs/batch_source_locator.json` (`96999ab9c93dd8971b343042a9dbb8df6ab0d66f4db2c3e00054f6ef1ac2564e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/inputs/blind_dependency_inventory.json` (`cee3f527e4582a03a70520e7864c372da75f2140392322d6a49718e26586d499`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/inputs/blind_dossier.md` (`7a5bd33ff1ea3e65255b020ad25ab7501115dc1aea24642856afcce2dd58b424`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/inputs/blind_review_packet.md` (`7a5bd33ff1ea3e65255b020ad25ab7501115dc1aea24642856afcce2dd58b424`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/inputs/declaration_dossier.md` (`ba2d2e2a8c91462dac419bf4935548195bf30496120495d9acb48e610b45056c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/inputs/dependency_inventory.json` (`702e1ca8fe1cad722ad5a80256ca75a4bbebef2d098c1e0abee8ccbb20527226`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/inputs/direct_review_packet.md` (`639e57a28f57d0f85207f093640439c6df60a1907145d77861cd43ecbf8da2f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T171603Z/inputs/source_locator.json` (`41677466d4582dfb4b3f0a082656e135029c920126d21c0d26f58fc14fdc9355`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/agent_outputs/agent_runs.json` (`40939758aa4203328e11372ce16e15d65d43a9d5d895b56450f4383079900822`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/agent_outputs/batch_source_contract.json` (`856d0400f37d309d6e394f4e5d704d0cd26bb8d59f2cdc4932f9f89bb4eb46e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/agent_outputs/source_contract.json` (`8382e02a58cc71b4a8a320aa5a67b773ec069a6ce10b727a0cba3137ed95a345`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/inputs/batch_source_locator.json` (`344c2f15f875394c1b35c8732c25ff4482a74b2364f89e81c7bee4a9d3ea6fc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/inputs/blind_dependency_inventory.json` (`cee3f527e4582a03a70520e7864c372da75f2140392322d6a49718e26586d499`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/inputs/blind_dossier.md` (`7a5bd33ff1ea3e65255b020ad25ab7501115dc1aea24642856afcce2dd58b424`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/inputs/blind_review_packet.md` (`7a5bd33ff1ea3e65255b020ad25ab7501115dc1aea24642856afcce2dd58b424`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/inputs/declaration_dossier.md` (`ba2d2e2a8c91462dac419bf4935548195bf30496120495d9acb48e610b45056c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/inputs/dependency_inventory.json` (`702e1ca8fe1cad722ad5a80256ca75a4bbebef2d098c1e0abee8ccbb20527226`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/inputs/direct_review_packet.md` (`639e57a28f57d0f85207f093640439c6df60a1907145d77861cd43ecbf8da2f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/history/20260831T204104Z/inputs/source_locator.json` (`2ea9cd95c3e23710c9d8d3f8b7a0ea4d93f2af70c3f227735b9c769345a44a93`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/inputs/blind_dependency_inventory.json` (`cee3f527e4582a03a70520e7864c372da75f2140392322d6a49718e26586d499`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/inputs/blind_dossier.md` (`7a5bd33ff1ea3e65255b020ad25ab7501115dc1aea24642856afcce2dd58b424`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/inputs/blind_review_packet.md` (`7a5bd33ff1ea3e65255b020ad25ab7501115dc1aea24642856afcce2dd58b424`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/inputs/declaration_dossier.md` (`06d98cc51f29292911c65e49a1225df857c12c21c4571e3a1a2b0127d48713d6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/inputs/dependency_inventory.json` (`702e1ca8fe1cad722ad5a80256ca75a4bbebef2d098c1e0abee8ccbb20527226`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/inputs/direct_review_packet.md` (`639e57a28f57d0f85207f093640439c6df60a1907145d77861cd43ecbf8da2f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-BODY-2.7-SG-IMPLIES-SE/faithfulness/inputs/source_locator.json` (`2ea9cd95c3e23710c9d8d3f8b7a0ea4d93f2af70c3f227735b9c769345a44a93`)
