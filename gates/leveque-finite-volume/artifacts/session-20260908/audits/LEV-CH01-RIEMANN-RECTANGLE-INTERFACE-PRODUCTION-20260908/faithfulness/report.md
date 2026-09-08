# Faithfulness audit: LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `f219ca8cd2fd27a5a94dc84ac0c76097d2653f3b68e94b49dd3c3c23fb712c0b`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source renderings and supplied declaration evidence resolves the classification disagreement without majority vote. The reverse implication is settled by the logical structure of the complete conditional proposition: its own premises supply every needed certificate and function. The forward implication fails because those structures do not express the source's physical approximation relationships or general conservation claim. Analytic ambiguity at shocks remains explicit, but no longer prevents the implication decision. The appropriate classification is not-faithful-weaker. No tools, filesystem access, target proof, or independent hash recomputation were used.

## Implications

- **Lean implies source:** `no`. The conditional target supplies a pipeline for an already certified method but does not constrain unequal-state numerical fluxes to approximate physical interface fluxes or connect the updated sequence to an evolved physical state. The scalar advection construction described above satisfies its premises while permitting a persistent arbitrary interface-flux error. Conservation is supplied by certificates for chosen local solutions, not established for the source's independently considered discontinuous solutions generally. Correct normalization, signs, and Riemann initial data do not recover these missing claims.
- **Source implies lean:** `yes`. Under the actual Lean binders and bundled premises, choose the canonical normalized cell averages, apply the supplied certified solver at each admitted adjacent pair, and define information, fluxes, and updated values by the supplied functions. All remaining assertions are input properties or certificate projections. The complete conditional proposition therefore follows without using any source theorem. This does not establish that the source guarantees a method with these properties, nor that its instantaneous conservation statement is equivalent to the rectangle predicate.

## Findings

- **major / missing-physical-approximation-relationship:** The target permits procedures lacking the numerical meaning of the selected source workflow.
- **major / conditional-repackaging:** The theorem does not establish the substantive certificates or their availability in the general source setting. Its additional hypotheses cannot count as genuine strength.
- **major / unestablished-analytic-correspondence:** The rectangle certificate cannot be accepted as a verified equivalent of the source law. This uncertainty does not obstruct classification of the complete conditional target.
- **minor / selected-solver-execution-not-identified:** The target does not characterize the supplied method's particular execution or transfer its consistency assertion to every permitted existential witness. The source itself does not mandate a particular solver.
- **note / nonvacuity-and-preserved-conventions:** Rejection concerns substantive coverage and applicability, rather than inconsistent premises, degenerate division, or incorrect local signs.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `fail` | `fail` |
| `C03` | `fail` | `fail` |
| `C04` | `fail` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `pass` | `pass` |
| `C07` | `fail` | `unclear` |
| `C08` | `fail` | `fail` |
| `C09` | `pass` | `pass` |
| `C10` | `fail` | `fail` |
| `C11` | `fail` | `unclear` |
| `C12` | `fail` | `pass` |
| `N01` | `fail` | `fail` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `fail` | `fail` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `fail` | `unclear` |

## Dependency coverage

- Blind translator covered `139` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `139` dependencies (`37` hash-reused); failing or unclear: `D001, D005, D010, D012, D014, D015, D016, D017, D020, D021, D025, D026, D029, D034`.

## Remaining uncertainties

- The selected source pages do not determine whether conservation at discontinuities means an almost-everywhere derivative balance, a trace formulation, or another weak interpretation. Equivalence with D005's all-endpoint, all-real-time rectangle predicate remains unestablished.
- The source gives no quantitative threshold or error metric for a numerical flux to approximate the correct flux reasonably well. No particular accuracy order or bound can be extracted from this passage.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`80b268ed7d8705b67e54504580bd79e2fedcd7daab2bfc89027e05a4ed4f3d9d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`619bb74b9fc8c89992fff1e2c9e7be5714cb9a580cb854f4fb294956e6f7c25a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`638f1bda6122a61fe5ae9c63a43bc652816dfdcb6c9af5d4db21e71865da7c80`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`e89c45f677e99524052084302aa0e5d6003edc3f6cb5a700f0050cd6228e5632`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`6df1958d7bb155f4d7db14fb7c6e2de2938bfb227f84765261c3a1f59d8fbac2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`9000b17c91c00ea83df98a168b1f00b7dc425d0ff5c9fdf768860d53603c21c1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/decision.json` (`44dfd5c682eb5fdcd9fabd7b747df0ccbabc280d31482e26861c714a7b56c1a4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`cffdcdfb7534d0ae8b1c14adf70d400bab7ddb36695d22e323f67d58d5996c90`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`7b93db3d2fcf72f5f6476a79f6aae2900c4f7646ed92b95f6ae6ea7f8b27116a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`7b93db3d2fcf72f5f6476a79f6aae2900c4f7646ed92b95f6ae6ea7f8b27116a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`dd4339b10452bdaab307b6a8efee7653f3446987f40d2d26bb15c5804759d1fd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`64b7c03633360b2add2708cf983899f6bd94364b798371dbbf5b0b5fe39988ea`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`83efd926ce56f318791a21628195883290078a73bc07c7773c79f8c275f16681`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`d887e548da0741526e05d6b2665e67aea6e2395ae2633341a1d99e78c030629e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`2d71d37ee16921d100ec3f1041330c04df4c78b0fb3bcbb95f209e441360e32f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`f26c1cc7ef5cee9e32f60b1ff8a0e217779f0db7e6e96b8810cc0196edac795d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`80b268ed7d8705b67e54504580bd79e2fedcd7daab2bfc89027e05a4ed4f3d9d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`c874ed85acae6160f0bdc964b93f21df45e49a758ad1666d004c1772c6f67dc3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`bf2e9629df17eae318bfa0b5b0b1b9ca6abb67ddc44cd2717975f3bddb8029d4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`4eb0a69ef8a9d562d106d485806f6c320e14e3249d79b6a9777db6f360d306f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`febcf5ffaafae8f4bf4512f26a9a3d76d5765229e4f96bf70259e164ac0d43ef`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`f1dd2019ec2741d26a3e1c1df94c25109075333033c9ba46661464e97f485f69`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`9a5e1fcadca0f049efab7a534d082c76ebad109407cc1e939dbf26f00d16a2f0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`5a2dabe394a8e5b639c0c339b8b56a6403b63d029380c2d23dd7032afe21a973`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`638f1bda6122a61fe5ae9c63a43bc652816dfdcb6c9af5d4db21e71865da7c80`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`889c6a2ce734ed82f220b70be3eed0cac420f0e7eeb737cc63d1f55c6b02c249`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`735a29e415042b4cd648dbcd6da54ca7587a5876a92aec354c844b1fad40690a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`cc86b8badd69f809bcfd500ef136e5bc2b8b430c2ce114693cc4acd46aa0a55e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`b0802ccbbac7c1cb485a1ff5ec2f507e941e323b441aa22ca1bf39efaa2b60ef`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`e217df3792dd16cc19151efeeef84fa8b68f7ec36205974164e36a0687e24469`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`e89c45f677e99524052084302aa0e5d6003edc3f6cb5a700f0050cd6228e5632`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`b759d8b1f49b8d488cf8262935b488ca4bbfbba92e7613e9267ffe3f3ffded8c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`5be86ad3a0b96544c90cd129c9c5ff89b500a2f45055a255ca9fd90c91ed0467`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`1f260028fb8b80a4ac009e317bcb3b4a09406dcde20b910f044c4985f26c8745`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`aab27d08d5749c5b842c5602c6f538749aaf52957629b7be89b8f3bc4fa6649f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_prepared_validation.txt` (`5dcf9c88ca97df1bfb0fc90af8850995614673b4ba2e790a6613362c032e0bb1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/orchestrator_route_exact_task.txt` (`27b46a058bd2d63701b22e9ac356577ef6a01dc8c3e3142539deca1d7738976d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/page-025.png` (`ba1b4e78f97dc8161b93e8faaf79f389e7e871756e6eb6352a6123a8b565f8f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`d7d9a104c431c4e253f51a0bfc85e95443507c845b420c7441d2ffe8f7ab518e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`e8b6fddc191af677903397faa18391f2a9d27796291bdfaab0f9210527fb72de`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`6df1958d7bb155f4d7db14fb7c6e2de2938bfb227f84765261c3a1f59d8fbac2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`84e28aff321a9db8233ca81d8d5f78c405fac9e207449dcc28aaea57dc2914dc`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`8df71694628ffd188de05805b042d0d51598448714d82bf561ed49fc5810bb7d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`fef52fff291692ef4ab43f6bad046e8fa81c64571233013716f1379c56ca0da7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`e8443daae0e237ed9def145d15997398cb7571cc0bcb44751034adcd8ef0010e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`a990032e104bcbcf0c1da8cb6c7dde950901bb895b78b0952dbe1116fbd7a1b2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`9000b17c91c00ea83df98a168b1f00b7dc425d0ff5c9fdf768860d53603c21c1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`8937eaeabacae177c8c6a2190061a0a69fb575f579479e3d72a1fc375185cdab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`2b0c3086f053902ed4f2d885867091638c7e62ce619804d4a7103bd24fae9bc1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`df2591ad1eec6840a67096a96c0c12e94a4a7ce6131550fe64df01747f3a528c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`f9c486d878798a567e273aa804e0fdd7d031343ff2006c043d7947220e8094fa`)
