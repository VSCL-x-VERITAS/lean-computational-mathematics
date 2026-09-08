# Faithfulness audit: LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908

## Decision

- Classification: `undetermined`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `821c64b87ffe22018abdbc1fff01f846f4067ff5feb6911e4bb0e4add39990d7`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source images and exact inline declarations support the same finite real hyperbolic system and signed component-wave mechanism. The blind translation preserves the target's semantics. Independent implication analysis resolves source-implies-Lean affirmatively and separates the understood meaning of Differentiable from its uncertain source applicability. The evidence does not settle the opposite implication over the source's full intended solution class, so undetermined is the consistent classification. No tools, target proof, or external evidence were used, and source or rendering hashes were not independently recomputed.

## Implications

- **Lean implies source:** `unclear`. The target gives a complete real eigenbasis, unique coefficients, exact scalar decoupling, and signed translation with reconstruction for globally jointly differentiable solutions. These recover the selected correspondence on that class. The attached source pages do not establish that this class exhausts the intended component waves: equation (1.3) describes profiles without a regularity qualification, and the general construction is deferred to Chapter 3. Neither a broader weak-solution interpretation nor an exclusively jointly differentiable interpretation should be imposed without evidence.
- **Source implies lean:** `yes`. A complete independent real eigenvector family in R^m provides the required basis and paired real speeds. Its fixed coordinate isomorphism diagonalizes A and transports existing slice derivatives in both directions, yielding the pointwise biconditional with derivative existence included. For the globally jointly differentiable solutions quantified by the final conjunct, the chain rule makes every characteristic coordinate constant along lines of slope λ_i. Evaluating at time zero gives u_i(x,t) = u_i(x − λ_i t,0), and the basis representation yields the finite reconstruction. These consequences require no decision about additional nonsmooth source cases.

## Findings

- **major / unresolved-propagation-applicability:** Acceptance remains unestablished. If broader solution classes are intended, this is reduced applicability; it must not be reclassified as faithful-stronger merely because the classical conclusion is explicit.
- **note / reverse-implication-resolved:** Source-implies-Lean is affirmative; the round-trip judge's uncertainty in this direction is unnecessary.
- **note / spectral-semantics-and-nonvacuity:** No spectral, sign, coordinate-identity, or vacuity defect was found. These checks do not resolve the remaining source-class uncertainty.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `unclear` | `unclear` |
| `C05` | `unclear` | `unclear` |
| `C06` | `pass` | `pass` |
| `C07` | `pass` | `unclear` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `unclear` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `unclear` |

## Dependency coverage

- Blind translator covered `140` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `140` dependencies (`0` hash-reused); failing or unclear: `D013`.

## Remaining uncertainties

- The supplied primary-source pages do not settle whether the selected general propagation assertion is confined to globally jointly differentiable classical solutions or includes less regular component waves. Consequently full Lean-implies-source coverage cannot be certified.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`b53d516ddbe0e7e3e242713a6d9659dbc2b12961e9bf6e3dd8056cb0e39ac1ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`12528a8c72fca5fcf50693601eafeca405d230538e2fb288750e3b69873368e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`502b5572805314a1961707766ec4f6263f72861145b0d6ad208c1fa8e4a35d70`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`05b1a0b41734eec6297e90ed64664e6fba6d824633584fbe34b60cf4b4a8ac97`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`add633aebb60865352aa2a751e735a336072a4162d2d3236f4110f9e5bc57ef5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`de07c9ec4156605d2dbffd70ae40cafcc4b9eab70012cc138b9e6792b66eeeda`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/decision.json` (`22dba9b9b51021adfdd3276c752702d8567946e4db95675bb1bdc3875d93803e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`facc0e30a134411f6431467363fa14bb5400c9147f6810421ad039cda7558c5d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`4e7e2daa30c8e9295f4576d64a68cd37bd0126e46a0b695fdbd83e2a984fea31`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`4e7e2daa30c8e9295f4576d64a68cd37bd0126e46a0b695fdbd83e2a984fea31`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`64c31c2f17cf7e4e1a000d49a5b23a17b90643ab4dab74a8981ff1cebb15626b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`334b7eadc25c5632dbfababeecc6a33209bc2e0ca89e8e23bd432bd3549e4edb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`104c3a0807fa6868d5e044a9f43b2e5081e7f1ff4965f248f1a84fe3734f4f22`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`dd96220549ebf60572e1f44bcc1e7a6f786f61fb250252aded7f4e6033934242`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`cc3d3ab37ee32163437fe6d0ad083a435723ad671c74c5731730365b0523433f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`b53d516ddbe0e7e3e242713a6d9659dbc2b12961e9bf6e3dd8056cb0e39ac1ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`4061b82728763a5d5e5d85329460575a91beade142d2c1a4ee827bedd96a18a1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`777881eb706d15fc72f2157b904f740634a26180fe6ad9a66df76ef82a74c8a9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`3602472892d389ed541865485dc5efb105fe9cfa2d7ac6153f984ad04b2f2959`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`09581f423deda723a4a199b69e1841a3645eabd52ef8b511f7e29e614d124426`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`8add4fd7782588b933a2c1c0a0e2ec8cdb3fa72fd0e2ad0c42b44ed9ce9291f0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`a88d34a689ae38e04b1279821c300fb3f4142687584115490ee0d959f0b584b3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`502b5572805314a1961707766ec4f6263f72861145b0d6ad208c1fa8e4a35d70`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`e0468dfe73d42bd275ca3a2b5d9ab1266bc54566e98b1720b9e1ceab4814a2e0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`354baf9cd337d2827ec27527e70fd068cd006346c9212b1c1426e55fbfe05e50`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`c77aa12fbdd41f23aaf21b6d22a8ebaa35ee780c256bbdfcea1622babac3543d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`da901bd8f5919080736ef7cae99494353a772eb6adeebbf82bdab18405c6750b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/blind-preflight.json` (`df2c610413711872b4432a3acbc3158b2cda5a8f6c224054fdaf1cbfe5304729`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`b5741fdc4e89e53022f78fbfc809c3773de66fb82965e96d61e941146034196f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`f8ea57d92cebad58ec6ef68a218b0ebe65a24a2eb14796abba75484b5af1dd80`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`05b1a0b41734eec6297e90ed64664e6fba6d824633584fbe34b60cf4b4a8ac97`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`d187340a689598ba7c7d892ec52e4b47bd1c0470e19ed920beb4834e14352bb0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`b543ae14f45accf7b27832ea013d5b5407e53c91070c805447ee431ba0c005e0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`490ee6b0e1f03a3675d06072ae6e50123467e52a9d3dcf69c53da236c8d12a2b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`a2bf14587a05c5b2d560d641a9f6bb372a588df152f0df8da5e78bc986ffd6cc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/page-024.png` (`6a95398093b6adf8fbfd948f95a69c83e6f3175bbb05465e922c595311ee7f92`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/primary-pages.json` (`02028b479bcb509ad80fcd69fb0721f6df47503dda347aa2ef2a21df0291876a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`193b15d34e8cad3ad9e28fd5af743af815663a980cfcd99d24676917fa011e2a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`3e31718d26f2568adc4318dd8ae536cbea74e76b7b88efbdbc45a8a22e34518e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`ae06992c8592a8767c13bf19532feffc7014c4e75508d77bfcd7e93e6f979057`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`add633aebb60865352aa2a751e735a336072a4162d2d3236f4110f9e5bc57ef5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`d0c348c0c2e15ffba47c16cf9757afbfee2e3f156b7f3154ed163a4a7f9eee1b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`a594e7319929a3c1b53e7a4d18898c415d89bd0b958385e900e2b8a953c4adea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`e654ce859e06595b25c17815f48d4e7fbb10ce1e65a1cb3f8720afbd3497cb58`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`1c63ea9a030ce30832d7cc11322eaadae1622a26c92cd0c8976d2cf50bda8bd3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`8befa20d1fa4b054ac795f8df955f55376b7b2ef35e6b3c86268ec872d9661c6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`de07c9ec4156605d2dbffd70ae40cafcc4b9eab70012cc138b9e6792b66eeeda`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`0105a525c57fdd67bcf17182095f7647eeaf6690e74b92dbdd46641b6b419e09`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`d49222566c1fcaffe03b4b4d1d11f197a3c08d64c14d447dc1e34c6a970395bc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`8c1ec247d5523f46c2dc81cc0a055ab0f97750f4e4b8a5f7c4b8939581cbc6a2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EIGENVALUES-GENERAL-PROPAGATION-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`86123bd5f04040034cee3f0fbeeb0d93b56b6a4c2425a86e0f232fe288081ab1`)
