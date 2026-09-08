# Faithfulness audit: LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `6e7c79f37c6f52c1a040594ed36291bd7700318fb818c802a3fba4076cf14a06`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source pages and inline declarations confirms the substantive source-coverage failures. The central adjudication issue is the reverse implication: the target's conditional conclusion is derivable by definitions and finite real-module algebra regardless of the integral's hidden implementation, so the reverse implication is yes under the supplied mathematical implication policy. Lean-to-source coverage remains no, yielding not-faithful-weaker and rejection. The hypotheses are satisfiable; extra restrictions cannot be counted as genuine strength. The remaining integral uncertainty is preserved explicitly rather than guessed. No tools were used and no source or rendering hashes were independently recomputed.

## Implications

- **Lean implies source:** `no`. The target does not recover the selected passage's method operating on approximate cell-average data in the integral conservation-law setting. D009 supplies exact averages of the same static field used by D007 for pointwise reference fluxes. There is no separate approximate input array, governing conservation-law relation, or assurance that all physical cell edges are represented. D014 permits the two-cell example with omitted exterior exchanges, and D011 restricts flux dependence to a shared binary rule. These omissions persist even in the source's ordinary real finite-dimensional setting, independently of the unresolved generalized integral behavior.
- **Source implies lean:** `yes`. As a conditional mathematical proposition, the target follows from its own premises, definitions, and real-module algebra. Set v_c to the positive real cell measure, a_c to the supplied normalized integral, F_i to the defined binary numerical flux, and Q_c to D010. Define b_c = a_c − (Δt/v_c) • Q_c. This gives the local balance, and finite summation gives the aggregate balance because Σ_{c∈S} Q_c equals D008. Positivity, average certification, flux identification, and the error bound follow from premises or definitions. This derivation works for any values returned by D096. Consequently the source context also entails this conditional theorem, although the source does not itself prescribe its additional modeling choices.

## Findings

- **major / exact-and-approximate-object-roles:** The target does not preserve the source's distinct exact and approximate state roles. Reinterpreting the field as a reconstruction leaves the separate physical reference state unrepresented.
- **major / incomplete-physical-flux-linkage:** The algebraic boundary sum need not represent the physical boundary exchange. Common-closure incidence alone does not establish physical orientation or the appropriate flux at a discontinuity.
- **major / restricted-process-and-assumed-accuracy:** The target adds restrictions and an assumed error criterion without recovering the general numerical-data process. These changes are not faithful strengthening.
- **note / nonvacuous-algebraic-derivability:** The theorem is nonvacuous as algebra, but its independent derivability resolves the reverse implication to yes without restoring source faithfulness.
- **note / unresolved-external-integral-boundary:** Full generalized average semantics remain unverified. The final rejection and implication classification do not depend on resolving this implementation detail.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `fail` | `fail` |
| `C03` | `fail` | `fail` |
| `C04` | `fail` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `unclear` | `unclear` |
| `C07` | `fail` | `fail` |
| `C08` | `fail` | `fail` |
| `C09` | `fail` | `fail` |
| `C10` | `fail` | `fail` |
| `C11` | `fail` | `fail` |
| `C12` | `fail` | `fail` |
| `N01` | `fail` | `fail` |
| `N02` | `fail` | `fail` |
| `N03` | `fail` | `fail` |
| `N04` | `fail` | `fail` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `unclear` | `unclear` |

## Dependency coverage

- Blind translator covered `112` dependencies (`0` hash-reused); unclear: `D096`.
- Direct judge covered `112` dependencies (`14` hash-reused); failing or unclear: `D002, D003, D004, D006, D007, D008, D009, D010, D011, D013, D014, D025, D034, D035, D038, D041, D044, D048, D054, D073, D096`.

## Remaining uncertainties

- The exact implementation and totalization behavior of D096 for incomplete real normed spaces cannot be established from the supplied wrapped projection. No particular fallback convention is asserted. This does not affect the algebraic reverse implication or the source-coverage failure.
- The selected paragraph does not specify a quantitative meaning of adequate flux approximation or a discrete temporal flux convention. Those choices cannot be uniquely extracted from the attached source pages.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`059978533243ba9a62d7dd61481a276d49f33a94ccbbc83188e286c153e82700`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`321e6449026946b7cead3742b590898147accce83197eba8edfbfab2df28d2e3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`e3ead8e6a4e8b5c71aa548238999e89d3ba867c8423ea2969289acfe32373ea6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`2bff8b5330d819fac24794a4cdf5e7a6ae9b6e7588ae2fbb4b4398f4554ea2e8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`f024bfa455c09a970a399314936fa50c1f23cc918005bdc24ccc516872affbe0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`4ff9ca9e6b08133305666539e4266e031ab2b98a7c7fb1bb15506c50d4a4bf63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/decision.json` (`8660b099909f6f75de955b1ef62d176191887521f1e1c261f6dc645743074375`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`1d016d9e9ed0176766a4f570029a0390dcf25bbba0c702758b125bda5c9fab14`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`85df7d2575c9b3d74de165dce14a4bcddbdfedc6e8171f799660730e3d97a7f1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`85df7d2575c9b3d74de165dce14a4bcddbdfedc6e8171f799660730e3d97a7f1`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`4a8eaed5199b6367662361ecfb7242512ad715e50f5068bd348d021bcc214d6f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`8e6ef714f8f99783ed2088057d251aa06031c7ae884daee4dd67b9d945b96091`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`8a7fe602f8e77ae67987a0ed8b38b61e7e4eb57c5747c1286cadb15be044a8b8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`7ed6b364d3cbc21ce567cd1de017285570e062dfb36e62239db63342a6ef16a4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`06cdd8fb97a2cc148418db8b3bc42216e258bdf5626b85efe555a87726129b7e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`29cd3673f97acc3337b5c21f1f027888c4a027710d29587c7ecedc6fa5f7ad82`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`059978533243ba9a62d7dd61481a276d49f33a94ccbbc83188e286c153e82700`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`fafa361e1b8bf3c105308526ceab1149cb57c42008c9866e6676a394ba5907ab`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`2ac3bc0bce3930f7ad2a4448c8169d3dfdd90e705dfbecb276635335e222c0b0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`05d5ba345a80b288e811bb947e41edcaf30b9fa902964d79b45fccff671be37c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`5d41df3a008fbc9a4fd9aa6569f6c9d0168859b7102e6988c27ce523fa00c5fb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`6f00bfc438022fa65650507f97c0ac300c5f04089e508bde1c0a28d1c340e6c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`ba0aafcef7530fba7b89c375466ea8337d4a7500cad4114bac6dca5862a7a65b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`cc301596d6a45242c7020ba6bd4849fdbe6ff42e18072c78c9db8fc0d640a483`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`e3ead8e6a4e8b5c71aa548238999e89d3ba867c8423ea2969289acfe32373ea6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`96ebc6c4b5ad294eb37ad410a8f7f0ac0251219bc5104ed8dfee6728bbef32b6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`a152b9d41f5f664ebbca3f33cd80051376516ed5159fc4eac664800d8ec1a919`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`8df9e7c52663ed01f20d236cc2f62c03989eb2ac28148a932aecd4d0cf0fdf14`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`ad6b8b82f4bce85f72f4e6feaa72dcb45c4ceadfb05819712b0d77b7d9fe593c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`55d3df718918a70f2ba0c75f4a35082c72da80e2e6a6ded7dd97abf3831fa8a8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`2bff8b5330d819fac24794a4cdf5e7a6ae9b6e7588ae2fbb4b4398f4554ea2e8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`75165d2b696e088a7b07a6aa40844c71e55e7fe0fc8d5cc41ae9181510966296`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`719675b4379ed83ebcb0b8df9c654b22faf7ea3285cf195bcdd3b8ea0f6860b5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`ba65863e72b367b0ae18cabca2f6d6ff905a3dbac9ed9dd22f40b04b62e19fc8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`21c9b5dc925d396a7dd826232c2bc0e8e2760090bc8e2bee93681eb0a643f839`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/page-026.png` (`c59386b593acaac6cee4f9bd2ecf8e328436c328ce898213bb58e69dfc7f547d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`3f8f935ce5aebf540dea9fbcac34139b0bd05ed230c52b44f75671a32fbb5192`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`f024bfa455c09a970a399314936fa50c1f23cc918005bdc24ccc516872affbe0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`fa8a76f9b0523eed6389ff8d03e5e02efc37a10f7d6f1be5eed0031eb1f92ea0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`8ee6217ec2d6906d7d9f178c1babcadbb98dd7adc69e75ba2a2aeb06098c38e7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`51b66d917c06f1e55854cc8fdadaf950a6802ba80294a8f8c5ea7fedf2a6d516`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`a7612aa05269dfe65e5d80cfbf9a68b1b770f9d2114f2110f907532765ba0756`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`ff6fda39da2cd7515c32c0c4bf89f07397299a2dfb351508d73838289bfd989f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`4ff9ca9e6b08133305666539e4266e031ab2b98a7c7fb1bb15506c50d4a4bf63`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`e87a0e1333354993fef74ffb6db1e46868d0e3aec9915d967ff47a991a7aa535`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`2f41289f1a4ba6b085558d8439af5490bad9026fc1fb0c5e58f2a09665cf3e53`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`982e864309353a9fa8a33c505a19649752941e673d28e81f12e88642152d9700`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-FINITE-VOLUME-FLUX-UPDATE-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`85b9b964005dba23d3a8b41db7549932edb5e549c10f92959e740fbfb646b125`)
