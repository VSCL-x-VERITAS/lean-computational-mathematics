# Faithfulness audit: LEV-CH01-ADVECTION-LINEAR-FLUX

## Decision

- Classification: `faithful-equivalent`
- Accepted: `true`
- Adjudicated: `false`
- Target SHA-256: `d80ac0b61ff6741e6a9f401e228090fe2b06e546ec824f07d63f9290991204ce`
- Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`

The matrix flux definition reduces componentwise to speed times the scalar state, and the conservation law plus the supplied smoothness package yields the scalar constant-coefficient advection equation, exactly as the source derives from f(q)=u-bar q. The source's mass conservation, linear flux f(q)=u-bar q, and sufficient smoothness instantiate all Lean premises and give both conclusions. The explicit analytic hypotheses merely spell out the source's smoothness needed for the integral-to-differential step; they do not restrict velocity sign or assert extra dynamics.

## Implications

- **Lean implies source:** `yes`. The matrix flux definition reduces componentwise to speed times the scalar state, and the conservation law plus the supplied smoothness package yields the scalar constant-coefficient advection equation, exactly as the source derives from f(q)=u-bar q.
- **Source implies lean:** `yes`. The source's mass conservation, linear flux f(q)=u-bar q, and sufficient smoothness instantiate all Lean premises and give both conclusions. The explicit analytic hypotheses merely spell out the source's smoothness needed for the integral-to-differential step; they do not restrict velocity sign or assert extra dynamics.

## Findings

- **note / smoothness explicitization:** These are technical witnesses for the same derivation, not an additional scientific conclusion.

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
| `N01` | `not-applicable` | `pass` |
| `N02` | `not-applicable` | `not-applicable` |
| `N03` | `not-applicable` | `not-applicable` |
| `N04` | `not-applicable` | `not-applicable` |
| `N05` | `not-applicable` | `not-applicable` |
| `N06` | `pass` | `pass` |

## Dependency coverage

- Blind translator covered `134` dependencies (`0` hash-reused); unclear: `none`.
- Direct judge covered `134` dependencies (`0` hash-reused); failing or unclear: `none`.

## Remaining uncertainties

No remaining uncertainties were recorded.

## Artifact provenance

- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/agent_outputs/agent_runs.json` (`be177896e696a97b5632b120f3fae79edf78b9ac8a4f7d5dd09e50c13db56af7`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/agent_outputs/batch_source_contract.json` (`01d18cafac5980a1ef30e5dd62c3b5c1d2c0698b31b34b16c4e66e96fbb17aea`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/agent_outputs/blind_translation.json` (`bb4f35e04f90f450c9383a161fcb27f3b2ef689b6cbecd31fd0fe0ca22f2f539`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/agent_outputs/direct_judge.json` (`5431eef9c76bb8bc0c907aa134be9380798c07aceb7edef01b3a948c453c1a47`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/agent_outputs/roundtrip_judge.json` (`961890d2a256b06912159a1717eba35aa8eaaadfaa1e8690a7567cb01c12675c`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/agent_outputs/source_contract.json` (`346b008078220a42c6a28c4f222835dffe164200e3b66ad40d654888d3e3ff27`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/decision.json` (`900799391ccfc52262b73363da6b76f8cb92124e078e16562341746ed08e4f5d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/agent_outputs/adjudicator.json` (`8f12dc815635e75c067116f0ad11a6e9e1c591419e9c6d61d4ad42b7ec975eaa`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/agent_outputs/agent_runs.json` (`38d10cdc4cb94510fa4224318ccf1a221de75e20491b7be918e864292b4a9c23`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/agent_outputs/batch_source_contract.json` (`01d18cafac5980a1ef30e5dd62c3b5c1d2c0698b31b34b16c4e66e96fbb17aea`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/agent_outputs/blind_translation.json` (`97692db4b700fa80817b4a0b778fcf7f89e81451b37daae829a8a4b928f2b1f6`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/agent_outputs/direct_judge.json` (`6fff60aa4bce80bfdf7dc0a18110258700f5bbdce059b5080cd33a6276de8cf9`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/agent_outputs/roundtrip_judge.json` (`2d0a3bb5b845ca6788aadbe3fe2c24dee7d71cd14ef2c56fafd8efcd50623297`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/agent_outputs/source_contract.json` (`346b008078220a42c6a28c4f222835dffe164200e3b66ad40d654888d3e3ff27`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/inputs/batch_source_locator.json` (`903d9a89b0834bb17300a6f194a89f28c332dc3313cccd3490dacc2520501bf5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/inputs/blind_dependency_inventory.json` (`f07efffcefc7fc7ee0a59b6f4babfdd0575a53a86b635f70f01b222e7a9e7a32`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/inputs/blind_dossier.md` (`08ee94f46fad80ea04eeb6f91a7fe13ea60515e2686e67c24aa76a96dded0007`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/inputs/blind_review_packet.md` (`08ee94f46fad80ea04eeb6f91a7fe13ea60515e2686e67c24aa76a96dded0007`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/inputs/declaration_dossier.md` (`1333acac3e53275acacc74d50f5fa963706076f52cc073f697f8a7ed014afe1d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/inputs/dependency_inventory.json` (`7b9a12a84b93f32f2e420d8ee1d997802fd71c95c27e3ff5d3c706f392916ba3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/inputs/direct_review_packet.md` (`1f11b4b32c9de6837302552abaabe8bf05afec09869e1b9b42818f284428ae35`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/history/20260901T073230Z/inputs/source_locator.json` (`1cf9e8ed6351339a451476b01b2304cad4e35d889fd51f6a35c9a2c892b3247d`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/inputs/batch_source_locator.json` (`903d9a89b0834bb17300a6f194a89f28c332dc3313cccd3490dacc2520501bf5`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/inputs/blind_dependency_inventory.json` (`60d7209b4aede21ce0eafafcc65f68d32b3d0e9b9856052cc774c8cd774669cc`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/inputs/blind_dossier.md` (`fc40de54acb27514da5df346a52ac133cfadfffc897cda97db548245b92925ef`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/inputs/blind_review_packet.md` (`fc40de54acb27514da5df346a52ac133cfadfffc897cda97db548245b92925ef`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/inputs/declaration_dossier.md` (`82fee7278e09df6ebec8850cd07ee7385d76e014d5f18579d41310497de01649`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/inputs/dependency_inventory.json` (`e02a40c72cff01aa20b1f37a577482ffacd5ce0e3f3f630d9dd513f00a59197a`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/inputs/direct_review_packet.md` (`564051b6ab8eeab903071212ea690384009288d5542aabb9cc5ea74f87da76a3`)
- `gates/leveque-finite-volume/artifacts/LEV-CH01-ADVECTION-LINEAR-FLUX/faithfulness/inputs/source_locator.json` (`1cf9e8ed6351339a451476b01b2304cad4e35d889fd51f6a35c9a2c892b3247d`)
