# Faithfulness audit: HDP-02-EQ-2.18

## Decision

- Classification: `faithful-stronger`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `9f3f960c74968226c46f172897d1c9013baaafcbae05e0503143d4627336f190`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The target preserves the source's exact distributional conclusion, zero center, summed variances, and mutual-independence premise. Its variance symbol is reparameterized: Lean sigma_i is already the nonnegative variance represented in the source by sigma_i^2. The extra real weights and arbitrary finite index type are legitimate extensions, because setting all weights to one on the source finite range exactly and nonvacuously recovers Equation (2.18). Conversely, the displayed unweighted source assertion alone does not state the weighted law or all added boundary and indexing cases. Under the fixed implication policy the result is therefore accepted as faithful-stronger.

## Implications

- **Lean implies source:** `yes`. Represent the displayed range 1 through N by a finite index type, choose every weight a_i=1, and set each Lean NNReal sigma_i to the source variance sigma_i^2. Then the target input laws and mutual-independence premise are the source premises, the weighted sum reduces to sum X_i, and sum toNNReal(1^2)*sigma_i reduces to sum sigma_i^2. This is a nonvacuous specialization for ordinary N and positive variances.
- **Source implies lean:** `no`. Equation (2.18) itself asserts only the unweighted initial-segment case. It does not quantify over arbitrary real coefficients or assert the scalar-multiplication law needed to replace X_i by a_i X_i, and it does not state the arbitrary-Fintype, empty-family, or explicit degenerate-variance cases. Those additions cannot be obtained from the displayed source claim alone without extra Gaussian facts and reindexing results.

## Findings

- **note / weighted-generalization:** This makes the Lean theorem strictly stronger, while the a_i=1 instance faithfully recovers the source.
- **note / variance-reparameterization:** The matching substitution is Lean sigma_i = source sigma_i^2; treating the two sigma symbols as the same unsquared quantity would be erroneous.
- **note / boundary-generalization:** The target adds coherent empty and degenerate cases; they do not make the source specialization vacuous.
- **major / arbitrary-weight-strengthening:** This is genuine nonvacuous additional content. It preserves the source as the all-weights-one instance but is not implied by the selected source contract alone.
- **minor / finite-domain-and-endpoint-extension:** Ordinary nonempty finite source cases are recovered by reindexing. Empty and degenerate cases are coherent additional endpoints, not restrictions, but they extend what is explicit in the source.
- **note / variance-reparameterization:** There is no variance-versus-standard-deviation mismatch: assigning the translation parameter the value denoted sigma_i squared in the source recovers the source variance exactly.
- **note / independence-semantics:** The independence premise matches and is neither weakened to pairwise independence nor omitted.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `fail` |
| `C03` | `pass` | `fail` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `fail` |
| `C10` | `pass` | `fail` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `32` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `32` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/agent_outputs/agent_runs.json` (`896757fd3b3cc83b1387cba3b4b7b877a9f2fb1ca8c7e601bb6b5672f0d3bc5d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/agent_outputs/blind_translation.json` (`e4333bdf975c2a93dde4a331a3c372b29d415cd30f79e8f55367e7e1a085f737`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/agent_outputs/direct_judge.json` (`3fb697d100e30f748cfbc36dd7cb5b078ddc60e1e9442849a44d491dca9cb6b4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/agent_outputs/roundtrip_judge.json` (`b7f8fbcef2d2dac25196eb718e801c76d73bc6306ff29e336d1da447773c7c8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/agent_outputs/source_contract.json` (`4ad6a7826d89cf808b2ffbf559cb02589259cf7dcca4062626332cd395d8020f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/decision.json` (`4e9b91960c6e70efeab946201298821a66b1b27ae79831961ec2f661e53a19fa`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/agent_outputs/agent_runs.json` (`d7adf53b435e10c18203b6ed32953d3c633e45fde944d21e4468f8b5ad75615a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/agent_outputs/blind_translation.json` (`e4333bdf975c2a93dde4a331a3c372b29d415cd30f79e8f55367e7e1a085f737`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/agent_outputs/direct_judge.json` (`3fb697d100e30f748cfbc36dd7cb5b078ddc60e1e9442849a44d491dca9cb6b4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/agent_outputs/roundtrip_judge.json` (`b7f8fbcef2d2dac25196eb718e801c76d73bc6306ff29e336d1da447773c7c8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/agent_outputs/source_contract.json` (`4ad6a7826d89cf808b2ffbf559cb02589259cf7dcca4062626332cd395d8020f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/decision.json` (`08cbc339857686a40d0bab3464c56641118e14741d7ce8a2ebfe80b215acc085`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/inputs/blind_dependency_inventory.json` (`3ca826a91832c1634ba19e0f05311495c1e836362a6ac7ee9a79b53188a79b1b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/inputs/blind_dossier.md` (`94cca1c912cfb0f4d82c5ddcafca0a3c4e253474fe71b4cf299967e279f6ffac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/inputs/blind_review_packet.md` (`94cca1c912cfb0f4d82c5ddcafca0a3c4e253474fe71b4cf299967e279f6ffac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/inputs/declaration_dossier.md` (`ca96c1daf625089a11846fd16560fbf655324c708dae2cf49a933e8974b40d12`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/inputs/dependency_inventory.json` (`3ca826a91832c1634ba19e0f05311495c1e836362a6ac7ee9a79b53188a79b1b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/inputs/direct_review_packet.md` (`5a46d0cebd22289b430cf46dc5c34f30ebcd41362ce8bbc29e6b6d75130be208`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082435Z/inputs/source_locator.json` (`b3b63231daa136d63acf599f7c7f217ba839d33264381980f1e048e3a41e8682`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082513Z/inputs/blind_dependency_inventory.json` (`3ca826a91832c1634ba19e0f05311495c1e836362a6ac7ee9a79b53188a79b1b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082513Z/inputs/blind_dossier.md` (`94cca1c912cfb0f4d82c5ddcafca0a3c4e253474fe71b4cf299967e279f6ffac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082513Z/inputs/blind_review_packet.md` (`94cca1c912cfb0f4d82c5ddcafca0a3c4e253474fe71b4cf299967e279f6ffac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082513Z/inputs/declaration_dossier.md` (`b80162bf171464e0107464d95872dea959f0a59d866ae9b09b0f56e67eca2b67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082513Z/inputs/dependency_inventory.json` (`3ca826a91832c1634ba19e0f05311495c1e836362a6ac7ee9a79b53188a79b1b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082513Z/inputs/direct_review_packet.md` (`5a46d0cebd22289b430cf46dc5c34f30ebcd41362ce8bbc29e6b6d75130be208`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T082513Z/inputs/source_locator.json` (`b3b63231daa136d63acf599f7c7f217ba839d33264381980f1e048e3a41e8682`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/agent_outputs/agent_runs.json` (`896757fd3b3cc83b1387cba3b4b7b877a9f2fb1ca8c7e601bb6b5672f0d3bc5d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/agent_outputs/blind_translation.json` (`e4333bdf975c2a93dde4a331a3c372b29d415cd30f79e8f55367e7e1a085f737`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/agent_outputs/direct_judge.json` (`3fb697d100e30f748cfbc36dd7cb5b078ddc60e1e9442849a44d491dca9cb6b4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/agent_outputs/roundtrip_judge.json` (`b7f8fbcef2d2dac25196eb718e801c76d73bc6306ff29e336d1da447773c7c8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/agent_outputs/source_contract.json` (`4ad6a7826d89cf808b2ffbf559cb02589259cf7dcca4062626332cd395d8020f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/decision.json` (`5a1c679d15b7554f884bfb26e6ed8f8c0b7fddc3c14f634c573d0eef5ba7c5af`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/inputs/blind_dependency_inventory.json` (`3ca826a91832c1634ba19e0f05311495c1e836362a6ac7ee9a79b53188a79b1b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/inputs/blind_dossier.md` (`94cca1c912cfb0f4d82c5ddcafca0a3c4e253474fe71b4cf299967e279f6ffac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/inputs/blind_review_packet.md` (`94cca1c912cfb0f4d82c5ddcafca0a3c4e253474fe71b4cf299967e279f6ffac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/inputs/declaration_dossier.md` (`b80162bf171464e0107464d95872dea959f0a59d866ae9b09b0f56e67eca2b67`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/inputs/dependency_inventory.json` (`3ca826a91832c1634ba19e0f05311495c1e836362a6ac7ee9a79b53188a79b1b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/inputs/direct_review_packet.md` (`5a46d0cebd22289b430cf46dc5c34f30ebcd41362ce8bbc29e6b6d75130be208`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/history/20260831T100412Z/inputs/source_locator.json` (`b3b63231daa136d63acf599f7c7f217ba839d33264381980f1e048e3a41e8682`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/inputs/blind_dependency_inventory.json` (`3ca826a91832c1634ba19e0f05311495c1e836362a6ac7ee9a79b53188a79b1b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/inputs/blind_dossier.md` (`94cca1c912cfb0f4d82c5ddcafca0a3c4e253474fe71b4cf299967e279f6ffac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/inputs/blind_review_packet.md` (`94cca1c912cfb0f4d82c5ddcafca0a3c4e253474fe71b4cf299967e279f6ffac`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/inputs/declaration_dossier.md` (`cef42948c9668a69662d2dea97b1039ea62f80129ca00688413a7a5a4edc2d1d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/inputs/dependency_inventory.json` (`3ca826a91832c1634ba19e0f05311495c1e836362a6ac7ee9a79b53188a79b1b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/inputs/direct_review_packet.md` (`5a46d0cebd22289b430cf46dc5c34f30ebcd41362ce8bbc29e6b6d75130be208`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-EQ-2.18/faithfulness/inputs/source_locator.json` (`b3b63231daa136d63acf599f7c7f217ba839d33264381980f1e048e3a41e8682`)
