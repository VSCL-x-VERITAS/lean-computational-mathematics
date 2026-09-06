# Faithfulness audit: HDP-02-EQ-2.24

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `5319df3075279c6e9711657afea0c1759250a2fb97d18bbc853dc900c9f9af48`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The direct and round-trip evidence agree that the guarded Lean statement is exact for every K > 0 and correctly scopes the two absolute constants globally. Their uncertainty is resolved asymmetrically: the source implies Lean because Lean imposes no obligation at K = 0, but Lean-to-source cannot be decided without choosing between source interpretations of the undefined quotient. The audit therefore remains undetermined and unaccepted rather than silently introducing a division-by-zero convention.

## Implications

- **Lean implies source:** `unclear`. The implication holds exactly on K > 0. At K = 0 the source quotient is undefined and the text does not say whether the case is excluded or should carry an extended all-λ conclusion, whereas Lean's guarded statement asserts nothing. No source-silent convention may be selected to force a verdict.
- **Source implies lean:** `yes`. On K > 0 the source supplies the exact guarded implication. At K = 0 Lean has a false 0 < K antecedent, so it demands nothing beyond any possible source treatment of the degenerate case.

## Findings

- **major / source-silent-zero-denominator-boundary:** Lean is exact on the defined positive-K regime but makes no assertion for the all-zero family; the source supplies insufficient evidence to determine whether that omission matches its intended boundary behavior.
- **note / positive-regime-exactness:** There is no quantitative, indexing, strictness, or object-role discrepancy in the nondegenerate regime.
- **note / absolute-constant-scope:** The constants are genuinely uniform and cannot depend on the formalized data.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `83` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `83` dependencies (`0` hash-reused); failing or unclear: `D020, D044`.

## Remaining uncertainties

- The immutable source does not specify whether c/0 excludes the all-zero family or denotes an unbounded admissible λ range; this prevents deciding the global Lean-to-source implication.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/agent_outputs/adjudicator.json` (`1d01151523591e4aa56b6ce5c8c54ee3947271ddbd33cae9753c0754927d56d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/agent_outputs/agent_runs.json` (`fe69c82cff7b18084cca8c6874f9b82b100ad54cc3f8d111b0fd422e4f28f687`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/agent_outputs/blind_translation.json` (`f139b0c768f502afe74a42e4c82868318a24c9d60ab7fb375bd2760e6b1365a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/agent_outputs/direct_judge.json` (`8427423dd22b10694efb950b4ec7439d06b01163247855f54edfa3f4676ce161`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/agent_outputs/roundtrip_judge.json` (`aca242a199babbe0dcfbd689e069a854d554ec9e4af39ee5ba3298a9d9ef74c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/agent_outputs/source_contract.json` (`32732704f6273db3503f2f15b16554abc73378a4b2befa3cae6bbfc4004b56d1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/decision.json` (`040ed67b240a0348e4a89035221e129b9343a95a0e59d8dce9186c5a413c0023`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/agent_outputs/agent_runs.json` (`fe1bfa9958fdf5d63cf52c3ac3804af7aded44711a3b2bdab836692b334da037`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/agent_outputs/blind_translation.json` (`a682d5e1d97488ed29744d11755fd696706060148185a9134fe8e32b52423e11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/agent_outputs/source_contract.json` (`32732704f6273db3503f2f15b16554abc73378a4b2befa3cae6bbfc4004b56d1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/inputs/batch_source_locator.json` (`ec5cb95affd594b55cf7a42816ff3bbe96a38c2a912b8e9588cc03c01faac3f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/inputs/blind_dependency_inventory.json` (`2607978b2012ba159f4dd976734dea24e052071e0a8a8fcd9613c2d6a73fdaff`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/inputs/blind_dossier.md` (`c9a5630b8d9aae6d8654aa75f8bc4248be59896b1edd20b89de957d36b1cbf11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/inputs/blind_review_packet.md` (`c9a5630b8d9aae6d8654aa75f8bc4248be59896b1edd20b89de957d36b1cbf11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/inputs/declaration_dossier.md` (`21b2361e4a0a49f3c74cda09200abf6fe8b052e494c83bbd8165d95aa85d7095`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/inputs/dependency_inventory.json` (`a4023c89b5c6471dbe68a1bee2be50aa2b0b79a39bf2a3c8a02c5ada7ef0ff36`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/inputs/direct_review_packet.md` (`08c319effa019f6d9762b37962ef8424e87f0958fcbb8197f429522aae65eaee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T025653Z/inputs/source_locator.json` (`7a03b86d390149fb66ba7f71b44f8c8e7323f6bf93aebe63d60fcf0f7200eb27`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/agent_outputs/agent_runs.json` (`12a3499da93028b594f5d000b315722cf5c812be0edc0fa39ca064c852e73158`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/agent_outputs/blind_translation.json` (`a682d5e1d97488ed29744d11755fd696706060148185a9134fe8e32b52423e11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/agent_outputs/direct_judge.json` (`0e012e92679d64a51086e68de8f5ca7cd9ae2898277f5b8b7027675be034d8c7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/agent_outputs/roundtrip_judge.json` (`ed7576fad96016bba93aced5f93f3dcaf1503ec60966647945fc969e10bccdb4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/agent_outputs/source_contract.json` (`32732704f6273db3503f2f15b16554abc73378a4b2befa3cae6bbfc4004b56d1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/inputs/batch_source_locator.json` (`ec5cb95affd594b55cf7a42816ff3bbe96a38c2a912b8e9588cc03c01faac3f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/inputs/blind_dependency_inventory.json` (`2607978b2012ba159f4dd976734dea24e052071e0a8a8fcd9613c2d6a73fdaff`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/inputs/blind_dossier.md` (`c9a5630b8d9aae6d8654aa75f8bc4248be59896b1edd20b89de957d36b1cbf11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/inputs/blind_review_packet.md` (`c9a5630b8d9aae6d8654aa75f8bc4248be59896b1edd20b89de957d36b1cbf11`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/inputs/declaration_dossier.md` (`21b2361e4a0a49f3c74cda09200abf6fe8b052e494c83bbd8165d95aa85d7095`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/inputs/dependency_inventory.json` (`a4023c89b5c6471dbe68a1bee2be50aa2b0b79a39bf2a3c8a02c5ada7ef0ff36`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/inputs/direct_review_packet.md` (`08c319effa019f6d9762b37962ef8424e87f0958fcbb8197f429522aae65eaee`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260829T031358Z/inputs/source_locator.json` (`7a03b86d390149fb66ba7f71b44f8c8e7323f6bf93aebe63d60fcf0f7200eb27`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/agent_outputs/adjudicator.json` (`1d01151523591e4aa56b6ce5c8c54ee3947271ddbd33cae9753c0754927d56d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/agent_outputs/agent_runs.json` (`3404a928cf2fe1eab8c6174b5fbbce2f46755a7fd45a024f1ca6b4d9cf4d5bf6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/agent_outputs/blind_translation.json` (`f139b0c768f502afe74a42e4c82868318a24c9d60ab7fb375bd2760e6b1365a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/agent_outputs/direct_judge.json` (`8427423dd22b10694efb950b4ec7439d06b01163247855f54edfa3f4676ce161`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/agent_outputs/roundtrip_judge.json` (`aca242a199babbe0dcfbd689e069a854d554ec9e4af39ee5ba3298a9d9ef74c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/agent_outputs/source_contract.json` (`32732704f6273db3503f2f15b16554abc73378a4b2befa3cae6bbfc4004b56d1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/decision.json` (`d161ce5aaa22d8e7f2f135814661a35a59a31271f31f38fb4e49d53ac701883a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/inputs/batch_source_locator.json` (`ec5cb95affd594b55cf7a42816ff3bbe96a38c2a912b8e9588cc03c01faac3f7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/inputs/blind_dependency_inventory.json` (`eb377c671c73ba373c1dabbb24a4acc000684f6025e4ef5a296f8d1151b26f0b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/inputs/blind_dossier.md` (`f916e847783c55b108728617b561d037a41434ad69841d572eb0d18c4f331333`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/inputs/blind_review_packet.md` (`f916e847783c55b108728617b561d037a41434ad69841d572eb0d18c4f331333`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/inputs/declaration_dossier.md` (`842fb971321b7865df27258b53cdc9fd07bf4a83fdbc48468d40fe722c5a0f31`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/inputs/dependency_inventory.json` (`22bb184e597dc106c2c9635879c77e28e2688008a4c42692ee5288d643783326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/inputs/direct_review_packet.md` (`bbcb0bf5301ec32a2bedc300693402b573cec26ca0e0c7ef5f4acc8b6d18e447`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T083705Z/inputs/source_locator.json` (`7a03b86d390149fb66ba7f71b44f8c8e7323f6bf93aebe63d60fcf0f7200eb27`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/agent_outputs/adjudicator.json` (`1d01151523591e4aa56b6ce5c8c54ee3947271ddbd33cae9753c0754927d56d2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/agent_outputs/agent_runs.json` (`fe69c82cff7b18084cca8c6874f9b82b100ad54cc3f8d111b0fd422e4f28f687`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/agent_outputs/batch_source_contract.json` (`03fdb89e94f6d8149de278795126b3cfb32c15b4e71ec9859143b39fd55a2268`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/agent_outputs/blind_translation.json` (`f139b0c768f502afe74a42e4c82868318a24c9d60ab7fb375bd2760e6b1365a1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/agent_outputs/direct_judge.json` (`8427423dd22b10694efb950b4ec7439d06b01163247855f54edfa3f4676ce161`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/agent_outputs/roundtrip_judge.json` (`aca242a199babbe0dcfbd689e069a854d554ec9e4af39ee5ba3298a9d9ef74c8`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/agent_outputs/source_contract.json` (`32732704f6273db3503f2f15b16554abc73378a4b2befa3cae6bbfc4004b56d1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/decision.json` (`3adcebda46440e1bbe7f54882024c449f6415e8fa01b5c0a9c41f73fd508a470`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/inputs/blind_dependency_inventory.json` (`eb377c671c73ba373c1dabbb24a4acc000684f6025e4ef5a296f8d1151b26f0b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/inputs/blind_dossier.md` (`f916e847783c55b108728617b561d037a41434ad69841d572eb0d18c4f331333`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/inputs/blind_review_packet.md` (`f916e847783c55b108728617b561d037a41434ad69841d572eb0d18c4f331333`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/inputs/declaration_dossier.md` (`ae6a10133da0e4f6d55e607037fe13b3d46a9d38a08d40534652aa2d7f113bf9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/inputs/dependency_inventory.json` (`22bb184e597dc106c2c9635879c77e28e2688008a4c42692ee5288d643783326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/inputs/direct_review_packet.md` (`bbcb0bf5301ec32a2bedc300693402b573cec26ca0e0c7ef5f4acc8b6d18e447`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/history/20260831T101308Z/inputs/source_locator.json` (`7a03b86d390149fb66ba7f71b44f8c8e7323f6bf93aebe63d60fcf0f7200eb27`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/inputs/blind_dependency_inventory.json` (`eb377c671c73ba373c1dabbb24a4acc000684f6025e4ef5a296f8d1151b26f0b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/inputs/blind_dossier.md` (`f916e847783c55b108728617b561d037a41434ad69841d572eb0d18c4f331333`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/inputs/blind_review_packet.md` (`f916e847783c55b108728617b561d037a41434ad69841d572eb0d18c4f331333`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/inputs/declaration_dossier.md` (`f9531a3ebd21265e898b1b3e80fa80bff0e4268688615951d53ff2d745d497be`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/inputs/dependency_inventory.json` (`22bb184e597dc106c2c9635879c77e28e2688008a4c42692ee5288d643783326`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/inputs/direct_review_packet.md` (`bbcb0bf5301ec32a2bedc300693402b573cec26ca0e0c7ef5f4acc8b6d18e447`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.24/faithfulness/inputs/source_locator.json` (`7a03b86d390149fb66ba7f71b44f8c8e7323f6bf93aebe63d60fcf0f7200eb27`)
