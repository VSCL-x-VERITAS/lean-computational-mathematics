# Faithfulness audit: LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908

## Decision

- Classification: `not-faithful-weaker`
- Accepted: `false`
- Adjudicated: `true`
- Target SHA-256: `0a11c9bd8e91b0194e3878d1064f1090148a8081982019dd3882e0f6233e0592`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached source images and the supplied declaration evidence confirms genuine sequential execution and exhaustive direction coverage, but no semantic guarantee that the executed maps solve one-dimensional coordinate problems. The decisive counterexample satisfies the formal assumptions on an ordinary rectangular grid, so uncertainty about logical rectangularity does not undermine rejection. The complete Lean proposition follows from finite-list construction under its own input assumptions; this resolves the judges' classification disagreement in favor of not-faithful-weaker. Remaining geometric uncertainty is retained explicitly. No tools were used, no target proof was needed, and the supplied provenance hashes were not independently recomputed.

## Implications

- **Lean implies source:** `no`. Even on an ordinary two-dimensional rectangular grid with nonconstant real cell data, the permitted updates can broadcast a selected cell's value to every cell for every fraction and direction. D022 accepts these maps because they preserve constants. D019 and the target add no relation to a governing hyperbolic problem, coordinate-line solves, or a high-resolution finite volume method. Correctly scheduling and executing such maps therefore does not establish the source's defining numerical operation. This failure persists independently of the unresolved logical-grid interpretation and of whether the paragraph's practical assessments are included as formal conclusions.
- **Source implies lean:** `yes`. With the supplied Lean definitions admitted, fix any grid, method, and initialState satisfying the quantified input types. Map method.fractionalStep over the grid's direction list. Its nonemptiness and exhaustive directional coverage follow from D023 and the copied fields in D018. Define successive states by applying each stored total update at its stored fraction. The constructors D020–D021 produce an execution ending at the last state, with the initial state and one state after every step, hence exactly schedule.length + 1 entries. This argument derives the complete proposition from its structural assumptions without any substantive source premise. Consequently the source entails this weaker proposition in that background. It does not follow that the source identifies arbitrary maps as numerical solvers or endorses every formal modeling convention.

## Findings

- **major / missing-directional-solver-semantics:** The target admits updates unrelated to directional numerical problems, so its conclusion cannot recover the source's defining operation.
- **major / generic-execution-substituted-for-numerical-construction:** The theorem is a nonvacuous generic execution fact whose truth bypasses the intended numerical content. This supports not-faithful-weaker rather than faithful-stronger.
- **major / missing-finite-volume-role-linkage:** A function type can represent numerical data, but the supplied contract does not establish the relevant numerical roles. Imported averaging definitions outside the target's semantic dependencies do not supply that missing connection.
- **minor / unresolved-geometric-correspondence:** Complete geometric equivalence cannot be certified. Rejection and the implication classification do not depend on resolving this uncertainty.
- **note / classification-and-scope-correction:** Unsupported representation choices prevent faithful equivalence, but do not refute the reverse logical implication here. Schedule conventions are not stronger numerical conclusions, and trace existence is not universal practical sufficiency.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `fail` | `fail` |
| `C03` | `pass` | `pass` |
| `C04` | `fail` | `fail` |
| `C05` | `fail` | `fail` |
| `C06` | `fail` | `pass` |
| `C07` | `pass` | `fail` |
| `C08` | `fail` | `fail` |
| `C09` | `pass` | `fail` |
| `C10` | `fail` | `unclear` |
| `C11` | `unclear` | `fail` |
| `C12` | `fail` | `fail` |
| `N01` | `fail` | `fail` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `fail` | `fail` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `fail` | `fail` |

## Dependency coverage

- Blind translator covered `87` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `87` dependencies (`6` hash-reused); failing or unclear: `D001, D003, D005, D007, D008, D011, D012, D016, D019, D022, D025, D030, D032, D035, D068`.

## Remaining uncertainties

- The attached primary-source pages do not define logical rectangularity sufficiently to establish equivalence with arbitrary global coordinate bijections and measurable inverse images of half-open boxes. The Lean declaration meanings are clear; their complete geometric correspondence remains unresolved.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/agent_outputs/adjudicator.json` (`4e7b5345e241a12f8745e74c4b00e7e968221502b08e3002c0329effeffda8c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/agent_outputs/agent_runs.json` (`0e9612b9fc7a5b2cbcb4c47808c8cec3a28c22f41a08c583860586dbdf8124c6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/agent_outputs/blind_translation.json` (`3bc3fe73d4bc2c0afc41d57d8b2f4e2632dbfe6058063ee8d3329d21a1a8a478`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/agent_outputs/direct_judge.json` (`ba142f97955e6b10230ef878901747bd9837094cefab423a85caf73676d723d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`30aeb3002587746974da40b0e9d252716296be269c9f8c7fe5e7efeba3d6bcf5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/agent_outputs/source_contract.json` (`24c2f6aef814e9b5123d2824a5f62bdf743a35cfb1ed643f0a9ccbacef3d08ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/decision.json` (`f4bc6e665499951d8ddf5a80cba2f0c5ed5d548e97fef9fb9984a7b22012ccf8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`694571285589c5cf1fe643b9464d67125282501c1b0a92a68cd190f4518ce2c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/inputs/blind_dossier.md` (`067bd5ef532b91d7f3eb078d02f7dbdc1bce0972d0ed0563aae7cfcce4265218`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/inputs/blind_review_packet.md` (`067bd5ef532b91d7f3eb078d02f7dbdc1bce0972d0ed0563aae7cfcce4265218`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/inputs/declaration_dossier.md` (`db2914bf23af8a2465bb2b770ba85ba045d24ce5a8425416e26fd566912c5648`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/inputs/dependency_inventory.json` (`5d42dca98210e06c8241b047fba0b75ca337ab818b184dd90a5a8d3e092ab96e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/inputs/dependency_reuse_direct.json` (`0b04ac61b1d006f2403f2d9bed8aff90f0824acbb78de46e36e4925ff64c712b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/inputs/direct_review_packet.md` (`b59c819ab80e9f589bb25732359dd7311bd1d850e0eeb8b45c78048a766b2456`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/inputs/source_locator.json` (`d5aef6bfcd5f4c90ed98a3eb8976bcea9852f6bd6292f53a1d8f0c44d18fbd3e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/a_events.jsonl` (`08297e174e46b726f40cbc6f0003769ee10c31820a553fa6db917f8006714425`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/a_final.json` (`4e7b5345e241a12f8745e74c4b00e7e968221502b08e3002c0329effeffda8c7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/a_input.txt` (`d923d59bbca14ba1fbad949ec95186aed153b71463f8917dab80fbb7a81cecfa`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/a_runtime.json` (`08ba45289db3ed8e6396ca9de480d221b97f27604ef8e4cff838931b10cef8f2`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/a_stderr.txt` (`0829271f65c6415b5ae02de7b1fc44033354d280c7e06417305c45ec1dfafb48`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/a_transport.json` (`6aaf8a86852d20f198eca487d7c1dab8a6b622b5e78244701d91f66acacb8f65`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/additional_primary_context_20260908.json` (`d957b3874db7b6d7d558530890cef84d5e66795e3850179bb651dd1b1b73abf0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/adjudication_triggers.json` (`6f20184afcdd086b847ee7852705ea4975631d9bea133f764ee89bd770fee519`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/b_events.jsonl` (`373599943d3d3710837c0889e515969acccfef32096e70776cbd9e220254de99`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/b_final.json` (`3bc3fe73d4bc2c0afc41d57d8b2f4e2632dbfe6058063ee8d3329d21a1a8a478`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/b_input.txt` (`507f33b3670c9203b029fcbdd420e62e2d499a247cccc9a85ee2a2b435345c42`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/b_runtime.json` (`c4a53a190abf4d5fbcfce06e665d8dbc9c0643da48300dc29596b8996fc02a04`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/b_stderr.txt` (`6d7f8b70e5ff484e5c13bedd6d027e112ad23277461578ae7f20b4b7a57a9310`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/b_transport.json` (`ae53a812e1a641e48409e9b3d94f325b42bce9b55b735d014bb90acf0c48da37`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/d_events.jsonl` (`3eaffe1575a5f671fb25d8fc374383d88fca2383a42cbf0cb54cce7234452d79`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/d_final.json` (`ba142f97955e6b10230ef878901747bd9837094cefab423a85caf73676d723d0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/d_input.txt` (`e1e250912e254ebaaf826d2348b9bea7ccb27823f6c2fec56cac0321104ee7d5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/d_runtime.json` (`f487645306f1f0a5c9343af72f6e824606f888ad7ded2007f27394089d391b15`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/d_stderr.txt` (`3e87119b63da61f2125b13422dbe63c234a7f2e56b28616c68c2f158b94d1678`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/d_transport.json` (`90d07016dc788ec86a3344cdea8fbbbd19a2f60bc47a6bcacc5804a776a52ae6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/direct_reuse_preparation_20260908.json` (`662061ca8fc4c53c17a66265f42f98c9bc049c4d1afaee85ba4bfe5ec8fdd6d6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/page-027.png` (`846448532f30299bac80ef20bdfe0759fbb5e9215996c9bd8d839ff8303b35b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/page-028.png` (`ac871ae8d940867a19f2e470aabfa9e4c1e3d1c1f6e48a116920b0623a9b3984`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/page-029.png` (`38ddcc8e4f9afb72079edd7484088dea7c2d299b72df4e78113ca972fa2c816b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/r_events.jsonl` (`a02721e3242f3652f2db99d256418ad2dbdf55c6bc0ab3c2282a6316670cf8fe`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/r_final.json` (`30aeb3002587746974da40b0e9d252716296be269c9f8c7fe5e7efeba3d6bcf5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/r_input.txt` (`ad4c3da747695cc61738a775f9669e9df74aa4c8eecdb7e27eee35a47dd007c8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/r_runtime.json` (`8fd32c3f64d4dc4724a50439b178b63d2761096d7c00daf6be62b5bca71d7815`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/r_stderr.txt` (`211bb789fad315bd2c8d7a04422b569923ce368a04c24335b095954fbef190cd`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/r_transport.json` (`9777295e25b21a7dc7892dda63c42f9f0cfda9a954eff8cbb7a56f05535bb05a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-apply_dependency_reuse.stdout.txt` (`21c1a79e99ce7af4b9c7f43119575daf03c00d8199344e0f045aaf156cd14676`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stderr.txt` (`e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/reuse-preparation-validate_audit.stdout.txt` (`3a9d0d409291a9a64c8a21750094d2b3aa8b3acfd3dc2a3118b79cbf7ee96d33`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/s_events.jsonl` (`36e5afdc886c8232154df9992878b1fd3d45d094a9bb4780767e8ac319f56293`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/s_final.json` (`24c2f6aef814e9b5123d2824a5f62bdf743a35cfb1ed643f0a9ccbacef3d08ad`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/s_input.txt` (`0f50f6bde62fc50acfa614aa35415cc41a339e704f24f062ace474eff7e371bf`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/s_runtime.json` (`89f719c39d2a1d5bd60d13e85160f0fdffbaef3472227e7336515766c3fd2c04`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/s_stderr.txt` (`131468d4fba3520f7ad990b729de60d58c53eaa264ddc7c55f5d3342c83924e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-DIMENSIONAL-SPLITTING-CANONICAL-20260908/faithfulness/orchestration/s_transport.json` (`6f83ef97bbdade33b7da27120b6e258596efbcc81e394e48ea358d69144334a6`)
