# Faithfulness audit: LEV-CH01-HETEROGENEOUS-CELL-AVERAGING

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `9f4d4892897689bb8639636573642bab51450709e365b02eabf15941de7e937e`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Primary evidence supports the direct judge's equivalence classification, but not by vote. The source's operative content is a cell-indexed assignment obtained from a problem-appropriate average restricted to each cell's enclosed volume, with cell-to-cell difference permitted in a heterogeneous medium. The target leaves the average formula completely abstract and makes only the nondegenerate, local, constant-preserving meaning of such an average explicit. Its unequal-property conclusion is conditional on unequal averages and merely transports that inequality through the one-field property wrapper. None of the disputed clauses is a new unconditional theorem conclusion, and none changes the source objects or averaging region. Consequently Lean implies the selected source claim and the source, in its intended finite-volume context and explicit unequal case, implies the Lean proposition.

## Implications

- **Lean implies source:** `yes`. On every intended positive-finite finite-volume instance satisfying the explicit different-average case, the target supplies a property for every cell whose stored parameter is exactly the chosen problem-dependent average, and the rule's EqOn law ensures that this value depends only on the material data over that cell's region. This directly realizes the source's cellwise assignment by appropriate averaging and its permitted cell-to-cell difference.
- **Source implies lean:** `yes`. In the source's ordinary finite-volume context, an appropriate average over a cell's enclosed volume is cell-local, normalized on constant material data, and taken on nondegenerate finite cells. The source does not assert that all cells must differ; in the target's explicitly assumed unequal-average case, assigning the one-field wrapper to each average gives the assignment, locality, constant-preservation, and unequal-property conjuncts. Thus the formal clauses unpack the selected source meaning rather than state an independent stronger result.

## Findings

- **note / classification-of-side-conditions:** Under the fixed audit policy, narrower applicability and restated consequences of hypotheses cannot support faithful-stronger; here the clauses are source-semantic unpacking, so both implication directions remain yes.

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

- Blind translator covered `40` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `40` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/agent_outputs/adjudicator.json` (`acc4a962b54e543a78acef7b31d3649178cb0707f5371ea087a419d844163b71`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/agent_outputs/agent_runs.json` (`e0a468c6cf23f3da149d423ccd9f833c33c0371ea4ae016e9ba1d9c12d0327d6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/agent_outputs/blind_translation.json` (`e81c610e7863b7d6442159451abb6b2ffb3935be38ef9cb220b54074636e7a68`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/agent_outputs/direct_judge.json` (`f0f74745891d5924285c00e314aafd418702c291b8318e6c53118c96cb2268d2`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/agent_outputs/roundtrip_judge.json` (`1405b85891dd6b2a8193516900867e4de5739a50ab9733ffe0cf65a8731a3eda`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/agent_outputs/source_contract.json` (`b0b8799d13ffa913b36dab89c6176538507343d9ed0f2ca2ba4b0f06353e382b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/decision.json` (`533d0b707c733f650b50c92e00060f45cf07c44068732064063197a8370b1c23`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/agent_outputs/agent_runs.json` (`312c801ff8fe17332730e6b26cf1cba6f4561f622803576d571de85d8c018385`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/agent_outputs/batch_source_contract.json` (`bddda9768531429c363af90d5c05ed2bfc848979a985ecdf5d08386318ecab93`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/agent_outputs/blind_translation.json` (`ebeba7b081d4a60b14a6f4bdf6928247ec795bb2dec42bddf5dd2e07cefc1203`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/agent_outputs/direct_judge.json` (`828a3196046473e9b9fadaee8ddc9adc984a2ec864e1d3d371d965e6d0d06a5a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/agent_outputs/roundtrip_judge.json` (`e18a14921568679e0e384e1f805a985f13f0df0b1627131cc457942ccb670a51`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/agent_outputs/source_contract.json` (`f042b3b49ac1d6c2a6265ce37b85eac2208d6e1f6ee1005184626da04b9036b1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/inputs/blind_dependency_inventory.json` (`80d664f5d96906c427aebb7cfff533aa67042386371523fc938bafd840d3f8ec`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/inputs/blind_dossier.md` (`7324fd241a75b826c3ac6d3db057ec0c9b5096dc38edabe116386950be935440`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/inputs/blind_review_packet.md` (`7324fd241a75b826c3ac6d3db057ec0c9b5096dc38edabe116386950be935440`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/inputs/declaration_dossier.md` (`27131c2bb4efe0458cca7220f76c7d4e73b38114b614e1553e8d77c19ca95172`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/inputs/dependency_inventory.json` (`fd3133e372bb60fb4d5784a7b329f3121be98195158520f37e2bbe23cadc325b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/inputs/direct_review_packet.md` (`43d28fd83574231d29d510aed76868608db7e530f4cf75cbbb5256cab617d6dd`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T072720Z/inputs/source_locator.json` (`3bf8db82e02cdcbfe88f5c2870003dcaa22037f98ca135d3ade178d866d7ab3e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T073502Z/inputs/blind_dependency_inventory.json` (`9c74464500420ea87a0495cf07e507071272111583a2c529d518754effb4dd2f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T073502Z/inputs/blind_dossier.md` (`9435daa9b1cd06b2edd43b94ab49e6600fd3f79a085ce3cf5d399560bbd2214b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T073502Z/inputs/blind_review_packet.md` (`9435daa9b1cd06b2edd43b94ab49e6600fd3f79a085ce3cf5d399560bbd2214b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T073502Z/inputs/declaration_dossier.md` (`71a2407187d398f58500660f4061fdd54a5433c96f9296cb2e6b32eddcc607ab`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T073502Z/inputs/dependency_inventory.json` (`bc6289c81e5c9ce69b2a951f28772651fb1c3d7e1c49b5d0c3300b98a5cd70ce`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T073502Z/inputs/direct_review_packet.md` (`8b34221d737f0bd54dcff33b090db2ac0ac2dbfaee1f04e0d4ba45d73bad6504`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T073502Z/inputs/source_locator.json` (`3bf8db82e02cdcbfe88f5c2870003dcaa22037f98ca135d3ade178d866d7ab3e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/agent_outputs/agent_runs.json` (`b02e95396282416a0d60c98ac948b4d8dadf2a66562b17e1379362c69704ba53`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/agent_outputs/batch_source_contract.json` (`bddda9768531429c363af90d5c05ed2bfc848979a985ecdf5d08386318ecab93`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/agent_outputs/blind_translation.json` (`80957d80c8d2c7aca3e8d93cefb27e774bb45db14622de7175612816e9453b52`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/agent_outputs/direct_judge.json` (`1cd572b17556b26b7cb242c5e1d878bc61021893ff6a9071239f67db189ab01d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/agent_outputs/roundtrip_judge.json` (`27acf2e03b8d61db57756eed868d3f7d4f4bc6ac60b9d22dba1b8ff6e53a4504`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/agent_outputs/source_contract.json` (`f042b3b49ac1d6c2a6265ce37b85eac2208d6e1f6ee1005184626da04b9036b1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/inputs/blind_dependency_inventory.json` (`9c74464500420ea87a0495cf07e507071272111583a2c529d518754effb4dd2f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/inputs/blind_dossier.md` (`9435daa9b1cd06b2edd43b94ab49e6600fd3f79a085ce3cf5d399560bbd2214b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/inputs/blind_review_packet.md` (`9435daa9b1cd06b2edd43b94ab49e6600fd3f79a085ce3cf5d399560bbd2214b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/inputs/declaration_dossier.md` (`71a2407187d398f58500660f4061fdd54a5433c96f9296cb2e6b32eddcc607ab`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/inputs/dependency_inventory.json` (`bc6289c81e5c9ce69b2a951f28772651fb1c3d7e1c49b5d0c3300b98a5cd70ce`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/inputs/direct_review_packet.md` (`8b34221d737f0bd54dcff33b090db2ac0ac2dbfaee1f04e0d4ba45d73bad6504`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T090149Z/inputs/source_locator.json` (`3bf8db82e02cdcbfe88f5c2870003dcaa22037f98ca135d3ade178d866d7ab3e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/agent_outputs/agent_runs.json` (`45ef670e79c0cce57a078262e4f756515c29b90690da778736911e732fb9f5d6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/agent_outputs/source_contract.json` (`b0b8799d13ffa913b36dab89c6176538507343d9ed0f2ca2ba4b0f06353e382b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/inputs/batch_source_locator.json` (`550718920474263b37166c18428d725cd2014735d4ba54a8f624e00d6823be79`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/inputs/blind_dependency_inventory.json` (`9d7d24b415a21775d769dd21e32cab39108bfc33a5f7cce8f591d13ad870a1c1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/inputs/blind_dossier.md` (`653ad47c0316e1487eee8760200d1a6159d811c0d56f3bba121b4a7c75f07d41`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/inputs/blind_review_packet.md` (`653ad47c0316e1487eee8760200d1a6159d811c0d56f3bba121b4a7c75f07d41`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/inputs/declaration_dossier.md` (`4bf0e0e642c538bdbad320be8b41c440532ccccc5e50b83b4d93f1a4174f0f5f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/inputs/dependency_inventory.json` (`7c41a1be95c4ae7fec7486c647b6b6c85b094ca15992f4fc1b540c7ba0093a5c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/inputs/direct_review_packet.md` (`ac44434a10153651815304bf575c5361b3311aea7c71095cfb8ac09e5f6db147`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T105029Z/inputs/source_locator.json` (`3bf8db82e02cdcbfe88f5c2870003dcaa22037f98ca135d3ade178d866d7ab3e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/agent_outputs/agent_runs.json` (`2a4892006e1567653c54aea2340caa7ec0c5c78a710008b205e1d6853f000248`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/agent_outputs/blind_translation.json` (`ed77724860c2fa8d2cb66cb392f9474fcf99ab0e0bd0a829f4269cc296c21b5b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/agent_outputs/direct_judge.json` (`f280ae2028e78e14ddc2bc8fc62cfa20fb8c24af431c7bfb2f463b7bc1cdb665`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/agent_outputs/roundtrip_judge.json` (`1102cc7d7ddcecf45261164d773f82362bba6d553e47e8b3cf8f7404e1c1ea7a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/agent_outputs/source_contract.json` (`b0b8799d13ffa913b36dab89c6176538507343d9ed0f2ca2ba4b0f06353e382b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/inputs/blind_dependency_inventory.json` (`a0f32339cd8cdd62e6b395e759dab1a04ab7ab73f265e7659a8ad04afa7fb22a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/inputs/blind_dossier.md` (`bd665acea09d4c7a7b1db29d959672575a916b96fc84862023ca523172118504`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/inputs/blind_review_packet.md` (`bd665acea09d4c7a7b1db29d959672575a916b96fc84862023ca523172118504`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/inputs/declaration_dossier.md` (`0e1fc8f078b10fd0adb67bd03bb8e6d89d0537de726540aba39090fc70b7fcbb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/inputs/dependency_inventory.json` (`928144d9b03cbebc1c73f479f0dca5ff8d501123b647bc19ff1d8a89186ed3f3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/inputs/direct_review_packet.md` (`c99e4d28f05b8fe1cf0bee3fd75372f6e22e2b055761162392b71f1670f69fa7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T110748Z/inputs/source_locator.json` (`3bf8db82e02cdcbfe88f5c2870003dcaa22037f98ca135d3ade178d866d7ab3e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/agent_outputs/agent_runs.json` (`40d14f50308882efcba85b80d763e48690dec4c37f160833857e4433a9010a6b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/agent_outputs/direct_judge.json` (`8327984f356e21714f30f398cdca9065926a6383e453c686ad50fb16b133e788`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/agent_outputs/source_contract.json` (`b0b8799d13ffa913b36dab89c6176538507343d9ed0f2ca2ba4b0f06353e382b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/inputs/blind_dependency_inventory.json` (`c197524018ac3c64c94acdf12370d515a627dd9541b32da6f2e618922e49037f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/inputs/blind_dossier.md` (`0ff327133d1009f51c2548600f08dd4f029c8a0bc5f67c559ed62794d58e20d4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/inputs/blind_review_packet.md` (`0ff327133d1009f51c2548600f08dd4f029c8a0bc5f67c559ed62794d58e20d4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/inputs/declaration_dossier.md` (`d3bd43a0ef0455f1116d4c33111af00d574c7c7aa1cd339fe82400947567062d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/inputs/dependency_inventory.json` (`56fa2cde6435b90fb49f80cad4d8e9d1a3e63f1e26b9897451b75e0064460e65`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/inputs/direct_review_packet.md` (`27afc70892efa469ae16bd7f30f91e2c0e7ba0cb8731d57222575471a0c2c506`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T111757Z/inputs/source_locator.json` (`3bf8db82e02cdcbfe88f5c2870003dcaa22037f98ca135d3ade178d866d7ab3e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/agent_outputs/agent_runs.json` (`bafa624a58b208e54e886f29d893f173ff11d0a86513b3b0ed22cb861617780f`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/agent_outputs/batch_source_contract.json` (`45b44b76351bbde2fdb6838f07c921232e2ef38eb9b518faedba89f8350b075d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/agent_outputs/blind_translation.json` (`cf6e2ba9f876d8b359b321266da903dcdad1b1805556282485c83f7ec5d1cd01`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/agent_outputs/direct_judge.json` (`6bb5606d6e22fcb03e1977922d9d0021e1453e6bc8caa5addc1ae313494be24c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/agent_outputs/roundtrip_judge.json` (`523a4c90722393c13f7fcaf8ba99aee08bf4409fb7f9e0ef5b38d7fd3382f48d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/agent_outputs/source_contract.json` (`b0b8799d13ffa913b36dab89c6176538507343d9ed0f2ca2ba4b0f06353e382b`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/inputs/blind_dependency_inventory.json` (`354fcc9b76fe0c0444bd85d06b650fb84736e6a5583e95311aee7f370a41a9ce`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/inputs/blind_dossier.md` (`58c11e9bdf48324dcb799e33b1101f9c423ec118cd822f85ba35a6830cbf8ed0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/inputs/blind_review_packet.md` (`58c11e9bdf48324dcb799e33b1101f9c423ec118cd822f85ba35a6830cbf8ed0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/inputs/declaration_dossier.md` (`73abe6831f871af5a127e90c5356438d09060259332414decb62f05a5f59b5ad`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/inputs/dependency_inventory.json` (`a122174a12da1eeb73b2224edf7e125797b42b306d1968b7e0a92d3bf96203e0`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/inputs/direct_review_packet.md` (`04c4bd3a52e184a669c543766b127be2300caf4b4743c094f58f7a8810ca0afd`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/20260901T113508Z/inputs/source_locator.json` (`3bf8db82e02cdcbfe88f5c2870003dcaa22037f98ca135d3ade178d866d7ab3e`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/history/schema-invalid-20260901T1144Z/blind_translation.json` (`6fde592d16516e0b2097118180f36c7441dcb9faab29f12977eadd93c7ea43bb`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/inputs/blind_dependency_inventory.json` (`c27200030fd81d3c24966e0fc654b966f03c565eeb2a63006f7513955c102d0c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/inputs/blind_dossier.md` (`d0cc310fd2d552d77a7ce0e97e5672b6a4eae9bf41e8803f7092ae4c999dad63`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/inputs/blind_review_packet.md` (`d0cc310fd2d552d77a7ce0e97e5672b6a4eae9bf41e8803f7092ae4c999dad63`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/inputs/declaration_dossier.md` (`593320e35c0e1650083798e7655b5d6aa89e6c4023309bd327539a04acf62126`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/inputs/dependency_inventory.json` (`9b68709061613327555becb093a7bcaa5d25439d093aab7d89d462165eac9bb1`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/inputs/direct_review_packet.md` (`5df5b5f4204430de6ec304d4d33cbaf2d13bd64ab75a102171179085bae6f9d4`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-HETEROGENEOUS-CELL-AVERAGING/faithfulness/inputs/source_locator.json` (`3bf8db82e02cdcbfe88f5c2870003dcaa22037f98ca135d3ade178d866d7ab3e`)
