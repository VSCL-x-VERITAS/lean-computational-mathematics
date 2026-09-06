# Faithfulness audit: HDP-02-THM-2.8.2

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `75f95d4891e3ba80a9ff155b4501f1e08172d525dd278570ec40a7c39c3fe3c5`
- Source SHA-256: `ecc53be86c091b5df118c4464b6d81672e0261df960a3f32ceea4900107d090a`

The pinned PDF hash matches the specified SHA-256. Theorem 2.8.2 and its introducing sentence establish the weighted two-sided Bernstein bound for arbitrary real coefficients and every t ≥ 0, with no positivity requirement on K or the coefficient vector. The Lean translation is exact on the nondegenerate core K > 0 and a ≠ 0. Its explicit real-division structure additionally assigns zero to quotients with zero denominators, yielding right-hand side 2 there. Because the source does not state this or any alternative convention, adjudication cannot convert the boundary silence into equivalence without silently repairing the source. Both full implications therefore remain unclear, the classification remains undetermined, and the audit is not accepted.

## Implications

- **Lean implies source:** `unclear`. Yes on the exact nondegenerate core K > 0 and a ≠ 0, including t = 0 there. On K = 0 or a = 0, Lean assigns zero to division by zero, whereas the source supplies no boundary convention, so a whole-domain implication cannot be asserted without silently repairing the source.
- **Source implies lean:** `unclear`. Yes on the exact nondegenerate core. On the explicitly reachable zero-denominator domain, the source expression has no stipulated value and therefore cannot entail Lean's totalized right-hand side without an added convention.

## Findings

- **major / source-silent-boundary-semantics:** The target chooses a definite boundary semantics absent from the source, preventing certification of either full implication.
- **note / nondegenerate-core:** The formalization is equivalent to the source throughout the substantive nondegenerate domain.
- **note / threshold-boundary:** The threshold t = 0 alone is not a discrepancy; the unresolved issue is precisely zero denominators.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `unclear` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `pass` |
| `C11` | `unclear` | `unclear` |
| `C12` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `93` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `93` dependencies (`0` hash-reused); failing or unclear: `D050`.

## Remaining uncertainties

- The pinned source does not define the two quotient branches when K = 0 or a = 0. No whole-domain implication or accepted classification can be obtained without adopting an extra division or limiting convention.

## Artifact provenance

- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/agent_outputs/adjudicator.json` (`010c922d649bbbb01099778b852a8b91c282850123948a9795c99f636c198c65`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/agent_outputs/agent_runs.json` (`3dccb459bf7ec22f08be1790a1c5e8654b9e5de5ce70ac57d20789bc20e5f8f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/agent_outputs/blind_translation.json` (`0412d541eaf081f30bd7ab50801269acaa6af0472bd22d97e2a5ee45f8ba0760`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/agent_outputs/direct_judge.json` (`6077010b84949fb6bcdcc904bf2d5d879c1c796f029b34c94a8b10922ca3cf5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/agent_outputs/roundtrip_judge.json` (`8b4220e7fcd90f93e8f99b2ab6f0ba39e00fd268a68c6c8cd4d88f6696a88d09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/decision.json` (`d0a7d037c51237c74618b85e2df4dc6ef71a8846f61d55eebd4a7478188c108d`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T024634Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T024634Z/inputs/blind_dependency_inventory.json` (`ab63f33840d0b35e0cbf8e51c60e8aae33f18e057af289a123aeaaa4f1d33f7b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T024634Z/inputs/blind_dossier.md` (`750fe439a45164498d9e9f109cc8b3f01799559e7ef3869b09a29e9c56dc2a5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T024634Z/inputs/blind_review_packet.md` (`750fe439a45164498d9e9f109cc8b3f01799559e7ef3869b09a29e9c56dc2a5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T024634Z/inputs/declaration_dossier.md` (`f1915f25341191cfb0ed7f2d05f33da7703e0c153ff95101f5768e940a6ca526`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T024634Z/inputs/dependency_inventory.json` (`b583e6d5bf4932bb1008521943479076f41ef67a20084985256337b68cedcf2a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T024634Z/inputs/direct_review_packet.md` (`0490da6e672589c07048ffc911d3a7f0c76b5b9dac66b78c75bab650a12407ba`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T024634Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T030220Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T030220Z/inputs/blind_dependency_inventory.json` (`ab63f33840d0b35e0cbf8e51c60e8aae33f18e057af289a123aeaaa4f1d33f7b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T030220Z/inputs/blind_dossier.md` (`750fe439a45164498d9e9f109cc8b3f01799559e7ef3869b09a29e9c56dc2a5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T030220Z/inputs/blind_review_packet.md` (`750fe439a45164498d9e9f109cc8b3f01799559e7ef3869b09a29e9c56dc2a5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T030220Z/inputs/declaration_dossier.md` (`f1915f25341191cfb0ed7f2d05f33da7703e0c153ff95101f5768e940a6ca526`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T030220Z/inputs/dependency_inventory.json` (`b583e6d5bf4932bb1008521943479076f41ef67a20084985256337b68cedcf2a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T030220Z/inputs/direct_review_packet.md` (`0490da6e672589c07048ffc911d3a7f0c76b5b9dac66b78c75bab650a12407ba`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T030220Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/agent_outputs/agent_runs.json` (`e528683a9b140bdc88c3cc46553c4cf618365ba030ab49029f57a5a0e3c6d542`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/agent_outputs/blind_translation.json` (`774da4537ed53c69bbd3dfebb5feb1259203fc325e9282e5b69ef4dfd03bad6a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/agent_outputs/direct_judge.json` (`94863542ece0f111b105fee20e283cdd81a25ec918b27d6748f622028a9cdefd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/agent_outputs/roundtrip_judge.json` (`1c8e9ecdf82e74d99e2096ddebaa8194dde3099d39c9d06a1ab9cf0bfcbaa1d0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/inputs/blind_dependency_inventory.json` (`b6ffe38ec88fd9bfa0526d7c65a79f369321f463d7c0272def583bed5a98fd96`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/inputs/blind_dossier.md` (`a6c617c3a16b13a2cfc129d2227146222ba0104d0bb540738e52874544e86631`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/inputs/blind_review_packet.md` (`a6c617c3a16b13a2cfc129d2227146222ba0104d0bb540738e52874544e86631`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/inputs/declaration_dossier.md` (`228f35cca60c60db7bed7597cd0d79c0d6ae8cfd4bc058e97675d4e3dbcbb9c1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/inputs/dependency_inventory.json` (`1cd5e067c00db599d48cc4e89ae9021007f24bb2e130684c64377ef2a3dff7b6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/inputs/direct_review_packet.md` (`b9d4525a6f3eb35c12585e9c2f3d0e19323dd94abac7abcc51ddff15a5a66a60`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T221507Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/agent_outputs/agent_runs.json` (`18bb64c77c56245f231e275a3cd00c632e25f8d2a341e6528ce1f949a0454b99`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/inputs/blind_dossier.md` (`d61cad694949f5bd4f7f8c7479743b401af857442bdb656e3805a2f3840bc339`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/inputs/blind_review_packet.md` (`d61cad694949f5bd4f7f8c7479743b401af857442bdb656e3805a2f3840bc339`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/inputs/declaration_dossier.md` (`87240a3ea1c58d33dcd533e65f6f16104a5bb18f8057a86e94148ccbae2d4dfd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/inputs/direct_review_packet.md` (`9dfa2fbd4e4fbe4eb08c249ab736361f7f5cb067ee9200ae0de3e9c0d0d6f353`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260828T230029Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/inputs/blind_dossier.md` (`d61cad694949f5bd4f7f8c7479743b401af857442bdb656e3805a2f3840bc339`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/inputs/blind_review_packet.md` (`d61cad694949f5bd4f7f8c7479743b401af857442bdb656e3805a2f3840bc339`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/inputs/declaration_dossier.md` (`87240a3ea1c58d33dcd533e65f6f16104a5bb18f8057a86e94148ccbae2d4dfd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/inputs/direct_review_packet.md` (`9dfa2fbd4e4fbe4eb08c249ab736361f7f5cb067ee9200ae0de3e9c0d0d6f353`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T002848Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/agent_outputs/agent_runs.json` (`18bb64c77c56245f231e275a3cd00c632e25f8d2a341e6528ce1f949a0454b99`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/inputs/blind_dossier.md` (`d61cad694949f5bd4f7f8c7479743b401af857442bdb656e3805a2f3840bc339`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/inputs/blind_review_packet.md` (`d61cad694949f5bd4f7f8c7479743b401af857442bdb656e3805a2f3840bc339`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/inputs/declaration_dossier.md` (`87240a3ea1c58d33dcd533e65f6f16104a5bb18f8057a86e94148ccbae2d4dfd`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/inputs/direct_review_packet.md` (`9dfa2fbd4e4fbe4eb08c249ab736361f7f5cb067ee9200ae0de3e9c0d0d6f353`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T014629Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/agent_outputs/adjudicator.json` (`010c922d649bbbb01099778b852a8b91c282850123948a9795c99f636c198c65`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/agent_outputs/agent_runs.json` (`2c8ac92a75166b885bfaad749c25717555ffc6b91a43ea3d96aaac626e5b71e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/agent_outputs/blind_translation.json` (`0412d541eaf081f30bd7ab50801269acaa6af0472bd22d97e2a5ee45f8ba0760`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/agent_outputs/direct_judge.json` (`6077010b84949fb6bcdcc904bf2d5d879c1c796f029b34c94a8b10922ca3cf5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/agent_outputs/roundtrip_judge.json` (`8b4220e7fcd90f93e8f99b2ab6f0ba39e00fd268a68c6c8cd4d88f6696a88d09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/decision.json` (`49b17501b3a8bc229347a3e3b4c5cfc789debd4b2cb310518400a41745d959a5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/inputs/blind_dossier.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/inputs/blind_review_packet.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/inputs/declaration_dossier.md` (`53202a5e23e01b4e9f931745be0f2aa77fe75e15e573f12d748356ed66551e8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/inputs/direct_review_packet.md` (`ab71cb6914678c5723f228147aa66efa4ca564a49906baeaccde91c5d5a715c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T021246Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/agent_outputs/adjudicator.json` (`010c922d649bbbb01099778b852a8b91c282850123948a9795c99f636c198c65`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/agent_outputs/agent_runs.json` (`2c8ac92a75166b885bfaad749c25717555ffc6b91a43ea3d96aaac626e5b71e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/agent_outputs/blind_translation.json` (`0412d541eaf081f30bd7ab50801269acaa6af0472bd22d97e2a5ee45f8ba0760`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/agent_outputs/direct_judge.json` (`6077010b84949fb6bcdcc904bf2d5d879c1c796f029b34c94a8b10922ca3cf5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/agent_outputs/roundtrip_judge.json` (`8b4220e7fcd90f93e8f99b2ab6f0ba39e00fd268a68c6c8cd4d88f6696a88d09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/decision.json` (`5f9eaa1d20ec9530d1bd18b7dfdf2cfd61b08146765622bd9e43c85f22a10c0e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/inputs/blind_dossier.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/inputs/blind_review_packet.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/inputs/declaration_dossier.md` (`53202a5e23e01b4e9f931745be0f2aa77fe75e15e573f12d748356ed66551e8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/inputs/direct_review_packet.md` (`ab71cb6914678c5723f228147aa66efa4ca564a49906baeaccde91c5d5a715c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T023453Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/agent_outputs/adjudicator.json` (`010c922d649bbbb01099778b852a8b91c282850123948a9795c99f636c198c65`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/agent_outputs/agent_runs.json` (`2c8ac92a75166b885bfaad749c25717555ffc6b91a43ea3d96aaac626e5b71e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/agent_outputs/blind_translation.json` (`0412d541eaf081f30bd7ab50801269acaa6af0472bd22d97e2a5ee45f8ba0760`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/agent_outputs/direct_judge.json` (`6077010b84949fb6bcdcc904bf2d5d879c1c796f029b34c94a8b10922ca3cf5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/agent_outputs/roundtrip_judge.json` (`8b4220e7fcd90f93e8f99b2ab6f0ba39e00fd268a68c6c8cd4d88f6696a88d09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/decision.json` (`d3b8b7ba945f8bfe0908329e217eecb243d08ab223aefb57d1ec17a27f03414b`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/inputs/blind_dossier.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/inputs/blind_review_packet.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/inputs/declaration_dossier.md` (`53202a5e23e01b4e9f931745be0f2aa77fe75e15e573f12d748356ed66551e8e`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/inputs/direct_review_packet.md` (`ab71cb6914678c5723f228147aa66efa4ca564a49906baeaccde91c5d5a715c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260829T031715Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/agent_outputs/adjudicator.json` (`010c922d649bbbb01099778b852a8b91c282850123948a9795c99f636c198c65`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/agent_outputs/agent_runs.json` (`2c8ac92a75166b885bfaad749c25717555ffc6b91a43ea3d96aaac626e5b71e4`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/agent_outputs/blind_translation.json` (`0412d541eaf081f30bd7ab50801269acaa6af0472bd22d97e2a5ee45f8ba0760`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/agent_outputs/direct_judge.json` (`6077010b84949fb6bcdcc904bf2d5d879c1c796f029b34c94a8b10922ca3cf5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/agent_outputs/roundtrip_judge.json` (`8b4220e7fcd90f93e8f99b2ab6f0ba39e00fd268a68c6c8cd4d88f6696a88d09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/decision.json` (`bd1bbcbf7b5008afa8db9ce4f05f6ffd71dca544cfc88039c0fd10e29887da07`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/inputs/batch_source_locator.json` (`202d9a7b519b0cd79dd8f3b7ab6f9cbd5a29155f5584636eca26ebdf0a58c856`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/inputs/blind_dossier.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/inputs/blind_review_packet.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/inputs/declaration_dossier.md` (`d61fb9c6d1274f92553ca33b364f9ff9e5018f5076515135b1676c6e2245e640`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/inputs/direct_review_packet.md` (`ab71cb6914678c5723f228147aa66efa4ca564a49906baeaccde91c5d5a715c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T085537Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/agent_outputs/adjudicator.json` (`010c922d649bbbb01099778b852a8b91c282850123948a9795c99f636c198c65`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/agent_outputs/agent_runs.json` (`3dccb459bf7ec22f08be1790a1c5e8654b9e5de5ce70ac57d20789bc20e5f8f1`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/agent_outputs/batch_source_contract.json` (`31b331b7c5b1cdb0b3f95a487470c011c93663c2dc063252710933fefb9a303a`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/agent_outputs/blind_translation.json` (`0412d541eaf081f30bd7ab50801269acaa6af0472bd22d97e2a5ee45f8ba0760`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/agent_outputs/direct_judge.json` (`6077010b84949fb6bcdcc904bf2d5d879c1c796f029b34c94a8b10922ca3cf5f`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/agent_outputs/roundtrip_judge.json` (`8b4220e7fcd90f93e8f99b2ab6f0ba39e00fd268a68c6c8cd4d88f6696a88d09`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/agent_outputs/source_contract.json` (`b7844cd4d3655d09e554f57b593cad8a443d84c06e13be13441bc7c01d33c1e0`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/decision.json` (`bbfdc45cc24c89c85b297548664d615aad042b1cbb92d5553feb21eaabf11a0c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/inputs/blind_dossier.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/inputs/blind_review_packet.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/inputs/declaration_dossier.md` (`fbedc840a15c6499241dc460d94273f9c99eef0c63efbe57647f6f3d299daace`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/inputs/direct_review_packet.md` (`ab71cb6914678c5723f228147aa66efa4ca564a49906baeaccde91c5d5a715c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/20260831T101947Z/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/history/rejected-role-outputs/direct_judge.invalid-accepted-flag.2026-08-28.json` (`8c304a140af5671c4cd4a5b80c283850d1e8e7d62af18b4d4a1fef82a34ee7ec`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/inputs/blind_dependency_inventory.json` (`141260d71d7115be877186e835ebfbba1166ae5a2d9e199731866f6dacbe6bbf`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/inputs/blind_dossier.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/inputs/blind_review_packet.md` (`a093e3c40edfd3f3f1b6aa4b8bad54f9d55280b20337bd2ea3c7bb076ea8d959`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/inputs/declaration_dossier.md` (`4733a6ead3df440cdbb54de80e32ae20065269b84712bb3581a216b9952e44d6`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/inputs/dependency_inventory.json` (`cfa711f675f5fb9559b8e2bd280e5300d49197a1abb53e63c5c2b9d7c127bb5c`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/inputs/direct_review_packet.md` (`ab71cb6914678c5723f228147aa66efa4ca564a49906baeaccde91c5d5a715c5`)
- `lean-numerical-stability/audits/vershynin-hdp/chapter02/HDP-02-THM-2.8.2/faithfulness/inputs/source_locator.json` (`d03b8eefe1f34fd5f1da016608b2a24914c2a00adb08b4ca438974768bacb6e9`)
