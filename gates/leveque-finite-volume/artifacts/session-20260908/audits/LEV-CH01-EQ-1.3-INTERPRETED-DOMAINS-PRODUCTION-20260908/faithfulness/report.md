# Faithfulness audit: LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `true`
- Target SHA-256: `8aa10fbd6a06fd55e0be210c580f30eef259d8b5d264ea035f4a6a5459122293`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

Independent inspection of the attached primary-source images, exact target types, supplied dependency declarations, blind reconstruction, both judgments and native supplement resolves every trigger. The measure supplement establishes the exact missing identification and normalization, which closes the downstream checklist and implication uncertainties. The target preserves scalar roles, quantification, real domains, signs, characteristic transport and both adopted analytic classes. Acceptance is therefore faithful-equivalent under the recorded user-adopted interpretation, with the original source-only limitations retained. No tools were used, no files were accessed or written, and no supplied source, rendering, runtime or dossier hashes were independently recomputed. The decision uses statement and definition evidence, not target proof evidence.

## Implications

- **Lean implies source:** `yes`. Under the recorded user-adopted interpretation, unfolding D003 gives exactly q(x,t)=p(x-ct). The unrestricted characteristic equality gives constant-speed, unchanged-shape transport for every real profile and speed. The fourth conjunct, through D001 and D004, gives classical solutionhood with both partial derivatives exactly when p is everywhere differentiable. The fifth conjunct, through D002, gives finite-rectangle balance with spatial and boundary-flux integrability exactly when p is locally interval integrable. The native supplement identifies every volume argument as ordinary real length measure. Thus the complete interpreted claim follows, including zero and negative speeds. This is not an implication to an unrestricted classical-solution claim for every profile, which the source context does not support.
- **Source implies lean:** `yes`. Under the recorded user-adopted interpretation, the displayed translated formula entails initial agreement and characteristic constancy; the characteristic composite therefore has derivative zero without profile regularity. The adopted classical characterization matches D001/D004: a differentiable profile gives partial derivatives -c p'(x-ct) and p'(x-ct), satisfying the PDE, while the spatial section at time zero forces profile differentiability in the reverse direction. The adopted rectangle characterization matches D002 with the identified length measure. Translation and invertible affine substitution give the required slice integrability and integrated balance for locally integrable profiles when c is nonzero; at zero speed spatial content is stationary and flux is zero. Conversely spatial integrability at time zero recovers the profile condition. Oriented integrals handle reversed endpoints by sign and equal endpoints by zero. These are the target's complete five conjuncts, with no extra uniqueness or boundary-value conclusion.

## Findings

- **note / resolved-measure-evidence-gap:** The round-trip judge's material measure uncertainty is resolved by declaration evidence, without inferring meaning from a name or accepting a hash as proof of correspondence.
- **note / interpretation-qualified-acceptance:** Faithful-equivalent and both yes implications apply only under the recorded user-adopted interpretation for this selected row. They do not attribute these exact analytic domains to the printed book.
- **note / nonvacuity-and-strength:** There is no reduced applicability disguised as strength, no zero-measure trivialization and no reliance on totalized integrals to certify nonintegrable profiles. The additional geometric conjuncts are consequences of translation, so faithful-equivalent is appropriate rather than faithful-stronger.

## Semantic checklist

| Check | Direct | Round-trip |
|---|---|---|
| `C01` | `pass` | `pass` |
| `C02` | `pass` | `pass` |
| `C03` | `pass` | `pass` |
| `C04` | `pass` | `unclear` |
| `C05` | `pass` | `unclear` |
| `C06` | `pass` | `unclear` |
| `C07` | `pass` | `pass` |
| `C08` | `pass` | `pass` |
| `C09` | `pass` | `pass` |
| `C10` | `pass` | `unclear` |
| `C11` | `pass` | `pass` |
| `C12` | `pass` | `pass` |
| `N01` | `pass` | `pass` |
| `N02` | `pass` | `pass` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `pass` | `pass` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `unclear` |

## Dependency coverage

- Blind translator covered `101` dependencies (`0` hash-reused); unclear: `D056`.
- Direct judge covered `101` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

- The pinned PDF does not itself explicitly specify this complete analytic profile class. Its introductory arbitrary-profile wording and nonsmooth solution sense remain unresolved without the recorded user-adopted interpretation; this acceptance does not settle a source-only comparison.
- Printed equation (11.33) has the displayed spatial-bound inconsistency in its initial-data term. That contextual issue remains unresolved and is not silently corrected here; the target uses the separately adopted finite-rectangle formulation.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/adjudicator.json` (`ecb1f9cef1d887a7bcde1fee5084fcd435c66a89e14614468b3abad268c0c237`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/agent_runs.json` (`4937e6ad6af6e5b2102143455966dfa39973de2e7b7da124935180d6af14db42`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/blind_translation.json` (`850bd5a33ddfdbf8a529c59425eefdf70207c604742a20ee62a063a6f2992373`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/direct_judge.json` (`6e8b566e0fdf9bf6b7e9a3ba2a7e79c1f0b9766b8774c50af8876bc8e5410ff4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/roundtrip_judge.json` (`5499f7c80112b6d1abb3e086d73ba7576f79dd29a318b0e846365c0d5b7ec19b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/agent_outputs/source_contract.json` (`3149d14809cae7c259d76638b606c5bd1f7e9fbdd906cdfd99ec3d0a920494ae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/decision.json` (`7592cfc9bc82067b1f89c4fa3c040111ab8e34ee3eb3e6264cfa9d1b0dacf79c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/blind_dependency_inventory.json` (`398ac7643101f6e8762ea4c452f7c4230bfb21dfddb8829776a2d3df5c8b44b8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/blind_dossier.md` (`b6883cbcec15d24e5c20c5a8a6a632b3a6b73d3f464bc583efd910708a68fb14`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/blind_review_packet.md` (`b6883cbcec15d24e5c20c5a8a6a632b3a6b73d3f464bc583efd910708a68fb14`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/declaration_dossier.md` (`0edecf2136d90d9f049816927a84d6ae004ddf0d3931ff6829edf1868c0ab25d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/dependency_inventory.json` (`54ed863e07857a8e17293469b950aafd1fc594137d215d355fec41157449162a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/direct_review_packet.md` (`273ed719cf6d8ea9b9d360705af90a940bdea03728079605af122573d0cd7b3c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/inputs/source_locator.json` (`82fd9d4c53c379d24153f7f8f662d9326ceacc9a2be9f2f9bef20b796def450d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/a_events.jsonl` (`3f3fb2687615fb1aeb1ab44092f43726af24b452468f169bc33bfd9b4ee4a807`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/a_final.json` (`ecb1f9cef1d887a7bcde1fee5084fcd435c66a89e14614468b3abad268c0c237`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/a_input.txt` (`ee21720d0705c89a634e319684ca181aa3cc29ae33f785d01c344d22485c7b88`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/a_runtime.json` (`e5ef606cd3ae1307d03b0c900dc92593bc31440c5e5eafc6b796c6b04750c066`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/a_stderr.txt` (`206d3aa659de135b48ac8e27e50c073667ca43effd0743528410a94897552912`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/a_transport.json` (`dffbad2f4e5e4c3487480c39a8faea32f7b092a994b2bbd85d2e5729eec32cfb`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/adjudication_triggers.json` (`de78ea7f301147a2f0cecb92da005dd599de8b05cb38601a2cf3ec62a0dadc66`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_events.jsonl` (`f4ef55f24aeee87815d89abea89e10e20bc6e59e85132dfef1e01740bd73219d`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_final.json` (`850bd5a33ddfdbf8a529c59425eefdf70207c604742a20ee62a063a6f2992373`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_input.txt` (`2b9b9c93665068530c2e38ad48eca5ad468ac7ccb16246e4a8fcff449fedfdb8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_runtime.json` (`27b358bf2228109579cf1299ab0090c07e97e003b2ed277cf27f68640a7ce808`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_stderr.txt` (`135263436f7d32b7810a61eee373fbcc3d165abf4408ae2b14b220ae580849f0`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/b_transport.json` (`8a1f30dcaa3550c955324c847486346176672cfbef014304740e4bb59df6015e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/blind-isolation-preflight.json` (`ff3f3c5c0cd032b9db59fdc199608968ca5046402fc682ecb3c2bba7d894d283`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/c.py` (`dda3ae2b90e1b8afc431c112f4c0d023abab8e9309acc4cdbaf65f9fc2b06197`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_events.jsonl` (`12d65def4edd23e27b8e5aceac9e139aff04b68cc1b316f9a67e3971a845f529`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_final.json` (`6e8b566e0fdf9bf6b7e9a3ba2a7e79c1f0b9766b8774c50af8876bc8e5410ff4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_input.txt` (`2ee42502aaec4a075caab13fb92a5e67f525940d672cf814054bb18f86c2fa2c`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_runtime.json` (`ca173120ff0fe8f7641e13437168e46aa73e0f518f79da7f1dd73543918ebd94`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_stderr.txt` (`eeb1175084ff69ba1364318c47eb70ed22d5e1702b004111fa5db4e6516bbb2e`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/d_transport.json` (`97fced7c8d8843c4bc5436aeabe74cb65daa13715cbdeaab3abc8ffa730e6533`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/helper-provenance.json` (`1538c85fef34f5708be6b7194c494e129c36d4dd61d7b5da4d96e0226b6e5fc3`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-023.png` (`c3f85efd2fad196b6145e234ace695657e1986bc3d398f73ca62e1503cea5316`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-026.png` (`de53be1aae881a448dd2718b09830eadd7387124ea339f874ee5f55d49fa2257`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-027.png` (`b23d80176b69db0cebf8fee1fcb4c64ace36777dae21a61097a3090ec29e2ac6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-037.png` (`0a2a379fb9d46ef6936d10cecfb859960b7186a3ba4866aef447df66bb162b68`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-038.png` (`76c82896ba204f4c8f62daa84cb1e99f7a906c698055898847d90bf82543b5e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-039.png` (`c556c94c84c0058913f8984ca0be339f9653be1bc2e3f294da0e99f7e547996a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-040.png` (`cd168bd5fa9cea8fdc99a115df7b1061c62d8b01ed24314cf3cb4322c45211b7`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-237.png` (`e364e7088c5343a5c5b6cf5719cb8a2900d063e67440525ffd8bdf0df1af126f`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/page-238.png` (`f21728762f67bbff20b5736cdb7d736c52d69970ca6cda6aa6c323d82210a2b5`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/primary_pages.json` (`e75c1baec6a87f9701e1fa5cc8d5707c2f3ced83003db17c0a2e1584c6c499a6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/q.py` (`50f602ad1b9b467761bd7bc3727ed0d27fe9ac8551ce3d052f946bb471679600`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r.py` (`4d7be7f452382ffb81a04596c9156a4779985fc8959cbcf8de3989428ea8d1e6`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_events.jsonl` (`072b0e61f3d45de00493b96263d177bcc6ffab763721d1f106620490b2768f66`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_final.json` (`5499f7c80112b6d1abb3e086d73ba7576f79dd29a318b0e846365c0d5b7ec19b`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_input.txt` (`6595947debf11c142483824953eef2a5d0a62464b3f4870ae856cbabc3384577`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_runtime.json` (`f1c8ce0ed17142049d3695d3caa1bd3821432a2f5d63474f5729b9a76c33e607`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_stderr.txt` (`430530bdd1a0027214a4ba3913032dabc64ae022adedfa4c9ac425a495edf48a`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/r_transport.json` (`3eab090e056cf995cd712c5408016b7fc575e4dd81c11140c490a0c9f5099d92`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_events.jsonl` (`ebdc7ca7da4b9ac55cde52632095e7fe81ecf0bded4c7b4ffc815caf2489ba29`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_final.json` (`3149d14809cae7c259d76638b606c5bd1f7e9fbdd906cdfd99ec3d0a920494ae`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_input.txt` (`4bbfcf93ae054fb36ae7fa019cca60409f1e2d617fe28179fa376b8312b80fa4`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_runtime.json` (`9707c33e6040efe8bce317f91e55a7544eb7b49eb61646206c59b87fcd5cb447`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_stderr.txt` (`f5ca5fda4e254b1351097c9057a5272bf4829e9aa931cfee6e407f15330515f8`)
- `gates/leveque-finite-volume/artifacts/session-20260908/audits/LEV-CH01-EQ-1.3-INTERPRETED-DOMAINS-PRODUCTION-20260908/faithfulness/orchestration/s_transport.json` (`965221fe0064d68ac6469d14ce4c52e2a9d6f990c9b6165e5bee7152e777554c`)
