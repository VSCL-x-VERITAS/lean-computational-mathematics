# Faithfulness audit: HDP-02-PROP-2.6.1

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `2620b401c7f6619b349ba32385454afe4ba21c35b08f21ec2098b46126c187a3`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The repaired target is directly faithful to Proposition 2.6.1. Its existential constant precedes every family and probability-space binder, hence is absolute; its assumptions are componentwise sub-gaussianity and centering plus mutual family independence; and its conjunctive conclusion contains both source claims. The quantitative clause is exactly the square of the intrinsic psi_2 gauge of the unweighted total sum bounded by C times the unweighted finite sum of squared intrinsic component gauges. IsSubGaussian supplies finite admissible scales for every component and, through the first conclusion, for the total sum, so ENNReal.toReal is lossless here. Arbitrary finite index types are reindexings of the source family, and the empty family is a coherent trivial endpoint. Both implications hold, so the fixed classification is faithful-equivalent, accepted, with no adjudication needed.

## Implications

- **Lean implies source:** `yes`. Specialize the arbitrary Fintype theorem to a consecutive positive finite index type. The one outer C is absolute, the hypotheses give componentwise centered sub-gaussian variables with mutual independence, and the conjunction gives both source conclusions with the exact unweighted squared-norm inequality. Finite-gauge toReal values equal the intrinsic source norms.
- **Source implies lean:** `yes`. For every nonempty Fintype, enumerate its elements and apply the source proposition; commutativity makes the unweighted sum independent of the enumeration. Enlarge the source constant to max(C,1) to obtain 1 <= C without weakening the bound. For the empty Fintype, the sum is zero, which is sub-gaussian with psi_2 gauge zero, so the inequality is the trivial endpoint 0 <= C*0. Thus the source entails the explicit arbitrary-probability-space formulation.

## Findings

- **note / endpoint-generalization:** This is a coherent theorem endpoint: the empty sum is zero, is sub-gaussian, has psi_2 gauge zero, and satisfies the estimate. It does not alter either implication.
- **note / finite-gauge-representation:** toReal is faithful on every gauge in the conclusion and does not collapse an infinite value.
- **note / constant-normalization:** Any valid absolute constant can be enlarged to at least one, so this normalization is logically equivalent and does not reduce applicability.
- **note / boundary-presentation:** No implication changes: the empty sum is zero, its sub-gaussian closure is immediate, and the displayed inequality reduces to 0 <= C * 0.

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

- Blind translator covered `81` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `81` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/agent_outputs/agent_runs.json` (`aafa0a22cd1440b8f4849a25e6b00e7bd1c6943518c32f3f51eef543e3076aa9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/agent_outputs/blind_translation.json` (`c2aaf834bd831a8eb662897430f9a46933d808080c7c5120a806590fb44cca94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/agent_outputs/direct_judge.json` (`7054ff24fa882e0f88238a80c1a644f33ee992253f0ba5b986820d4c007fd19f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/agent_outputs/roundtrip_judge.json` (`8f4a89e0852d18f342e484750dbdefc87c0fd779b86d900d876a9921e276d88e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/agent_outputs/source_contract.json` (`984975a69dbce7a410977cff0d49962733bbbf67d403c6edc831996c07179f3e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/decision.json` (`f7644af0f53738dd3742c3d53a128ec1119f857dc460f4784c74df8c37827757`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/agent_outputs/adjudicator.json` (`61dcb32782c7db501087e85bb5fedf93a7f78bd05466f72a597a0cef841e2815`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/agent_outputs/agent_runs.json` (`a37f64c6d88f20a8c97cb52254aaa66687328d8d804c48d13f07f5e0d95ec81c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/agent_outputs/blind_translation.json` (`a90b3ede9e14046b1eb2006228f1d0e43524365804725927e9f12467e2a29121`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/agent_outputs/direct_judge.json` (`e62492c380408c885e59550123d191e9c6e58cdf7d3f63f3b5c9eb96baf0c6ca`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/agent_outputs/roundtrip_judge.json` (`cf93113d3876ccd2daf9cbfbe58667019acbb97401908a8e27f88a2dad1e0e7b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/agent_outputs/source_contract.json` (`984975a69dbce7a410977cff0d49962733bbbf67d403c6edc831996c07179f3e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/decision.json` (`4b96ca505799d0279a3197a3aaafa980f2fd7f6e83f76c5c718bfb9e9ea77c9c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/inputs/blind_dependency_inventory.json` (`4500cddf559e7d7c8a7ccf1ffb7ba334f7c86ec697e3a7f396d9fd29fa631dc7`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/inputs/blind_dossier.md` (`e78597b688c2aad759d85ce4a5a8414572c0afc53d628ec75c2e2db31e880f0d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/inputs/blind_review_packet.md` (`e78597b688c2aad759d85ce4a5a8414572c0afc53d628ec75c2e2db31e880f0d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/inputs/declaration_dossier.md` (`c07149fc0aa8af69c98a135946fbef324b25c259d6baf798d29372ff7e988563`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/inputs/dependency_inventory.json` (`9f7c82cbfe9463b15d829fa31c9e8ea980740dee289e16b07efd3b0c9372ca34`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/inputs/direct_review_packet.md` (`c137bf10874d078108833fe099f4b927a3e7030f07ed7fbed896cdd794efae68`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T080517Z/inputs/source_locator.json` (`9b575fa5b395cd20480d47fcea5fbe35345eb537699ae1aa92a522bbd2c678e6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/agent_outputs/agent_runs.json` (`aafa0a22cd1440b8f4849a25e6b00e7bd1c6943518c32f3f51eef543e3076aa9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/agent_outputs/blind_translation.json` (`c2aaf834bd831a8eb662897430f9a46933d808080c7c5120a806590fb44cca94`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/agent_outputs/direct_judge.json` (`7054ff24fa882e0f88238a80c1a644f33ee992253f0ba5b986820d4c007fd19f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/agent_outputs/roundtrip_judge.json` (`8f4a89e0852d18f342e484750dbdefc87c0fd779b86d900d876a9921e276d88e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/agent_outputs/source_contract.json` (`984975a69dbce7a410977cff0d49962733bbbf67d403c6edc831996c07179f3e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/decision.json` (`516ba7c38a6bc911ef32a7a9dbc7be1d5423bd6ddcb1ac7acf0938fffc5692ed`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/inputs/blind_dependency_inventory.json` (`bbaa20c0fd815ca0a559f4cabad0e29d469f2e34fd7fc81db7ffdfd42a7cffc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/inputs/blind_dossier.md` (`3e1b0787e78c8f4e88e20971943b08cdc47d3ee596bcb08c02afa739ccc8f26a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/inputs/blind_review_packet.md` (`3e1b0787e78c8f4e88e20971943b08cdc47d3ee596bcb08c02afa739ccc8f26a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/inputs/declaration_dossier.md` (`7ac22ac3dc91f57b91e11c0119b681fa1c7477633a184d39e976475005684115`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/inputs/dependency_inventory.json` (`b880a0cc62fcda1f9e8727ab8d5824a1db5060fe7c542b047cb7c6c5f726a150`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/inputs/direct_review_packet.md` (`4a52f2ef8debcaf9eb4b6aa8ebdf9355bf905e5d31f0175b72a52154ac8abfdf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/history/20260831T101804Z/inputs/source_locator.json` (`9b575fa5b395cd20480d47fcea5fbe35345eb537699ae1aa92a522bbd2c678e6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/inputs/blind_dependency_inventory.json` (`bbaa20c0fd815ca0a559f4cabad0e29d469f2e34fd7fc81db7ffdfd42a7cffc2`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/inputs/blind_dossier.md` (`3e1b0787e78c8f4e88e20971943b08cdc47d3ee596bcb08c02afa739ccc8f26a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/inputs/blind_review_packet.md` (`3e1b0787e78c8f4e88e20971943b08cdc47d3ee596bcb08c02afa739ccc8f26a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/inputs/declaration_dossier.md` (`82c852eab404a00391c92057e8e3351bd693de4572591bf590638140ca03071f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/inputs/dependency_inventory.json` (`b880a0cc62fcda1f9e8727ab8d5824a1db5060fe7c542b047cb7c6c5f726a150`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/inputs/direct_review_packet.md` (`4a52f2ef8debcaf9eb4b6aa8ebdf9355bf905e5d31f0175b72a52154ac8abfdf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-PROP-2.6.1/faithfulness/inputs/source_locator.json` (`9b575fa5b395cd20480d47fcea5fbe35345eb537699ae1aa92a522bbd2c678e6`)
