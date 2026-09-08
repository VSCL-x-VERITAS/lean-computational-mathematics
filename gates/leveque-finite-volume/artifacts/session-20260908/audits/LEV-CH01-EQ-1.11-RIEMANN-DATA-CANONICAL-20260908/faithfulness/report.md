# Faithfulness audit: LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `861b306ff4259db6b6284b6ce1ba2f62207968fed14d59e56614d45bc846196d`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The attached primary-source images show exactly two strict half-line prescriptions at time zero, with no value assigned at the interface. The Lean proposition faithfully characterizes this class of initial traces through a total piecewise function with an existentially free origin value. It retains real vector states, both branch orientations, and pointwise equality, while making no evolution or solvability claim. All 17 dependencies and all 18 configured checks are accounted for; no unresolved semantic issue remains.

## Implications

- **Lean implies source:** `yes`. As a characterization of admissible initial data, the existential representation yields initialState x = leftState for x < 0 and initialState x = rightState for x > 0 by the two conditional branches. Identifying initialState x with q(x,0) recovers precisely (1.11). The theorem does not assert that every arbitrary initialState satisfies this prescription.
- **Source implies lean:** `yes`. Given a total initial trace satisfying (1.11), choose valueAtOrigin = initialState 0. For negative and positive x, the source branch equalities give agreement with riemannData; at zero the chosen witness gives agreement. Real-order trichotomy and function extensionality yield equality of functions. Conversely, that equality yields the source branches, establishing the stated characterization without an additional source condition.

## Findings

- **note / unrestricted-interface-value:** This is a faithful representation of an unspecified interface value, not an added boundary condition.
- **note / degenerate-cases:** Equal states preserve the literal formula. The zero-dimensional case is a harmless extension and does not make the positive-dimensional characterization vacuous.

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
| `N01` | `not-applicable` | `not-applicable` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `17` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `17` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`0b8ac5e390491f52aabf1cc4ed942c291174911b77ccb28739a0d6f4cc7032c9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`1c1685e715d5ee26d7593109fca373c8d54b2908e5f9fd94dc48eaaaf858efc1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`46f437105a02c7743d7a47332e28122742dcc0096b73db1130e51212dea39e86`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`586c40189923d7096763ae55dea3856277114cbf35655c3fc67b4ccb0019acb5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`dbe9c9477b7ae2562d595d31e18be4b25706ae91f0304e6b6380dcb880ff88f1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/decision.json` (`a108ae2f6b7f3c7128c62a56aa419ca59a5ffe365cfa436b549edb6666f65115`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`56819b250bfedbe15bf56733552971fc0cbfbf588499e360130ed80ba33ab798`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`6afcb100c72e5487e24a3d93ceb1c85accc8890a110f37cd7e9cad1d0bf6ada9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`6afcb100c72e5487e24a3d93ceb1c85accc8890a110f37cd7e9cad1d0bf6ada9`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`4b872d635e5af4eb4b7b0c875f1df19dcb3d6fcfe0fb1663d624100c5b36271c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`62da7b9d815b5ee46e748309cf00784bffa4f812cb5c5427666fcc7bd7b41036`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`73b99f29f0dff1ba11eb2c3b0ff86cda4b89d09099d7ccad139b3149fa8b630b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`66f38c12bc483f9a643162093c928c346c298a1039e5f518723bb5a14692edda`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`9ab307945bab7e5c7677f6f833c2517c74ca882e4c958dcaa959f1ae20b353f4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`1fede7b6356d3673c36c079665ba96f7f3e74ea93fa360559db90f484130cb2f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`b6ce320a01fdd24a2a8eeed8eed1a6e0f0d7182c155fa03a0323eb299e9218af`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`1c1685e715d5ee26d7593109fca373c8d54b2908e5f9fd94dc48eaaaf858efc1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`52fb5ffede63f86d92c4efe3d3e7ea8d17108eda9b582b35dc61f601502d2de5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`d5951572319c60e838562b90552b0be26fa5c035033ae05839d462cb22f7008f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`5467e31265499651223a10f8bf445f2433d18f7fd97ccae66762d1494fe450e4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`e878861cb77a938692617abad38701e8f6bec654c7431266a62e8164b0e52fd5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`134e524292b34ea0a231d55646f4c14f74167cc3bc442cfe13a8f62a114032e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`46f437105a02c7743d7a47332e28122742dcc0096b73db1130e51212dea39e86`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`8d3b88b5da55bbc24ee1b59c211f424b18a218e4bd1d5415cfa466a91ca33448`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`4d844ed91392cf0970888ecb84b375e7d7284424ef004b888da73295c622944b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`b191701097386db119e43ce7846d38c8152ce7f424a6d26ca9d8dd1063c1e429`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`db43a081313f5adeaea7aa5d6841c741499358c908bfe5d7d2b709436316ceb8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/direct_reuse_preparation_20260908.json` (`24419dec40a9a3cbbed50254bf3dd0b84fdf819c93f0502e51a781eb9c499730`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`a20796f8b922564a40d260aaac3e4908faeee3c12eeb604f7fde86aba76b031a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`586c40189923d7096763ae55dea3856277114cbf35655c3fc67b4ccb0019acb5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`fcb395d3bb752965bca169e71446caeb319763d13f5d5f9145ceccaff8b59fa4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`e548f10701597dd13543b2de72bf4030775b58c0d45785fac49fb148c0e75f75`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`0b7c183529228d1cf857b0634860227f8fb1a4cdb4b934dfb90febc6db838779`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`2bd4ac1aaa28b1657887628de989316bb94fbfa78a51ce28b11b3058e8b5fbd0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stdout.txt` (`1dee418e6a0d8fbc885f08a02d9858f1215e7357d02bed1b6bb92bac3ec820b5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stdout.txt` (`ef35e45c08d88606b6a9a29c9df67496a684d589cd528584f10d380036b9e942`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`c9b2d05d0e778969d8a05536d93b663177b60b74d81c11c45819599ffac7182c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`dbe9c9477b7ae2562d595d31e18be4b25706ae91f0304e6b6380dcb880ff88f1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`544f164b5eeb7ca28e4433059fa6b8613608448024c96d279f2c960381410313`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`ea640d0ab0f614e7f1d4f1e9f8b6743033589331152febe61dfe97a1de5f5308`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`7ed19bf6ec72dfd80ac1466c159b74338e772a8170107048cb812a3557d9dfe3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.11-RIEMANN-DATA-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`ac644c7d46f9e38b40bf70dd9ef25f1bbbcae009addc224872cde22f6ef575a4`)
