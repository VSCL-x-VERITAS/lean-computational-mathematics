# Faithfulness audit: LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `abe9b14705618401012fe913719eaee6e8c2d09b9db3cbd2ded4ad1b1101e1ac`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source pages confirms the scalar constant-speed contaminant setting, the first-endpoint-minus-second-endpoint flux order, and the distinction between boundary transport and additional production or loss. Inspection of the supplied target types, dependency definitions, blind translation, judgments, and native supplement resolves the sole substantive disagreement: the actual measure is normalized Lebesgue volume. The exact slice conditions, supplied representatives, signed iterated integrals, conditional biconditionals, and interval-dependent almost-everywhere derivative match refined Q6. Explicit homogeneous and nonhomogeneous examples establish nonvacuity. Both implications therefore hold for that interpretation-qualified comparison, giving faithful-equivalent acceptance. The unspecified printed-source analytic details remain unspecified; no majority vote, target proof, tools, or independent hash verification was used.

## Implications

- **Lean implies source:** `yes`. Under coordinator-selected interpretation SHA256 88a3ff8f4ea77901abc77a35afd4d9a93d55e2a3fef4fef05e43cf49c92bdec2 and refinement SHA256 8658feb83ed55f4c7a4a5c64a95c45313814c44b62573372ea716b5c791e97f3, the target represents the selected claim. Evaluation at the sole Fin 1 coordinate identifies its states with real scalars, and the native supplement identifies its exact measure with normalized Lebesgue volume. D001 supplies precisely the fixed representatives, every-time spatial slices, temporal boundary fluxes, signed spatial aggregates, and assumed sourced rectangle balance selected by the refinement. The conclusions preserve endpoint-flux order, distinguish mass defect from transport, characterize homogeneous conservation and its failure by integrated production, and give the selected almost-everywhere mass-rate identity for each fixed interval. This implication does not cover arbitrary nonconserving fields, singular production measures, bare joint-L1 classes, or unconditional classical PDE assertions.
- **Source implies lean:** `yes`. Under coordinator-selected interpretation SHA256 88a3ff8f4ea77901abc77a35afd4d9a93d55e2a3fef4fef05e43cf49c92bdec2 and refinement SHA256 8658feb83ed55f4c7a4a5c64a95c45313814c44b62573372ea716b5c791e97f3, every target conjunct follows within the selected supplied sourced model. Retain its premise; rearrange M(t)-M(s)=B(s,t)+R(s,t); use the already satisfied mass and flux integrability conditions to equate homogeneous conservation with universal vanishing of R; negate that universal statement to obtain the nonzero rectangle witness. For each fixed a,b, the temporally integrable boundary difference and signed production aggregate express M as a constant plus an indefinite Lebesgue integral, yielding the ordinary derivative almost everywhere. No exchange of integration order or joint absolute integrability is needed. The printed paragraph alone does not determine these additional analytic specifications.

## Findings

- **note / measure-evidence-gap-resolved:** The round-trip judgment's measure, null-set, nonvacuity, and mass-rate uncertainties are resolved without assuming that the interpretation's requested measure automatically describes the target.
- **note / interpretation-qualified-acceptance:** Acceptance must retain both hashes and the fixed-representative, every-slice, signed-aggregate scope. It must not be reported as unqualified printed-source equivalence, joint-L1 correspondence, or genuine strengthening through restricted applicability.
- **note / conditional-source-necessity:** The theorem faithfully captures the selected internal characterization. It supplies neither a general source-existence theorem nor a chemical constitutive law or pointwise uniqueness result.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `pass` |
| `C05` | `pass` | `pass` |
| `C06` | `pass` | `unclear` |
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
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `111` dependencies (`0` hash-reused); unclear: `D073`.
- Direct judge covered `111` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The printed source does not specify the production function space, fixed-representative treatment, sourced rectangle formula, or almost-everywhere temporal convention. Acceptance resolves correspondence only under the two recorded interpretation inputs; their selection does not remove the source-only ambiguity.
- Source, rendering, dossier, and native-output hashes are supplied provenance. I inspected the attached images and inline declarations without independently recomputing hashes or executing Lean.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`ce0fc34e85792cbee8ebbf629291c6c325125cd49e1e19efae68bc18f73a40ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`9a6860ed317fdf0b42440a209c52db6f1075abd58faebb35c2e7de6f7c5b42af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`89dc6861d5947ab4c937b247d1d6c86768b85eeee3f65098ac35eff9737a6614`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`5d5deffb0b923618ca4b25814137c1ad54c1306173def5ccc0a07797689429b6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`61f9cfe86b67808fa70335d1c91c50b69acb12b177432a6ac7c61e452ed955f3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`1d1623b1b0751e61d9ab35fdd6fac8a1e189e44ca8a8b4e47a6a162a1ced55a9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/decision.json` (`c8248f7f09aef51647d52aa785fe601b383284b2e225f16099b604688b372c3d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`13a6666fe70c9b366e7af4aa8c465f17ccbba793260044adb756b7da4d99bbed`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`dbd60e1ba2e2d770285942d5a3c1d26040410ef412653ec041e22f00d0f605a8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`dbd60e1ba2e2d770285942d5a3c1d26040410ef412653ec041e22f00d0f605a8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`6f97b5e67c2254f9111c7cc2c1a86fbcd56e2e2fd6e96a17c10e72bd02a6d485`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`2cbbd0eb8edb88e992244f59eb568c048000de3d1e3e57f462fa9df755b961a3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`64f076d7f2b2ad53386fd0d3f0b9d25b168c30dce66d23be91ba573ddb4248a2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`03bcd7db1290616aa7a67c25ca5cfc393cabc50aee2e37bc8cfa8bf5414b4df5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`0c5c49fd93bede6a3bd6cfa547c05fda2230b66530f477ea708c83f20d21e40c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`ce0fc34e85792cbee8ebbf629291c6c325125cd49e1e19efae68bc18f73a40ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`173748b764db06f91db87059c49af875c229fb2377859850815984bd2074e924`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`fb77125380e6bc2859840c6ea39f195c63a11ca01482f036689d9c3e2a37f629`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`82e9370330d57c3c3241c11affd418b6c91c0498523f55bffda428bed792a8d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`316fec0ea81522fc8bb0398148ac107e23ddc13e8f73303eec77d9ef5d01ab61`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`488872ac184b3b5d495c305563c451e45715c70614680b8513672347c2e13f26`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`17338aeb6012bb0b585fad6c2c044bed9f86a80aa115f85234ff1cc74a754a2e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`89dc6861d5947ab4c937b247d1d6c86768b85eeee3f65098ac35eff9737a6614`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`594e540f82604394839104e9d927d47c86f27524108dab183b56b2df6cfd6e1a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`01cac470115f05a759b9882367bf2df336daa654c40c30fc70534b59a607d490`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`a5e16d264b1f06e71f33e108e53e89e5339a72a13db67109439282afa957931b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`fb0aa0d1eef1aa091c07381db3fdbc44df5441929145b63cdb4e72ab4878521e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`dcdcf0220f7d6e68c03ae9cae9da8a7ceb89ad377a499bac63d46d64f4e75a7a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`7b99a2076b58a821ddebcf5bfb08bdfc2234e6dcbf8c21c0320998a7aae07ab3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`5d5deffb0b923618ca4b25814137c1ad54c1306173def5ccc0a07797689429b6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`10106a20e0a13c452d70d29283d571e7d5582f8fa381c7bc24093357ecb16d91`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`abb98f25fa85a52c003291d16de95d951cac1c4a87de654d2ed5c1921d459b0f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`a9e611526af279c6561c19dcdc7a90f2d7e7f75f2c244da9902f1873e0426637`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`88ca039a0b6767ef2f9ff093e826ceacc6b1b550e41ae2b8d33ff537b650c54f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`ce3e561d4785f70ff3de63c0b76df3857806d813c3a05318d103173dd7c1b7da`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`66255a883c1f6f0ebb899397731df25eb05e1f7f998d4f3830d273bc8988d42c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`0b3600c69673dbcf63a2b3df5b76aed16d0b2ff783bb0dd3cde4bf38df8cca2d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`61f9cfe86b67808fa70335d1c91c50b69acb12b177432a6ac7c61e452ed955f3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`06dd25f760a8353f35452fd0ae938727ffd66fed0b500b0eccd23ffa62332dac`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`266c6d412370d465cde0ef155b6aeceea1c43804b9ef250b93e2d1966b188299`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`42e5442480cb622512e6eefaefaf48d6f572fdff300b13e6212cd3a7f9dc0238`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`f9f966d65974314b8f0ac9f322bc97d38d29e172583c6812f651d741d391e868`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`9f254213897f6ddb207e29c3879cfcf7a0d76c2b1fe575e27ebc2eb667a9ef1e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`1d1623b1b0751e61d9ab35fdd6fac8a1e189e44ca8a8b4e47a6a162a1ced55a9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`52230ac52e8687541c7ec50387d5505c9c5aa3a432c3f889708f1361a4e1f2b2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`d160f74376efce43fda540a9f6992ea1d8a437d3cb1ad86bb3dc892a0421e1ae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`44dba6f31654ecf34b2ac96e033a9daa9695cd68719c87ff5f143d568082c2f9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-SOURCE-SLICES-REFINED-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`841ddf919fc4d539b3fd63fb8766a847e153757e23e4c34b56c3e18d90838f43`)
